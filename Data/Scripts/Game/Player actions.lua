-- BlockPlayer obj --

hotbar = {
    blocks.stone, blocks.clay, blocks.dirt, blocks.grass, blocks.oak_log,
    blocks.oak_leaf, blocks.sand, blocks.tin, blocks.copper, blocks.asphalt
}

-- blocks obj is in 'World generation'
local selectedBlock = blocks.stone
local currentSlot = 1
local tick = 0
local canBuild = true

function Behavior:Update()
    tick = tick + 1

    local player = CS.FindGameObject("Player")
    local mapObject = CS.FindGameObject("Map")
    local map = mapObject:GetComponent("MapRenderer"):GetMap()
    local north = Map.BlockOrientation.North
    
    local blockPreviewObject = CS.FindGameObject("BlockPreview")
    local blockSelection = CS.FindGameObject("SelectedBlock")
    
    if CS.Input.WasButtonJustPressed("ToggleBuild") then
        canBuild = not canBuild
    end
    
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
    
    selectedBlock = hotbar[currentSlot]
    
    local pos = self.gameObject.transform:GetPosition()
    local x = math.floor(pos.x/2+0.5)
    local y = math.floor(pos.y/2+0.5)
    local z = math.floor(pos.z/2+0.5)
    if canBuild then 
        blockSelection.transform:SetLocalPosition(Vector3:New(-3.08+currentSlot*0.56, 0.8125, 0))
        blockPreviewObject.transform:SetPosition(Vector3:New(x*2, y*2-4, z*2))
    else
        blockSelection.transform:SetLocalPosition(Vector3:New(0, 0, 5))
        blockPreviewObject.transform:SetPosition(Vector3:New(0, 0, 0))
    end
        
    if CS.Input.IsButtonDown("RClick") and canBuild and tick > 10 then
        if map:GetBlockIDAt(x,y,z) == blocks.air then
            map:SetBlockAt(x,y,z, selectedBlock, north)
            tick = 0
        end
    end    
    if CS.Input.IsButtonDown("LClick") and canBuild and tick > 10 then
        map:SetBlockAt(x,y,z, blocks.air, north)
        tick = 0
    end

    local nukeSize = 2 -- 5x5x5
    if CS.Input.WasButtonJustPressed("Nuke") then
        for i=-nukeSize,nukeSize,1 do
            for j=-nukeSize,nukeSize,1 do
                for k=-nukeSize,nukeSize,1 do
                    if math.randomrange(0,5) > 1 then
                        map:SetBlockAt(x+i,y+j,z+k, blocks.air, north)
                    end
                end
            end
        end
    end

end
