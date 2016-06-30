--AntiMagnetState.lua
--[[
无法收集物品状态
author:赵名飞
]]
AntiMagnetState = class(BasePlayerState)
AntiMagnetState._name = "AntiMagnetState"
AntiMagnetState.startTime = nil

function AntiMagnetState:Enter(role)
	self.startTime = UnityEngine.Time.time

    local effectGroup = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_debuff_hongse")--创建特效
    effect.transform.parent = role.gameObject.transform
    effect.transform.localPosition = Vector3(0.8,2.5,0)
    effectGroup:addObject(effect,RoleProperty.AntiMagnetTime)

end

function AntiMagnetState:Excute(role,dTime)
	if UnityEngine.Time.time - self.startTime > RoleProperty.AntiMagnetTime then
		role.stateMachine:removeSharedState(self)
		return
	end
end

function AntiMagnetState:Exit(role)
end
