local TeleportService = game:GetService("TeleportService")
local PlaceID = game.PlaceId

print("Esperando 4 segundos para iniciar server hop...")
task.wait(4)

print("Intentando server hop...")

while true do
    local ok, err = pcall(function()
        TeleportService:Teleport(PlaceID)
    end)

    if ok then
        print("Teleport enviado, esperando...")
        break
    else
        -- Si hay error (sala llena, fallo de Roblox, etc.)
        warn("Error al saltar de servidor. Reintentando en 2 segundos...")
        task.wait(2)
    end
end
