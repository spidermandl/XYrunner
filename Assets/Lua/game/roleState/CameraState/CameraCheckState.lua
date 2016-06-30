--[[
author:Desmond
检测摄像机的状态，并切换
]]
CameraCheckState = class(BaseCameraState)

CameraCheckState._name = "CameraCheckState"
CameraCheckState.role = nil --player
CameraCheckState.previousState = nil --player 上一帧state

function CameraCheckState:Enter(camera)
	GamePrint ("-------------function CameraCheckState:Enter(camera) ")
end

--[[ role:camera 为lua对象 ]]
function CameraCheckState:Excute(camera,dTime)
	if self.role == nil then --设置角色
		self:findPlayer()
		if self.role ~= nil then
			self.previousState = self.role.stateMachine:getState()._name
		end
		return
	end
	--冲过终点状态，不再切换其他状态
    if self.role.stateMachine.sharedStates["FinalSpurtState"] ~= nil 
    	or self.role.stateMachine:getState()._name == "VictoryState" 
    	or self.role.stateMachine:getState()._name == "EndlessRunningOutState" 
    	or self.role.stateMachine:getState()._name == "FailedState"
    	then
		camera.stateMachine:changeState(CameraStayState.new())
		return
	end
	--进入摄像机Z轴拉远拉近状态不再切换其他状态
	if camera.stateMachine.currentState._name == "CameraZBackState" or camera.stateMachine.currentState._name == "CameraZForwardState" then 
		return
	end
    --self.super.Excute(self,camera,dTime)

	local state = self.role.stateMachine:getState()._name
    --GamePrint("function CameraCheckState:Excute(camera,dTime) "..tostring(state)..' '..tostring(self.previousState))
	if state ~= self.previousState  then --状态切换触发的camera状态变化  
		if state == "RunState" then --落地 摄像机矫正
			if camera.stateMachine.currentState._name ~= "CameraZResetState" then
				camera.stateMachine:changeState(CameraYResetState.new())
			else
				local state = CameraZDropState.new()
				state.zAxisCatchingUpTime = camera.stateMachine.currentState.zAxisCatchingUpTime
				camera.stateMachine:changeState(state)
			end
		end
		if state == "DeadState" then
			camera.stateMachine:changeState(CameraFollowState.new())
		end
		if state == "WallClimbState" then --弹墙摄像机变化
			camera.stateMachine:changeState(CameraWallClimbState.new())
		end
		self.previousState = state
		return
	end
	if state == "BouncingState" then --弹蘑菇摄像机变化
		local targetZ = self.role.stateMachine:getState():GetTweenPathZ()
		if targetZ ~= nil and math.abs(targetZ) > 15 then --不再同一个Z轴
		 	--GamePrint("targetZ  :" ..targetZ.."self.role.gameObject.transform.position.z :"..self.role.gameObject.transform.position.z)
		   	local zReset = CameraZResetState.new()
		   	zReset.targetZ = targetZ
		   	camera.stateMachine:changeState(zReset)
		else
		   	camera.stateMachine:changeState(CameraFollowState.new())
		end
	end


	self.previousState = state
end

--[[ role:camera 为lua对象 ]]
function CameraCheckState:Exit(camera)
	-- body
end





