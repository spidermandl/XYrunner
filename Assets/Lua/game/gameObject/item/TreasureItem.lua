--[[
   author:Desmond
   宝箱道具
]]
TreasureItem = class (BaseItem)

TreasureItem.type = 'TreasureItem'

function TreasureItem:Awake()
    self.super.Awake(self)
end

function TreasureItem:initParam()
    -- body
    if self.gameObject.transform:Find("box") == nil then
        self.item  = PoolFunc:pickObjByPrefabName("Items/treasure_box")
        self.item.transform.parent = self.gameObject.transform
        self.item.transform.position = self.gameObject.transform.position
        self.item.transform.localScale = self.gameObject.transform.localScale
    else
        self.item = self.gameObject.transform:Find("box")
        self.item.localPosition = UnityEngine.Vector3(0,0,0)
    end

    if self.collider == nil then
        self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    end
    self.collider.isTrigger = true

    self.collider.center=UnityEngine.Vector3(0,0.5,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,bound.y,bound.z)
end
--启动事件--
function TreasureItem:Start()

end

function TreasureItem:Update()
    self.super.Update(self)
end


function TreasureItem:OnTriggerEnter(gameObj)
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end
    self.stateMachine:changeState(BoxExplodeState.new())

end

--打开宝箱
function TreasureItem:explode()
    --print ("--------------------function TreasureItem:explode() 1 ")
    local obj = PoolFunc:pickObjByLuaName("CoinInTreasureItem")
    local lua = obj:GetComponent(BundleLua.GetClassType())
    if lua == nil then
        lua = obj:AddComponent(BundleLua.GetClassType())
    end
    lua.luaName = "CoinInTreasureItem"
    obj:SetActive(true)
    --print ("--------------------function TreasureItem:explode() 2 ")
    obj.transform.position = self.gameObject.transform.position
end

