--[[
author:赵名飞
普通城管鸟受击状态
]]
NormalBirdEnemyDefState = class (BaseEnemyState)

NormalBirdEnemyDefState._name = "NormalBirdEnemyDefState"
NormalBirdEnemyDefState.animator = nil

function NormalBirdEnemyDefState:Enter(role)
	self.super.Enter(self,role)
	self.super.DefStateEnter(self,role)
end

function NormalBirdEnemyDefState:Excute(role,dTime)
	self.super.DefStateExcute(self,role,dTime)
end

function NormalBirdEnemyDefState:Exit(role)
	self.super.DefStateExit(self,role)
end