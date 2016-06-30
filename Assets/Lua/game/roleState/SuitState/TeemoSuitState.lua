--[[
提莫套装状态
作者：秦仕超
]]
TeemoSuitState = class (BasePlayerState) 
TeemoSuitState._name = "TeemoSuitState"

function TeemoSuitState:Enter(role)
  	-- 遍历萌宠table 有提莫增强属性
	local buff = StealthState.new()
    role.stateMachine:addSharedState(buff)
end

function TeemoSuitState:Excute(role,dTime)
	if role.stateMachine.sharedStates["StealthState"] == nil then
        role.stateMachine:removeSharedState(self)
    end
end

function TeemoSuitState:Exit(role)
end


