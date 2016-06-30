--[[
author:huqiuxiang
丘比救起主角状态
]]
ChobeRescueState = class (PetRescueState)
ChobeRescueState._name = "ChobeRescueState"

function ChobeRescueState:Enter(role)
	self.super.Enter(self,role)
end

function ChobeRescueState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
end

function ChobeRescueState:desmondMove(role,dTime)
	self.super.desmondMove(self,role,dTime)
end