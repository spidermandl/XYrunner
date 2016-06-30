--[[
author:Huqiuxiang 赵名飞
胆小龟受击状态
]]
BowserEnemyDefState = class (BaseEnemyState)
BowserEnemyDefState._name = "BowserEnemyDefState"

function BowserEnemyDefState:Enter(role)
	self.super.Enter(self,role)
    self.super.DefStateEnter(self,role)
end

function BowserEnemyDefState:Excute(role,dTime)
     self.super.DefStateExcute(self,role,dTime,BowserEnemyIdleState.new())
end

function BowserEnemyDefState:Exit(role)
	 self.super.DefStateExit(self,role)
end