--[[
author:huqiuxiang
新手引导 体力结束道具 状态
]]
StaminaGuideItemEndState = class (IState)
StaminaGuideItemEndState._name = "StaminaGuideItemEndState"
StaminaGuideItemEndState.effect = nil -- 特效
StaminaGuideItemEndState.player = nil -- 主角
StaminaGuideItemEndState.dialogueIsOver = nil -- 对话结束
StaminaGuideItemEndState.GudieRunningSceneTXT = nil

function StaminaGuideItemEndState:Enter(role)
    self.player = LuaShell.getRole(LuaShell.DesmondID) 
    role.gameObject.transform:GetChild(0).gameObject:SetActive(false) 
    self.GudieRunningSceneTXT = TxtFactory:getTable(TxtFactory.GudieRunningSceneTXT) 

    local scene = find("sceneUI")
    self.sceneUI = LuaShell.getRole(scene.gameObject:GetInstanceID())

    if role.compulsion == "1" then -- 强制引导
        -- local uiblood = find("UIGuide_bloodSS")
        -- destroy(uiblood.gameObject)
        self.sceneUI:SetPauseValue()
        self.showPhoto = role.showPhoto -- 提示图片
        self.animator = self.player.character:GetComponent("Animator")
        self.animator.speed = 0
        self:creatUI()
    end
end

function StaminaGuideItemEndState:Excute(role,dTime)

end

function StaminaGuideItemEndState:Exit(role,dTime)
    if self.effect ~= nil then
		GameObject.Destroy(self.effect)
	end
end

-- 创建对话框ui类
function StaminaGuideItemEndState:creatUI()
    local tab = {} 
    local idTab = self.GudieRunningSceneTXT:GetData(1006,"DOCONTENT_ID")
    local idTabd = string.gsub(idTab,'"',"")
    local array = lua_string_split(tostring(idTabd),",")

    self.sceneUI:DialogueUIPanelShow(array,self)
end

-- 对话结束返回
function StaminaGuideItemEndState:dialogIsOver()
    self.sceneUI:SetPauseValue()
    self.animator.speed = 1
end