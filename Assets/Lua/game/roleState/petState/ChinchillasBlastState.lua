--[[
author:Desmond
龙猫冲击波状态
]]
ChinchillasBlastState = class (BasePetState) 

ChinchillasBlastState._name = "ChinchillasBlastState"

function ChinchillasBlastState:Enter(role)
	self.super.Enter(self,role)
end

function ChinchillasBlastState:Excute(role,dTime)
	if role.collider.radius >= RoleProperty.ChinchillasBlastBoundary then --大于冲击波最大半径
		return
	end
	role.collider.radius = RoleProperty.ChinchillasBlastSpeed * dTime + role.collider.radius
end

function ChinchillasBlastState:Exit(role)
	self.super.Exit(self,role)
end
