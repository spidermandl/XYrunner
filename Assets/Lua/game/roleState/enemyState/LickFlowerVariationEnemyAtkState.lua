--[[
author:Huqiuxiang
变异甜人花攻击状态  buff 玩家无法跳跃
]]
LickFlowerVariationEnemyAtkState = class (BaseEnemyState)
LickFlowerVariationEnemyAtkState._name = "LickFlowerVariationEnemyAtkState"
LickFlowerVariationEnemyAtkState.player = nil -- 主角

function LickFlowerVariationEnemyAtkState:Enter(role)
	self.super.Enter(self,role)
	self.super.AtkStateEnter(self,role)
    self.player = LuaShell.getRole(LuaShell.DesmondID) 

    local buff = CantJumpState.new()
    buff.duringTime = ConfigParam.CantJumpTime
    self.player.stateMachine:addSharedState(buff) -- 主角无法跳跃buff
end

function LickFlowerVariationEnemyAtkState:Excute(role,dTime)
	self.super.AtkStateExcute(self,role,dTime,LickFlowerEnemyIdleState.new())
end
