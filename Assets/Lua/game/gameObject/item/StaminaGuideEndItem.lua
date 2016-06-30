--[[
   author:huqiuxiang
   体力引导道具 StaminaGuideItem
]]
StaminaGuideEndItem = class (BaseItem)
StaminaGuideEndItem.type = 'StaminaGuideEndItem'
StaminaGuideEndItem.dialogueIsOver = nil 
StaminaGuideEndItem.GudieRunningSceneTXT = nil

function StaminaGuideEndItem:Awake()
	-- print("-----------------StaminaBottle Awake--->>>-----------------")
    if self.gameObject.transform:Find("GuideItem") == nil then
        self.item  = PoolFunc:pickObjByPrefabName("Items/GuideItem")
        self.item.transform.parent = self.gameObject.transform
        self.item.transform.position = self.gameObject.transform.position
        self.item.transform.localScale = UnityEngine.Vector3(1.5,1.5,1.5)
        self.item.transform.rotation = Quaternion.Euler(0,90,0)
    else
        self.item = self.gameObject.transform:Find("GuideItem")
        self.item.localPosition = UnityEngine.Vector3(0,0,0)
    end

    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = true

    self.collider.center=UnityEngine.Vector3(0,0.5,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,10,bound.z)

    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self

    self.GudieRunningSceneTXT = TxtFactory:getTable(TxtFactory.GudieRunningSceneTXT) 
end

--启动事件--
function StaminaGuideEndItem:Start()
end

function StaminaGuideEndItem:Update()
    self.super.Update(self)
end

function StaminaGuideEndItem:FixedUpdate()
end

function StaminaGuideEndItem:OnTriggerEnter( gameObj )
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end
    self:creatUI()

    self.stateMachine:changeState(StaminaGuideItemEndState.new()) 
end

-- 创建对话框ui类
function StaminaGuideEndItem:creatUI()
    local tab = {} 
    local idTab = self.GudieRunningSceneTXT:GetData(2003,"CONTENT_ID")
    local idTabd = string.gsub(idTab,'"',"")
    local array = lua_string_split(tostring(idTabd),",")

    local scene = find("sceneUI")
    local sceneLua = LuaShell.getRole(scene.gameObject:GetInstanceID())
	self.dialogueIsOver = false
    sceneLua:DialogueUIPanelShow(array,self)
end

-- 对话结束返回
function StaminaGuideEndItem:dialogIsOver()

end