--[[
  魂 用作冲击波扩散
  作者：秦仕超
]]
SoulPet = class (BasePet)


SoulPet.roleName = "soul"


function SoulPet:Awake()
    self.super.Awake(self)
    print("SoulPet")
end

--启动事件--
function SoulPet:Start()
	self.super.Start(self)
	self.stateMachine:changeState(ChinchillasBlastState.new())
end


function SoulPet:OnTriggerEnter( gameObj )

    -- if self.enhance == false then
    --     return
    -- end

    local role = LuaShell.getRole(gameObj.gameObject:GetInstanceID())
    if role==nil or role.type ~= "enemy" then
        return
    end
    role:assimilateToItem()

end


function SoulPet:itweenCallback()
    -- self.super.itweenCallback(self)
end

function SoulPet:init()
    -- self.super.init(self)

    self.collider = self.gameObject:AddComponent(UnityEngine.SphereCollider.GetClassType())
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0,0)
    self.collider.radius=0.5

    self.rigidBody = self.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    self.rigidBody.useGravity = false
    self.rigidBody.isKinematic = true
    self.rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll
end

