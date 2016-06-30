--[[
author:赵名飞
z轴落地修复状态
]]
CameraZDropState= class(BaseCameraState)

CameraZDropState._name = "CameraZDropState"
CameraZDropState.zAxisCatchingUpTime = nil --修复时间
CameraZDropState.role = nil --player
CameraZDropState.moveSpeed = nil --移动速度

function CameraZDropState:Enter(camera)
	if self.role == nil then
		self:findPlayer()
	end
	self.moveSpeed = self:GetSpeed(camera)
end

--[[ role:camera 为lua对象 ]]
function CameraZDropState:Excute(camera,dTime)
    --self.super.Excute(self,camera,dTime)
    self:dealChangeY(camera)
end
--修复误差
function CameraZDropState:dealChangeY( camera )
    local disY = self.role.gameObject.transform.position.y + camera.defaultFixedDistance.y - camera.gameObject.transform.position.y
    local disX = self.role.gameObject.transform.position.x + camera.defaultFixedDistance.x - camera.gameObject.transform.position.x
    local disZ = self.role.gameObject.transform.position.z + camera.defaultFixedDistance.z - camera.gameObject.transform.position.z
 	if math.abs(disZ) > 0.1 then--or math.abs(disX) > 0.1 then --摄像机z方向没有移动到目标点,开始移动
 		local moveDisX = UnityEngine.Time.deltaTime * self.moveSpeed.x
		if math.abs(disX) > moveDisX then --矫正x lost frame gap 数值
			disX = disX/math.abs(disX) * moveDisX
		end
		camera.gameObject.transform:Translate(disX,0,0)

		local moveDisY = UnityEngine.Time.deltaTime * self.moveSpeed.y
		if math.abs(disY) > moveDisY then --矫正y lost frame gap 数值
			disY = disY/math.abs(disY) * moveDisY
		end
		camera.gameObject.transform:Translate(0,disY,0)

		local moveDisZ = UnityEngine.Time.deltaTime * self.moveSpeed.z
		if math.abs(disZ) > math.abs(moveDisZ) then --矫正gap数值
			disZ = disZ/math.abs(disZ)*moveDisZ
		end
		camera.gameObject.transform:Translate(0,0,disZ)
	else
		camera.stateMachine:changeState(CameraNormalState.new())
	end

end

--[[ role:camera 为lua对象 ]]
function CameraZDropState:Exit(camera)
	-- body
end
--获取移动速度
function CameraZDropState:GetSpeed(camera)
	local speed = Vector3(0,0,0)
	if self.role ~= nil then
		local camera_x = camera.gameObject.transform.position.x
		local player_x = self.role.gameObject.transform.position.x
		speed.x = math.abs((camera_x + camera.defaultFixedDistance.x - player_x)/self.zAxisCatchingUpTime) --根据移动距离 / 移动时间 取移动速度
		local camera_y = camera.gameObject.transform.position.y
		local player_y = self.role.gameObject.transform.position.y
		speed.y = math.abs((player_y + camera.defaultFixedDistance.y - camera_y)/self.zAxisCatchingUpTime)
		local camera_z = camera.gameObject.transform.position.z
		local player_z = self.role.gameObject.transform.position.z
		speed.z = math.abs((player_z + camera.defaultFixedDistance.z - camera_z)/self.zAxisCatchingUpTime)
	end
	return speed
end