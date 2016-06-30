--[[
author:Desmond
技能cd时间 共享状态
]]
SkillCDState = class(BasePlayerState)

SkillCDState._name = "SkillCDState"
SkillCDState.TIME_CAP = RoleProperty.SprintCDTime
SkillCDState.time = 0


function SkillCDState:Enter(role)
    self.super.Enter(self,role)
    --print ("------------function SkillCDState:Enter(role) "..tostring(self.TIME_CAP))
end

function SkillCDState:Excute(role,dTime)
	self.time = self.time +dTime
	if self.time > self.TIME_CAP then
		role.stateMachine:removeSharedState(self)
		role:updateSkillIcon()
	else
		role:updateSkillIcon(math.floor(self.time))
	end

	
end

function SkillCDState:Exit(role)
	
end
