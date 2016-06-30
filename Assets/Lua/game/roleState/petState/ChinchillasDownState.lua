--[[
龙猫落地状态
作者： 赵名飞
]]
ChinchillasDownState = class (BasePetState) 

ChinchillasDownState._name = "ChinchillasDownState"
ChinchillasDownState.time = 0 --记录下落时间

function ChinchillasDownState:Enter(role)
	-- 做在场景里的话 从idle开始   根据条件生成 从drop开始
	self.player = LuaShell.getRole(LuaShell.DesmondID)
    self.animator = role.character:GetComponent("Animator")
    self.animator:Play("attack")
    self:CreatEffect(role)
end

function ChinchillasDownState:Excute(role,dTime)
	self.time = self.time + dTime
	if self.time >= 2 then --落地两秒
		role.stateMachine:changeState(nil)
	end
end

function ChinchillasDownState:Exit(role)
	self.super.Exit(self,role)
	--role:playVanishExplode() --冷藏龙猫
end
--落地效果
function ChinchillasDownState:CreatEffect(role)

    local effectManager = PoolFunc:pickSingleton("EffectGroup")
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_pet_Lm_small")
    effect.name = "ef_pet_Lm_small"
    effect.transform.parent = role.gameObject.transform
    effect.transform.position = role.gameObject.transform.position
    effectManager:addObject(effect)
end




