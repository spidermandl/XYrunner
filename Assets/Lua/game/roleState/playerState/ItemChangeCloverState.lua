--[[
道具变四叶草状态
author:赵名飞
]]
ItemChangeCloverState = class (BasePlayerState)
ItemChangeCloverState._name = "ItemChangeCloverState"
ItemChangeCloverState.ongoing_times = nil --持续时间
ItemChangeCloverState.CD_time = nil	--CD时间
ItemChangeCloverState.distance = nil --作用距离
ItemChangeCloverState.itemId = nil --变成的道具id
ItemChangeCloverState.itemManager = nil -- itemGroup
ItemChangeCloverState.startTime = nil --状态开始时间
function ItemChangeCloverState:Enter(role)
	self.itemManager = PoolFunc:pickSingleton("ItemGroup")
	self.startTime = UnityEngine.Time.time
end
function ItemChangeCloverState:Excute(role,dTime)
	if UnityEngine.Time.time - self.startTime > self.ongoing_times then
		role.stateMachine:removeSharedState(self)
		return
	end
	self.itemManager:changeItemByDistance(self.distance,self.itemId)
end

function ItemChangeCloverState:Exit(role)
	GetCurrentSceneUI().uiCtrl:SetSkillCDTime(self.CD_time) 	--记录CD时间
	role.stateMachine:removeSharedStateByName("PlayingSkillState")
end