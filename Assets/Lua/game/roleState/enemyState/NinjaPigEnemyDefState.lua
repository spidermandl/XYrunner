--[[
author:Huqiuxiang 赵名飞
忍者猪 受击状态
]]
NinjaPigEnemyDefState = class (BaseEnemyState)

NinjaPigEnemyDefState._name = "NinjaPigEnemyDefState"
NinjaPigEnemyDefState.animator = nil

function NinjaPigEnemyDefState:Enter(role)
	self.super.Enter(self,role)
	self.super.DefStateEnter(self,role)
end

function NinjaPigEnemyDefState:Excute(role,dTime)
	self.super.DefStateExcute(self,role,dTime)
end

function NinjaPigEnemyDefState:Exit(role)
     self.super.DefStateExit(self,role)
end