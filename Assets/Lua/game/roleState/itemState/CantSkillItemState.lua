--[[
author:huqiuxiang
不能发技能道具状态
]]
CantSkillItemState = class (IState)
CantSkillItemState._name = "CantSkillItemState"
CantSkillItemState.effect = nil -- 特效
CantSkillItemState.player = nil -- 主角

function CantSkillItemState:Enter(role)
    self.player = LuaShell.getRole(LuaShell.DesmondID) 

    local buff = CantSkillState.new()
    buff.duringTime = ConfigParam.CantSkillTime
    self.player.stateMachine:addSharedState(buff) 

    local child = role.gameObject.transform:GetChild(0)
    child.gameObject:SetActive(false)

end

function CantSkillItemState:Excute(role,dTime)
end

function CantSkillItemState:Exit(role,dTime)
    if self.effect ~= nil then
        GameObject.Destroy(self.effect)
    end
end