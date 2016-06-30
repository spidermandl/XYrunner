--[[
真无敌状态
author:Huqiuxiang
]]
InvincibleState = class(BasePlayerState)
InvincibleState._name = "InvincibleState"
InvincibleState.isShowEffect = true
InvincibleState.frameTime = 1
InvincibleState.startTime = nil
InvincibleState.roleAttack = 0
InvincibleState.effects = nil 
InvincibleState.duringTime = 7
InvincibleState.effectType = 0 -- 0 为普通 1 为 无尽
InvincibleState.state = 0  -- 0 为罩子特效状态  1 为罩子结束特效
InvincibleState.effectEndTime = 0.5
InvincibleState.effectEnd = nil -- 结束特效
InvincibleState.effectGroup = nil --特效管理类

function InvincibleState:Enter(role)
	self.startTime = UnityEngine.Time.time
	self.duringTime = self.duringTime + (self.duringTime * role.property.StateBonusTime) --本身持续时间 + 角色增益时间
	self.roleAttack = role.property.attack
	role.property.attack = 99
	self.effectGroup = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
	if self.isShowEffect then
		self.effects = self:creatEffect(role)
		self.effectGroup:addObject(self.effects,true)
    	self.state = 0 
	end
	
	-- print ("----------------------------------------------- function ChangeBigState:Enter------------------------") ConfigParam.InvincibleState
end

function InvincibleState:Excute(role,dTime)
	if self.isShowEffect then
		if self.state == 0 then
		    if UnityEngine.Time.time - self.startTime > self.duringTime then
	            self.effectEnd = self:creatEffectEnd()
	            self.effectGroup:addObject(self.effectEnd,true)
	            self.effectGroup:removeObject(self.effects)
		    	self.state = 1 
		    end
		elseif self.state == 1 then
	    	self.effectEnd.gameObject.transform.position = role.gameObject.transform.position
	    	
		end  
	end
	if self.state == 1 then
		if UnityEngine.Time.time - self.startTime > self.duringTime + self.effectEndTime then
		    role.stateMachine:removeSharedState(self)
		    return
	    end
	end
	self.frameTime = self.frameTime + 1

end

function InvincibleState:Exit(role)
	role.property.attack = self.roleAttack
	if self.effects ~= nil then
		self.effectGroup:removeObject(self.effects)
	end
	if self.effectEnd ~= nil then
		self.effectGroup:removeObject(self.effectEnd)
	end
	-- role.stateMachine:addSharedState(InvincibleEndState.new()) 
end

-- 特效切换
function InvincibleState:creatEffect(role)
	if self.isShowEffect == false then return end
	local effect = nil
	if self.effectType == 0 then
		effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_prop_safetyhelmet") --创建特效
		effect.gameObject.transform.parent = role.gameObject.transform
		effect.gameObject.transform.localPosition = Vector3.zero
	elseif self.effectType == 1 then
		effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_player_tuoweixingxing") --创建特效
		effect.gameObject.transform.parent = role.gameObject.transform
		effect.gameObject.transform.localPosition = Vector3(1,0,0)
	end
	return effect
end

-- 特效结束
function InvincibleState:creatEffectEnd()
	if self.isShowEffect == false then return end
	local effect = nil
	if self.effectType == 0 then
		effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_prop_safetyhelmet_end") --创建特效
	elseif self.effectType == 1 then
		effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_prop_safetyhelmet_end") --创建特效
	end

	return effect
end
