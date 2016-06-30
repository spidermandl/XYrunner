--[[
  author:Desmond
  单面平面
]]
MonoSurface = class (BaseSurface)

MonoSurface.surface = nil
MonoSurface.collider = nil
MonoSurface.type = 'MonoSurface' --收集道具类型
MonoSurface.upFace = false --正上方接触面
MonoSurface.role = nil

function MonoSurface:Awake()
	--print("-----------------MonoSurface Awake--->>>-----------------")

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

function MonoSurface:initParam()
    self.upFace = false

    self.super.initParam(self)
end

--启动事件--
function MonoSurface:Start()

    -- if ConfigParam.FilterColliderMash == true then--去碰撞物mesh
    --     if ConfigParam.isSceneObjLoadDynamic == false then
    --         destroy(self.gameObject:GetComponent(UnityEngine.MeshFilter.GetClassType()))
    --         destroy(self.gameObject:GetComponent(UnityEngine.MeshRenderer.GetClassType()))
    --     end
    -- end
    
end

function MonoSurface:Update()
    self.super.Update(self)

end

function MonoSurface:OnCollisionEnter( collision )
    if collision.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --非与主角碰撞
        -- 注了下面两行为了 金币的collider.isTrigger为false  人能吃到金币
        -- local collider = collision.gameObject:GetComponent("BoxCollider")
        -- collider.isTrigger = true
        return
    end

    self.role = LuaShell.getRole(collision.gameObject:GetInstanceID())
    local contactDir=collision.contacts[0].normal

    if math.abs(contactDir.x)/math.abs(contactDir.y)< 0.1 and contactDir.y<0 and math.abs(contactDir.z)<0.1 then
        self.upFace=true
    end
    
    if self.upFace==true then --从上跳到平面
        --self.role.stateMachine:changeState(RunState.new())
    else

    end

    -- print(collision.gameObject.name)
end


function MonoSurface:OnCollisionStay( collision )
    --print("-----------------FlatSurface OnCollisionStay--->>>-----------------")
end

function MonoSurface:OnCollisionExit( collision )
    --print ("-------------------------------------->>>>>> function FlatSurface:OnCollisionExit( collision ) ")
    if collision.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --与主角碰撞
        return
    end
    

    if self.upFace == false then
        print("Enter -----self.upFace==false----")
        if self.role.stateMachine:getState()._name ~= "WallClimbState" then --没有触碰弹墙板
            self.role.stateMachine:removeSharedState(BlockState.new())
        end
    end

        
end

