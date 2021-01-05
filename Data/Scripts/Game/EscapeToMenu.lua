function Behavior:Awake()
    
end

function Behavior:Update()
    if CS.Input.WasButtonJustReleased("Escape") then
        local menuScene = CraftStudio.FindAsset("Main Menu", "Scene")
        CraftStudio.LoadScene(menuScene)
    end
end
