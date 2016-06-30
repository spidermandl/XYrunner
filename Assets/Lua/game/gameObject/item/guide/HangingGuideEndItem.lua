--[[
   author:huqiuxiang
   踏墙引导结束道具 HangingGuideItem
]]
HangingGuideEndItem = class (BaseItem)
HangingGuideEndItem.type = 'HangingGuideEndItem'
HangingGuideEndItem.dialogueIsOver = nil 
HangingGuideEndItem.doneAction = nil -- 标记是否已经做过

function HangingGuideEndItem:Awake()
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
    self.super.Awake(self)

end

function HangingGuideEndItem:initParam()
    self.super.initParam(self)
    
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0.5,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,20,bound.z)
    self.doneAction = false
    self.gameObject.transform:GetChild(0).gameObject:SetActive(false) -- 空中跳跃 去提示
end

function HangingGuideEndItem:OnTriggerEnter( gameObj )
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false or self.doneAction == true then
        return
    end

    --[[self.stateMachine:changeState(HangingGuideEndItemState.new()) 
    self.doneAction = true]]

    local effect = find("jiantou")
    if effect ~= nil then
        GameObject.Destroy(effect) -- 销毁指示ui
    end
    local scene = find("sceneUI")
    local sceneLua = LuaShell.getRole(scene.gameObject:GetInstanceID())

    -- 开启按钮
    sceneLua:SetAllClickBtn()
    RoleProperty.unlimitedHP = false

end

