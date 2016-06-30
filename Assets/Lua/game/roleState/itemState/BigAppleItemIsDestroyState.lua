--[[
author:huqiuxiang
大苹果破坏状态 BigAppleItemIsDestroyState
]]

BigAppleItemIsDestroyState = class (IState)

BigAppleItemIsDestroyState._name = "BigAppleItemIsDestroyState"
BigAppleItemIsDestroyState.animator = nil
BigAppleItemIsDestroyState.randomItem = 5 --爆出吸收物件数量
BigAppleItemIsDestroyState.effect = nil 

function BigAppleItemIsDestroyState:Enter(role)
    role.player.stateMachine:removeSharedState(BlockState.new())
    self.effect = newobject(Util.LoadPrefab("Effects/Common/ef_monster_guike")) --创建特效
    self.effect.gameObject.transform.position = role.gameObject.transform.position
    createFollowItems(role.player,self.randomItem) --创建箱子弹出金币
    -- 播放倒塌动画
    local child = role.gameObject.transform:GetChild(0)
    child.gameObject:SetActive(false)
end

function BigAppleItemIsDestroyState:Excute(role,dTime)
end

function BigAppleItemIsDestroyState:Exit(role,dTime)
    if self.effect ~= nil then
        GameObject.Destroy(self.effect)
    end
end