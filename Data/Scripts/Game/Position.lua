local pos
showCoords = 1

function Behavior:Update()
    
    local player = CS.FindGameObject("PlayerModel")
    
    local coords = CS.FindGameObject("Coords")
    pos = player.transform:GetPosition()
    
    local posX = tostring(pos.y).format("%.1f", pos.x/2)
    local posY = tostring(pos.y).format("%.1f", pos.y/2-0.9)
    local posZ = tostring(pos.y).format("%.1f", pos.z/2)
    local posText = posX .. ' / ' .. posY .. ' / ' .. posZ

    if CS.Input.WasButtonJustReleased("ToggleCoords") then
        showCoords = showCoords + 1
    end
    
    if showCoords % 2 == 0 then
        coords.textRenderer:SetText(posText)
    else
        coords.textRenderer:SetText('')
    end
    
end
