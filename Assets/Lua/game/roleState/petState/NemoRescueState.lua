--[[
author:huqiuxiang
nemo救起主角状态 NemoRescueState
]]
NemoRescueState = class (PetRescueState)
NemoRescueState._name = "NemoRescueState"

function NemoRescueState:Enter(role)
	self.super.Enter(self,role)
	local buff = InvincibleState.new()
    self.dead.stateMachine:addSharedState(buff) -- 主角无敌buff
end

function NemoRescueState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
end

function NemoRescueState:desmondMove(role,dTime)
	self.super.desmondMove(self,role,dTime)
end