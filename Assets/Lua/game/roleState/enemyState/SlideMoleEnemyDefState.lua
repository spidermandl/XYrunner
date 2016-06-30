--[[
author:Huqiuxiang 赵名飞
潜行鼠受击状态
]]
SlideMoleEnemyDefState = class (BaseEnemyState)
SlideMoleEnemyDefState._name = "SlideMoleEnemyDefState"

function SlideMoleEnemyDefState:Enter(role)
	self.super.Enter(self,role)
	self.super.DefStateEnter(self,role)
end

function SlideMoleEnemyDefState:Excute(role,dTime)
	self.super.DefStateExcute(self,role,dTime)
end

function SlideMoleEnemyDefState:Exit(role)
    self.super.DefStateExit(self,role)
end