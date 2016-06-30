--[[
author:huqiuxiang
新手引导 吃体力道具 状态
]]
GetStaminaGuideItemState = class (IState)
GetStaminaGuideItemState._name = "GetStaminaGuideItemState"
GetStaminaGuideItemState.effect = nil -- 特效
GetStaminaGuideItemState.player = nil -- 主角
GetStaminaGuideItemState.sceneUI = nil -- ui逻辑scene

function GetStaminaGuideItemState:Enter(role)
    self.GudieRunningSceneTXT = TxtFactory:getTable(TxtFactory.GudieRunningSceneTXT) -- 新手跑酷配置表
    self.player = LuaShell.getRole(LuaShell.DesmondID) 

    local scene = find("sceneUI")
    self.sceneUI = LuaShell.getRole(scene.gameObject:GetInstanceID())

    role.gameObject.transform:GetChild(0).gameObject:SetActive(false)   -- 隐藏提示面板
    self:creatUI()
    self.showPhoto = role.showPhoto -- 提示图片
    self.animator = self.player.character:GetComponent("Animator")
    self.animator.speed = 0
    self.sceneUI:SetPauseValue()  -- 场景暂停设定
    -- print("GetStaminaGuideItemState:Enter")
end

function GetStaminaGuideItemState:Excute(role,dTime)

end

function GetStaminaGuideItemState:Exit(role,dTime)
    if self.effect ~= nil then
		GameObject.Destroy(self.effect) -- 销毁指示ui
	end
end

-- 创建对话框ui类
function GetStaminaGuideItemState:creatUI()
    local tab = {} 
    local idTab = self.GudieRunningSceneTXT:GetData(1005,"DOCONTENT_ID") -- 新手引导配置表 对话id
    local idTabd = string.gsub(idTab,'"',"")
    local array = lua_string_split(tostring(idTabd),",")


    self.dialogueIsOver = false
    self.sceneUI:DialogueUIPanelShow(array,self) -- 调用场景ui 里显示对话框方法
end

-- 对话结束返回
function GetStaminaGuideItemState:dialogIsOver()
    self.animator.speed = 1
    self.sceneUI:SetPauseValue()  -- 场景暂停设定
end