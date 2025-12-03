-- CONFIG
local PlaceID = game.PlaceId
local waitTime = 4 -- segundos entre intentos

-- SERVICIOS
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- queue_on_teleport para mantener el script activo
if queue_on_teleport then
    queue_on_teleport([[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sevastianjimenez66-spec/brainrot-server/main/serverhop.lua"))()
    ]])
end

print("Esperando "..waitTime.." segundos para iniciar server hop...")
task.wait(waitTime)

-- Función para obtener servidores públicos
local function getServers(cursor)
    local url = "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
    if cursor then
        url = url .. "&cursor=" .. cursor
    end
    local response = HttpService:GetAsync(url)
    return HttpService:JSONDecode(response)
end

-- Función de server hop
local function serverHop()
    local success, servers = pcall(getServers)
    if not success then
        warn("Error al obtener servidores, reintentando en 5 segundos...")
        task.wait(5)
        serverHop()
        return
    end

    local currentJobId = game.JobId
    local targetServer = nil

    -- Elegir un servidor diferente y con espacio
    for _, server in pairs(servers.data) do
        if server.id ~= currentJobId and server.playing < server.maxPlayers then
            targetServer = server.id
            break
        end
    end

    if targetServer then
        print("Teletransportando a un nuevo servidor: "..targetServer)
        TeleportService:TeleportToPlaceInstance(PlaceID, targetServer, LocalPlayer)
    else
        print("No se encontró servidor disponible distinto, reintentando en 5 segundos...")
        task.wait(5)
        serverHop()
    end
end

-- Ejecutar el server hop
serverHop()
