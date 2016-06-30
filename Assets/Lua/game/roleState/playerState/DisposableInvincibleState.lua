--[[
一次性护盾状态 抵消一次角色的defend 状态
author:Huqiuxiang
]]
DisposableInvincibleState = class(BasePlayerState)
DisposableInvincibleState._name = "DisposableInvincibleState"
DisposableInvincibleState.effectGroup = nil --特效管理器
DisposableInvincibleState.effects = nil --特效

function DisposableInvincibleState:Enter(role)
	GamePrint("----------function DisposableInvincibleState:Enter(role)")
	self.effectGroup = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
	self.effects = PoolFunc:pickObjByPrefabName("Effects/Common/ef_prop_safetyhelmet") --创建特效
	self.effects.gameObject.transform.parent = role.gameObject.transform
	self.effects.gameObject.transform.localPosition = Vector3.zero
	self.effectGroup:addObject(self.effects,true)
end

function DisposableInvincibleState:Excute(role,dTime)
end

function DisposableInvincibleState:Exit(role)
	if self.effects ~= nil then
		self.effectGroup:removeObject(self.effects)
		local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_prop_safetyhelmet_end") --创建结束特效
		effect.gameObject.transform.parent = role.gameObject.transform
		effect.gameObject.transform.localPosition = Vector3.zero
		self.effectGroup:addObject(effect)
	end
end