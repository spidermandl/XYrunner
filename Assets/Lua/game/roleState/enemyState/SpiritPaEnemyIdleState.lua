--[[
author:Huqiuxiang
敌人待机状态
]]
SpiritPaEnemyIdleState = class (BaseEnemyState)
SpiritPaEnemyIdleState._name = "SpiritPaEnemyIdleState"

function SpiritPaEnemyIdleState:Enter(role)
	self.super.Enter(self,role)
	self.super.IdlStateEnter(self,role)

	--show特效
	local effectManager = PoolFunc:pickSingleton("EffectGroup")
	local effect = role.character.transform:Find("ef_monster_xiaopa")
	if effect == nil then
		effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_monster_xiaopa")
		effectManager:addObject(effect)
	end
	effect.name = "ef_monster_xiaopa"
	effect.transform.parent = role.character.transform
	effect.transform.localPosition = UnityEngine.Vector3(0,0.5,1)
    effect.transform.localRotation = Quaternion.Euler(0,0,0)
    effect.transform.localScale = UnityEngine.Vector3.one
end

function SpiritPaEnemyIdleState:Excute(role,dTime)
	self.super.IdlStateExcute(self,role,SpiritPaEnemyAtkState.new())
	-- if role.distance < 5 and role.distance ~= 0 then
 --        role.stateMachine:changeState(SpiritPaEnemyAtkState.new())
 --    end
end

function SpiritPaEnemyIdleState:Exit(role)
	GameObject.Destroy(role.effectG)
end