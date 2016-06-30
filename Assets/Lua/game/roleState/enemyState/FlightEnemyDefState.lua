--[[
author:Huqiuxiang
飞行龟壳受击状态
]]
FlightEnemyDefState = class (BaseEnemyState)

FlightEnemyDefState._name = "FlightEnemyDefState"
FlightEnemyDefState.animator = nil

function FlightEnemyDefState:Enter(role)
    self.super.Enter(self,role)
    self.super.DefStateEnter(self,role)
end

function FlightEnemyDefState:Excute(role,dTime)
	self.super.DefStateExcute(self,role,dTime)
end

function FlightEnemyDefState:Exit(role)
    self.super.DefStateExit(self,role)
end