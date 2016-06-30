--[[
author:Desmond
角色跳跃进顶端状态
]]
JumpTopState = class (BasePlayerState)

JumpTopState.isDroping =false --是否下降
JumpTopState._name = "JumpTopState"

function JumpTopState:Enter(role)
	--print ("--------------------------------function JumpTopState:Enter(role)------>>>>> ")
	self.super.Enter(self,role)
	--self.animator:Play("single jump top")
	self.super.playAnimation(self,role,"single jump top")
end

function JumpTopState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
    -------------------一小段下降，落地检测---------------------------------
    local flag =false
	if role.property.moveDir.y < 0 then
		self.isDroping = true 
		flag = self.super.isLanding(self,role,dTime)
	end

	if flag == true then --落地
		role.stateMachine:changeState(DropState.new())
		return
	end
	------------------------------------------------------------------------
	local dHeight = (role.property.moveDir.y - role.property.jumpACC * dTime ) * dTime
	local acc = role.property.jumpACC
	if role.property.moveDir.y < 0 then
		acc = role.property.dropACC
	end
	role.property.moveDir.y = role.property.moveDir.y - acc * dTime
	role.gameObject.transform:Translate(role.property.moveDir.x*dTime,dHeight, 0, Space.World)

	-- local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
 --    print ("--------------------------------function JumpTopState:Excute(role,dTime)>>>>> "..tostring(animInfo.normalizedTime))
	-- if animInfo.normalizedTime >= 1.0 then --动画结束
	-- 	role.stateMachine:changeState(DropState.new())
	-- end

end


