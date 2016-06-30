--[[
author:huqiuxiang
新手引导 跳道具 状态
]]
JumpGuideItemState = class (IState)
JumpGuideItemState._name = "JumpGuideItemState"
JumpGuideItemState.effect = nil -- 特效
JumpGuideItemState.player = nil -- 主角
JumpGuideItemState.GudieRunningSceneTXT = nil 
JumpGuideItemState.uiCtrl = nil 
JumpGuideItemState.animator = nil
JumpGuideItemState.showPhoto = nil 
JumpGuideItemState.sceneLua = nil
function JumpGuideItemState:Enter(role)

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
        self.player.stateMachine:addSharedState(BlockState.new())-- 被墙格挡状态
        local curState = self.player.stateMachine:getState() 
        if curState._name ~= "RunState" then 
        self.player.stateMachine:changeState(StopState.new())
        end

        -- 添加不能攻击buff
        local buff = CantAttackState.new()
        buff.stage = 1 
        self.player.stateMachine:addSharedState(buff)

        self:creatUI(role) -- 创建ui
        self.player.isGuideJumped = true
    --else
        
    --end
        RoleProperty.unlimitedHP = true

end

function JumpGuideItemState:Excute(role,dTime)
     if self.player.stateMachine:getState()._name == "JumpState" or self.player.stateMachine:getState()._name == "DoubleJumpState"  then -- 判断是否为跳 或者二段跳状态
        self.player.stateMachine:removeSharedState(BlockState.new())
        self.animator.speed = 1
        local buff = self.player.stateMachine:getSharedState("CantAttackState")
        if buff ~= nil then
            buff.stage = 0
        end 
        GameObject.Destroy(self.effect) -- 销毁指示ui

        -- 开启按钮
        self.sceneLua:SetAllClickBtn()
        RoleProperty.unlimitedHP = false
     end
end

function JumpGuideItemState:Exit(role,dTime)
    if self.effect ~= nil then
        GameObject.Destroy(self.effect) -- 销毁指示ui
    end
end

-- 创建对话框ui类
function JumpGuideItemState:creatUI(role)
    local tab = {}
    local idTab = nil 
    idTab = self.GudieRunningSceneTXT:GetData(1001,"DONTCONTENT_ID") -- 新手引导配置表 对话id
    local idTabd = string.gsub(idTab,'"',"")
    local array = lua_string_split(tostring(idTabd),",") 

    self.sceneLua:DialogueUIPanelShow(array,self) -- 调用场景ui 里显示对话框方法

end

-- 对话结束返回
function JumpGuideItemState:dialogIsOver()
    -- 生成提示
    if self.sceneLua.jumpBtn == nil then
        self.sceneLua.jumpBtn = find("BtnJump")
    end
    self.sceneLua.jumpBtn.gameObject:SetActive(true)
    
    AddonClickNew(1,self.sceneLua.jumpBtn,function()
        self.sceneLua:PlayMouseEffect()
    end)

    if  self.sceneLua.jumpBtn.gameObject.transform:Find("jiantou") == nil then
        self.uiCtrl = GuideUIShow.new() -- 新手引导ui动画类
        self.effect = self.uiCtrl:init("UI/battle/jiantou",self.sceneLua.jumpBtn,self.showPhoto)
    end
    -- 禁用其他按钮
    self.sceneLua:SetCanClickBtn(self.sceneLua.jumpBtn)
end