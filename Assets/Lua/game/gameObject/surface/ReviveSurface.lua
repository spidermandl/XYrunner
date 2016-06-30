--[[
  author:Desmond
  重生板
]]
ReviveSurface = class(BaseSurface)
ReviveSurface.type="ReviveSurface"
ReviveSurface.moveSpeed = 0 --移动速度
ReviveSurface.releasePoint = nil --释放点

function ReviveSurface:Awake()
	
    --[[ table参数
        救起移动速度
        就生板大小 localscale
        救起终点位置
    ]]
    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = false
    self.collider.center=UnityEngine.Vector3(0,0,0)
    
    --[[设置刚体]]
    self.rigidBody = self.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    self.rigidBody.useGravity = false
    self.rigidBody.isKinematic = false
    self.rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll

    if ConfigParam.FilterColliderMash == true then--去碰撞物mesh
    	-- GameObject.OnDestroy(self.gameObject:GetComponent(UnityEngine.MeshFilter.GetClassType()))
     --    GameObject.OnDestroy(self.gameObject:GetComponent(UnityEngine.MeshRenderer.GetClassType()))
    end

    self.super.Awake(self)

end

--设置参数
function ReviveSurface:initParam()
    if type(self.bundleParams) == "table" then  --参数从json中读入,动态加载时生效
        local config = self.bundleParams
        self.moveSpeed = tonumber(config[1])
        local array = lua_string_split(config['surface_localScale'],",")
        self.collider.size = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) --碰撞大小
        --array = lua_string_split(config['target_localPosition'],",")
        --self.releasePoint = self.gameObject.transform.position+
                        --UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3]))--下落点
                        --print (tostring(self.releasePoint))
    else
        self.moveSpeed = tonumber(tostring(System.Array.GetValue(self.bundleParams,0)))
        --self.releasePoint = self.gameObject.transform:Find("target").position
    end

    self.monoTrigger = true

    self.super.initParam(self)
end

--启动事件--
function ReviveSurface:Start()
    --print("-----------------ReviveSurface Start--->>>-----------------")
end



function ReviveSurface:OnCollisionEnter( collision )
    --print("-----------------ReviveSurface OnCollisionEnter --->>>----------------- ")
    if collision.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --非与主角碰撞
        return
    end
    local role = LuaShell.getRole(collision.gameObject:GetInstanceID())

    if role.stateMachine.sharedStates["PathFindingState"] ~= nil then --是否有自动寻路状态
        return
    end
    --[[生成宠物]]
------------------------------------------------------------------------------------
    if role.stateMachine:getState()._name ~= "DeadState" then
        role.stateMachine:changeState(DeadState.new())
        local pet = role:createPet(role:getPlyPetTypeID()) --只能用哈比救人
        pet:triggerFollowerSkill()
    end
end


