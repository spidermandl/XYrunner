--[[
   author:huqiuxiang
   滑翔引导道具 DiveGuideItem
]]
DiveGuideItem = class (BaseItem)
DiveGuideItem.item = nil
DiveGuideItem.collider = nil
DiveGuideItem.stateMachine = nil
DiveGuideItem.dialogueIsOver = nil 
DiveGuideItem.GudieRunningSceneTXT = nil

function DiveGuideItem:Awake()
	-- print("-----------------StaminaBottle Awake--->>>-----------------")
    if self.gameObject.transform:Find("GuideItem") == nil then
        self.item  = newobject(Util.LoadPrefab("Items/GuideItem"))
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
function DiveGuideItem:Start()
end

function DiveGuideItem:Update()
    self.super.Update(self)
end

function DiveGuideItem:FixedUpdate()
end

function DiveGuideItem:OnTriggerEnter( gameObj )
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end
    -- self:roleSet()
    self.stateMachine:changeState(DiveGuideItemState.new()) 
    -- self:creatUI()
end

-- function DiveGuideItem:roleSet()
--     local player = LuaShell.getRole(LuaShell.DesmondID) 
--     player.property.canDive = true
-- end

-- -- 创建对话框ui类
-- function DiveGuideItem:creatUI()
--     local tab = {} 
--     local idTab = self.GudieRunningSceneTXT:GetData(2001,"CONTENT_ID")
--     local idTabd = string.gsub(idTab,'"',"")
--     local array = lua_string_split(tostring(idTabd),",")
    

--     local scene = find("sceneUI")
--     local sceneLua = LuaShell.getRole(scene.gameObject:GetInstanceID())
--     self.dialogueIsOver = false
--     sceneLua:DialogueUIPanelShow(array,self)

-- end

-- -- 对话结束返回
-- function DiveGuideItem:dialogIsOver()

-- end