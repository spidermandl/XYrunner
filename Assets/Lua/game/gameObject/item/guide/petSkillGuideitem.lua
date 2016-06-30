--petSkillGuideitem.lua
--[[
   author:huqiuxiang
   跳引导道具 petSkillGuideitem
]]
petSkillGuideitem = class (BaseItem)
petSkillGuideitem.type = 'petSkillGuideitem'

function petSkillGuideitem:Awake()
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
function petSkillGuideitem:Start()

end

function petSkillGuideitem:initParam()
    self.super.initParam(self)
    
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0.5,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,10,bound.z)


end

function petSkillGuideitem:FixedUpdate()
end

function petSkillGuideitem:OnTriggerEnter( gameObj )
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end
    --GamePrintTable("PetSkillGuideItem PetSkillGuideItem11111111")
	--GamePrintTable(self.bundleParams)
    self.stateMachine:changeState(petSkillGuideitemState.new())
end
