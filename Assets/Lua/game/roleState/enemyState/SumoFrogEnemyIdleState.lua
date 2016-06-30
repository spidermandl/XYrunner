--[[
author:Huqiuxiang
相扑青蛙待机状态
]]
SumoFrogEnemyIdleState = class (BaseEnemyState)
SumoFrogEnemyIdleState._name = "SumoFrogEnemyIdleState"

function SumoFrogEnemyIdleState:Enter(role)
	self.super.Enter(self,role)
    self.super.IdlStateEnter(self,role)
end

function SumoFrogEnemyIdleState:Excute(role,dTime)

	if role.distance < 1  and role.distance ~= 0 then --近战怪提前播放攻击动画
         role.stateMachine:changeState(EnemyAtkState.new())
    end
end