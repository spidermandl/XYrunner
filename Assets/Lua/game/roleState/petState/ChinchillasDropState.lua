--[[
龙猫下落状态
作者：秦仕超 赵名飞
]]
ChinchillasDropState = class (BasePetState) 

ChinchillasDropState._name = "ChinchillasDropState"
ChinchillasDropState.time = 0 --记录下落时间

function ChinchillasDropState:Enter(role)
	self.player = LuaShell.getRole(LuaShell.DesmondID)
    self.animator = role.character:GetComponent("Animator")
    self.animator:Play("idle")
end

function ChinchillasDropState:Excute(role,dTime)
	self.time = self.time + dTime
	role.gameObject.transform:Translate(Vector3.down * dTime * RoleProperty.ChinchillasDropSpeed)
	if self.time >= 5 then --持续5秒 （没有碰到地一直下落情况）
		role.stateMachine:changeState(ChinchillasDownState.new())
	end
end

function ChinchillasDropState:Exit(role)
	self.super.Exit(self,role)
end




