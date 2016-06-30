--[[
author:Huqiuxiang 赵名飞
忍者猪 攻击状态
]]
NinjaPigEnemyAtkState = class (BaseEnemyState)
NinjaPigEnemyAtkState._name = "NinjaPigEnemyAtkState"

function NinjaPigEnemyAtkState:Enter(role)
	self.super.Enter(self,role)
	self.super.AtkStateEnter(self,role)
end

function NinjaPigEnemyAtkState:Excute(role,dTime)
	self.super.AtkStateExcute(self,role,dTime,NinjaPigEnemyIdleState.new())
end