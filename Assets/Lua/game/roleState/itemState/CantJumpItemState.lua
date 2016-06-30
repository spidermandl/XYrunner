--[[
author:huqiuxiang
不能跳道具状态
]]
CantJumpItemState = class (IState)
CantJumpItemState._name = "CantJumpItemState"
CantJumpItemState.effect = nil -- 特效
CantJumpItemState.player = nil -- 主角

function CantJumpItemState:Enter(role)
    self.player = LuaShell.getRole(LuaShell.DesmondID) 

    local buff = CantJumpState.new()
    buff.duringTime = ConfigParam.CantJumpTime
    self.player.stateMachine:addSharedState(buff) 

    local child = role.gameObject.transform:GetChild(0)
    child.gameObject:SetActive(false)

end

function CantJumpItemState:Excute(role,dTime)
end

function CantJumpItemState:Exit(role,dTime)
    if self.effect ~= nil then
		GameObject.Destroy(self.effect)
	end
end