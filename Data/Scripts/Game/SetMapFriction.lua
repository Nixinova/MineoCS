function Behavior:Awake()
    -- Disable vertical friction
    self.gameObject.physics:SetAnisotropicFriction( Vector3:New( 1, 0, 1 ) )
end
