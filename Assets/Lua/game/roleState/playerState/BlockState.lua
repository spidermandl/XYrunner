--[[
author:Desmond
角色被障碍物挡住状态 共享状态
]]
BlockState = class (BasePlayerState)

BlockState._name = "BlockState"

function BlockState:Enter(role)
	--GamePrint("--------------function BlockState:Enter(role) ")
	self.super.Enter(self,role)
	role.isBlocked = true
end

function BlockState:Excute(role,dTime)
	
end

function BlockState:Exit(role)
	role.isBlocked = false
end