--[[
author:Huqiuxiang
胆小龟攻击状态
]]

BowserEnemyAtkState = class (BaseEnemyState)
BowserEnemyAtkState._name = "BowserEnemyAtkState"

function BowserEnemyAtkState:Enter(role)
	self.super.Enter(self,role)
	self.super.AtkStateEnter(self,role)
end

function BowserEnemyAtkState:Excute(role,dTime)
    self.super.AtkStateExcute(self,role,dTime,BowserEnemyIdleState.new())
end