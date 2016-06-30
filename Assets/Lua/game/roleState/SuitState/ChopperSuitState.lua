--[[
乔巴套装状态
作者：秦仕超
]]
ChopperSuitState = class (BasePlayerState) 
ChopperSuitState._name = "ChopperSuitState"
function ChopperSuitState:Enter(role)
	-- 遍历萌宠table 有乔巴增强属性
	local buff = ChangeBigState.new()
    role.stateMachine:addSharedState(buff)
end

function ChopperSuitState:Excute(role,dTime)
	if role.stateMachine.sharedStates["ChangeBigState"] == nil then
        role.stateMachine:removeSharedState(self)
    end
end

function ChopperSuitState:Exit(role)

end

