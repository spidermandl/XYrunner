--[[
   author:huqiuxiang
   变大药水
]]
ChangeBigBottle = class (BaseItem)
ChangeBigBottle.type = 'ChangeBigBottle'
ChangeBigBottle.effect = nil --特效
function ChangeBigBottle:Awake()
    self.super.Awake(self)
end

function ChangeBigBottle:initParam()
    if type(self.bundleParams) == "table" then
        local config = self.bundleParams
        local param = lua_string_split(config['param'],";")
        self.itemId = param[1]
        local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
        local modelName = txt:GetData(self.itemId,TxtFactory.S_MATERIAL_MODEL)
        local effectName = txt:GetData(self.itemId,TxtFactory.S_MATERIAL_EFFECT)
        self.effect = self.super.CreateEffect(self,effectName)
        self.item  = PoolFunc:pickObjByPrefabName("Items/"..modelName)
        self.item.transform.parent = self.gameObject.transform
        self.item.transform.localPosition = Vector3.zero
        self.item.transform.localScale = UnityEngine.Vector3.one
        self.item.transform.localRotation = Quaternion.Euler(0,0,0)
    end
    if self.collider == nil then
        self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    end
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,bound.y,bound.z)
    self.super.initParam(self)
end


--启动事件--
function ChangeBigBottle:Start()
end

function ChangeBigBottle:Update()
    self.super.Update(self)
end

function ChangeBigBottle:FixedUpdate()
end

function ChangeBigBottle:OnTriggerEnter( gameObj )
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end
    
    local task = TxtFactory:getTable(TxtFactory.TaskManagement)
    task:SetTaskData(TaskType.TASK_COLLECT,tonumber(self.bundleParams.param),1)
    self.stateMachine:changeState(ChangeBigBottleState.new())
    PoolFunc:inactiveObj(self.gameObject)
        --移除特效
    if self.effect ~= nil then
        local effectManager = PoolFunc:pickSingleton("EffectGroup") --effect管理器
        effectManager:removeObject(self.effect)
    end
end