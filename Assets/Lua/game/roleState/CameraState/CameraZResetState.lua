--[[
author:赵名飞
z轴恢复到初始位置
]]
CameraZResetState= class(BaseCameraState)

CameraZResetState._name = "CameraZResetState"
CameraZResetState.role = nil --player
CameraZResetState.targetZ = nil -- 目标位置相对角色的Z轴
CameraZResetState.RealZ = nil -- 目标位置真实的Z轴
CameraZResetState.startTime = nil --开始时间
CameraZResetState.role_last_pos = nil --角色上一帧位置

CameraZResetState.zAxisTailingTime = nil --camera's tailing time triggered by z-axis forward distance over first stage  
CameraZResetState.zAxisBreakingSpeed = nil --camera's breaking down speed triggered by z-axis forward distance over first stage  
CameraZResetState.zAxisCatchingUpTime = nil --camera's catch up time triggered by z-axis forward distance over first stage 

function CameraZResetState:Enter(camera)
	if self.role == nil then
		self:findPlayer()
	end
	if self.role ~= nil then
		self.role_last_pos = self.role.gameObject.transform.position
	end
	
	self.startTime=UnityEngine.Time.time
	self.zAxisTailingTime,self.zAxisBreakingSpeed,self.zAxisCatchingUpTime = camera:GetParamByTargetZ(self.targetZ)
	self.RealZ = GetRounding(self.role.gameObject.transform.position.z + self.targetZ)
	
	GamePrint("-------------function CameraZResetState:Enter(camera)  self.targetZ :"..(self.targetZ))
	camera.gameObject.transform.position = self.role.gameObject.transform.position + camera.defaultFixedDistance
end

--[[ role:camera 为lua对象 ]]
function CameraZResetState:Excute(camera,dTime)
	if UnityEngine.Time.time - self.startTime < self.zAxisTailingTime then
		self:NormalMove(camera,true,Vector3(1,1,1))
    else
    	if self.targetZ > 0 then 
    		self:NormalMove(camera,true,Vector3(1,1,1) - self.zAxisBreakingSpeed)--朝里移动
    	else
    		self:NormalMove(camera,false,Vector3(1,1,1) - self.zAxisBreakingSpeed)--朝外移动
    	end
    	
    end
end
--常规跟随
function CameraZResetState:NormalMove( camera,isRole,speed)
	local del_x = self.role.gameObject.transform.position.x - self.role_last_pos.x
	local del_y = self.role.gameObject.transform.position.y - self.role_last_pos.y
	local del_z = self.role.gameObject.transform.position.z - self.role_last_pos.z
	--朝外移动，Z轴移动到位置就不再移动Z轴
	if isRole == false and camera.gameObject.transform.position.z < self.RealZ + camera.defaultFixedDistance.z then
		del_z = 0
	end 
	camera.gameObject.transform:Translate(del_x*speed.x,del_y*speed.y,del_z*speed.z, Space.World)  
	self.role_last_pos = self.role.gameObject.transform.position
end