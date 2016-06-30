--[[
   author:huqiuxiang
   不能发技能道具 CantSkillItem
]]
CantSkillItem = class (BaseItem)
CantSkillItem.type = 'CantSkillItem'

function CantSkillItem:Awake()
	-- print("-----------------StaminaBottle Awake--->>>-----------------")
    if self.gameObject.transform:Find("magnet") == nil then
        self.item = PoolFunc:pickObjByPrefabName("Items/magnet")
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
function CantSkillItem:Start()
end

function CantSkillItem:Update()
    self.super.Update(self)
end

function CantSkillItem:FixedUpdate()
end

function CantSkillItem:OnTriggerEnter( gameObj )
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end
    self.stateMachine:changeState(CantSkillItemState.new()) 
end