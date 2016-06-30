--[[
author:Huqiuxiang 赵名飞
忍者猪 待机状态
]]
NinjaPigEnemyIdleState = class (BaseEnemyState)
NinjaPigEnemyIdleState._name = "NinjaPigEnemyIdleState"
NinjaPigEnemyIdleState.time = 0
function NinjaPigEnemyIdleState:Enter(role)
    self.super.Enter(self,role)
	self.super.IdlStateEnter(self,role)
end

function NinjaPigEnemyIdleState:Excute(role,dTime)
	self.super.Excute(self,role)
    self.time = self.time + dTime --计时
    if self.time >= ConfigParam.NinJaChangeTime then
        role:changeEnemy(1) --变美女
        self.time = 0
    else
        if role.distance < 4  and role.distance ~= 0 then --近战怪提前播放攻击动画
            role.stateMachine:changeState(NinjaPigEnemyAtkState.new())
        end
    end
    
end

