function Behavior:Awake()
    
end

function Behavior:Update()
    local map = CS.FindGameObject("Map")
    local mousePos = CS.Input.GetMousePosition()
    local ray = self.gameObject.GetComponent("Camera"):CreateRay(mousePos)
    
    if ray:IntersectsMapRenderer(map) ~= nil then
        
    end
end
