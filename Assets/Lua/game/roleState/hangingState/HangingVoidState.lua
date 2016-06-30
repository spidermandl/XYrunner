--[[
author:Desmond
下落离开弹墙状态
]]
HangingVoidState = class (IState)
HangingVoidState._name = "HangingVoidState"

--[[ item:item 为lua对象 ]]
function HangingVoidState:Enter(item)
	GamePrint("---------------function HangingVoidState:Enter(item) ")
	item.player.stateMachine:removeSharedState(HangingBlockState.new())
    item.collider.isTrigger = true
end

--[[ 
item:item 为lua对象
dTime:update时间间隔
]]
function HangingVoidState:Excute(item,dTime)

end

--[[ item:item 为lua对象 ]]
function HangingVoidState:Exit(item)
	-- body
end