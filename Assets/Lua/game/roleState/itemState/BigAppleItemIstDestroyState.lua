--[[
author:huqiuxiang
大苹果未破坏状态 BigAppleItemIstDestroyState
]]
BigAppleItemIstDestroyState = class (IState)

BigAppleItemIstDestroyState._name = "BigAppleItemIstDestroyState"
BigAppleItemIstDestroyState.animator = nil
BigAppleItemIstDestroyState.randomItem = 5 --爆出吸收物件数量
BigAppleItemIstDestroyState.effect = nil 

function BigAppleItemIstDestroyState:Enter(role)
    role.player.stateMachine:addSharedState(BlockState.new())
end

function BigAppleItemIstDestroyState:Excute(role,dTime)

    if role.player.stateMachine:getState()._name == "SprintState"  or role.player.stateMachine.sharedStates["ChangeBigState"] ~= nil then
    	 --print("BigAppleItemIstDestroyState:Excute111111111111")
         role.stateMachine:changeState(BigAppleItemIsDestroyState.new())
         --print("BigAppleItemIstDestroyState:Excute2222222222")
    end
end

function BigAppleItemIstDestroyState:Exit(role,dTime)
    if self.effect ~= nil then
        GameObject.Destroy(self.effect)
    end
end