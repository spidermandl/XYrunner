--[[
author:huqiuxiang
墙被未破坏状态
]]
CrackWallIstDestroyState = class (IState)

CrackWallIstDestroyState._name = "CrackWallIstDestroyState"
CrackWallIstDestroyState.animator = nil
CrackWallIstDestroyState.randomItem = 5 --爆出吸收物件数量
CrackWallIstDestroyState.effect = nil 

function CrackWallIstDestroyState:Enter(role)
    role.player.stateMachine:addSharedState(BlockState.new())
end

function CrackWallIstDestroyState:Excute(role,dTime)

    if role.player.stateMachine:getState()._name == "SprintState"  or role.player.stateMachine.sharedStates["ChangeBigState"] ~= nil then
         role.stateMachine:changeState(CrackWallIsDestroyState.new())
    end
end

function CrackWallIstDestroyState:Exit(role,dTime)
    if self.effect ~= nil then
        GameObject.Destroy(self.effect)
    end
end