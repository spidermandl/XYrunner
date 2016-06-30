--[[
author:Huqiuxiang
相扑青蛙攻击状态
]]
SumoFrogEnemyAtkState = class (BaseEnemyState)
SumoFrogEnemyAtkState._name = "SumoFrogEnemyAtkState"

function SumoFrogEnemyAtkState:Enter(role)
	self.super.Enter(self,role)
    self.super.AtkStateEnter(self,role)
end

function SumoFrogEnemyAtkState:Excute(role,dTime)
   self.super.AtkStateExcute(self,role,dTime,SumoFrogEnemyIdleState.new())
end