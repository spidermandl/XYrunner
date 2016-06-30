--[[
author:Huqiuxiang 赵名飞
小水滴受击状态
]]
LittleDropEnemyDefState = class (BaseEnemyState)

LittleDropEnemyDefState._name = "LittleDropEnemyDefState"
LittleDropEnemyDefState.animator = nil

function LittleDropEnemyDefState:Enter(role)
	self.super.Enter(self,role)
	self.super.DefStateEnter(self,role)
end

function LittleDropEnemyDefState:Excute(role,dTime)
	self.super.DefStateExcute(self,role,dTime)
end

function LittleDropEnemyDefState:Exit(role)
	self.super.DefStateExit(self,role)
end