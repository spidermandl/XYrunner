--[[
author: 赵名飞
普通城管鸟攻击状态
]]

NormalBirdEnemyAtkState = class (BaseEnemyState)

NormalBirdEnemyAtkState._name = "NormalBirdEnemyAtkState"

function NormalBirdEnemyAtkState:Enter(role)
	self.super.Enter(self,role)
    self.super.AtkStateEnter(self,role)
end

function NormalBirdEnemyAtkState:Excute(role,dTime)
   self.super.AtkStateExcute(self,role,dTime,NormalBirdEnemyIdleState.new())
end