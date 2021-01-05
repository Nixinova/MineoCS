workbenchOpen = false
workbenchClickCount = 0
quarryIcon = nil
quarryCount = 0

function Behavior:Awake()
    CS.Input.UnlockMouse()
    quarryIcon = CS.FindGameObject("QuarryIcon")
    --quarryIcon.transform:SetLocalPosition(Vector3:New(-6.375,4.375,0.125))
end

function Behavior:Update()
    --[[local player = CS.FindGameObject("Model")
    local coords = player.transform:GetPosition()
    local x = nil
    local y = nil
    local z = nil--]]
    
    local inv = CS.FindAsset('Workbench', 'Scene')
    local workbench = CS.FindGameObject("Workbench"):GetComponent("ModelRenderer")
    local workbenchInv = CS.FindGameObject("WorkbenchInv")
    local scene = CS.FindAsset('Game', 'Scene')
    local exitWorkbench = CS.FindGameObject("ExitWorkbench"):GetComponent("TextRenderer")
    
    local mousePos = CS.Input.GetMousePosition()
    local ray = CS.FindGameObject("Camera"):GetComponent("Camera"):CreateRay(mousePos)
    
    if ray:IntersectsModelRenderer(workbench) ~= nil 
    and CS.Input.IsButtonDown("RClick")
    then
        --[[x = coords.x
        y = coords.y
        z = coords.z--]]
        workbenchOpen = true
    end
    
    if workbenchOpen == true then
        CS.Input.UnlockMouse()
        
        workbenchInv:GetComponent("ModelRenderer"):SetOpacity("1")
        workbenchInv.transform:SetLocalPosition(Vector3:New(0,-0.22,-0.5))
        
        local quarryCountText = CS.FindGameObject("QuarryCount"):GetComponent("TextRenderer")
        
        if ray:IntersectsModelRenderer(quarryIcon:GetComponent("ModelRenderer")) ~= nil 
        and CS.Input.WasButtonJustPressed("LClick")
        then
            if inventory.stone >= 32 then
                inventory.stone = inventory.stone - 32
            quarryCount = quarryCount + 1
            end
        end
        
        if quarryCount == 0 then
            quarryCountText:SetOpacity("0")
        else
            quarryCountText:SetText(quarryCount)
            quarryCountText:SetOpacity("1")
        end
        
        if ray:IntersectsTextRenderer(exitWorkbench) ~= nil
        and CS.Input.WasButtonJustPressed("LClick")
        then
            workbenchOpen = false
            workbenchInv:GetComponent("ModelRenderer"):SetOpacity("1")
            workbenchInv.transform:SetLocalPosition(Vector3:New(0,-0.22,-0.5))
        end
    else
        CS.Input.LockMouse()
        workbenchInv:GetComponent("ModelRenderer"):SetOpacity("0")
        workbenchInv.transform:SetLocalPosition(Vector3:New(0,-0.22,0.5))
    end
end
