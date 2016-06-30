--[[
author:Huqiuxiang
胆小龟待机状态
]]
BowserEnemyIdleState = class (BaseEnemyState)
BowserEnemyIdleState._name = "BowserEnemyIdleState"

function BowserEnemyIdleState:Enter(role)
	self.super.Enter(self,role)
	self.super.IdlStateEnter(self,role)
end

function BowserEnemyIdleState:Excute(role,dTime)

	if role.distance < 3  and role.distance ~= 0 then--近战怪提前播放攻击动画
        role.stateMachine:changeState(BowserEnemyAtkState.new())
    end
end