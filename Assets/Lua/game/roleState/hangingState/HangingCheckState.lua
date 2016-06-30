--[[
author:Desmond
挂墙检测状态 共享状态
]]
HangingCheckState = class (IState)
HangingCheckState._name = "HangingCheckState"
HangingCheckState.previousState = nil 

--[[ item:item 为lua对象 ]]
function HangingCheckState:Enter(item)
	GamePrint("-------------function HangingCheckState:Enter(item) ")
end

--[[ 
item:item 为lua对象
dTime:update时间间隔
]]
function HangingCheckState:Excute(item,dTime)

	local player = item.player
    local name = player.stateMachine:getState()._name

    -- GamePrint("--------------function HangingCheckState:Excute(item,dTime) "..tostring(name)..' '
    -- 	..tostring(player.stateMachine:getSharedState("HangingBlockState")))

    if 
    name == "RunState" and player.stateMachine:getSharedState("HangingBlockState") ~= nil then --吸墙掉落
    	item.stateMachine:changeState(HangingOnGroundState.new())

	elseif name == "RunState" and player.stateMachine:getSharedState("HangingBlockState") == nil then --落地
    	item.stateMachine:changeState(HangingNormalState.new())

	elseif (name == "JumpTopState" or name == "AirAttackState") and player.stateMachine:getSharedState("HangingBlockState") ~= nil then --吸强起跳至顶点
		item.stateMachine:changeState(HangingNormalState.new())

	elseif name == "WallClimbState" then --吸墙状态
		--GamePrint("-------------function HangingCheckState:Excute(item,dTime) 2")
		item.stateMachine:changeState(HangingOnProgressState.new())

	elseif self.previousState == "WallClimbState" and name == "JumpState" then --吸强反向起跳
		
		--item.stateMachine:changeState(HangingNormalState.new())
		item.stateMachine:changeState(HangingLeaveState.new())

	elseif self.previousState == "WallClimbState" and name == "DropState" then --下落至吸强底部
		item.stateMachine:changeState(HangingVoidState.new())
	else
		
    end

    self.previousState = name

end

--[[ item:item 为lua对象 ]]
function HangingCheckState:Exit(item)
	-- body
end