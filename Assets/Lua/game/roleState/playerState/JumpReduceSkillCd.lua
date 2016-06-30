--[[
跳跃减少技能CD状态
author:赵名飞
]]
JumpReduceSkillCd = class (BasePlayerState)
JumpReduceSkillCd._name = "JumpReduceSkillCd"
JumpReduceSkillCd.reduceValue = nil --技能cd时间
JumpReduceSkillCd.battleScene = nil
function JumpReduceSkillCd:Enter(role)
	self.battleScene = GetCurrentSceneUI()
end
function JumpReduceSkillCd:ReduceSkillCd(role)
	local value = 1/(self.reduceValue and self.reduceValue or 1)
	self.battleScene.uiCtrl:ReduceSkillCd(value) 	--记录CD时间
	if self.battleScene.uiCtrl.skillCDOver == false then
		role.stateMachine:removeSharedState(self)
	end
end
function JumpReduceSkillCd:Excute(role,dTime)
end

function JumpReduceSkillCd:Exit(role)
end