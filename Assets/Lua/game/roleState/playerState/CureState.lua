--[[
   author:Huqiuxiang
   主角恢复体力状态 共享状态
]]
CureState = class(BasePlayerState)
CureState._name = "CureState"
CureState.multiple = true --可同时存在多个
CureState.startTime = nil
CureState.effects = nil 
CureState.effectsTime = 1.5

function CureState:Enter(role)
	self.startTime = UnityEngine.Time.time
	
	local effectGroup = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_prop_tili")
    effect.transform.parent = role.gameObject.transform.parent
    effect.transform.localPosition = role.gameObject.transform.localPosition
    effect.transform.localScale = role.gameObject.transform.localScale
    effectGroup:addObject(effect)

    role:addStamina(TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_BLOOD_BOTTLE_EXTRA))-- 回复体力
end

function CureState:Excute(role,dTime)
	if UnityEngine.Time.time - self.startTime >self.effectsTime then
		role.stateMachine:removeSharedState(self)
		return
	end
    self.effects.gameObject.transform.position = role.gameObject.transform.position
end

function CureState:Exit(role)
end