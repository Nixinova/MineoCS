local currentMenu = 'pause'
local buttons = {"resume", "save", "world1", "world2", "world3", "back", "quit"}
local hovered = {}
local pos = {}

local savedText
local savedTick = 0

function Behavior:Update()
    savedTick = savedTick + 1
    
    local camera = CS.FindGameObject("Camera")
    local mousePos = CS.Input.GetMousePosition()
    local ray = camera:GetComponent("Camera"):CreateRay(mousePos)
    
    local pauseMenu = CS.FindGameObject("PauseMenu")
    local saveMenu = CS.FindGameObject("SaveMenu")
    
    if not savedText then savedText = CS.FindGameObject("SavedText"):GetComponent("TextRenderer") end
    
    local size = {large = Vector3:New(.9, .9, .9), regular = Vector3:New(.8, .8, .8)}
    
    -- Pause menu open/close
    if CS.Input.WasButtonJustPressed("Escape") then
        ingame = not ingame
        currentMenu = 'pause'
    end
    self.gameObject.transform:SetLocalPosition(Vector3:New(0, 0, ingame and .5 or -.5))
    CS.FindGameObject("GUI").transform:SetLocalPosition(Vector3:New(0, 0, ingame and -.25 or .25))
    
    -- Initialise buttons
    for _,name in ipairs(buttons) do
        buttons[name] = CS.FindGameObject(name:sub(1,1):upper() .. name:sub(2) .. "Button")
        if not pos[name] then pos[name] = buttons[name].transform:GetPosition() end
        hovered[name] = ray:IntersectsModelRenderer(buttons[name]:GetComponent("ModelRenderer")) ~= nil
        buttons[name].transform:SetLocalScale(hovered[name] and size.large or size.regular)
    end
    
    -- Button clicks
    if CS.Input.WasButtonJustPressed("LClick") then
        if currentMenu == 'pause' then
            if hovered.resume then ingame = true
            elseif hovered.save then currentMenu = 'save'
            elseif hovered.quit then CS.Exit()
            end
        elseif currentMenu == 'save' then
            if hovered.back then currentMenu = 'pause'
            elseif hovered.world1 then SaveWorld(1)
            elseif hovered.world2 then SaveWorld(2)
            elseif hovered.world3 then SaveWorld(3)
            end
        end
    end
    
    -- Switch menus
    local positions = {visible = Vector3:New(0, 0, -0.5), hidden = Vector3:New(0, 0, 0.5)}
    if not ingame then
        if currentMenu == 'pause' then
            pauseMenu.transform:SetLocalPosition(positions.visible)
            saveMenu.transform:SetLocalPosition(positions.hidden)
        elseif currentMenu == 'save' then
            saveMenu.transform:SetLocalPosition(positions.visible)
            pauseMenu.transform:SetLocalPosition(positions.hidden)
        end
    else
        saveMenu.transform:SetLocalPosition(positions.hidden)
        pauseMenu.transform:SetLocalPosition(positions.hidden)
    end
    
    -- Saved text
    if savedTick > 3*60 then
        savedText:SetOpacity(0)
        savedTick = 0
    end

    -- Mouse locking
    if ingame then CS.Input.LockMouse() else CS.Input.UnlockMouse() end
    
    
end

function SaveWorld(id)
    CS.Storage.Save(
        "World" .. id,
        {seed = worldSeed, biomeCoords = biomeCoords, worldType = worldType, placedBlocks = placedBlocks}, 
        function(err) print(err ~= nil and "Unknown error" or "Successfully saved world " .. id) end
    )
    ingame = not ingame
    currentMenu = 'pause'
    savedText:SetOpacity(1)
end
