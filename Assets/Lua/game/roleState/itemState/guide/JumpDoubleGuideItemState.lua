--[[
author:huqiuxiang
新手引导 二段跳道具 状态
]]
JumpDoubleGuideItemState = class (IState)
JumpDoubleGuideItemState._name = "JumpDoubleGuideItemState"
JumpDoubleGuideItemState.effect = nil -- 特效
JumpDoubleGuideItemState.player = nil -- 主角
JumpDoubleGuideItemState.GudieDialogTXT = nil
JumpDoubleGuideItemState.animator = nil
JumpDoubleGuideItemState.showPhoto = nil
JumpDoubleGuideItemState.sceneLua = nil
function JumpDoubleGuideItemState:Enter(role)

    local scene = find("sceneUI")
    self.sceneLua = LuaShell.getRole(scene.gameObject:GetInstanceID())

    self.Role = role
    self.player = LuaShell.getRole(LuaShell.DesmondID) 
    role.gameObject.transform:GetChild(0).gameObject:SetActive(false) -- 隐藏提示面板
    self.GudieRunningSceneTXT = TxtFactory:getTable(TxtFactory.GudieRunningSceneTXT) -- 新手跑酷配置表
    self.showPhoto = role.showPhoto -- 提示图片
    self.animator = self.player.character:GetComponent("Animator") 
    UnityEngine.Time.timeScale = 0
    --if role.compulsion == "1" then -- 强制引导

        --self.animator.speed = 0
       -- role.isBlocked = true
        --[[self.player.stateMachine:addSharedState(BlockState.new())-- 被墙格挡状态
        local curState = self.player.stateMachine:getState() 
        if curState._name ~= "RunState" then 
        self.player.stateMachine:changeState(StopState.new())
        end]]

        -- 添加不能攻击buff
        --local buff = CantAttackState.new()
        --buff.stage = 1 
        --self.player.stateMachine:addSharedState(buff)

        self:creatUI() -- 创建ui
        self.player.isGuideDoubleJumped = true

    --else
    --end
        RoleProperty.unlimitedHP = true
end

--[[function JumpDoubleGuideItemState:Excute(role,dTime)
     if self.player.stateMachine:getState()._name == "DoubleJumpState" or self.player.stateMachine:getState()._name == "JumpState" then
        self.animator.speed = 1
        -- 移除效果
        local buff = self.player.stateMachine:getSharedState("CantAttackState")
        if buff ~= nil then
            buff.stage = 0
        end 

        GameObject.Destroy(self.effect) -- 销毁指示ui
        self.sceneLua:SetAllClickBtn()
     end
     
end]]

function JumpDoubleGuideItemState:Exit(role,dTime)
    if self.effect ~= nil then
		GameObject.Destroy(self.effect) -- 销毁指示ui
	end
end

-- 创建对话框ui类
function JumpDoubleGuideItemState:creatUI()
    local tab = {} 
    local idTab = self.GudieRunningSceneTXT:GetData(1003,"DOCONTENT_ID") -- 新手引导配置表 对话id
    local idTabd = string.gsub(idTab,'"',"")
    local array = lua_string_split(tostring(idTabd),",")

    self.sceneLua:DialogueUIPanelShow(array,self) -- 调用场景ui 里显示对话框方法

end

-- 对话结束返回
function JumpDoubleGuideItemState:dialogIsOver()
    --GamePrint("JumpDoubleGuideItemState")
    -- 禁用其他按钮
    self.sceneLua.jumpBtn.gameObject:SetActive(true)  -- 显示战斗按钮
    self.sceneLua:SetCanClickBtn(self.sceneLua.jumpBtn)
    local nnum = 0
    AddonClickNew(1,self.sceneLua.jumpBtn,function()
        UnityEngine.Time.timeScale = 1
        --GamePrint("JumpDoubleGuideItemState 0 0 0 0 00")
        --self.player.stateMachine:removeSharedState(BlockState.new())
        self.sceneLua:PlayMouseEffect()
        nnum = nnum +1
        if nnum == 1 then
            --GamePrint("JumpDoubleGuideItemState 22222 222222 2222")
            self.sceneLua:SetCanClickBtn()
             -- 延迟0.2秒后暂停
            coroutine.start(zhantingJump,self)

            local effectBack = self.effect.gameObject.transform:FindChild("bg") -- 去掉黑色蒙板
            effectBack.gameObject:SetActive(false)

            local effectPhoto = self.effect.gameObject.transform:FindChild("photo") -- 去掉提示框
            effectPhoto.gameObject:SetActive(false)
        end

        if  nnum == 2 then
            UnityEngine.Time.timeScale = 1
            if self.effect ~= nil then
                GameObject.Destroy(self.effect) -- 销毁指示ui
            end
            -- 开启按钮
            self.sceneLua:SetAllClickBtn()
            RoleProperty.unlimitedHP = false
        end
    end)


    if  self.sceneLua.attackBtn.gameObject.transform:Find("jiantou") == nil then
        self.uiCtrl = GuideUIShow.new() -- 新手ui指导
        self.effect = self.uiCtrl:init("UI/battle/jiantou",self.sceneLua.jumpBtn,"-") -- 指示箭头
    end
--[[    self.sceneLua.jumpBtn.gameObject:SetActive(true)

    if  self.sceneLua.jumpBtn.gameObject.transform:Find("jiantou") == nil then
        self.uiCtrl = GuideUIShow.new() -- 新手引导ui动画类
        self.effect = self.uiCtrl:init("UI/battle/jiantou",self.sceneLua.jumpBtn,self.showPhoto)
    end]]
end
function zhantingJump(self)
    --GamePrint("JumpDoubleGuideItemState 111 1111")
    coroutine.wait(0.3)
    UnityEngine.Time.timeScale = 0
    self.sceneLua:SetCanClickBtn(self.sceneLua.jumpBtn)
end