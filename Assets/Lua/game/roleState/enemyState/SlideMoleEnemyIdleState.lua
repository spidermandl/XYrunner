--[[
author:Huqiuxiang 赵名飞
潜行鼠待机状态
]]
SlideMoleEnemyIdleState = class (BaseEnemyState)
SlideMoleEnemyIdleState._name = "SlideMoleEnemyIdleState"

function SlideMoleEnemyIdleState:Enter(role)
	self.super.Enter(self,role)
	self.super.IdlStateEnter(self,role)
end

function SlideMoleEnemyIdleState:Excute(role,dTime)
	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	if role.distance < ConfigParam.MoleAttackDistance  and role.distance ~= 0 and animInfo.normalizedTime >= 1.0 then
         role.stateMachine:changeState(SlideMoleEnemyAtkState.new())
    end
end