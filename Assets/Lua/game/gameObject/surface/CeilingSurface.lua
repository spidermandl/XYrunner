--[[
author:Desmond
天花板
]]
CeilingSurface = class(BaseSurface)
CeilingSurface.type = "CeilingSurface"
CeilingSurface.role = nil --主角

function CeilingSurface:Awake()

    self.gameObject.layer = UnityEngine.LayerMask.NameToLayer("Step")
    self.gameObject.name = self.type
    
    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = false
    self.collider.center=UnityEngine.Vector3(0,0,0)

    --[[设置刚体]]
    self.rigidBody = self.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    self.rigidBody.useGravity = false
    self.rigidBody.isKinematic = false
    self.rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll

    
    self.super.Awake(self)
end

function CeilingSurface:initParam()
    self.super.initParam(self)
end
--启动事件--
function CeilingSurface:Start()
    --print("-----------------CeilingSurface Start--->>>-----------------")
    if ConfigParam.FilterColliderMash == true then--去碰撞物mesh
        if ConfigParam.isSceneObjLoadDynamic == false then
            destroy(self.gameObject:GetComponent(UnityEngine.MeshFilter.GetClassType()))
            destroy(self.gameObject:GetComponent(UnityEngine.MeshRenderer.GetClassType()))
        end
    end
    
end


function CeilingSurface:OnCollisionEnter( collision )
	if collision.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --非与主角碰撞
        -- 注了下面两行为了 金币的collider.isTrigger为false  人能吃到金币
        -- local collider = collision.gameObject:GetComponent("BoxCollider")
        -- collider.isTrigger = true
		return
	end

	--GamePrint("-----------------CeilingSurface OnCollisionEnter--->>>-----------------")
	self.role = LuaShell.getRole(collision.gameObject:GetInstanceID())
    if self.role.stateMachine:getState()._name ~= "DeadState" then --角色被救起状态 不下落
        self.role.stateMachine:changeState(DropState.new())
    end
end


