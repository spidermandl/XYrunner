--[[
author:Huqiuxiang
舔人花攻击状态
]]
LickFlowerEnemyAtkState = class (BaseEnemyState)
LickFlowerEnemyAtkState._name = "LickFlowerEnemyAtkState"

function LickFlowerEnemyAtkState:Enter(role)
	self.super.Enter(self,role)
	self.super.AtkStateEnter(self,role)
end

function LickFlowerEnemyAtkState:Excute(role,dTime)
	self.super.AtkStateExcute(self,role,dTime,LickFlowerEnemyIdleState.new())
end