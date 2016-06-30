--[[
author:Huqiuxiang
敌人攻击状态
]]
KoffingEnemyAtkState = class (BaseEnemyState)

KoffingEnemyAtkState._name = "KoffingEnemyAtkState"
KoffingEnemyAtkState.animator = nil

function KoffingEnemyAtkState:Enter(role)
	self.super.Enter(self,role)
	self.super.AtkStateEnter(self,role)
end

function KoffingEnemyAtkState:Excute(role,dTime)
	 self.super.AtkStateExcute(self,role,dTime,KoffingEnemyIdleState.new())
end