--[[
author:Huqiuxiang
敌人受击状态
]]
SpiritPaEnemyDefState = class (BaseEnemyState)
SpiritPaEnemyDefState._name = "SpiritPaEnemyDefState"

function SpiritPaEnemyDefState:Enter(role)
	self.super.Enter(self,role)
	self.super.DefStateEnter(self,role)
end

function SpiritPaEnemyDefState:Excute(role,dTime)
	self.super.DefStateExcute(self,role,dTime)
end

function SpiritPaEnemyDefState:Exit(role)
     self.super.DefStateExit(self,role)
end