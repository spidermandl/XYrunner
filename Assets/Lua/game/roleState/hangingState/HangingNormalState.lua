--[[
author:Desmond
默认状态
]]
HangingNormalState = class (IState)
HangingNormalState._name = "HangingNormalState"

--[[ item:item 为lua对象 ]]
function HangingNormalState:Enter(item)
	GamePrint("---------------function HangingNormalState:Enter(item) ")
	item.player.stateMachine:removeSharedState(HangingBlockState.new())
    item.collider.isTrigger = false
end

--[[ 
item:item 为lua对象
dTime:update时间间隔
]]
function HangingNormalState:Excute(item,dTime)

end

--[[ item:item 为lua对象 ]]
function HangingNormalState:Exit(item)
	-- body
end

