local hotbar = {
    blocks.stone, blocks.clay, blocks.dirt, blocks.grass, blocks.oak_log,
    blocks.oak_leaf, blocks.sand, blocks.tin, blocks.copper, blocks.asphalt
}
local selectedBlock = blocks.stone
local currentSlot = 1
local showF3 = false
local canBuild = true
local tick = 0

function Behavior:Update() 
if ingame then
    tick = tick + 1

    local player = CS.FindGameObject("Player")
    local playerPos = player.transform:GetPosition()
    local aimPos = self.gameObject.transform:GetPosition()
    local coords = CS.FindGameObject("Coords")
    local mapObject = CS.FindGameObject("Map")
    local map = mapObject:GetComponent("MapRenderer"):GetMap()
    local north = Map.BlockOrientation.North
    
    local worldYOffset = mapObject.transform:GetPosition().y/2
    
    local blockPreviewObject = CS.FindGameObject("BlockPreview")
    local blockSelection = CS.FindGameObject("SelectedBlock")
    
    -- Toggle build
    if CS.Input.WasButtonJustPressed("ToggleBuild") then canBuild = not canBuild end
    
    -- Change item slot
    for i=1,10,1 do
        if CS.Input.WasButtonJustPressed("Item" .. i) then
            currentSlot = i
        end
    end
    if CS.Input.WasButtonJustPressed("ScrollUp") then
        currentSlot = currentSlot - 1
    end
    if CS.Input.WasButtonJustPressed("ScrollDown") then
        currentSlot = currentSlot + 1
    end
    if currentSlot > 10 then currentSlot = 1 end
    if currentSlot < 1 then currentSlot = 10 end
    
    -- Build preview
    selectedBlock = hotbar[currentSlot]
    local x = math.floor(aimPos.x/2+0.5)
    local y = math.floor(aimPos.y/2+0.5)
    local z = math.floor(aimPos.z/2+0.5)
    if canBuild then 
        blockSelection.transform:SetLocalPosition(Vector3:New(-3.08+currentSlot*0.56, 0.8125, 0))
        blockPreviewObject.transform:SetPosition(Vector3:New(x*2, y*2-4, z*2))
    else
        blockSelection.transform:SetLocalPosition(Vector3:New(0, 0, 5))
        blockPreviewObject.transform:SetPosition(Vector3:New(0, 0, 0))
    end
        
    -- Build
    if CS.Input.IsButtonDown("RClick") and canBuild and tick > clickDelay then
        if map:GetBlockIDAt(x,y-worldYOffset,z) == blocks.air then
            map:SetBlockAt(x,y-worldYOffset,z, selectedBlock, north)
            placedBlocks[x .. '/' .. y-worldYOffset .. '/' .. z] = selectedBlock
            tick = 0
        end
    end    
    if CS.Input.IsButtonDown("LClick") and canBuild and tick > clickDelay then
        map:SetBlockAt(x,y-worldYOffset,z, blocks.air, north)
        placedBlocks[x .. '/' .. y-worldYOffset .. '/' .. z] = blocks.air
        tick = 0
    end
   
    -- Nuke
    local nukeSize = 2 -- 5x5x5
    if CS.Input.WasButtonJustPressed("Nuke") and tick > clickDelay then
        for i=-nukeSize,nukeSize,1 do
            for j=-nukeSize,nukeSize,1 do
                for k=-nukeSize,nukeSize,1 do
                    if math.randomrange(0,5) > 1 then
                        map:SetBlockAt(x+i, y+j-worldYOffset, z+k, blocks.air, north)
                        placedBlocks[x+i .. '/' .. y+j-worldYOffset .. '/' .. z+k] = blocks.air
                    end
                end
            end
        end
        tick = 0
    end
    
    -- F3
    if CS.Input.WasButtonJustReleased("ToggleCoords") then showF3 = not showF3 end
    local posX = tostring(playerPos.y).format("%.1f", playerPos.x/2)
    local posY = tostring(playerPos.y).format("%.1f", playerPos.y/2-worldYOffset-0.25)
    local posZ = tostring(playerPos.y).format("%.1f", playerPos.z/2)
    local posText = posX .. ' / ' .. posY .. ' / ' .. posZ

    CS.FindGameObject("Version"):GetComponent("TextRenderer"):SetText(showF3 and version or '')
    coords.textRenderer:SetText(showF3 and posText or '')

end
end
