--[[
author:Huqiuxiang 赵名飞
醉酒鼠待机状态
]]
DrunkRatEnemyIdleState = class(BaseEnemyState)
DrunkRatEnemyIdleState._name = "DrunkRatEnemyIdleState"
DrunkRatEnemyIdleState.time = 0

function DrunkRatEnemyIdleState:Enter(role)
	self.super.Enter(self,role)
	local animator = role.character:GetComponent("Animator")
	animator:Play("idle")
    --self.super.IdlStateEnter(self,role)
end

function DrunkRatEnemyIdleState:Excute(role,dTime)
	if role.distance < ConfigParam.DrunkRatAttackDistance and role.distance ~= 0 then
		--error("20   ole.distance   :"..role.distance)
		self.time = self.time + dTime
		if self.time >= ConfigParam.DrunkRatAttackInterval then
			--GamePrint("self.time >= ConfigParam.DrunkRatAttackInterval   :"..self.time)
   			role.stateMachine:changeState(DrunkRatEnemyAtkState.new())
   		end
	end
end