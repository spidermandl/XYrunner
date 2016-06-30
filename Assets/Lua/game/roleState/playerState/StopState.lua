--[[
无状态 新手指导用
author:Desmond
]]
StopState = class(BasePlayerState)

StopState._name = "StopState"


function StopState:Enter(role)
    self.super.Enter(self,role)

    --self.animator:Play("idle")
    -- self.super.playAnimation(self,role,"idle")
    -- print("StopState:Enter")
   -- role.property.moveDir.x=0
   -- role.property.moveDir.y=0
   -- role.property.moveDir.z=0
   	  role.isBlocked = true
end

function StopState:Excute(role,dTime)
	 -- print("StopState:Excute")
end

function StopState:Exit(role)
     role.isBlocked = false
end