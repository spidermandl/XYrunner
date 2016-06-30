--[[
   author:huqiuxiang
   踏墙引导道具 HangingGuideItem
]]
HangingGuideItem = class (BaseItem)
HangingGuideItem.type = 'HangingGuideItem'
HangingGuideItem.dialogueIsOver = nil 
HangingGuideItem.doneAction = nil -- 标记是否已经做过


function HangingGuideItem:Awake()
	-- print("-----------------StaminaBottle Awake--->>>-----------------")
    if self.gameObject.transform:Find("GuideItem") == nil then
        self.item = PoolFunc:pickObjByPrefabName("Items/GuideItem")
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

function HangingGuideItem:initParam()
    self.super.initParam(self)
    
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0.5,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,10,bound.z)
    
    self.doneAction = false

    self.gameObject.transform:GetChild(0).gameObject:SetActive(true) -- 空中跳跃 去提示
end

function HangingGuideItem:FixedUpdate()
end

function HangingGuideItem:OnTriggerEnter( gameObj )
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false or self.doneAction == true then
        return
    end
    --return
   self.stateMachine:changeState(HangingGuideItemState.new()) 
    self.doneAction = true
end


