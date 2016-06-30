--[[
   author:Huqiuxiang
   问号宝箱道具
]]
--BaseBehaviour BaseItem
UnsolvedTreasureItem = class (BaseItem)
UnsolvedTreasureItem.type = 'UnsolvedTreasureItem'


function UnsolvedTreasureItem:Awake()
	-- print("-----------------UnsolvedTreasureItem Awake--->>>-----------------")
    if self.gameObject.transform:Find("box") == nil then
        self.item  = PoolFunc:pickObjByPrefabName("Items/treasure_box")
        self.item.transform.parent = self.gameObject.transform
        self.item.transform.position = self.gameObject.transform.position
        self.item.transform.localScale = self.gameObject.transform.localScale
    else
        self.item = self.gameObject.transform:Find("box")
        self.item.localPosition = UnityEngine.Vector3(0,0,0)
    end

    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = true

    self.collider.center=UnityEngine.Vector3(0,0.5,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,bound.y,bound.z)

    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self
end

--启动事件--
function UnsolvedTreasureItem:Start()
end

function UnsolvedTreasureItem:Update()
    self.super.Update(self)
end

function UnsolvedTreasureItem:OnTriggerEnter( gameObj )
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end
    self.stateMachine:changeState(UnsolvedTreasureBoxExplodeState.new())
end

