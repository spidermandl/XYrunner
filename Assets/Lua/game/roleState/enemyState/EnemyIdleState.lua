--[[
author:Desmond
敌人待机状态
]]
EnemyIdleState = class (BaseEnemyState)
EnemyIdleState._name = "EnemyIdleState"
EnemyIdleState.effectManager = nil --特效管理器
EnemyIdleState.effect = nil  --特效

function EnemyIdleState:Enter(role)
	self.super.Enter(self,role)
    self.super.IdlStateEnter(self,role)

    self.effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
    self.effect = role.gameObject.transform:FindChild("ef_xiaohei_idlel01")
    if self.effect == nil then
        local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_xiaohei_idlel01")
        self.effectManager:addObject(effect)
        effect.gameObject.name = "ef_xiaohei_idlel01"
        effect.transform.parent = role.gameObject.transform
        effect.transform.position = role.gameObject.transform.position
        effect.transform.localScale = role.gameObject.transform.localScale
        self.effect = effect
    end
    self.effect.gameObject:SetActive(true)
end

function EnemyIdleState:Excute(role,dTime)
   if role.distance < 3  and role.distance ~= 0 then--近战怪提前播放攻击动画
        role.stateMachine:changeState(EnemyAtkState.new())
    end
end

function EnemyIdleState:Exit(role)
end
