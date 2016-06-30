--[[
author:Desmond
camera base state
]]
BaseCameraState = class(IState)
BaseCameraState.role = nil --角色
BaseCameraState.role_last_pos = nil  --角色上一帧位置

--[[ camera:camera 为lua对象 ]]
function BaseCameraState:Enter(camera)

end

--[[ 
camera:camera 为lua对象
dTime:update时间间隔
]]
function BaseCameraState:Excute(camera,dTime)
	if self.role == nil then --设置角色
		self:findPlayer()
		return
	end

	local del_x = self.role.gameObject.transform.position.x - self.role_last_pos.x
	local del_y = self.role.gameObject.transform.position.y - self.role_last_pos.y
	local del_z = self.role.gameObject.transform.position.z - self.role_last_pos.z
	--如果摄像机与玩家Y轴距离小于设定Y轴，让摄像机跟着玩家Y轴移动
    local fix_y = del_y
    if self.role.gameObject.transform.position.y + camera.defaultFixedDistance.y > camera.gameObject.transform.position.y then
    	fix_y = 0
    end
	camera.gameObject.transform:Translate(del_x,fix_y,del_z, Space.World)    
	self:dealChangeY(camera,del_y)
	self.role_last_pos = self.role.gameObject.transform.position
end

--[[ camera:camera 为lua对象 ]]
function BaseCameraState:Exit(camera)
	-- body
end

--处理y值变化
function BaseCameraState:dealChangeY( camera,del_y )
	-- body
end
--检测Y轴坐标是否超过摄像头允许范围
function BaseCameraState:isYOutOfBound(camera)
	if self.role == nil then
		self:findPlayer()
	end
    if self.isReset == true then
    	return true
    end
	if self.role ~= nil then
		local camera_y = camera.gameObject.transform.position.y
		local player_y = self.role.gameObject.transform.position.y
		local distance = camera.defaultFixedDistance.y - camera_y - player_y
		--GamePrint("--------------function CameraYResetState:isYOutOfBound(camera) "..tostring(player_y - (camera_y-camera.defaultFixedDistance.y)).." "..tostring(camera.withinYAxis))
		if player_y - (camera_y-camera.defaultFixedDistance.y) > camera.withinYAxis or
		   player_y - (camera_y-camera.defaultFixedDistance.y) < 0 then
			self.isReset = true
			self.y_speed = math.abs((player_y + camera.defaultFixedDistance.y - camera_y)/camera.yAxisMovingTime) --根据移动距离 / 移动时间 取移动速度
			return true
		end
	end
	return false
end
function BaseCameraState:findPlayer()
	self.role = LuaShell.getRole(LuaShell.DesmondID)
	--GamePrint("function BaseCameraState:findPlayer() "..tostring(self.role))
	if self.role ~= nil then
		self.role_last_pos = self.role.gameObject.transform.position
	end
end