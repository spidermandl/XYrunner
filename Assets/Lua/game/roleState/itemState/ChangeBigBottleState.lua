
--[[
author:huqiuxiang
变大瓶子状态
]]
ChangeBigBottleState = class (IState)
ChangeBigBottleState._name = "ChangeBigBottleState"
ChangeBigBottleState.effect = nil -- 特效
ChangeBigBottleState.player = nil -- 主角

function ChangeBigBottleState:Enter(role)
    self.player = LuaShell.getRole(LuaShell.DesmondID) 

    local buff = ChangeBigState.new()
    buff.duringTime = self.player.property.ChangeBigTime--ConfigParam.ChangeBigTime
    self.player.stateMachine:addSharedState(buff) -- 主角变大buff

    local child = role.gameObject.transform:GetChild(0)
    child.gameObject:SetActive(false)
end

function ChangeBigBottleState:Excute(role,dTime)
end

function ChangeBigBottleState:Exit(role,dTime)
end