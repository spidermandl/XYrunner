--[[
author:huqiuxiang
体力瓶子回血状态
]]
StaminaBottleState = class (IState)
StaminaBottleState._name = "StaminaBottleState"
StaminaBottleState.effect = nil -- 特效
StaminaBottleState.player = nil -- 主角

function StaminaBottleState:Enter(role)
    self.player = LuaShell.getRole(LuaShell.DesmondID) 
    local buff = CureState.new()
    self.player.stateMachine:addSharedState(buff) -- 主角恢复体力buff

    local child = role.gameObject.transform:GetChild(0)
    child.gameObject:SetActive(false)
    -- self.effect.gameObject.transform.parent = self.player.gameObject.transform
end

function StaminaBottleState:Excute(role,dTime)
end

function StaminaBottleState:Exit(role,dTime)
    if self.effect ~= nil then
		GameObject.Destroy(self.effect)
	end
end