--[[
无法跳跃状态
author:Huqiuxiang
]]
CantJumpState = class(BasePlayerState)
CantJumpState._name = "CantJumpState"
CantJumpState.frameTime = 1
CantJumpState.startTime = nil
CantJumpState.effects = nil 
CantJumpState.duringTime = 3
CantJumpState.stage = 2

function CantJumpState:Enter(role)
	self.startTime = UnityEngine.Time.time
	self.effects = newobject(Util.LoadPrefab("Effects/Common/ef_debuff_lanse")) --创建特效
    self.effects.gameObject.transform.position = role.gameObject.transform.position
    -- self.duringTime = ConfigParam.CantJumpTime
	-- print ("----------------------------------------------- function ChangeBigState:Enter------------------------")
end

function CantJumpState:Excute(role,dTime)
    self.effects.gameObject.transform.position = role.gameObject.transform.position
    if self.stage == 0 then  
        role.stateMachine:removeSharedState(self)
	elseif self.stage == 1 then 

	elseif self.stage == 2 then 
        self:duringTimeStage(role,dTime)
    end
end

function CantJumpState:Exit(role)
	if self.effects ~= nil then
		GameObject.Destroy(self.effects)
	end
end

-- 时间限定阶段
function CantJumpState:duringTimeStage(role,dTime)
	if UnityEngine.Time.time - self.startTime > self.duringTime then
		role.stateMachine:removeSharedState(self)
		return
	end
end