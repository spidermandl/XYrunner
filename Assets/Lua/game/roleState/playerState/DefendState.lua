--[[
角色受击状态
author:Desmond
]]
DefendState = class(BasePlayerState)
DefendState.previousState = nil

DefendState._name = "DefendState"


function DefendState:Enter(role) 
    self.super.Enter(self,role)
    --self.animator:Play("hit")
    self.super.playAnimation(self,role,"hit")

    role:hitDefence() --计算攻击伤害
end

function DefendState:Excute(role,dTime)
    self.super.Excute(self,role,dTime)

	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	--print ("-------------------------------->>>>>>>>>> function AttackState:Excute(role,dTime) "..tostring(animInfo.normalizedTime))

	if animInfo.normalizedTime > 1.0 then --动画结束
		-- print("受击动画结束")
		local flag = self.super.isOnGround(self,role,dTime)
		if flag == true then
			role.stateMachine:changeState(RunState.new())
		else
			role.stateMachine:changeState(DropState.new())
		end
		-- self.previousState = role.stateMachine:getPreState()
		-- --print ("-------------------------------->>>>>>>>>> function AttackState:Excute(role,dTime) "..tostring(flag).." "..tostring(self.previousState._name))
		-- if flag == true then --or self.previousState._name == "DefendState"
		-- 	role.stateMachine:changeState(RunState.new())
		-- 	--print("奔跑状态")
		-- elseif self.previousState._name == "DoubleDropState" or self.previousState._name == "DoubleJumpState" then
		-- 	role.stateMachine:changeState(DoubleDropState.new())
		-- 	--print("二连跳状态")
		-- else
		-- 	role.stateMachine:changeState(DropState.new())
		-- 	--print("下落状态")
		-- end
	end

end