--[[
author:Huqiuxiang
敌人受击状态
]]
MadRabbitEnemyDefState = class (BaseEnemyState)
MadRabbitEnemyDefState._name = "MadRabbitEnemyDefState"

function MadRabbitEnemyDefState:Enter(role)
	self.super.Enter(self,role)
	self.super.DefStateEnter(self,role)
end

function MadRabbitEnemyDefState:Excute(role,dTime)
	self.super.DefStateExcute(self,role,dTime)
end

function MadRabbitEnemyDefState:Exit(role)
	self.super.DefStateExit(self,role)
end