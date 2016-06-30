--[[
author:Huqiuxiang
敌人状态
]]
KoffingEnemyDefState = class (BaseEnemyState)

KoffingEnemyDefState._name = "KoffingEnemyDefState"

function KoffingEnemyDefState:Enter(role)
	 
	self.super.Enter(self,role)
    self.super.DefStateEnter(self,role)
end

function KoffingEnemyDefState:Excute(role,dTime)
	self.super.DefStateExcute(self,role,dTime)
end

function KoffingEnemyDefState:Exit(role)
	--print ("-----------------------function KoffingEnemyDefState:Exit(role) ")
    self.super.DefStateExit(self,role)
end