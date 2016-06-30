--[[
author:Huqiuxiang
弹跳龟壳受击状态
]]
SpringEnemyDefState = class (BaseEnemyState)

SpringEnemyDefState._name = "SpringEnemyDefState"
SpringEnemyDefState.animator = nil

function SpringEnemyDefState:Enter(role)
	self.super.Enter(self,role)
	role.HP = role.HP - role:getPlayer().property.attack
	if role.HP < 1 then --受伤 死亡判断
		self.idCanDestroy = true
	else

	end		
	self.stage = self.BACKWARDS
    self.positionX = role.gameObject.transform.position.x
    local effectManager = PoolFunc:pickSingleton("EffectGroup")
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_npc_hit")
    effectManager:addObject(effect)
    effect.transform.parent=role.gameObject.transform
    local pos = role.gameObject.transform.position
    pos.y = pos.y + 0.5
    effect.transform.position = pos
    effect.transform.localScale = role.gameObject.transform.localScale
    local pArray = effect.gameObject.transform:GetComponentsInChildren(UnityEngine.ParticleSystem.GetClassType())
    local length = pArray.Length-1 
    for i=0,length do
    	System.Array.GetValue(pArray,i):Play()
	end
end

function SpringEnemyDefState:Excute(role,dTime)
	 self.super.DefStateExcute(self,role,dTime)
end

function SpringEnemyDefState:Exit(role)
     self.super.DefStateExit(self,role)
end