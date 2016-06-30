--[[
author:Desmond
行走中被挂墙挡住
共享状态
]]
FlyATKBlockState = class(BasePlayerState)

FlyATKBlockState._name = "FlyATKBlockState"
FlyATKBlockState.TIME_CAP = 0.5 --空中攻击间隔0.5秒
FlyATKBlockState.time = 0

function FlyATKBlockState:Enter(role)
end

function FlyATKBlockState:Excute(role,dTime)
	self.time = self.time + dTime
	if role.stateMachine:getState()._name == "RunState" then --落地
		role.stateMachine:removeSharedState(self)
		return
	end

	if self.time > self.TIME_CAP then --过时
		role.stateMachine:removeSharedState(self)
	end
end

function FlyATKBlockState:Exit(role)
end
