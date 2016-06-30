--[[
author:Huqiuxiang 赵名飞
潜行鼠攻击状态
]]
SlideMoleEnemyAtkState = class (BaseEnemyState)
SlideMoleEnemyAtkState._name = "SlideMoleEnemyAtkState"
SlideMoleEnemyAtkState.player = nil -- 主角

function SlideMoleEnemyAtkState:Enter(role)
	self.super.Enter(self,role)
	self.super.AtkStateEnter(self,role)
end

function SlideMoleEnemyAtkState:Excute(role,dTime)
	--攻击完成后，进入站立待机状态
	self.super.AtkStateExcute(self,role,dTime,SlideMoleEnemyStandState.new())
end