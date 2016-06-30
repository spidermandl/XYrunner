--[[
   author:huqiuxiang
   二段跳引导道具 JumpDoubleGuideItem
]]
JumpDoubleGuideItem = class (BaseItem)
JumpDoubleGuideItem.type = 'JumpDoubleGuideItem'
JumpDoubleGuideItem.compulsion = nil 

function JumpDoubleGuideItem:Awake()
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

function JumpDoubleGuideItem:initParam()
    self.super.initParam(self)
    
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,10,bound.z)

    --self.gameObject.transform:GetChild(0).gameObject:SetActive(false)
end

--启动事件--
function JumpDoubleGuideItem:Start()
end

function JumpDoubleGuideItem:Update()
    self.super.Update(self)
end

function JumpDoubleGuideItem:FixedUpdate()
end

function JumpDoubleGuideItem:OnTriggerEnter(gameObj)
    --GamePrintTable("JumpDoubleGuideItem")
    --GamePrintTable(self.bundleParams)
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end
    self.stateMachine:changeState(JumpDoubleGuideItemState.new())
    self.gameObject:GetComponent('BoxCollider').enabled = false
end


