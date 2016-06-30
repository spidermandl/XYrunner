--[[
author:Huqiuxiang 赵名飞
舔人花受击状态
]]
LickFlowerEnemyDefState = class (BaseEnemyState)
LickFlowerEnemyDefState._name = "LickFlowerEnemyDefState"

function LickFlowerEnemyDefState:Enter(role)
	self.super.Enter(self,role)
	self.super.DefStateEnter(self,role)
end

function LickFlowerEnemyDefState:Excute(role,dTime)
	self.super.DefStateExcute(self,role,dTime)
end

function LickFlowerEnemyDefState:Exit(role)
     self.super.DefStateExit(self,role)
end