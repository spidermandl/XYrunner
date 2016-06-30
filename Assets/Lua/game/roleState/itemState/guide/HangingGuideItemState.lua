--[[
author:huqiuxiang
新手引导 踏墙道具 状态
]]
HangingGuideItemState = class (IState)
HangingGuideItemState._name = "HangingGuideItemState"
HangingGuideItemState.effect = nil -- 特效
HangingGuideItemState.player = nil -- 主角
HangingGuideItemState.GudieRunningSceneTXT = nil 
HangingGuideItemState.flag = nil -- 标记是否处理过
HangingGuideItemState.sceneLua = nil -- ui逻辑

function HangingGuideItemState:Enter(role)
    self.player = LuaShell.getRole(LuaShell.DesmondID) 
    self.GudieRunningSceneTXT = TxtFactory:getTable(TxtFactory.GudieRunningSceneTXT) 
    self.showPhoto = role.showPhoto -- 提示图片
    self.animator = self.player.character:GetComponent("Animator")
    role.gameObject.transform:GetChild(0).gameObject:SetActive(false) 
    self.flag = false

    --if self.player.isGuideHanged == true then -- 是否提示过

    --else
        self.animator.speed = 0
        self.player.stateMachine:addSharedState(BlockState.new())
        self.player.stateMachine.jumpStage = 0

        self.showPhoto = role.showPhoto -- 提示图片
        local scene = find("sceneUI")
        self.sceneLua = LuaShell.getRole(scene.gameObject:GetInstanceID())

        -- self.sceneLua.pause = true
        self:creatUI()
        --self.player.isGuideHanged = true
    --end
    RoleProperty.unlimitedHP = true
end

function HangingGuideItemState:Excute(role,dTime)
    if  self.flag == true then
        return
    end

    if self.player.stateMachine:getState()._name == "JumpState" or self.player.stateMachine:getState()._name == "DoubleJumpState"  then
        self.player.stateMachine:removeSharedState(BlockState.new())
        --[[local effectBack = self.effect.gameObject.transform:FindChild("bg") -- 去掉黑色蒙板
        effectBack.gameObject:SetActive(false)

        local effectPhoto = self.effect.gameObject.transform:FindChild("photo") -- 去掉提示框
        effectPhoto.gameObject:SetActive(false)]]

        self.animator.speed = 1
        self.flag = true
    end
end

function HangingGuideItemState:Exit(role,dTime)
    if self.effect ~= nil then
		GameObject.Destroy(self.effect)
	end
end

-- 创建对话框ui类
function HangingGuideItemState:creatUI()
    local tab = {} 
    local idTab = self.GudieRunningSceneTXT:GetData(1006,"DOCONTENT_ID")
    local idTabd = string.gsub(idTab,'"',"")
    -- print("idTabd"..idTabd)
    local array = lua_string_split(tostring(idTabd),",")

    self.dialogueIsOver = false
    self.sceneLua:DialogueUIPanelShow(array,self)
end
-- 对话结束返回
function HangingGuideItemState:dialogIsOver()
    -- local scene = find("sceneUI")
    local BtnJump = self.sceneLua.jumpBtn

    if  BtnJump.gameObject.transform:Find("jiantou") == nil then
        self.uiCtrl = GuideUIShow.new()
        self.effect = self.uiCtrl:init("UI/battle/jiantou",BtnJump,self.showPhoto)
    end
    -- self.sceneUI.pause = true
    -- 生成提示
    local nnum = 0
    AddonClickNew(1,BtnJump,function()
        nnum = nnum + 1
        self.sceneLua:PlayMouseEffect()
        if nnum == 1 then
        
            local effectBack = self.effect.gameObject.transform:FindChild("bg") -- 去掉黑色蒙板
            effectBack.gameObject:SetActive(false)

            local effectPhoto = self.effect.gameObject.transform:FindChild("photo") -- 去掉提示框
            effectPhoto.gameObject:SetActive(false)
        end

        --[[if nnum > 2 and self.effect ~= nil then
            GameObject.Destroy(self.effect) -- 销毁指示ui
            -- 开启按钮
            self.sceneLua:SetAllClickBtn()
            RoleProperty.unlimitedHP = false
        end]]
    end)
        -- 禁用其他按钮
    self.sceneLua:SetCanClickBtn(self.sceneLua.jumpBtn)
end