version = 'Alpha 0.4.2'
worldType = 'normal'
biomeCoords = {}
placedBlocks = {}
worldSeed = nil
mapSize = 64
completedMap = false
north = Map.BlockOrientation.North
ingame = false
clickDelay = 10

blocks = {
    bedrock = 0, stone = 1, clay = 2, sandstone = 4,
    dirt = 8, grass = 9, grass_plains = 9, grass_forest = 10, grass_snowy = 11, sand = 12,
    log = 16, oak_log = 16, redwood_log = 17, spruce_log = 18,
    leaf = 24, oak_leaf = 24, redwood_leaf = 25, spruce_leaf = 26,
    copper = 32, asphalt = 33, tin = 34,
    
    debug = 240,
    air = 255
}