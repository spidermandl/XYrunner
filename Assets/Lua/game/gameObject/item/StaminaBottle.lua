--[[
   author: huqiuxiang
   体力瓶 StaminaBottle
]]
StaminaBottle = class (BaseItem)
StaminaBottle.type = 'StaminaBottle'
StaminaBottle.effect = nil --特效
function StaminaBottle:Awake()
    self.super.Awake(self)
end
function StaminaBottle:initParam()
    local config = self.bundleParams
    if type(config) == "table" then
        local param = lua_string_split(config['param'],";")
        self.itemId = param[1]
    else
        self.itemId = config
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
function StaminaBottle:Start()
end

function StaminaBottle:Update()
    self.super.Update(self)
    -- if self.role.stateMachine:getSharedState("MagnetState") ~= nil then
    --      self.gameObject.transform.position =  Vector3.MoveTowards(self.gameObject.transform.position, self.role.gameObject.transform.position,Time.deltaTime * 28)
    -- end
end

function StaminaBottle:FixedUpdate()
end

function StaminaBottle:OnTriggerEnter( gameObj )
    -- print("StaminaBottle:OnTriggerEnter gameObj name :"..gameObj.name)
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end

    local task = TxtFactory:getTable(TxtFactory.TaskManagement)
    task:SetTaskData(TaskType.TASK_COLLECT,tonumber(self.itemId),1)
    self.stateMachine:changeState(StaminaBottleState.new())
    PoolFunc:inactiveObj(self.gameObject)
        --移除特效
    if self.effect ~= nil then
        local effectManager = PoolFunc:pickSingleton("EffectGroup") --effect管理器
        effectManager:removeObject(self.effect)
    end
end