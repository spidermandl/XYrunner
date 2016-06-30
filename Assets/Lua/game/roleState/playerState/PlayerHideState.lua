--PlayerHideState.lua
--[[
主角隐藏状态
author:赵名飞
]]
PlayerHideState = class (BasePlayerState)
PlayerHideState._name = "PlayerHideState"

function PlayerHideState:Enter(role)
    self:PlayEffect()
    role:setSuitVisible(false)
end

function PlayerHideState:Excute(role,dTime)
    self.super.Excute(self,role,dTime)
    --role.gameObject.transform:Translate(role.property.moveDir.x*dTime,0,0, Space.World)
end

function PlayerHideState:Exit(role)
	self:PlayEffect()
    role:setSuitVisible(true)
end

function PlayerHideState:PlayEffect(effectName)
	if effectName ~= nil then
		local effectManager = PoolFunc:pickSingleton("EffectGroup")
    	local effect  = PoolFunc:pickObjByPrefabName("Effects/Common/"..effectName)
    	effect.transform.parent=role.gameObject.transform
    	effect.transform.position = role.gameObject.transform.position
    	effect.transform.localScale = role.gameObject.transform.localScale
    	effectManager:addObject(self.effect)
	end
end