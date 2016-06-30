--[[
   author:huqiuxiang
   混乱道具 CoinWaveItem
]]
CoinWaveItem = class (BaseItem)
CoinWaveItem.type = 'CoinWaveItem'

function CoinWaveItem:Awake()
    self.super.Awake(self)
end

function CoinWaveItem:initParam()
    if type(self.bundleParams) == "table" then
        local config = self.bundleParams
        local param = lua_string_split(config['param'],";")
        self.itemId = param[1]
        local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
        local modelName = "magnet"--txt:GetData(self.itemId,TxtFactory.S_MATERIAL_MODEL)
        local effectName = txt:GetData(self.itemId,TxtFactory.S_MATERIAL_EFFECT)
        self.super.CreateEffect(self,effectName)
        self.item  = PoolFunc:pickObjByPrefabName("Items/"..modelName)
        self.item.transform.parent = self.gameObject.transform
        self.item.transform.localPosition = Vector3(0,-0.4,0)
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
function CoinWaveItem:Start()
end

function CoinWaveItem:Update()
    self.super.Update(self)
end

function CoinWaveItem:FixedUpdate()
end

function CoinWaveItem:OnTriggerEnter( gameObj )
    self.super.OnTriggerEnter(self,gameObj)
    self.stateMachine:changeState(CoinWaveItemState.new()) 
    PoolFunc:inactiveObj(self.gameObject)
end