--[[
  小熊
  作者：huqiuxiang
]]
LittleBearPet = class (BasePet)
LittleBearPet.roleName = "LittleBear"


function LittleBearPet:Awake()
    self:ObjCreat()
end

--启动事件--
function LittleBearPet:Start()
    self.super.Start(self)
    -- self.super.BaseScenePetCreat(self,LuaShell.getRole(LuaShell.DesmondID))
    self.stateMachine:changeState(LittleBearGivingState.new())
end


function LittleBearPet:OnTriggerEnter( gameObj )
end

function LittleBearPet:itweenCallback()
    -- self.super.itweenCallback(self)
end

function LittleBearPet:ObjCreat()
  --[[设置角色]]
    if self.gameObject.transform:Find(self.roleName) == nil then
        self.character  = --newobject(ioo.LoadPrefab("Monster/"..self.roleName))
        newobject(Util.LoadPrefab("Pet/"..self.roleName))
        self.character.transform.parent=self.gameObject.transform
        self.character.transform.localPosition = UnityEngine.Vector3(0,0,0)
        self.character.transform.localScale = UnityEngine.Vector3(1,1,1)
        self.character.transform.rotation = Quaternion.Euler(0,90,0)
    else
        self.character = self.gameObject.transform:Find(self.roleName)
    end
    -- --[[设置碰撞体]]
    -- self.collider = self.gameObject:AddComponent(UnityEngine.CapsuleCollider.GetClassType())
    -- self.collider.isTrigger = true
    -- self.collider.center=UnityEngine.Vector3(0,0.8,0)
    -- self.collider.radius=0.9
    -- self.collider.height=1.8
end