--[[
author:Huqiuxiang 赵名飞
城管鸟 攻击状态
]]
ChasedBirdEnemyAtkState = class (BaseEnemyState)
ChasedBirdEnemyAtkState._name = "ChasedBirdEnemyAtkState"
ChasedBirdEnemyAtkState.modelName = "Effects/Common/ef_monster_chengguan"
ChasedBirdEnemyAtkState.effect = nil --攻击特效
ChasedBirdEnemyAtkState.effectManager = nil --特效管理器

function ChasedBirdEnemyAtkState:Enter(role)
    self.super.Enter(self,role)
    self.super.AtkStateEnter(self,role)
    self.effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
end

function ChasedBirdEnemyAtkState:Excute(role,dTime)

    local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
    if animInfo.normalizedTime < 0.9 then --动画结束
        if self.effect == nil then
            self.effect = PoolFunc:pickObjByPrefabName(self.modelName)
            self.effectManager:addObject(self.effect)
        end
        self.effect.transform.parent = role.gameObject.transform
        self.effect.transform.localPosition = role.character.transform.localPosition
        self.effect.transform.localScale = role.character.transform.localScale
    end
    if animInfo.normalizedTime >= 0.9 then
        role.stateMachine:changeState(ChasedBirdEnemyIdleState.new())
    end
end