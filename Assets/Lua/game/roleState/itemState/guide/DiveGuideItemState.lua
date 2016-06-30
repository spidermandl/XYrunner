--[[
author:huqiuxiang
新手引导 滑翔道具 状态
]]
DiveGuideItemState = class (IState)
DiveGuideItemState._name = "DiveGuideItemState"
DiveGuideItemState.effect = nil -- 特效
DiveGuideItemState.player = nil -- 主角
DiveGuideItemState.sceneUI = nil 

function DiveGuideItemState:Enter(role)
    self.player = LuaShell.getRole(LuaShell.DesmondID) 
    self.GudieRunningSceneTXT = TxtFactory:getTable(TxtFactory.GudieRunningSceneTXT) -- 新手跑酷配置表
    role.gameObject.transform:GetChild(0).gameObject:SetActive(false)  -- 隐藏提示面板
    self.showPhoto = role.showPhoto -- 提示图片
    self.animator = self.player.character:GetComponent("Animator")
    local scene = find("sceneUI")
    self.sceneUI = LuaShell.getRole(scene.gameObject:GetInstanceID())

    if role.compulsion == "1" then -- 强制引导
        self.animator.speed = 0
        self.player.stateMachine.jumpStage = 1 -- 当前为一段跳状态
        self:creatUI()
        self.player.stateMachine:changeState(StopState.new())
        self.sceneUI:SetPauseValue() -- 场景暂停设定
    else

    end

end

function DiveGuideItemState:Excute(role,dTime)
    if self.player.stateMachine:getState()._name == "DiveState" or self.player.stateMachine:getState()._name == "DoubleJumpState" then
        self.animator.speed = 1 
        GameObject.Destroy(self.effect) -- 销毁指示ui
    end
end

function DiveGuideItemState:Exit(role,dTime)
    if self.effect ~= nil then
		GameObject.Destroy(self.effect) -- 销毁指示ui
	end
end

-- 创建对话框ui类
function DiveGuideItemState:creatUI()
    local tab = {} 
    local idTab = self.GudieRunningSceneTXT:GetData(1004,"DOCONTENT_ID") -- 新手引导配置表 对话id
    local idTabd = string.gsub(idTab,'"',"")
    local array = lua_string_split(tostring(idTabd),",")
    

    -- self.sceneUI = LuaShell.getRole(scene.gameObject:GetInstanceID())
    self.dialogueIsOver = false
    self.sceneUI:DialogueUIPanelShow(array,self) -- 调用场景ui 里显示对话框方法

end

-- 对话结束返回
function DiveGuideItemState:dialogIsOver()
    local BtnJump = find("BtnJump")
    
    self.sceneUI:SetPauseValue() -- 场景暂停设定
    if  BtnJump.gameObject.transform:Find("jiantou") == nil then
        self.uiCtrl = GuideUIShow.new()  -- 新手ui指导
        self.effect = self.uiCtrl:init("UI/battle/jiantou",BtnJump,self.showPhoto) -- 指示箭头
    end
end