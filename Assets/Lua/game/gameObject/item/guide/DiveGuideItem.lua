--[[
   author:huqiuxiang
   滑翔引导道具 DiveGuideItem
]]
DiveGuideItem = class (BaseItem)
DiveGuideItem.item = nil
DiveGuideItem.collider = nil
DiveGuideItem.stateMachine = nil
DiveGuideItem.GudieRunningSceneTXT = nil
DiveGuideItem.compulsion = nil 

function DiveGuideItem:Awake()
	-- print("-----------------StaminaBottle Awake--->>>-----------------")
    if self.gameObject.transform:Find("GuideItem") == nil then
        self.item  = newobject(Util.LoadPrefab("Items/GuideItem"))
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

function DiveGuideItem:initParam()
    self.super.initParam(self)
    
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0.5,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,20,bound.z)
end

function DiveGuideItem:OnTriggerEnter( gameObj )
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end
    self.stateMachine:changeState(DiveGuideItemState.new()) 
    -- self:creatUI()
end


