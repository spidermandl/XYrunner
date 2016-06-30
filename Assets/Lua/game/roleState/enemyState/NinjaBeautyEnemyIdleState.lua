--NinjaBeautyEnemyIdleState.lua
--[[
author: 赵名飞
忍者美女 待机状态
]]
NinjaBeautyEnemyIdleState = class (BaseEnemyState)
NinjaBeautyEnemyIdleState._name = "NinjaBeautyEnemyIdleState"
NinjaBeautyEnemyIdleState.time = 0

function NinjaBeautyEnemyIdleState:Enter(role)
    self.super.Enter(self,role)
	self.super.IdlStateEnter(self,role)
end

function NinjaBeautyEnemyIdleState:Excute(role,dTime)
	
    self.time = self.time + dTime --计时
    if self.time >= ConfigParam.NinJaChangeTime then
        role:changeEnemy(0) --变猪
        self.time = 0
    end
end