include("fantasma.jl")
using Genie, Genie.Renderer.Json, Genie.Requests, HTTP
using UUIDs

route("/run", method = GET) do
    Agents.step!(model, 1)
    agents = []
    for ghost in allagents(model)
        push!(agents, Dict(
            :id => ghost.id,
            :pos => ghost.posicion
            :type => ghost.type
        ))
    end

    json(Dict(:agents => agents))
end

Genie.config.run_as_server = true
Genie.config.cors_headers["Access-Control-Allow-Origin"] = "*"
Genie.config.cors_headers["Access-Control-Allow-Headers"] = "Content-Type"
Genie.config.cors_headers["Access-Control-Allow-Methods"] = "GET,POST,PUT,DELETE,OPTIONS"
Genie.config.cors_allowed_origins = ["*"]

Genie.startup(8000, "0.0.0.0")