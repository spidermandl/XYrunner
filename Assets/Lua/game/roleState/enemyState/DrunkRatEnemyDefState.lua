--[[
author:Huqiuxiang 赵名飞
醉酒鼠受击状态
]]
DrunkRatEnemyDefState = class (BaseEnemyState)
DrunkRatEnemyDefState._name = "DrunkRatEnemyDefState"

function DrunkRatEnemyDefState:Enter(role)
	self.super.Enter(self,role)
	self.super.DefStateEnter(self,role)
end

function DrunkRatEnemyDefState:Excute(role,dTime)
	 self.super.DefStateExcute(self,role,dTime)
end

function DrunkRatEnemyDefState:Exit(role)
	self.super.DefStateExit(self,role)
end