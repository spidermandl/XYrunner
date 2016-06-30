--[[
电力球状态 三个阶段
author:Huqiuxiang
]]
ElectricBallState = class(BasePlayerState)
ElectricBallState._name = "ElectricBallState"
ElectricBallState.multiple = true --可同时存在多个
ElectricBallState.effects = nil 
ElectricBallState.state = 1
ElectricBallState.player = nil 
-- ElectricBallState.previousDamageTimes = nil
-- ElectricBallState.currentDamageTimes = nil 

function ElectricBallState:Enter(role)
	self.player = role
    -- self.previousDamageTimes = role.property.DamageTimes 
end

function ElectricBallState:Excute(role,dTime)
    -- self.currentDamageTimes = role.property.DamageTimes 
    -- self.state = self.currentDamageTimes - self.previousDamageTimes

	if self.state == 0 then
	     role.stateMachine:removeSharedState(self)
	elseif self.state == 1 then
         self:effectCreat("ef_debuff_hongse",role)
	elseif self.state == 2 then
         self:effectCreat("ef_debuff_lvse",role)
	elseif self.state == 3 then
         self:effectCreat("ef_debuff_lanse",role)
         if role.stateMachine.sharedStates["MagnetState"] == nil then
         	 local buff = MagnetState.new()
         	 buff.stage = 0
         	 buff.distance = 3
             role.stateMachine:addSharedState(MagnetState.new())
         end
	end
end

function ElectricBallState:Exit(role)
    if self.effects ~= nil then
		GameObject.Destroy(self.effects)
	end
end

function ElectricBallState:effectCreat(effect,role)
	if self.effects == nil then
	    -- 创建特效 
	     self.effects = newobject(Util.LoadPrefab("Effects/Common/"..effect))
    end
    self.effects.gameObject.transform.position = role.gameObject.transform.position
end

-- 受击 
function ElectricBallState:changeState()
    -- print("self.state"..self.state)
	if self.effects ~= nil then
		GameObject.Destroy(self.effects)
        self.effects = nil 
	end
	if self.state == 3 then

		 -- 如果是ufo 则return 
		 -- return
		 self.player.stateMachine.sharedStates["MagnetState"].stage = 1
		 -- self.state = self.state - 1
		 -- return
	end
	self.state = self.state - 1
end

-- 相同状态叠加处理
function ElectricBallState:addState(newState)
	if self.effects ~= nil then
		GameObject.Destroy(self.effects)
        self.effects = nil 
	end

    self.state = self.state + newState 
    if self.state > 3 then
    	 self.state = 3
    end
end