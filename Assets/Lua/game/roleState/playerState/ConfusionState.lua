--[[
混乱状态 跳跃攻击反向
author:Huqiuxiang
]]
ConfusionState = class(BasePlayerState)
ConfusionState._name = "ConfusionState"
ConfusionState.frameTime = 1
ConfusionState.startTime = nil
ConfusionState.effects = nil 
ConfusionState.duringTime = 3 

function ConfusionState:Enter(role)
	self.startTime = UnityEngine.Time.time
	self.effects = newobject(Util.LoadPrefab("Effects/Common/ef_debuff_lvse")) --创建特效
    self.effects.gameObject.transform.position = role.gameObject.transform.position
    -- self.duringTime = ConfigParam.ConfusionTime
	-- print ("----------------------------------------------- function ChangeBigState:Enter------------------------")
end

function ConfusionState:Excute(role,dTime)
	if UnityEngine.Time.time - self.startTime > self.duringTime then
		role.stateMachine:removeSharedState(self)
		return
	end
    self.effects.gameObject.transform.position = role.gameObject.transform.position
	self.frameTime = self.frameTime + 1
end

function ConfusionState:Exit(role)
    if self.effects ~= nil then
		GameObject.Destroy(self.effects)
	end
end
