function Behavior:Awake()
    local shipPos = {x = math.random(minXZ,maxXZ), z = math.random(minXZ,maxXZ)}
    self.gameObject.transform:SetPosition(Vector3:New(shipPos.x, 32, shipPos.z))
    print(shipPos.x .. ' ' .. shipPos.z)
end

function Behavior:Update()
    
end
