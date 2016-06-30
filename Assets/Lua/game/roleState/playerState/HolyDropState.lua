--[[
直线x轴不变化落地状态
author:赵名飞
]]

HolyDropState  =  class(BasePlayerState)
HolyDropState.dropPoint = 0 --下降高度
HolyDropState.dropDistance = 0 --下降距离
HolyDropState.allTime = 0--计时
HolyDropState._name="HolyDropState"
HolyDropState.CleanState = nil --清屏状态
function HolyDropState:Enter(role)
	self.super.Enter(self,role)
	self.allTime = 0
	self.super.playAnimation(self,role,"single drop descend")
	role.property.moveDir.y = math.abs(role.property.moveDir.y) --y向量速度,方向向下
	self.dropPoint = role.gameObject.transform.position.y
	self.CleanState = CleanMonsterState.new()
   	self.CleanState.CleanMonsterDistance = ConfigParam.RebornCleanDistance
   	role.stateMachine:addSharedState(self.CleanState)
end

function HolyDropState:Excute(role,dTime)
	if self.allTime < 0.2 then--延迟
		self.allTime = self.allTime + dTime
		return
	end
	self.super.Excute(self,role,dTime,0)
    local landPoint = self.super.BaseDrop(self,role,dTime)
    self.dropDistance = self.dropPoint-landPoint

    local flag = self.super.isOnGround(self,role)
    if flag == true then
	    local effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
		local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_single_drop")
		effectManager:addObject(effect)
		effect.transform.parent = role.gameObject.transform.parent
		effect.transform.position = role.gameObject.transform.position
		effect.transform.localScale = role.gameObject.transform.localScale
    end
end

function HolyDropState:Exit(role)
	role.stateMachine:removeSharedState(self.CleanState)
end