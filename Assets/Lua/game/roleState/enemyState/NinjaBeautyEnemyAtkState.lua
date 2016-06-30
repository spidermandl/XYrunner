--NinjaBeautyEnemyAtkState.lua
--[[
author: 赵名飞
忍者美女 攻击状态
]]
NinjaBeautyEnemyAtkState = class (BaseEnemyState)
NinjaBeautyEnemyAtkState._name = "NinjaBeautyEnemyAtkState"
NinjaBeautyEnemyAtkState.time = 0

function NinjaBeautyEnemyAtkState:Enter(role)
    self.super.Enter(self,role)
	self.super.AtkStateEnter(self,role)
end

function NinjaBeautyEnemyAtkState:Excute(role,dTime)
	self.super.AtkStateExcute(self,role,dTime,NinjaBeautyEnemyIdleState.new())
end