using Agents

@agent struct Ghost(GridAgent{2})
    type::String = "Ghost"
end
matrix = [
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
    0 1 0 1 0 0 0 1 1 1 0 1 0 1 0 1 0;
    0 1 1 1 0 1 0 0 0 0 0 1 0 1 1 1 0;
    0 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 0;
    0 1 0 1 0 1 0 0 0 0 0 1 1 1 0 1 0;
    0 1 1 1 0 1 0 1 1 1 0 1 0 1 0 1 0;
    0 1 0 1 0 1 0 1 1 1 0 1 0 1 0 1 0;
    0 1 0 1 1 1 0 0 1 0 0 1 0 1 1 1 0;
    0 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 0;
    0 1 1 1 0 1 0 0 0 0 0 1 0 1 1 1 0;
    0 1 0 1 0 1 0 1 1 1 0 0 0 1 0 1 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
]

function agent_step!(agent, model)
    #suponiendo que el pacman existe y esta en x posicion
    pacman_posicion = (7,1)
    ruta = a_star_search(agent.posicion, pacman_posicion, model)

    if !isempty(ruta)
        next_posicion = ruta[1]
        move_agent!(agent, next_posicion, model)
    else
        randomwalk!(agent, model)
    end
end

function a_star_search(start, goal, model)
    open_set = [start]
    came_from = Dict()
    g_score = Dict(start => 0)
    f_score = Dict(start => heuristic(start, goal))

     while !isempty(open_set)
        # Encontrar nodo con menor f_score
        current = open_set[1]
        for node in open_set
            if get(f_score, node, Inf) < get(f_score, current, Inf)
                current = node
            end
        end

         # Si llegamos al objetivo, reconstruir camino
        if current == goal
            return reconstruct_path(came_from, current)
        end
        
        # Remover current de open_set
        filter!(x -> x != current, open_set)
        
        # Explorar vecinos
        for neighbor in get_valid_neighbors(current, model)
            tentative_g_score = get(g_score, current, Inf) + 1
            
            if tentative_g_score < get(g_score, neighbor, Inf)
                came_from[neighbor] = current
                g_score[neighbor] = tentative_g_score
                f_score[neighbor] = tentative_g_score + heuristic(neighbor, goal)
                
                if neighbor ∉ open_set
                    push!(open_set, neighbor)
                end
            end
        end
    end
    return[]
end

function heuristic(a, b)
    return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

function reconstruct_path(came_from, current)
    total_path = [current]
    while haskey(came_from, current)
        current = came_from[current]
        push!(total_path, current)
    end
    return reverse(total_path)
end

function get_valid_neighbors(pos, model)
    x, y = pos
    possible_moves = [
        (x, y-1), (x, y+1), (x-1, y), (x+1, y)
    ]
    
    valid_moves = []
    for move in possible_moves
        mx, my = move
        if 1 <= mx <= size(matrix, 2) && 1 <= my <= size(matrix, 1)
            if matrix[my, mx] == 1
                push!(valid_moves, move)
            end
        end
    end
    
    return valid_moves
end

function initialize_model()
    space = GridSpace((17,14); periodic = false, metric = :manhattan)
    model = StandardABM(Ghost, space; agent_step!)

    add_agent!((3, 3), model)  
    return model
    
end

model = initialize_model()

