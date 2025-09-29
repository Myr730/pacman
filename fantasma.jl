using Agents

@agent struct Ghost(GridAgent{2})
    type::String = "Ghost"
end

function agent_step!(_agent, _model)
end

function initialize_model()
    space = GridSpace((5,5); periodic = false, metric = :manhattan)
    model = StandardABM(Ghost, space; agent_step!)
    return model
    
    
end

model = initialize_model()

function agent_step!(agent, model)
    randomwalk!(agent, model)
end

figure, _ = abmplot(model; agent_color = :red, agent_marker = :circle, as = 80) ; figure