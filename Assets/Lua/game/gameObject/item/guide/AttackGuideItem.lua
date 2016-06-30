--[[
   author:huqiuxiang
   攻击引导道具 AttackGuideItem
]]
AttackGuideItem = class (BaseItem)
AttackGuideItem.type = 'AttackGuideItem'

function AttackGuideItem:Awake()
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

function AttackGuideItem:initParam()
    self.super.initParam(self)
    
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,5,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,10,bound.z)
    --GamePrintTable(self.bundleParams)
--[[    if type(self.bundleParams) == "table" then 
        if self.bundleParams[2] == nil then 
            self.gameObject.transform:GetChild(0).gameObject:SetActive(false) -- 空中跳跃 去提示
        end
    end]]
    self.gameObject.transform:GetChild(0).gameObject:SetActive(true) 
end

function AttackGuideItem:OnTriggerEnter( gameObj )
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end
    --GamePrintTable(self.bundleParams)
    local  sstate = AttackGuideItemState.new()
    sstate.bundleParams = self.bundleParams
    self.stateMachine:changeState(sstate)
end

