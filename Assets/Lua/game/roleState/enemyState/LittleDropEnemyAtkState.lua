--[[
author:Huqiuxiang 赵名飞
小水滴攻击状态
]]

LittleDropEnemyAtkState = class (BaseEnemyState)

LittleDropEnemyAtkState._name = "LittleDropEnemyAtkState"

function LittleDropEnemyAtkState:Enter(role)
	self.super.Enter(self,role)
    self.super.AtkStateEnter(self,role)
end

function LittleDropEnemyAtkState:Excute(role,dTime)
   self.super.AtkStateExcute(self,role,dTime,LittleDropEnemyIdleState.new())
end