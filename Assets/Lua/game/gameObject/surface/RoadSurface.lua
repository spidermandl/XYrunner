--[[
author Desmond
路面
]]
RoadSurface = class(BaseSurface)
RoadSurface.type = "RoadSurface"
RoadSurface.role = nil --主角

function RoadSurface:Awake()

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

function RoadSurface:initParam()
    self.super.initParam(self)
end
--启动事件--
function RoadSurface:Start()
    --print("-----------------RoadSurface Start--->>>-----------------")
    if ConfigParam.FilterColliderMash == true then--去碰撞物mesh
        if ConfigParam.isSceneObjLoadDynamic == false then
            destroy(self.gameObject:GetComponent(UnityEngine.MeshFilter.GetClassType()))
            destroy(self.gameObject:GetComponent(UnityEngine.MeshRenderer.GetClassType()))
        end
    end
    
end


function RoadSurface:OnCollisionEnter( collision )
	--GamePrint("-----------------RoadSurface OnCollisionEnter--->>>-----------------")
	if collision.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --非与主角碰撞
        -- 注了下面两行为了 金币的collider.isTrigger为false  人能吃到金币
        -- local collider = collision.gameObject:GetComponent("BoxCollider")
        -- collider.isTrigger = true
		return
	end

	self.role = LuaShell.getRole(collision.gameObject:GetInstanceID())
	-- local contactDir=collision.contacts[0].normal
 --    --GamePrint("-----------function RoadSurface:OnCollisionEnter( collision ) "..tostring(contactDir.y))
 --    if contactDir.y <= 0 then
	-- 	self.upFace = true
 --    end
    
 --    if self.upFace==true then --从上跳到平面
	-- 	--self.role.stateMachine:changeState(RunState.new())
	-- else
 --        --GamePrint("-----------function RoadSurface:OnCollisionEnter( collision ) 3")
 --        self.role.stateMachine:changeState(DropState.new())
	-- end
    if self.gameObject.transform.parent.name == "MovingSurface" then --站在云的路上，播放云动作
        --GamePrint("self.gameObject.transform.parent.name  :"..self.gameObject.transform.parent.name)
        local anim = self.gameObject.transform.parent.transform:Find("clouds/cloud"):GetComponent("Animator")
        anim:Play("idle")
    end
end
