PetIdleState = class(IState)

PetIdleState._name = "PetIdleState"
PetIdleState.animator = nil

function PetIdleState:Enter(role)
    self.animator = role.character:GetComponent("Animator")
    self.animator:Play("idle")
    --[[
    local dead = LuaShell.getRole(LuaShell.DesmondID)
    if dead.stateMachine:getState()._name == "DeadState" then
    	print("救起主角")
    	role.stateMachine:changeState(PetRescueState.new())
    end
    ]]
end

function PetIdleState:Excute(role,dTime)
--print ("-------------------------------->>>>  function PetIdleState:Excute(role,dTime)")
end