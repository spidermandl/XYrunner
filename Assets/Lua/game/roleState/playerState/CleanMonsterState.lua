--[[
清屏状态
author:赵名飞
]]
CleanMonsterState = class (BasePlayerState)
CleanMonsterState._name = "CleanMonsterState"
CleanMonsterState.CleanMonsterDistance = 0 --清屏距离

function CleanMonsterState:Enter(role)
	self.enemyManager = PoolFunc:pickSingleton("EnemyGroup")
	GamePrint("CleanMonsterState  作用范围："..self.CleanMonsterDistance)
end

function CleanMonsterState:Excute(role,dTime)
	self.enemyManager:CleanEnemyByDistance(self.CleanMonsterDistance)
end

function CleanMonsterState:Exit(role)
	--self.enemyManager:CleanEnemyByDistance(self.CleanMonsterDistance * 2)
end