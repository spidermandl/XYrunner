--[[
   author: huqiuxiang
   精灵球 PokeBallItem
]]
PokeBallItem = class (BaseItem)
PokeBallItem.item = nil
PokeBallItem.collider = nil
PokeBallItem.stateMachine = nil

function PokeBallItem:Awake()
	-- print("-----------------PokeBallItem Awake--->>>-----------------")
    if self.gameObject.transform:Find("PokeBall") == nil then
        self.item  = PoolFunc:pickObjByPrefabName("Items/PokeBall")
        self.item.transform.parent = self.gameObject.transform
        self.item.transform.position = self.gameObject.transform.position
        self.item.transform.localScale = self.gameObject.transform.localScale
    else
        self.item = self.gameObject.transform:Find("PokeBall")
        self.item.localPosition = UnityEngine.Vector3(0,0,0)
    end

    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = true

    self.collider.center=UnityEngine.Vector3(0,0,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,bound.y,bound.z)

    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self
end

--启动事件--
function PokeBallItem:Start()
end

function PokeBallItem:Update()
    self.super.Update(self)
    -- if self.role.stateMachine:getSharedState("MagnetState") ~= nil then
    --      self.gameObject.transform.position =  Vector3.MoveTowards(self.gameObject.transform.position, self.role.gameObject.transform.position,Time.deltaTime * 28)
    -- end
end

function PokeBallItem:FixedUpdate()
end

function PokeBallItem:OnTriggerEnter( gameObj )
    -- print("PokeBallItem:OnTriggerEnter gameObj name :"..gameObj.name)
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end
    self.stateMachine:changeState(PokeballItemState.new())
end