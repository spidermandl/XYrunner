--[[
  author:Desmond
  普通平面,正上面行走，侧面是墙，阻挡
]]

FlatSurface = class(BaseSurface)
FlatSurface.type = "FlatSurface"
FlatSurface.role = nil --主角

function FlatSurface:Awake()

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

function FlatSurface:initParam()
    self.upFace = false

    self.super.initParam(self)
end
--启动事件--
function FlatSurface:Start()
    --print("-----------------FlatSurface Start--->>>-----------------")
    if ConfigParam.FilterColliderMash == true then--去碰撞物mesh
        if ConfigParam.isSceneObjLoadDynamic == false then
            destroy(self.gameObject:GetComponent(UnityEngine.MeshFilter.GetClassType()))
            destroy(self.gameObject:GetComponent(UnityEngine.MeshRenderer.GetClassType()))
        end
    end
    
end


function FlatSurface:OnCollisionEnter( collision )
	--print("-----------------FlatSurface OnCollisionEnter--->>>-----------------")
	-- self.collider.isTrigger = true
	-- self.rigidBody.isKinematic = true
	if collision.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --非与主角碰撞
        -- 注了下面两行为了 金币的collider.isTrigger为false  人能吃到金币
        -- local collider = collision.gameObject:GetComponent("BoxCollider")
        -- collider.isTrigger = true
		return
	end

	self.role = LuaShell.getRole(collision.gameObject:GetInstanceID())
	local contactDir=collision.contacts[0].normal

    --print ("--------------function FlatSurface:OnCollisionEnter( collision ) "..tostring(math.abs(contactDir.x))..' '..tostring(contactDir.y)..' '..tostring(contactDir.z))
	if math.abs(contactDir.x)/math.abs(contactDir.y)< 0.1 and contactDir.y<0 and math.abs(contactDir.z)<0.1 then
		self.upFace=true
    end
    
    if self.upFace==true then --从上跳到平面
		self.role.stateMachine:changeState(RunState.new())
	else
        --print("-----------------FlatSurface OnCollisionEnter--->>>----------------- 1 "..tostring(contactDir.y))
        if contactDir.x == 0 or contactDir.y/math.abs(contactDir.x) > 0.1 then --从下往上碰
            --print("-----------------FlatSurface OnCollisionEnter--->>>----------------- 2")
            self.role.stateMachine:changeState(DropState.new())
        else
            self.role.stateMachine:addSharedState(BlockState.new())
        end
	end

    -- print(collision.gameObject.name)
end


function FlatSurface:OnCollisionStay( collision )
    --print("-----------------FlatSurface OnCollisionStay--->>>-----------------")
end

function FlatSurface:OnCollisionExit( collision )
	--print ("-------------------------------------->>>>>> function FlatSurface:OnCollisionExit( collision ) ")
    if collision.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --与主角碰撞
		return
	end
    
 --    local state = self.role.stateMachine:getState()

    
 --    if self.upFace==true and state._name == "RunState" then --从上跳到平面
 --    	--self.super.dropFromSurface(self)
 --        -- print("Enter -----self.upFace==true----")
 --    	return
	-- end

	if self.upFace == false then
        --print("Enter -----self.upFace==false----")
        if self.role.stateMachine:getState()._name ~= "WallClimbState" then --没有触碰弹墙板
		    self.role.stateMachine:removeSharedState(BlockState.new())
        end
	end

    	
end
