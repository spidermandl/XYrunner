--[[
author:Huqiuxiang 赵名飞
城管鸟 受击状态
]]
ChasedBirdEnemyDefState = class (BaseEnemyState)
ChasedBirdEnemyDefState._name = "ChasedBirdEnemyDefState"

function ChasedBirdEnemyDefState:Enter(role)
	self.super.Enter(self,role)
	self.super.DefStateEnter(self,role)
end

function ChasedBirdEnemyDefState:Excute(role,dTime)
	self.super.DefStateExcute(self,role,dTime)
end

function ChasedBirdEnemyDefState:Exit(role)
     self.super.DefStateExit(self,role)
end