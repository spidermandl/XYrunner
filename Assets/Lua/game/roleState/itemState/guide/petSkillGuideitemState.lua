
--petSkillGuideitemState.lua
--[[
author:huqiuxiang
新手引导 宠物攻击
]]
petSkillGuideitemState = class (IState)
petSkillGuideitemState._name = "petSkillGuideitemState"
petSkillGuideitemState.effect = nil -- 特效
petSkillGuideitemState.player = nil -- 主角
petSkillGuideitemState.GudieRunningSceneTXT = nil 
petSkillGuideitemState.uiCtrl = nil 
petSkillGuideitemState.animator = nil
petSkillGuideitemState.showPhoto = nil 
petSkillGuideitemState.sceneLua = nil
function petSkillGuideitemState:Enter(role)

    --GamePrintTable("PetSkillGuideItem PetSkillGuideItem 22222222222")
    --GamePrintTable(role)
    self.Role = role
    self.player = LuaShell.getRole(LuaShell.DesmondID) 
            local scene = find("sceneUI")
    self.sceneLua = LuaShell.getRole(scene.gameObject:GetInstanceID()) --BattleScene.lua

    
    role.gameObject.transform:GetChild(0).gameObject:SetActive(false) -- 隐藏提示面板
    self.GudieRunningSceneTXT = TxtFactory:getTable(TxtFactory.GudieRunningSceneTXT) -- 新手跑酷配置表
    self.showPhoto = role.showPhoto -- 提示图片
    self.animator = self.player.character:GetComponent("Animator") 

    self.player.stateMachine:addSharedState(BlockState.new())-- 被墙格挡状态
    local curState = self.player.stateMachine:getState() 
    if curState._name ~= "RunState" then 
    self.player.stateMachine:changeState(StopState.new())
    end

    local buff = CantJumpState.new() -- 不能跳
    buff.stage = 1 
    self.player.stateMachine:addSharedState(buff)
    self:creatUI() -- 创建对话ui
    self.player.isGuideAttacked = true 

    RoleProperty.unlimitedHP = true
end

function petSkillGuideitemState:Excute(role,dTime)
     if self.player.stateMachine:getState()._name == "JumpState" or self.player.stateMachine:getState()._name == "DoubleJumpState"  then -- 判断是否为跳 或者二段跳状态
        self.player.stateMachine:removeSharedState(BlockState.new())
        self.animator.speed = 1
        local buff = self.player.stateMachine:getSharedState("CantAttackState")
        if buff ~= nil then
            buff.stage = 0
        end 
        GameObject.Destroy(self.effect) -- 销毁指示ui
        --RoleProperty.unlimitedHP == false
     end
end

function petSkillGuideitemState:Exit(role,dTime)
    if self.effect ~= nil then
        GameObject.Destroy(self.effect) -- 销毁指示ui
    end
end

-- 创建对话框ui类
function petSkillGuideitemState:creatUI(role)
    local tab = {}
    local idTab = nil 
    idTab = self.GudieRunningSceneTXT:GetData(1008,"DONTCONTENT_ID") -- 新手引导配置表 对话id
    local idTabd = string.gsub(idTab,'"',"")
    local array = lua_string_split(tostring(idTabd),",") 

    self.sceneLua:DialogueUIPanelShow(array,self) -- 调用场景ui 里显示对话框方法

end

-- 对话结束返回
function petSkillGuideitemState:dialogIsOver()
    self.sceneLua.speedUpBtn:SetActive(true)
    local num = 0
    AddonClickNew(1,self.sceneLua.speedUpBtn,function()
        self.sceneLua:PlayMouseEffect()
        num = num + 1
        if num >= 2 then
            return
        end
        self.player.stateMachine:removeSharedState(BlockState.new())
       -- self.Role.isBlocked = false
        local buff = self.player.stateMachine:getSharedState("CantJumpState")
        if buff ~= nil then
            buff.stage = 0
        end 
        if self.effect ~= nil then
            GameObject.Destroy(self.effect) -- 销毁指示ui
        end
        RoleProperty.unlimitedHP = false
        self.player:playSkill("101024")
        self.sceneLua:SetAllClickBtn()

        coroutine.start(DelayFinishGame)
    end)
         -- 禁用按钮
    self.sceneLua:SetCanClickBtn(self.sceneLua.speedUpBtn)
    if  self.sceneLua.speedUpBtn.transform:Find("jiantou") == nil then
        self.uiCtrl = GuideUIShow.new() -- 新手引导ui动画类
        self.effect = self.uiCtrl:init("UI/battle/jiantou",self.sceneLua.speedUpBtn,self.showPhoto,Vector3(0,-103,0))
        --self.effect.transform.localPosition = Vector3(0,-103,0)
    end

end

-- 延迟4.5秒结算
function DelayFinishGame()
    -- body
    coroutine.wait(4.5)
    local scene = find(ConfigParam.SceneOjbName)
    local battleScene = LuaShell.getRole(scene.gameObject:GetInstanceID())

    if battleScene.BattleGuideView.isGuideLevel == true then
        if battleScene.BattleGuideViewFinish == true then
            return
        end
        --des.stateMachine:addSharedState(BlockState.new())-- 被墙格挡状态
        battleScene.mainCamera.stateMachine:changeState(CameraStayState.new())
        battleScene:VictoryUIPanelShow(nil,nil)
        battleScene.BattleGuideViewFinish = true
    end

end