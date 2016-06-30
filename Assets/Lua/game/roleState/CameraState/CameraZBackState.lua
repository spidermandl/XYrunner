--[[
author:赵名飞
z轴拉远状态
]]
CameraZBackState= class(BaseCameraState)

CameraZBackState._name = "CameraZBackState"
CameraZBackState.role = nil --player
CameraZBackState.moveSpeed = nil --移动速度
CameraZBackState.zAxisFixedPoint = nil --相机拉远距离
CameraZBackState.zAxisMoveingTime = nil --相机拉远时间
CameraZBackState.role_last_pos = nil --角色上帧位置
function CameraZBackState:Enter(camera)

	self.zAxisFixedPoint = camera.gameObject.transform.position + self.zAxisFixedPoint
	self.moveSpeed = self:GetSpeed(camera)
	--GamePrint("					CameraZBackState:Enter		")
end

--[[ role:camera 为lua对象 ]]
function CameraZBackState:Excute(camera,dTime)
	if self.role == nil then --设置角色
		self:findPlayer()
		return
	end

	local del_x = self.role.gameObject.transform.position.x - self.role_last_pos.x
	local del_y = self.role.gameObject.transform.position.y - self.role_last_pos.y
	local del_z = self.role.gameObject.transform.position.z - self.role_last_pos.z
	camera.gameObject.transform:Translate(del_x,0,0, Space.World)    
	self:dealChangeY(camera,del_y)
	self.role_last_pos = self.role.gameObject.transform.position
end
--修复误差
function CameraZBackState:dealChangeY( camera )
	local disY = self.zAxisFixedPoint.y - camera.gameObject.transform.position.y
    local disX = self.zAxisFixedPoint.x - camera.gameObject.transform.position.x
    local disZ = self.zAxisFixedPoint.z - camera.gameObject.transform.position.z
 	if math.abs(disZ) > 0.1 or math.abs(disY) > 0.1 then --没有移动到目标点,开始移动
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
		--camera.stateMachine:changeState(CameraNormalState.new())
	end

end
--获取移动速度
function CameraZBackState:GetSpeed(camera)
	local speed = Vector3(0,0,0)
	speed.x = math.abs((self.zAxisFixedPoint.x - camera.gameObject.transform.position.x)/self.zAxisMoveingTime) --根据移动距离 / 移动时间 取移动速度
	speed.y = math.abs((self.zAxisFixedPoint.y - camera.gameObject.transform.position.y)/self.zAxisMoveingTime) --根据移动距离 / 移动时间 取移动速度
	speed.z = math.abs((self.zAxisFixedPoint.z - camera.gameObject.transform.position.z)/self.zAxisMoveingTime) --根据移动距离 / 移动时间 取移动速度
	return speed
end