--[[
author:Desmond
丘比跟随状态
]]
ChobeFollowState = class (BasePlayerState)

ChobeFollowState._name = "ChobeFollowState"
ChobeFollowState.reAppearTimeGap = 0 --龙猫出现时间累积
function ChobeFollowState:Enter(role)
    self.super.Enter(self,role)
    --print("======Enter ChobeThrowingThingsState======")
end

function ChobeFollowState:Excute(role,dTime)
    -- if self.reAppearTimeGap < RoleProperty.PetFlightAppearCD then
    --     self.reAppearTimeGap=self.reAppearTimeGap+dTime
    -- else
    --     self.reAppearTimeGap = 0
    --     -- local chobe=role.gameObject.transform.parent:Find("petParent")
    --     local position = role.gameObject.transform.position
    --     local chobe=createPet(role,"ChobePet")
    --     chobe.gameObject.transform.position = UnityEngine.Vector3(position.x -0.5,position.y+1.2,position.z)
    --     -- chobe.gameObject.transform.parent=role.gameObject.transform
    	
    --     -- chobe.stateMachine:changeState(ChobeThrowingThingsState.new())
    -- end
end

function ChobeFollowState:Exit(role)

end