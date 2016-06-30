--[[
author:Huqiuxiang
敌人待机状态
]]
KoffingEnemyIdleState = class (BaseEnemyState)
KoffingEnemyIdleState._name = "KoffingEnemyIdleState"


function KoffingEnemyIdleState:Enter(role)
	self.super.Enter(self,role)
    self.super.IdlStateEnter(self,role)
end

function KoffingEnemyIdleState:Excute(role,dTime)
	
end