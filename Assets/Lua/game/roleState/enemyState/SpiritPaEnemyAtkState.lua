--[[
author:Huqiuxiang
小帕攻击状态 
]]
SpiritPaEnemyAtkState = class (BaseEnemyState)
SpiritPaEnemyAtkState._name = "SpiritPaEnemyAtkState"

function SpiritPaEnemyAtkState:Enter(role)
	self.super.Enter(self,role)
	self.super.AtkStateEnter(self,role)
end

function SpiritPaEnemyAtkState:Excute(role,dTime)
	self.super.AtkStateExcute(self,role,dTime,SpiritPaEnemyIdleState.new())
end