--[[
   author:huqiuxiang
   体力引导道具 StaminaGuideItem
]]
StaminaGuideEndItem = class (BaseItem)
StaminaGuideEndItem.type = 'StaminaGuideEndItem'
StaminaGuideEndItem.compulsion = nil 

function StaminaGuideEndItem:Awake()
	-- print("-----------------StaminaBottle Awake--->>>-----------------")
    if self.gameObject.transform:Find("GuideItem") == nil then
        self.item  = PoolFunc:pickObjByPrefabName("Items/GuideItem")
        self.item.transform.parent = self.gameObject.transform
        self.item.transform.localPosition = UnityEngine.Vector3(0,0,0)
        self.item.transform.localScale = UnityEngine.Vector3(1.5,1.5,1.5)
        self.item.transform.rotation = Quaternion.Euler(0,0,0)
    else
        self.item = self.gameObject.transform:Find("GuideItem")
        self.item.localPosition = UnityEngine.Vector3(0,0,0)
    end

    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())

    self.super.guideItemsAwake(self)
    self.super.Awake(self)
end

function StaminaGuideEndItem:initParam()
    self.super.initParam(self)
    
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0.5,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,20,bound.z)
end

function StaminaGuideEndItem:OnTriggerEnter( gameObj )
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end
    -- self.player = LuaShell.getRole(LuaShell.DesmondID)
    self.stateMachine:changeState(StaminaGuideItemEndState.new()) 
end

