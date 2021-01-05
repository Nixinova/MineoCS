-- Map obj

local debug = false

local mapSize = 64
minXZ = -mapSize
maxXZ = mapSize
north = Map.BlockOrientation.North

blocks = {
    bedrock = 0, stone = 1, clay = 2, sandstone = 4,
    dirt = 8, grass = 9, grass_plains = 9, grass_forest = 10, sand = 12,
    log = 16, oak_log = 16, redwood_log = 17, spruce_log = 18,
    leaf = 24, oak_leaf = 24, redwood_leaf = 25, spruce_leaf = 26,
    copper = 32, asphalt = 33, tin = 34,
    
    debug = 240,
    air = 255
}

local completedMap = false

function Behavior:Start()
if completedMap == false then
    print("World generation start")
    local map = self.gameObject:GetComponent("MapRenderer"):GetMap()
    
    local n = 0

    local grassMax = 8
    local grassY = math.randomrange(grassMax-2,grassMax)
    local undergroundLvl = grassMax-4
    local grassChange = 1
    local chunkSize = 4
    local groundType
    local belowGroundType
    
    -- biomes
    local biomes = {'oak_forest', 'spruce_forest', 'redwood_forest', 'desert'}
    local biomeCoords = {}
    for i,v in ipairs(biomes) do
        local startX = math.random(minXZ, maxXZ)
        local startZ = math.random(minXZ, maxXZ)
        local endX = math.random(startX, maxXZ)
        local endZ = math.random(startZ, maxXZ)
        biomeCoords[v] = {
            startX = startX,
            startZ = startZ,
            endX = endX,
            endZ = endZ,
        }
    end
    
    -- blocks
    if not debug then
    local dx = 1
    local dz = 1
    --for n=1, (maxXZ-minXZ)*(maxXZ-minXZ), chunkSize do
    for x=minXZ, maxXZ, chunkSize do
        for z=minXZ, maxXZ, chunkSize do
        
            local biome = 'plains'
            for i,v in ipairs(biomes) do
                local coords = biomeCoords[v]
                if x > coords.startX and x < coords.endX and z > coords.startX and z < coords.endX then
                    biome = v
                end
            end
        
            local grassChangeChance = math.random(0,2)
            if grassChangeChance == 0 then
                grassChange = math.random(-1,1)
            end
            grassY = math.round(math.randomrange(grassY+grassChange, grassMax))
            
            for X=x, x+chunkSize, 1 do
                for Z=z, z+chunkSize, 1 do
                    
                    if grassY > undergroundLvl then
                    
                        if biome == 'plains' then
                            groundType = blocks.grass_plains
                            belowGroundType = blocks.dirt
                        elseif string.find(biome,'forest') then
                            groundType = blocks.grass_forest
                            belowGroundType = blocks.dirt
                        elseif biome == 'desert' then
                            groundType = blocks.sand
                            belowGroundType = blocks.sandstone
                        end
                    else
                        groundType = blocks.air
                        belowGroundType = blocks.clay
                    end
                    
                    if map:GetBlockIDAt(X, grassY+1, Z) == blocks.air
                    then
                        map:SetBlockAt(X, grassY, Z, groundType, north)
                        map:SetBlockAt(X, grassY-1, Z, belowGroundType, north)
                        map:SetBlockAt(X, grassY-2, Z, belowGroundType, north)
                        map:SetBlockAt(X, grassY-3, Z, belowGroundType, north)
                    end
                    
                    for Y=grassY-4, 0, -1 do
                        map:SetBlockAt(X, Y, Z, blocks.stone, north)
                    end
                    map:SetBlockAt(X, 0, Z, blocks.bedrock, north)
            
                    -- trees
                    local treeChance = math.random(1, 4*chunkSize*chunkSize)
                    if treeChance == 1 and string.find(biome, 'forest') then

                        local maxTreeSize
                        local minTreeSize
                        local maxTreeY
                        local minTreeY

                        local logType
                        local leafType

                        if biome == 'oak_forest' then
                            logType = blocks.oak_log
                            leafType = blocks.oak_leaf
                            minTreeSize = 3
                            maxTreeSize = math.random(4,6)
                        end
                        if biome == 'redwood_forest' then
                            logType = blocks.redwood_log
                            leafType = blocks.redwood_leaf
                            minTreeSize = 5
                            maxTreeSize = math.random(7,11)
                        end
                        if biome == 'spruce_forest' then
                            logType = blocks.spruce_log
                            leafType = blocks.spruce_leaf
                            minTreeSize = 4
                            maxTreeSize = math.random(6,8)
                        end

                        local minTreeY = grassY+minTreeSize
                        local maxTreeY = grassY+maxTreeSize

                        map:SetBlockAt(x, grassY, z, blocks.dirt, north)
                        for Y=grassY+1, minTreeY, 1 do
                            map:SetBlockAt(x, Y, z, logType, north)
                        end

                        for Y=minTreeY, maxTreeY, 1 do
                            map:SetBlockAt(x, Y, z, logType, north)
                            map:SetBlockAt(x+1, Y, z, leafType, north)
                            map:SetBlockAt(x, Y, z+1, leafType, north)
                            map:SetBlockAt(x-1, Y, z, leafType, north)
                            map:SetBlockAt(x, Y, z-1, leafType, north)
                            if Y > minTreeY and Y < maxTreeY then
                                map:SetBlockAt(x+1, Y, z+1, leafType, north)
                                map:SetBlockAt(x+1, Y, z-1, leafType, north)
                                map:SetBlockAt(x-1, Y, z-1, leafType, north)
                                map:SetBlockAt(x-1, Y, z+1, leafType, north)
                            end
                        end

                        map:SetBlockAt(x, maxTreeY, z, leafType, north)
                        map:SetBlockAt(x, maxTreeY+1, z, leafType, north)
                    end

                    -- grass Y change
                    local grassChngChance = math.random(-20,20)
                    if grassChngChance == -1 then
                        grassY = grassY - 1
                        end
                        if grassChngChance == 1 then
                        grassY = grassY + 1
                    end
                    
                end
                
            end
        end

    end 
    print("World generation done")
    
    -- ship
    n = 16
    while n < 24 do
        for X=-3,3,1 do for Z=-3,3,1 do
            map:SetBlockAt(X, n, Z, blocks.air, north)
        end end
        n = n + 1
    end
    
    -- floor
    n = 16
    while n > 8 do
        for X=-3,3,1 do for Z=-3,3,1 do
            map:SetBlockAt(X, n, Z, blocks.asphalt, north)
        end end 
        for X=-1,1,2 do for Z=-1,1,2 do
            map:SetBlockAt(6*X, n, 0*Z, blocks.asphalt, north)
            map:SetBlockAt(6*X, n, 1*Z, blocks.asphalt, north)
            map:SetBlockAt(5*X, n, 2*Z, blocks.asphalt, north)
            map:SetBlockAt(4*X, n, 2*Z, blocks.asphalt, north)
            map:SetBlockAt(3*X, n, 3*Z, blocks.asphalt, north)
            map:SetBlockAt(2*X, n, 4*Z, blocks.asphalt, north)
            map:SetBlockAt(2*X, n, 5*Z, blocks.asphalt, north)
            map:SetBlockAt(1*X, n, 6*Z, blocks.asphalt, north)
            map:SetBlockAt(0*X, n, 6*Z, blocks.asphalt, north)
        end end
        for X=-1,1,1 do for Z=-1,1,1 do
            map:SetBlockAt(4*X, n, 1*Z, blocks.asphalt, north)
            map:SetBlockAt(5*X, n, 1*Z, blocks.asphalt, north)
            map:SetBlockAt(1*X, n, 4*Z, blocks.asphalt, north)
            map:SetBlockAt(1*X, n, 5*Z, blocks.asphalt, north)
        end end
        n=n-1
    end
    
    -- walls
    n = 17
    while n < 24 do
        for X=-1,1,2 do
            for Z=-1,1,2 do
                for X1=-3,3,1 do for Z1=-3,3,1 do
                    map:SetBlockAt(X1, n, Z1, blocks.air, north)
                end end
                if math.random(0,1) == 0 then map:SetBlockAt(6*X, n, 0*Z, blocks.copper, north) end
                if math.random(0,1) == 0 then map:SetBlockAt(6*X, n, 1*Z, blocks.copper, north) end
                if math.random(0,1) == 0 then map:SetBlockAt(5*X, n, 2*Z, blocks.copper, north) end
                if math.random(0,1) == 0 then map:SetBlockAt(4*X, n, 2*Z, blocks.copper, north) end
                if math.random(0,1) == 0 then map:SetBlockAt(3*X, n, 3*Z, blocks.copper, north) end
                if math.random(0,1) == 0 then map:SetBlockAt(2*X, n, 4*Z, blocks.copper, north) end
                if math.random(0,1) == 0 then map:SetBlockAt(2*X, n, 5*Z, blocks.copper, north) end
                if math.random(0,1) == 0 then map:SetBlockAt(1*X, n, 6*Z, blocks.copper, north) end
                if math.random(0,1) == 0 then map:SetBlockAt(0*X, n, 6*Z, blocks.copper, north) end
                if math.random(0,1) == 0 then map:SetBlockAt(0*X, n, 0*Z, blocks.air, north) end
                if math.random(0,1) == 0 then map:SetBlockAt(0*X, n, 1*Z, blocks.air, north) end
                if math.random(0,1) == 0 then map:SetBlockAt(1*X, n, 0*Z, blocks.air, north) end
                if math.random(0,1) == 0 then map:SetBlockAt(1*X, n, 1*Z, blocks.air, north) end
                map:SetBlockAt(4*X, n, 0*Z, blocks.air, north)
                map:SetBlockAt(4*X, n, 1*Z, blocks.air, north)
                map:SetBlockAt(5*X, n, 0*Z, blocks.air, north)
                map:SetBlockAt(5*X, n, 1*Z, blocks.air, north)
                map:SetBlockAt(0*X, n, 4*Z, blocks.air, north)
                map:SetBlockAt(1*X, n, 4*Z, blocks.air, north)
                map:SetBlockAt(0*X, n, 5*Z, blocks.air, north)
                map:SetBlockAt(1*X, n, 5*Z, blocks.air, north)
            end
        end
        n=n+1
    end
    
    -- roof
    for X=-3,3,1 do for Z=-3,3,1 do
        if math.random(0,1) == 0 then map:SetBlockAt(X, 24, Z, blocks.tin, north) end
    end end
    for X=-1,1,2 do for Z=-1,1,2 do
        if math.random(0,1) == 0 then map:SetBlockAt(6*X, 24, 0*Z, blocks.tin, north) end
        if math.random(0,1) == 0 then map:SetBlockAt(6*X, 24, 1*Z, blocks.tin, north) end
        if math.random(0,1) == 0 then map:SetBlockAt(5*X, 24, 2*Z, blocks.tin, north) end
        if math.random(0,1) == 0 then map:SetBlockAt(4*X, 24, 2*Z, blocks.tin, north) end
        if math.random(0,1) == 0 then map:SetBlockAt(3*X, 24, 3*Z, blocks.tin, north) end
        if math.random(0,1) == 0 then map:SetBlockAt(2*X, 24, 4*Z, blocks.tin, north) end
        if math.random(0,1) == 0 then map:SetBlockAt(2*X, 24, 5*Z, blocks.tin, north) end
        if math.random(0,1) == 0 then map:SetBlockAt(1*X, 24, 6*Z, blocks.tin, north) end
        if math.random(0,1) == 0 then map:SetBlockAt(0*X, 24, 6*Z, blocks.tin, north) end
    end end
    print("Ship generation done")
    end
    
    print("Map complete")
    completedMap = true
end
end

function Behavior:Update()
end