--[[
无法攻击状态
author:Huqiuxiang
]]
CantAttackState = class(BasePlayerState)
CantAttackState._name = "CantAttackState"
CantAttackState.frameTime = 1
CantAttackState.startTime = nil
CantAttackState.bigSize = 1.5
CantAttackState.effects = nil 
CantAttackState.duringTime = 3 
CantAttackState.hitForPa = 0 -- 被小帕攻击多一特效
CantAttackState.paBuffEffect = nil
CantAttackState.stage = 2

function CantAttackState:Enter(role)
	self.startTime = UnityEngine.Time.time

    local effectGroup = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_debuff_hongse")--创建特效
    effect.transform.parent = role.gameObject.transform
    effect.transform.localPosition = role.gameObject.transform.localPosition
    effectGroup:addObject(effect)

    if self.hitForPa == 1 then
    	local paBuffEffect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_xiaopa_hit_debuff")--创建特效
    	paBuffEffect.transform.parent = role.gameObject.transform
        paBuffEffect.transform.localPosition = role.gameObject.transform.localPosition
        effectGroup:addObject(paBuffEffect)
    end
	-- print ("----------------------------------------------- function ChangeBigState:Enter------------------------")
end

function CantAttackState:Excute(role,dTime)
    if self.stage == 0 then  
        role.stateMachine:removeSharedState(self)
	elseif self.stage == 1 then 

	elseif self.stage == 2 then 
        self:duringTimeStage(role,dTime)
    end
end

function CantAttackState:Exit(role)
end

-- 时间限定阶段
function CantAttackState:duringTimeStage(role,dTime)
	if UnityEngine.Time.time - self.startTime > self.duringTime then
		role.stateMachine:removeSharedState(self)
		return
	end
end