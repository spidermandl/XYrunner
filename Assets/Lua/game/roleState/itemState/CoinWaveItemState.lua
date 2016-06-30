--[[
author:huqiuxiang
金币冲击波道具状态
]]
CoinWaveItemState = class (IState)
CoinWaveItemState._name = "CoinWaveItemState"
CoinWaveItemState.effect = nil -- 特效
CoinWaveItemState.player = nil -- 主角

function CoinWaveItemState:Enter(role)
    self.player = LuaShell.getRole(LuaShell.DesmondID) 
    self.player.stateMachine:addSharedState(CoinWaveState.new()) 

    local child = role.gameObject.transform:GetChild(0)
    child.gameObject:SetActive(false)

end

function CoinWaveItemState:Excute(role,dTime)
end

function CoinWaveItemState:Exit(role,dTime)
    if self.effect ~= nil then
        GameObject.Destroy(self.effect)
    end
end
