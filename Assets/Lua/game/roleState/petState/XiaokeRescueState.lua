--[[
author:huqiuxiang
小柯救起主角状态
]]
XiaokeRescueState = class (PetRescueState)
XiaokeRescueState._name = "XiaokeRescueState"

function XiaokeRescueState:Enter(role)
	self.super.Enter(self,role)
	local buff = CureState.new()
	buff.StaminaAdd = ConfigParam.XiaoKeStaminaAdd
	self.dead.stateMachine:addSharedState(buff)
end

XiaokeRescueState.FlowInSpeed = 3
function XiaokeRescueState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
end

function XiaokeRescueState:desmondMove(role,dTime)
	self.super.desmondMove(self,role,dTime)
end