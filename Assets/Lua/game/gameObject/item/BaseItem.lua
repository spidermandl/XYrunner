--[[
   author: huqiuxiang
   BaseItem
   物品基类
]]

BaseItem = class (BaseBehaviour)
BaseItem.type = "item"
BaseItem.item = nil
BaseItem.collider = nil
BaseItem.role = nil -- 主角
BaseItem.stateMachine = nil
BaseItem.staminaAdd = 2 
BaseItem.effect = nil 
BaseItem.compulsion = nil
BaseItem.showPhoto = nil 

BaseItem.itemManager = nil

function BaseItem:Awake()
    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self
    if type(self.bundleParams) == "table" then  --参数从json中读入,动态加载时生效
        --[[ table参数
            怪物id
        ]]
        self.enemyId = self.bundleParams.param
        --print ("--------------function BaseEnemy:Awake() "..tostring(self.enemyId))
        local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
        self.roleName = txt:GetData(self.enemyId,TxtFactory.S_MATERIAL_MODEL)
        --print("-----------------BaseEnemy Awake--->>>----------------- ")
    end
    self.itemManager = PoolFunc:pickSingleton("ItemGroup") --获取怪物管理器
    local lua = self.gameObject:GetComponent(BundleLua.GetClassType()) --移除lua update
    lua.isUpdate = false

    self:initParam()
end

function BaseItem:Start()
end

function BaseItem:initParam()
    self.itemManager:addObject(self) --加入物体
end
function BaseItem:CreateEffect(effectName)
    if effectName == nil or effectName == "" then
        return
    end
    local effectManager = PoolFunc:pickSingleton("EffectGroup") --effect管理器
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/"..effectName)
    effectManager:addObject(effect,true)
    effect.transform.parent = self.gameObject.transform
    effect.transform.localPosition = Vector3.zero
    return effect
end
function BaseItem:Update()
	if self.role == nil then
		self.role=LuaShell.getRole(LuaShell.DesmondID)
		return
	end
    if self.gameObject == nil then
        return
    end

    self.stateMachine:runState(UnityEngine.Time.deltaTime)
    
    self.distance = self.gameObject.transform.position.x - self.role.character.transform.position.x  -- 与主角距离
    if self.distance < ConfigParam.objectDestroyByCameraDis then
    	 --销毁特效
        local state = self.stateMachine:getState()
        if state ~= nil then
        	-- print("self state :"..tostring(state))
            state:Exit(self)
        end
        --LuaShell.OnDestroy(self.gameObject:GetInstanceID()) --销毁对象
        -- print(self.gameObject.name)
        --PoolFunc:inactiveObj(self.gameObject)
        self:inactiveSelf()
    end

end


function BaseItem:OnTriggerEnter( gameObj )
    if gameObj.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --与主角碰撞
        return false
    end
    -- if self.role ~= nil then
    --     local buff = self.role.stateMachine:getSharedState("AntiMagnetState")
    --     if buff ~= nil then --判断是否有 无法收集物品状态
    --         return
    --     end
    -- end
    
end

function BaseItem:guideItemsAwake()
    if type(self.bundleParams) == "table" then
        local config = self.bundleParams
        local param = lua_string_split(config['param'],";")
        self.compulsion = param[1]
        self.showPhoto = param[2]
    end
end

--冷藏自身
function BaseItem:inactiveSelf()
    local state = self.stateMachine:getState()
    if state ~= nil then
        state:Exit(self)
    end
    
    if self.item ~= nil then
        PoolFunc:inactiveObj(self.item)
    end

    self.itemManager:removeObject(self)
end
