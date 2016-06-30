--[[
author:huqiuxiang
墙被破坏状态
]]
CrackWallIsDestroyState = class (IState)

CrackWallIsDestroyState._name = "CrackWallIsDestroyState"
CrackWallIsDestroyState.animator = nil
CrackWallIsDestroyState.randomItem = 5 --爆出吸收物件数量
CrackWallIsDestroyState.effect = nil 

function CrackWallIsDestroyState:Enter(role)
	role.player.stateMachine:removeSharedState(BlockState.new())
    self.effect = newobject(Util.LoadPrefab("Effects/Common/ef_monster_guike")) --创建特效
    self.effect.gameObject.transform.position = role.gameObject.transform.position

    -- 播放倒塌动画

    local child = role.gameObject.transform:GetChild(0)
    child.gameObject:SetActive(false)
end

function CrackWallIsDestroyState:Excute(role,dTime)
end

function CrackWallIsDestroyState:Exit(role,dTime)
    if self.effect ~= nil then
        GameObject.Destroy(self.effect)
    end
end