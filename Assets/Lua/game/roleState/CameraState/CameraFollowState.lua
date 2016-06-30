--[[
author:赵名飞
摄像机在指定时间移动到指定偏移量后 三轴跟随玩家
]]
CameraFollowState= class(BaseCameraState)

CameraFollowState._name = "CameraFollowState"
CameraFollowState.role = nil --player
CameraFollowState.moveSpeed = nil --移动速度
CameraFollowState.zAxisFixedPoint = nil --相机与角色的偏差
CameraFollowState.zAxisMoveingTime = nil --相机移动时间
CameraFollowState.role_last_pos = nil  --角色上一帧位置
function CameraFollowState:Enter(camera)
	if self.role == nil then
		self:findPlayer()
	end
	if self.zAxisFixedPoint == nil then --如果不设置目标位置，就恢复配置的位置
		self.zAxisFixedPoint = camera.defaultFixedDistance
	end
	if self.zAxisMoveingTime == nil then
		self.zAxisMoveingTime = 0.5
	end
	--GamePrint("					CameraZBackState:Enter		")
end

--[[ role:camera 为lua对象 ]]
function CameraFollowState:Excute(camera,dTime)
	--self.super.Excute(self,camera,dTime)
	local del_x = self.role.gameObject.transform.position.x - self.role_last_pos.x
	local del_y = self.role.gameObject.transform.position.y - self.role_last_pos.y
	local del_z = self.role.gameObject.transform.position.z - self.role_last_pos.z
	camera.gameObject.transform:Translate(del_x,del_y,del_z, Space.World)
	self:dealChangeY(camera)
	self.role_last_pos = self.role.gameObject.transform.position
end
--修复误差
function CameraFollowState:dealChangeY( camera,del_y )
	local moveSpeed = self:GetSpeed(camera)
    local disY = self.role.gameObject.transform.position.y + self.zAxisFixedPoint.y - camera.gameObject.transform.position.y
    local disX = self.role.gameObject.transform.position.x + self.zAxisFixedPoint.x - camera.gameObject.transform.position.x
    local disZ = self.role.gameObject.transform.position.z + self.zAxisFixedPoint.z - camera.gameObject.transform.position.z
    --GamePrint("function CameraYResetState:dealChangeY( camera,del_y ) "..tostring(disY))
 	if math.abs(disY) > 0.1 or math.abs(disZ) > 0.1  then --or math.abs(disX) > 0.01 then --摄像机y方向没有移动到目标点,开始移动
		--print("------------function CameraAutoFixState:dealChangeY( del_y ) 2")
		--camera y轴距离矫正
		local moveDisY = UnityEngine.Time.deltaTime * moveSpeed.y
		if math.abs(disY) > math.abs(moveDisY) then --矫正gap数值
			disY = disY/math.abs(disY)*moveDisY
		end
		camera.gameObject.transform:Translate(0,disY,0)

		local moveDisX = UnityEngine.Time.deltaTime * moveSpeed.x
		if math.abs(disX) > moveDisX then --矫正x lost frame gap 数值
			disX = disX/math.abs(disX) * moveDisX
		end
		camera.gameObject.transform:Translate(disX,0,0)

		local moveDisZ = UnityEngine.Time.deltaTime * moveSpeed.z
		if math.abs(disZ) > moveDisZ then --矫正x lost frame gap 数值
			disZ = disZ/math.abs(disZ) * moveDisZ
		end
		camera.gameObject.transform:Translate(0,0,disZ)

	else
		--print("------------function CameraAutoFixState:dealChangeY( del_y ) 3")
		--camera.stateMachine:changeState(CameraNormalState.new())
	end

end
--获取移动速度
function CameraFollowState:GetSpeed(camera)
	local speed = Vector3(0,0,0)
	speed.x = math.abs((self.role.gameObject.transform.position.x + self.zAxisFixedPoint.x -camera.gameObject.transform.position.x)/self.zAxisMoveingTime) --根据移动距离 / 移动时间 取移动速度
	speed.y = math.abs((self.role.gameObject.transform.position.y + self.zAxisFixedPoint.y -camera.gameObject.transform.position.y)/self.zAxisMoveingTime) --根据移动距离 / 移动时间 取移动速度
	speed.z = math.abs((self.role.gameObject.transform.position.z + self.zAxisFixedPoint.z -camera.gameObject.transform.position.z)/self.zAxisMoveingTime) --根据移动距离 / 移动时间 取移动速度
	return speed
end