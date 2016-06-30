--[[
author:Huqiuxiang 赵名飞
舔人花待机状态
]]
LickFlowerEnemyIdleState = class (BaseEnemyState)
LickFlowerEnemyIdleState._name = "LickFlowerEnemyIdleState"

function LickFlowerEnemyIdleState:Enter(role)
	self.super.Enter(self,role)
	self.super.IdlStateEnter(self,role)
end

function LickFlowerEnemyIdleState:Excute(role,dTime)

	if role.distance < 6  and role.distance ~= 0 then--近战怪提前播放攻击动画
         role.stateMachine:changeState(LickFlowerEnemyAtkState.new())
    end
end