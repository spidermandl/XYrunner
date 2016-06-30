--[[
author: 赵名飞
普通城管鸟待机状态
]]
NormalBirdEnemyIdleState = class (BaseEnemyState)

NormalBirdEnemyIdleState._name = "NormalBirdEnemyIdleState"

function NormalBirdEnemyIdleState:Enter(role)
	self.super.Enter(self,role)
    self.super.IdlStateEnter(self,role)
end

function NormalBirdEnemyIdleState:Excute(role,dTime)
	if role.distance < ConfigParam.NormalBirdAttackDistance  and role.distance ~= 0 then--近战怪提前播放攻击动画
         role.stateMachine:changeState(NormalBirdEnemyAtkState.new())
    end
end