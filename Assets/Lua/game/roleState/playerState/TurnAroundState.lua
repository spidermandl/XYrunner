--[[
author:Desmond
角色转身状态 : 共享状态
]]
TurnAroundState = class(BasePlayerState)

TurnAroundState._name="TurnAroundState"

function TurnAroundState:Enter(role)
    role.moveSpeedVect = -1 * role.moveSpeedVect
    local vec = role.gameObject.transform.localScale
    vec.x = math.abs(vec.x)/role.moveSpeedVect
    role.gameObject.transform.localScale = vec
    role.character.gameObject.transform.localPosition = UnityEngine.Vector3(0,0,0)
    role.stateMachine:removeSharedState(BlockState.new())
    role.stateMachine:removeSharedState(self)
end

function TurnAroundState:Excute(role,dTime)
end

function TurnAroundState:Exit(role)
end