--[[
   author:huqiuxiang
   无敌道具
]]
InvincibleItem = class (BaseItem)
InvincibleItem.type = 'InvincibleItem'
InvincibleItem.itemId = nil --道具ID
InvincibleItem.duringTime = nil --效果持续时间
InvincibleItem.effect = nil --特效
function InvincibleItem:Awake()
    self.super.Awake(self)
end

function InvincibleItem:initParam()
    local config = self.bundleParams
    if type(config) == "table" then
        local param = lua_string_split(config['param'],";")
        self.itemId = param[1]
        local player = LuaShell.getRole(LuaShell.DesmondID) 
        self.duringTime = player.property.InvincibleTime
    else
        local param = lua_string_split(config,"|")
        self.itemId = param[1]
        self.duringTime = tonumber(param[2])
    end
    if self.itemId ~= nil then
        local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
        local modelName = txt:GetData(self.itemId,TxtFactory.S_MATERIAL_MODEL)
        local effectName = txt:GetData(self.itemId,TxtFactory.S_MATERIAL_EFFECT)
        self.effect = self.super.CreateEffect(self,effectName)
        self.item  = PoolFunc:pickObjByPrefabName("Items/"..modelName)
        self.item.transform.parent = self.gameObject.transform
        self.item.transform.localPosition = Vector3(0,0,0)
        self.item.transform.localScale = UnityEngine.Vector3.one
        self.item.transform.localRotation = Quaternion.Euler(0,0,0)
    end
    if self.collider == nil then
        self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    end
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x*6,bound.y,bound.z)
    self.super.initParam(self)
end
--启动事件--
function InvincibleItem:Start()
end


function InvincibleItem:FixedUpdate()
end

function InvincibleItem:OnTriggerEnter( gameObj )
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end

    local task = TxtFactory:getTable(TxtFactory.TaskManagement)
    task:SetTaskData(TaskType.TASK_COLLECT,tonumber(self.itemId),1)
    
    local player = LuaShell.getRole(LuaShell.DesmondID) 

    local buff = InvincibleState.new()
    buff.duringTime = self.duringTime
    player.stateMachine:addSharedState(buff) -- 主角无敌buff
    PoolFunc:inactiveObj(self.gameObject)
    --移除特效
    if self.effect ~= nil then
        local effectManager = PoolFunc:pickSingleton("EffectGroup") --effect管理器
        effectManager:removeObject(self.effect)
    end

end