--[[
author:huqiuxiang
混乱能道具状态
]]
ConfusionItemState = class (IState)
ConfusionItemState._name = "ConfusionItemState"
ConfusionItemState.effect = nil -- 特效
ConfusionItemState.player = nil -- 主角

function ConfusionItemState:Enter(role)
    self.player = LuaShell.getRole(LuaShell.DesmondID)

    local buff = ConfusionState.new()
    buff.duringTime = ConfigParam.ConfusionTime
    self.player.stateMachine:addSharedState(buff) 

    local child = role.gameObject.transform:GetChild(0)
    child.gameObject:SetActive(false)

end

function ConfusionItemState:Excute(role,dTime)
end

function ConfusionItemState:Exit(role,dTime)
    if self.effect ~= nil then
        GameObject.Destroy(self.effect)
    end
end

