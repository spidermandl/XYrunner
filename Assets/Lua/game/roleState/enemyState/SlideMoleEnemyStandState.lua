--[[
author:Huqiuxiang 赵名飞
敌人爬升状态
]]
SlideMoleEnemyStandState = class (BaseEnemyState)
SlideMoleEnemyStandState._name = "SlideMoleEnemyStandState"

function SlideMoleEnemyStandState:Enter(role)
	self.super.Enter(self,role)
	self.animator:Play("stand")
end

function SlideMoleEnemyStandState:Excute(role,dTime)
end