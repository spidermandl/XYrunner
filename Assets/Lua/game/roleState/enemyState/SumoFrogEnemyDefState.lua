--[[
author:Huqiuxiang
相扑青蛙受击状态
]]
SumoFrogEnemyDefState = class (BaseEnemyState)
SumoFrogEnemyDefState._name = "SumoFrogEnemyDefState"

function SumoFrogEnemyDefState:Enter(role)
	self.super.Enter(self,role)
	self.super.DefStateEnter(self,role)
end

function SumoFrogEnemyDefState:Excute(role,dTime)
     self.super.DefStateExcute(self,role,dTime,SumoFrogEnemyIdleState.new())
end

function SumoFrogEnemyDefState:Exit(role)
     self.super.DefStateExit(self,role)
end