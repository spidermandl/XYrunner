
--[[
author:huqiuxiang
无敌道具状态
]]
InvincibleItemState = class (IState)
InvincibleItemState._name = "InvincibleItemState"
InvincibleItemState.effect = nil -- 特效
InvincibleItemState.player = nil -- 主角

function InvincibleItemState:Enter(role)
    self.player = LuaShell.getRole(LuaShell.DesmondID) 

    local buff = InvincibleState.new()
    buff.duringTime = RoleProperty.InvincibleTime
    self.player.stateMachine:addSharedState(buff) -- 主角无敌buff

    local child = role.gameObject.transform:GetChild(0)
    child.gameObject:SetActive(false)
end

function InvincibleItemState:Excute(role,dTime)
end

function InvincibleItemState:Exit(role,dTime)
end