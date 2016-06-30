--[[
author:Huqiuxiang 赵名飞
小水滴待机状态
]]
LittleDropEnemyIdleState = class (BaseEnemyState)

LittleDropEnemyIdleState._name = "LittleDropEnemyIdleState"

function LittleDropEnemyIdleState:Enter(role)
	self.super.Enter(self,role)
    self.super.IdlStateEnter(self,role)
end

function LittleDropEnemyIdleState:Excute(role,dTime)
	if role.distance < 4  and role.distance ~= 0 then--近战怪提前播放攻击动画
         role.stateMachine:changeState(LittleDropEnemyAtkState.new())
    end
end