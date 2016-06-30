--[[
author:Desmond
角色被障碍物挡住状态 共享状态
]]
HangingBlockState = class (BasePlayerState)

HangingBlockState._name = "HangingBlockState"

function HangingBlockState:Enter(role)
	--GamePrint("--------------function HangingBlockState:Enter(role) ")
	self.super.Enter(self,role)
	role.isBlocked = true
end

function HangingBlockState:Excute(role,dTime)
	
end

function HangingBlockState:Exit(role)
	role.isBlocked = false
end