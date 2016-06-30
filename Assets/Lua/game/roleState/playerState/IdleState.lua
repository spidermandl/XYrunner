--[[
闲置状态
author:Desmond
]]
IdleState = class(BasePlayerState)

IdleState._name = "IdleState"


function IdleState:Enter(role)
    self.super.Enter(self,role)

    self.super.playAnimation(self,role,"idle")
    
    role.property.moveDir.x=0
    role.property.moveDir.y=0
    role.property.moveDir.z=0
end

function IdleState:Excute(role,dTime)

end

function IdleState:Exit(role)

end