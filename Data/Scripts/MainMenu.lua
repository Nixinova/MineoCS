local currentMenu = 'main'
local buttons = {
    "play", "exit",
    "newWorld", "loadWorld",
    "world1", "world2", "world3",
    "normalWorld", "flatWorld",
    "back"
}
local menus = {
    "main", "play", "worldSelect", "worldType"
}
local hovered = {}
local pos = {}
local button

function Behavior:Start()
    CS.Input.UnlockMouse()
end

function Behavior:Update()

    local camera = CS.FindGameObject("Camera")
    local mousePos = CS.Input.GetMousePosition()
    local ray = camera:GetComponent("Camera"):CreateRay(mousePos)
    
    local size = {regular = Vector3:New(8, 8, 8), large = Vector3:New(9, 9, 9)}
    
    CS.FindGameObject("Version"):GetComponent("TextRenderer"):SetText(version)
    
    -- Initialise
    for _,name in ipairs(buttons) do
        buttons[name] = CS.FindGameObject(name:sub(1,1):upper() .. name:sub(2) .. "Button")
        if not pos[name] then pos[name] = buttons[name].transform:GetPosition() end
        hovered[name] = ray:IntersectsModelRenderer(buttons[name]:GetComponent("ModelRenderer")) ~= nil
        buttons[name].transform:SetLocalScale(hovered[name] and size.large or size.regular)
    end
    for _,name in ipairs(menus) do
        menus[name] = CS.FindGameObject(name:sub(1,1):upper() .. name:sub(2))
        if not pos[name] then pos[name] = menus[name].transform:GetPosition() end
    end
    
    -- Check for clicks
    if CS.Input.WasButtonJustPressed("LClick") then
        if hovered.play then
            if completedMap then
                GenerateWorld()
            else 
                currentMenu = 'play'
            end
        elseif hovered.newWorld then
            currentMenu = 'worldType'
        elseif hovered.loadWorld then
            currentMenu = 'worldSelect'
        elseif hovered.world1 then LoadWorld(1)
        elseif hovered.world2 then LoadWorld(2)
        elseif hovered.world3 then LoadWorld(3)
        elseif hovered.normalWorld or hovered.flatWorld then
            worldType = hovered.normalWorld and 'normal' or 'flat'
            print('Set world type to ' .. worldType)
            GenerateWorld()
        elseif hovered.back then
            if currentMenu == 'worldType' then currentMenu = 'play'
            elseif currentMenu == 'worldSelect' then currentMenu = 'play'
            elseif currentMenu == 'play' then currentMenu = 'main'
            end
        elseif hovered.exit then
            CS.Exit()
        end
    end
    
    -- Move buttons offscreen when not that menu
    local xCoords = {worldSelect = {-10, 0, 10} }
    local zCoords = {main = 0+1, play = -10+1, worldSelect = -15+1, worldType = -20+1}
    local offScreen = Vector3:New(100, 0, 0)
    for i,name in ipairs(menus) do
        if currentMenu == name then
            local xCoord = xCoords[name] and xCoords[name][i]-10 or 0
            menus[name].transform:SetPosition(Vector3:New(xCoord, pos[name].y, zCoords[name]))
        else
            menus[name].transform:SetPosition(offScreen)
        end
    end
    buttons.back.transform:SetPosition(currentMenu == 'main' and offScreen or pos.back)
    
end

function GenerateWorld()
    currentMenu = 'main'
     CS.FindGameObject("Camera").transform:SetPosition(Vector3:New(0,0,-1))
    CS.FindGameObject("LoadingBox").transform:SetPosition(Vector3:New(0,0,-2))
    CS.LoadScene(CS.FindAsset("Game", "Scene"))
end

function LoadWorld(id)
    CS.Storage.Load(
        "World" .. id,
        function(err, data)
            if err ~= nil then 
                print("Unknown error") return
            end
            if data ~= nil then
                print("Successfully loaded world" .. id)
                worldSeed = data.seed
                worldType = data.worldType
                biomeCoords = data.biomeCoords
                placedBlocks = data.placedBlocks
                GenerateWorld()
            end
        end
    )
end