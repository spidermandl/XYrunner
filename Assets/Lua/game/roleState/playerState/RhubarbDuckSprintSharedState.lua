--[[
	author: 赵名飞
	在大黄鸭上冲刺公共状态
]]
RhubarbDuckSprintSharedState = class (BasePlayerState)
RhubarbDuckSprintSharedState._name = "RhubarbDuckSprintSharedState"

function RhubarbDuckSprintSharedState:Enter(role)
	self.super.Enter(self,role)
end

function RhubarbDuckSprintSharedState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
end

function RhubarbDuckSprintSharedState:Exit(role)

end