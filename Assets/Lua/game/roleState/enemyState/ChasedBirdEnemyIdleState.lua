--[[
author:Huqiuxiang 赵名飞
城管鸟 待机状态
]]
ChasedBirdEnemyIdleState = class (BaseEnemyState)
ChasedBirdEnemyIdleState._name = "ChasedBirdEnemyIdleState"

function ChasedBirdEnemyIdleState:Enter(role)
	self.super.Enter(self,role)
	 self.super.IdlStateEnter(self,role)
end

--攻击距离判断
function ChasedBirdEnemyIdleState:Excute(role,dTime)

    if role.distance < ConfigParam.BirdAttackDistance  and role.distance ~= 0 then
        role.stateMachine:changeState(ChasedBirdEnemyAtkState.new())
    end
end