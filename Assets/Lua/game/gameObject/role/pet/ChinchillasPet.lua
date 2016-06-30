--[[
  龙猫
  作者：秦仕超 赵名飞
]]
ChinchillasPet = class (BasePet)
ChinchillasPet.enhance = false --龙猫变色版
ChinchillasPet.roleName = "chinchillas" -- LittleBear Chinchillas
ChinchillasPet.type = "chinchillas"

function ChinchillasPet:Awake()
    self.super.Awake(self)
end

function ChinchillasPet:Update()
    if self.role == nil then
        self.role = LuaShell.getRole(LuaShell.DesmondID) 
        return
    end
end
--初始化固定属性
function ChinchillasPet:Start()
    --self.stateMachine:changeState(ChinchillasDropState.new())
end
function ChinchillasPet:OnCollisionEnter( gameObj )

    local role = LuaShell.getRole(gameObj.gameObject:GetInstanceID()) --碰撞的对象
    if role ~= nil then
        if role.type == 'FlatSurface' then
            self.stateMachine:changeState(ChinchillasDownState.new())
        end
    end
end
function ChinchillasPet:OnTriggerEnter( gameObj )

    local role = LuaShell.getRole(gameObj.gameObject:GetInstanceID()) --碰撞的对象
    if role ~= nil and role.type == 'enemy' then
        role:attackEnemy(self) --传入龙猫
    end
    
end
--初始化属性触发状态
function ChinchillasPet:initParam()
    --设置属性
    self.character.transform.localScale = Vector3(1.5,1.5,1.5)
    self.collider = self.gameObject:GetComponent(UnityEngine.SphereCollider.GetClassType())
    if self.collider == nil then
        self.collider = self.gameObject:AddComponent(UnityEngine.SphereCollider.GetClassType())
    end
    self.collider.isTrigger = false
    self.collider.center = UnityEngine.Vector3(0,1.8,0)
    self.collider.radius = 2.5
    self.rigidBody = self.gameObject:GetComponent(UnityEngine.Rigidbody.GetClassType())
    if self.rigidBody == nil then
        self.rigidBody = self.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    end
    self.rigidBody.useGravity = false
    self.rigidBody.isKinematic = true
    self.rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll
    --设置位置
    local posX = self.role.gameObject.transform.localPosition.x --获得当前角色x轴位置
    self.gameObject.transform.parent=self.role.gameObject.transform.parent
    self.gameObject.transform.localPosition = UnityEngine.Vector3(posX + 10,15,0)
    --添加状态
    self.stateMachine:changeState(ChinchillasDropState.new())
end
