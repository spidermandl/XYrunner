--[[
author:huqiuxiang
新手引导 体力道具 状态
]]
StaminaGuideItemState = class (IState)
StaminaGuideItemState._name = "StaminaGuideItemState"
StaminaGuideItemState.effect = nil -- 特效
StaminaGuideItemState.player = nil -- 主角
StaminaGuideItemState.GudieRunningSceneTXT = nil 
StaminaGuideItemState.dialogueIsOver = nil -- 对话结束

function StaminaGuideItemState:Enter(role)
    self.player = LuaShell.getRole(LuaShell.DesmondID) 
    self.GudieRunningSceneTXT = TxtFactory:getTable(TxtFactory.GudieRunningSceneTXT) 
    role.gameObject.transform:GetChild(0).gameObject:SetActive(false) 
    -- 创建提示ui
    local uiblood = find("blood")
    self.effect = newobject(Util.LoadPrefab("UI/battle/BloodShangshuo"))
    self.effect.gameObject.transform.parent = uiblood.gameObject.transform
    self.effect.gameObject.transform.localPosition = Vector3(-330,0,0)
    self.effect.gameObject.transform.localScale =Vector3.one
    self.effect.gameObject.name = "UIGuide_bloodSS"

    local scene = find("sceneUI")
    self.sceneUI = LuaShell.getRole(scene.gameObject:GetInstanceID())

    if role.compulsion == "1" then -- 强制引导
        self:creatUI()
        self.showPhoto = role.showPhoto -- 提示图片
        self.animator = self.player.character:GetComponent("Animator")
        self.animator.speed = 0
        self.sceneUI:SetPauseValue()
    end
end

function StaminaGuideItemState:Excute(role,dTime)

end

function StaminaGuideItemState:Exit(role,dTime)
    if self.effect ~= nil then
		GameObject.Destroy(self.effect)
	end
end

-- 创建对话框ui类
function StaminaGuideItemState:creatUI()
    local tab = {} 
    local idTab = self.GudieRunningSceneTXT:GetData(1004,"DOCONTENT_ID")
    local idTabd = string.gsub(idTab,'"',"")
    local array = lua_string_split(tostring(idTabd),",")
    
    self.sceneUI:DialogueUIPanelShow(array,self)

end

-- 对话结束返回
function StaminaGuideItemState:dialogIsOver()
    self.sceneUI:SetPauseValue()
    self.animator.speed = 1
end