--[[
author:Desmond
敌人攻击状态
]]
EnemyAtkState = class (BaseEnemyState)
EnemyAtkState._name = "EnemyAtkState"

function EnemyAtkState:Enter(role)
	self.super.Enter(self,role)
    self.super.AtkStateEnter(self,role)
end

function EnemyAtkState:Excute(role,dTime)
   self.super.AtkStateExcute(self,role,dTime,EnemyIdleState.new())
end

function EnemyAtkState:Exit(role)
end