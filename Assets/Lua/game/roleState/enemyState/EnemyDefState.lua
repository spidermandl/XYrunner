-- --[[
-- author:Desmond
-- 小黑受击状态
-- ]]

EnemyDefState = class(BaseEnemyState)
EnemyDefState._name = "EnemyDefState"
EnemyDefState.effectT = nil 

function EnemyDefState:Enter(role)
	self.super.Enter(self,role)
 	self.super.DefStateEnter(self,role)
 	--print(" EnemyDefState:Enter 小黑受击")
 	--[[
 	local effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
 	local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_player_goldcoins")
 	effect.transform.parent = role.gameObject.transform
    effect.transform.localPosition = role.gameObject.transform.localPosition
    effect.transform.localScale = role.gameObject.transform.localScale
    effectManager:addObject(effect)
    ]]
end

function EnemyDefState:Excute(role,dTime)
 	self.super.DefStateExcute(self,role,dTime)
end

function EnemyDefState:Exit(role)
	--print ("-------------------function EnemyDefState:Exit(role) ")
 	--destroy(self.effectT)
end


