--[[
author:huqiuxiang
不能攻击道具状态
]]
CantAttackItemState = class (IState)
CantAttackItemState._name = "CantAttackItemState"
CantAttackItemState.effect = nil -- 特效
CantAttackItemState.player = nil -- 主角

function CantAttackItemState:Enter(role)
    self.player = LuaShell.getRole(LuaShell.DesmondID) 
    
    local buff = CantAttackState.new()
    buff.duringTime = ConfigParam.CantAttackTime
    self.player.stateMachine:addSharedState(buff) 

    local child = role.gameObject.transform:GetChild(0)
    child.gameObject:SetActive(false)

end

function CantAttackItemState:Excute(role,dTime)
end

function CantAttackItemState:Exit(role,dTime)
    if self.effect ~= nil then
		GameObject.Destroy(self.effect)
	end
end