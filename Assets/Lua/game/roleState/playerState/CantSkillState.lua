--[[
无法发技能状态
author:Huqiuxiang
]]
CantSkillState = class(BasePlayerState)
CantSkillState._name = "CantSkillState"
CantSkillState.frameTime = 1
CantSkillState.startTime = nil
CantSkillState.effects = nil 
CantSkillState.duringTime = 3 

function CantSkillState:Enter(role)
	self.startTime = UnityEngine.Time.time
	self.effects = newobject(Util.LoadPrefab("Effects/Common/ef_debuff_zise")) --创建特效
    self.effects.gameObject.transform.position = role.gameObject.transform.position
    -- self.duringTime = ConfigParam.CantSkillTime
	-- print ("----------------------------------------------- function ChangeBigState:Enter------------------------")
end

function CantSkillState:Excute(role,dTime)
	if UnityEngine.Time.time - self.startTime > self.duringTime then
		role.stateMachine:removeSharedState(self)
		return
	end
    self.effects.gameObject.transform.position = role.gameObject.transform.position
	self.frameTime = self.frameTime + 1
end

function CantSkillState:Exit(role)
	if self.effects ~= nil then
		GameObject.Destroy(self.effects)
	end
end
