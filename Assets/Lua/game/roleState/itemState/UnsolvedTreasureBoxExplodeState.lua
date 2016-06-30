
--[[
author:Huqiuxiang
UnsolvedTreasureBoxExplodeState
问号宝箱爆破状态 
]]

UnsolvedTreasureBoxExplodeState = class (IState)

UnsolvedTreasureBoxExplodeState._name = "UnsolvedTreasureBoxExplodeState"
UnsolvedTreasureBoxExplodeState.animator = nil
UnsolvedTreasureBoxExplodeState.roleState = nil
UnsolvedTreasureBoxExplodeState.stateMachine = nil
UnsolvedTreasureBoxExplodeState.effect = nil 

function UnsolvedTreasureBoxExplodeState:Enter(role)
    self.animator = role.item:GetComponent("Animator")
    self.animator:Play("explode")

    local player = LuaShell.getRole(LuaShell.DesmondID)
    role:explode() --创建金币效果
    -- player.stamina = player.stamina + ConfigParam.UnsolvedTreasureReHP  --回复血量
    player.stateMachine:addSharedState(CureState.new())
    --加入各种随机状态
    local nub = math.random(1,4)
    local state = self:ChangeState(nub)
    player.stateMachine:addSharedState(self.roleState)

end

function UnsolvedTreasureBoxExplodeState:Excute(role,dTime)
	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	if animInfo.normalizedTime >= 1.0 then --动画结束
        local child = role.gameObject.transform:GetChild(0)
        child.gameObject:SetActive(false)
	end
	
end

function UnsolvedTreasureBoxExplodeState:Exit(role,dTime)
    if self.effect ~= nil then
        GameObject.Destroy(self.effect)
    end
end

function UnsolvedTreasureBoxExplodeState:ChangeState(nub)
    if nub == 1 then
      local CantJumpbuff = CantJumpState.new()
      CantJumpbuff.duringTime = ConfigParam.CantJumpTime
      self.roleState = CantJumpbuff
    elseif nub == 2 then
      local CantSkillbuff = CantSkillState.new()
      CantSkillbuff.duringTime = ConfigParam.CantSkillTime
      self.roleState = CantSkillbuff
    elseif nub == 3 then 
      local Confusionbuff = ConfusionState.new()
      Confusionbuff.duringTime = ConfigParam.ConfusionTime
      self.roleState = Confusionbuff
    elseif nub == 4 then
      local CantAttackbuff = CantAttackState.new()
      CantAttackbuff.duringTime = ConfigParam.CantAttackTime
      self.roleState = CantAttackbuff
    end
    return self.roleState
    -- ChangeBigState  UnstopableState StealthState  MagnetState
end