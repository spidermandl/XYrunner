--[[
   author:huqiuxiang
   跳引导道具 JumpGuideItem
]]
JumpGuideItem = class (BaseItem)
JumpGuideItem.type = 'JumpGuideItem'

function JumpGuideItem:Awake()
    -- print("-----------------StaminaBottle Awake--->>>-----------------")

    if self.gameObject.transform:Find("GuideItem") == nil then
        self.item  = PoolFunc:pickObjByPrefabName("Items/GuideItem")
        self.item.transform.parent = self.gameObject.transform
        self.item.transform.localPosition = UnityEngine.Vector3(0,0,0)
        self.item.transform.localScale = UnityEngine.Vector3(1.5,1.5,1.5)
        self.item.transform.rotation = Quaternion.Euler(0,0,0)
    else
        self.item = self.gameObject.transform:Find("GuideItem")
    end

    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.super.guideItemsAwake(self)

    self.super.Awake(self)
end

--启动事件--
function JumpGuideItem:Start()

end

function JumpGuideItem:initParam()
    self.super.initParam(self)
    
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0.5,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,10,bound.z)
end

function JumpGuideItem:FixedUpdate()
end

function JumpGuideItem:OnTriggerEnter( gameObj )
    --print ("-----------------------function JumpGuideItem:OnTriggerEnter( gameObj ) ")
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end

    self.stateMachine:changeState(JumpGuideItemState.new())
end


