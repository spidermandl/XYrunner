--[[
author:huqiuxiang
新手引导 攻击道具 状态
]]
AttackGuideItemState = class (IState)
AttackGuideItemState._name = "AttackGuideItemState"
AttackGuideItemState.effect = nil -- 特效
AttackGuideItemState.player = nil -- 主角
AttackGuideItemState.GudieRunningSceneTXT = nil 
AttackGuideItemState.uiCtrl = nil
AttackGuideItemState.animator = nil
AttackGuideItemState.bundleParams = nil --参数表
AttackGuideItemState.Role = nil
AttackGuideItemState.sceneLua = nil
function AttackGuideItemState:Enter(role)
    
    local scene = find("sceneUI")
    self.sceneLua = LuaShell.getRole(scene.gameObject:GetInstanceID())
    self.Role = role
    self.player = LuaShell.getRole(LuaShell.DesmondID) 
    role.gameObject.transform:GetChild(0).gameObject:SetActive(false) -- 隐藏提示面板
    self.GudieRunningSceneTXT = TxtFactory:getTable(TxtFactory.GudieRunningSceneTXT) -- 新手跑酷配置表
    self.showPhoto = role.showPhoto -- 提示图片
    self.animator = self.player.character:GetComponent("Animator") 

    --if role.compulsion == "1" then -- 强制引导
        --self.animator.speed = 0
       -- role.isBlocked = true
        UnityEngine.Time.timeScale = 0
        self.player.stateMachine:addSharedState(BlockState.new())-- 被墙格挡状态
        local curState = self.player.stateMachine:getState() 

--[[        if curState._name ~= "RunState" then 
        self.player.stateMachine:changeState(StopState.new())
        end]]

        local buff = CantJumpState.new() -- 不能跳
        buff.stage = 1 
        self.player.stateMachine:addSharedState(buff)
        self:creatUI() -- 创建对话ui
        self.player.isGuideAttacked = true 

    --else

    --end
    RoleProperty.unlimitedHP = true
end

--[[function AttackGuideItemState:Excute(role,dTime)
     if self.player.stateMachine:getSharedState("GroundAttackState") then
        --(guideNum == 2 and self.player.stateMachine:getState("AirAttackState") ~= nil ) then -- 判断是否为攻击状态
        self.player.stateMachine:removeSharedState(BlockState.new())
        self.animator.speed = 1
        local buff = self.player.stateMachine:getSharedState("CantJumpState")
        if buff ~= nil then
            buff.stage = 0
        end 
        if self.effect ~= nil then
            GameObject.Destroy(self.effect) -- 销毁指示ui
        end
        --self.player.stateMachine:changeState(DropState.new())
     end
end]]

function AttackGuideItemState:Exit(role,dTime)
    if self.effect ~= nil then
		GameObject.Destroy(self.effect)  -- 销毁指示ui
	end
end

-- 创建对话框ui类
function AttackGuideItemState:creatUI()
    local tab = {} 
    local idTab = self.GudieRunningSceneTXT:GetData(1002,"DOCONTENT_ID") -- 新手引导配置表 对话id
    local idTabd = string.gsub(idTab,'"',"")
    local array = lua_string_split(tostring(idTabd),",") -- 处理好的对话逻辑


    self.sceneLua:DialogueUIPanelShow(array,self) -- 调用场景ui 里显示对话框方法

end

-- 对话结束返回
function AttackGuideItemState:dialogIsOver()
    self.sceneLua.attackBtn.gameObject:SetActive(true)  -- 显示战斗按钮
    local oldFun = 1
    AddonClickNew(1,self.sceneLua.attackBtn,function()
        UnityEngine.Time.timeScale = 1
        self.sceneLua:PlayMouseEffect()
        self.player.stateMachine:removeSharedState(BlockState.new())
       -- self.Role.isBlocked = false
        local buff = self.player.stateMachine:getSharedState("CantJumpState")
        if buff ~= nil then
            buff.stage = 0
        end 
        if self.effect ~= nil then
            GameObject.Destroy(self.effect) -- 销毁指示ui
        end
                -- 开启按钮
        self.sceneLua:SetAllClickBtn()
        RoleProperty.unlimitedHP = false
    end)
    -- 禁用按钮
    self.sceneLua:SetCanClickBtn(self.sceneLua.attackBtn)

    if  self.sceneLua.attackBtn.gameObject.transform:Find("jiantou") == nil then
        self.uiCtrl = GuideUIShow.new() -- 新手ui指导
        self.effect = self.uiCtrl:init("UI/battle/jiantou",self.sceneLua.attackBtn,self.showPhoto) -- 指示箭头
    end

end