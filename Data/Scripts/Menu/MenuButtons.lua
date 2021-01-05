currentMenu = 'main'
worldType = 'normal'
local hovered = {play = false, exit = false, normalWorld = false, flatWorld = false}
local pos
local button

function Behavior:Update()

    local camera = CS.FindGameObject("Camera")
    local mousePos = CS.Input.GetMousePosition()
    local ray = camera:GetComponent("Camera"):CreateRay(mousePos)
    
    button = {
        play = CS.FindGameObject("PlayButton"),
        exit = CS.FindGameObject("ExitButton"),
        normalWorld = CS.FindGameObject("NormalWorldButton"),
        flatWorld = CS.FindGameObject("FlatWorldButton")
    }
    
    if not pos then pos = {
        play = button.play.transform:GetPosition(),
        exit = button.exit.transform:GetPosition(),
        normalWorld = button.normalWorld.transform:GetPosition(),
        flatWorld = button.flatWorld.transform:GetPosition()
    } end
    
    hovered.play = ray:IntersectsModelRenderer(button.play:GetComponent("ModelRenderer")) ~= nil
    hovered.exit = ray:IntersectsModelRenderer(button.exit:GetComponent("ModelRenderer")) ~= nil
    hovered.normalWorld = ray:IntersectsModelRenderer(button.normalWorld:GetComponent("ModelRenderer")) ~= nil
    hovered.flatWorld = ray:IntersectsModelRenderer(button.flatWorld:GetComponent("ModelRenderer")) ~= nil
        
    local size = {regular = Vector3:New(8, 8, 8), large = Vector3:New(9, 9, 9)}
    button.play.transform:SetLocalScale(hovered.play and size.large or size.regular)
    button.exit.transform:SetLocalScale(hovered.exit and size.large or size.regular)
    button.normalWorld.transform:SetLocalScale(hovered.normalWorld and size.large or size.regular)
    button.flatWorld.transform:SetLocalScale(hovered.flatWorld and size.large or size.regular)    
    
    local isClicked = CS.Input.WasButtonJustPressed("LClick")
    if hovered.play and isClicked then
        if completedMap then 
            LoadWorld()
        else 
            currentMenu = 'worldType'
        end
    elseif (hovered.normalWorld or hovered.flatWorld) and isClicked then
        worldType = hovered.normalWorld and 'normal' or 'flat'
        print('Set world type to ' .. worldType)
        LoadWorld()
    elseif hovered.exit and isClicked then
        CS.Exit()
    end
    
    -- Move buttons offscreen when not that menu
    local zCoords = {main = 0+1, worldType = -20+1}
    local offScreen = Vector3:New(100, 0, 0)
    if currentMenu == 'main' then
       button.play.transform:SetPosition(Vector3:New(0, pos.play.y, zCoords.main))
       button.exit.transform:SetPosition(Vector3:New(0, pos.exit.y, zCoords.main))
       button.normalWorld.transform:SetPosition(offScreen)
       button.flatWorld.transform:SetPosition(offScreen)
    elseif currentMenu == 'worldType' then
       button.play.transform:SetPosition(offScreen)
       button.exit.transform:SetPosition(offScreen)
       button.normalWorld.transform:SetPosition(Vector3:New(0, pos.normalWorld.y, zCoords.worldType))
       button.flatWorld.transform:SetPosition(Vector3:New(0, pos.flatWorld.y, zCoords.worldType))
    else
        
    end
    
end

function LoadWorld()
    currentMenu = 'main'
    CS.FindGameObject("Camera").transform:SetPosition(Vector3:New(0, 0, -25))
    CS.LoadScene(CS.FindAsset("Game", "Scene"))
end