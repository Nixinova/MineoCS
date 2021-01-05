quarryRunning = false
quarryPos = nil
isQuarryOn = false

X=0 Y=12 Z=0
Xi=0 Zi=0

tick = 0
loopNum = 0

function Behavior:Update()
    local air = 255
    local map = CS.FindGameObject("Map"):GetComponent("MapRenderer"):GetMap()
    local quarry = CS.FindGameObject("Quarry"):GetComponent("ModelRenderer")
    --local quarryPos = CS.FindGameObject("Quarry").transform:GetPosition()
    local mousePos = CS.Input.GetMousePosition()
    local ray = CS.FindGameObject("Camera"):GetComponent("Camera"):CreateRay(mousePos)
    
    if loopNum == 0 then
        quarryPos = CS.FindGameObject("Quarry").transform:GetPosition()
        X = math.round(quarryPos.x/2-1)
        Xi = math.round(quarryPos.x/2)
        Y = math.round(quarryPos.y/2)
        Z = math.round(quarryPos.z/2-1)
        Zi = math.round(quarryPos.z/2)
        print('Quarry coords: ' .. X..' '..Y..' '..Z)
    end
    
    if ray:IntersectsModelRenderer(quarry) ~= nil and CS.Input.IsButtonDown("Fire")
    then
        isQuarryOn = true
    end
    
    if tick % 10 and isQuarryOn == true then
        
        local inv = inventory
        local blockID = map:GetBlockIDAt(X,Y,Z)
        if blockID == blocks.grass or blockID == blocks.dirt then
            inventory.dirt = inventory.dirt + 1
        end
        if blockID == blocks.clay then
            inventory.clay = inventory.clay + 1
        end
        if blockID == blocks.stone then
            inventory.stone = inventory.stone + 1
        end
        
        X = X + 1
        if X > Xi+1 then
            X = X - 3
            Z = Z + 1
        end
        if Z > Zi+1 then
            Z = Z - 3
            Y = Y - 1
        end
        if Y < 2 then
            quarry:SetOpacity("0.0")
            isQuarryOn = false
        end
    end
    
    if tick >= 60 then tick = tick - 60 end
    tick = tick + 1
    
    loopNum = loopNum + 1
end
