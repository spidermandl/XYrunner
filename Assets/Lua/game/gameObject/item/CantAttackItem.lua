--[[
   author:huqiuxiang
   不能攻击道具 CantAttackItem
]]
CantAttackItem = class (BaseItem)
CantAttackItem.type = 'CantAttackItem'

function CantAttackItem:Awake()
	-- print("-----------------StaminaBottle Awake--->>>-----------------")
    if self.gameObject.transform:Find("magnet") == nil then
        self.item  = PoolFunc:pickObjByPrefabName("Items/magnet")
        self.item.transform.parent = self.gameObject.transform
        self.item.transform.position = self.gameObject.transform.position
        self.item.transform.localScale = UnityEngine.Vector3(1.5,1.5,1.5)
        self.item.transform.rotation = Quaternion.Euler(0,90,0)
    else
        self.item = self.gameObject.transform:Find("magnet")
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
function CantAttackItem:Start()
end

function CantAttackItem:Update()
    self.super.Update(self)
end

function CantAttackItem:FixedUpdate()
end

function CantAttackItem:OnTriggerEnter( gameObj )
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end
    self.stateMachine:changeState(CantAttackItemState.new())  
end




