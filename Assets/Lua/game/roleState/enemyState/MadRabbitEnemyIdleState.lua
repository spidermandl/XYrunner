--[[
author:Huqiuxiang 赵名飞
疯兔 待机状态
]]
MadRabbitEnemyIdleState = class (BaseEnemyState)
MadRabbitEnemyIdleState._name = "MadRabbitEnemyIdleState"
MadRabbitEnemyIdleState.time = 0 --攻击间隔时间

function MadRabbitEnemyIdleState:Enter(role)
	self.super.Enter(self,role)
	self.super.IdlStateEnter(self,role)
end

function MadRabbitEnemyIdleState:Excute(role,dTime)
	if role.distance < ConfigParam.MadRabbitAttackDistance and role.distance ~= 0 then
		self.time = self.time + dTime
		if self.time >= ConfigParam.MadRabbitAttackInterval then
   			role.stateMachine:changeState(MadRabbitEnemyAtkState.new())
   		end
    end
end