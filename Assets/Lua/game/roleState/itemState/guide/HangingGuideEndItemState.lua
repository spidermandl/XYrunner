--[[
author:huqiuxiang
新手引导 踏墙结束道具 状态
]]
HangingGuideEndItemState = class (IState)
HangingGuideEndItemState._name = "HangingGuideEndItemState"
HangingGuideEndItemState.effect = nil -- 特效
HangingGuideEndItemState.player = nil -- 主角
HangingGuideEndItemState.sceneUI = nil -- ui逻辑scene

function HangingGuideEndItemState:Enter(role)
    self.GudieRunningSceneTXT = TxtFactory:getTable(TxtFactory.GudieRunningSceneTXT) 
    self.player = LuaShell.getRole(LuaShell.DesmondID) 
    role.gameObject.transform:GetChild(0).gameObject:SetActive(false)  -- 隐藏提示面板
    local scene = find("sceneUI")
    self.sceneUI = LuaShell.getRole(scene.gameObject:GetInstanceID())
    self.sceneUI:SetPauseValue()  -- 场景暂停设定
    local jiantou =  find("jiantou")
    destroy(jiantou.gameObject)
    self:creatUI()
    self.showPhoto = role.showPhoto -- 提示图片

end

function HangingGuideEndItemState:Excute(role,dTime)

end

function HangingGuideEndItemState:Exit(role,dTime)
    if self.effect ~= nil then
		GameObject.Destroy(self.effect) -- 销毁指示ui
	end
end

-- 创建对话框ui类
function HangingGuideEndItemState:creatUI()
    local tab = {} 
    local idTab = self.GudieRunningSceneTXT:GetData(1007,"DOCONTENT_ID") -- 新手引导配置表 对话id
    local idTabd = string.gsub(idTab,'"',"")
    local array = lua_string_split(tostring(idTabd),",")

    self.dialogueIsOver = false
    self.sceneUI:DialogueUIPanelShow(array,self) -- 调用场景ui 里显示对话框方法
end

-- 对话结束返回
function HangingGuideEndItemState:dialogIsOver()
    self.sceneUI:SetPauseValue()  -- 场景暂停设定
end