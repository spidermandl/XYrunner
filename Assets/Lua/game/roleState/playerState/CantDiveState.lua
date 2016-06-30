--[[
无法滑翔状态
author:Huqiuxiang
]]
CantDiveState = class(BasePlayerState)
CantDiveState._name = "CantDiveState"
CantDiveState.frameTime = 1
CantDiveState.startTime = nil
CantDiveState.effects = nil 
CantDiveState.duringTime = 3
CantDiveState.stage = 2

function CantDiveState:Enter(role)
	self.startTime = UnityEngine.Time.time
    -- self.duringTime = ConfigParam.CantJumpTime
	-- print ("----------------------------------------------- function ChangeBigState:Enter------------------------")
end

function CantDiveState:Excute(role,dTime)

    if self.stage == 0 then  
        role.stateMachine:removeSharedState(self)
	elseif self.stage == 1 then 

	elseif self.stage == 2 then 
        self:duringTimeStage(role,dTime)
    end
end

function CantDiveState:Exit(role)
	if self.effects ~= nil then
		GameObject.Destroy(self.effects)
	end
end

-- 时间限定阶段
function CantDiveState:duringTimeStage(role,dTime)
	if UnityEngine.Time.time - self.startTime > self.duringTime then
		role.stateMachine:removeSharedState(self)
		return
	end
end