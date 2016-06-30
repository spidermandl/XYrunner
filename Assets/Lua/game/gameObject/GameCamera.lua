--[[
  author:Desmond
  游戏摄像机
]]

GameCamera = class(BaseBehaviour)
GameCamera.role = nil --角色

GameCamera.defaultFixedDistance = nil --relative distance against player
	
GameCamera.withinYAxis = nil  --camera following is y axis is over the very number
GameCamera.yAxisMovingTime = nil  --camera following time
	
GameCamera.zAxisCrossStage1 = nil --distance of z axis crossing stage one
GameCamera.zAxisCrossStage2 = nil --distance of z axis crossing stage two
GameCamera.zAxis16TailingTime = nil --camera's tailing time triggered by z-axis forward distance over first stage  
GameCamera.zAxis16BreakingSpeed = nil --camera's breaking down speed triggered by z-axis forward distance over first stage  
GameCamera.zAxis16CatchingUpTime = nil --camera's catch up time triggered by z-axis forward distance over first stage  

GameCamera.zAxis32TailingTime = nil --camera's tailing time triggered by z-axis forward distance over first stage  
GameCamera.zAxis32BreakingSpeed = nil --camera's breaking down speed triggered by z-axis forward distance over first stage  
GameCamera.zAxis32CatchingUpTime = nil --camera's catch up time triggered by z-axis forward distance over first stage 
	
GameCamera.zAxis_16TailingTime = nil --camera's tailing time triggered by z-axis backward distance over first stage
GameCamera.zAxis_16BreakingSpeed = nil --camera's breaking down speed triggered by z-axis backward distance over first stage 
GameCamera.zAxis_16CatchingUpTime = nil --camera's catch up time triggered by z-axis backward distance over first stage
	
GameCamera.zAxis_32TailingTime = nil --camera's tailing time triggered by z-axis backward distance over first stage
GameCamera.zAxis_32BreakingSpeed = nil --camera's breaking down speed triggered by z-axis backward distance over first stage 
GameCamera.zAxis_32CatchingUpTime = nil --camera's catch up time triggered by z-axis backward distance over first stage

GameCamera.zAxisFixedPoint = nil -- 摄像机Z轴拉远点
GameCamera.zAxisMoveingTime = nil -- 摄像机Z轴拉远恢复时间

function GameCamera:Awake()
	--print("-----------------GameCamera Awake--->>>-----------------")
    local path = Util.DataPath..AppConst.luaRootPath.."game/export/camera.json"
    local json = require "cjson"
    local util = require "3rd/cjson.util"
    local obj = json.decode(util.file_load(path))
    --GamePrint("---------------------function GameCamera:Awake() ------>>> ")
    local array = lua_string_split(obj.defaultFixedDistance,",")
    self.defaultFixedDistance = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3]))
    self.withinYAxis = tonumber(obj.withinYAxis)  
	self.yAxisMovingTime = tonumber(obj.yAxisMovingTime)    
		
	self.zAxisCrossStage1 = tonumber(obj.zAxisCrossStage1)   
	self.zAxisCrossStage2 = tonumber(obj.zAxisCrossStage2)   
	self.zAxis16TailingTime = tonumber(obj.zAxis16TailingTime)   
	array = lua_string_split(obj.zAxis16BreakingSpeed,",")
	self.zAxis16BreakingSpeed = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3]))  
	self.zAxis16CatchingUpTime = tonumber(obj.zAxis16CatchingUpTime)   

	self.zAxis32TailingTime = tonumber(obj.zAxis32TailingTime)   
	array = lua_string_split(obj.zAxis32BreakingSpeed,",")
	self.zAxis32BreakingSpeed = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) 
	self.zAxis32CatchingUpTime = tonumber(obj.zAxis32CatchingUpTime)   
		
	self.zAxis_16TailingTime = tonumber(obj.zAxis_16TailingTime)   
	array = lua_string_split(obj.zAxis_16BreakingSpeed,",")
	self.zAxis_16BreakingSpeed = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) 
	self.zAxis_16CatchingUpTime = tonumber(obj.zAxis_16CatchingUpTime)   
		
	self.zAxis_32TailingTime = tonumber(obj.zAxis_32TailingTime)   
	array = lua_string_split(obj.zAxis_32BreakingSpeed,",")
	self.zAxis_32BreakingSpeed = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) 
	self.zAxis_32CatchingUpTime = tonumber(obj.zAxis_32CatchingUpTime)   

	self.zAxisFixedPoint = tonumber(obj.zAxisFixedPoint)
	self.zAxisMoveingTime = tonumber(obj.zAxisMoveingTime)
    
    self.stateMachine = CameraStateMachine.new()
    self.stateMachine.role = self
    
    --self:changeState(CameraAutoFixState.new())
    self.stateMachine:addSharedState(CameraCheckState.new())
    self.stateMachine:changeState(CameraFixState.new())
    --self:changeState(CameraYResetState.new())
end


function GameCamera:LateUpdate()
	if self.role == nil then --设置角色
		self.role = LuaShell.getRole(LuaShell.DesmondID)

		if self.role ~= nil then
			self.gameObject.transform.position = 
				UnityEngine.Vector3(self.role.gameObject.transform.position.x + self.defaultFixedDistance.x,
					self.defaultFixedDistance.y,self.role.gameObject.transform.position.z + self.defaultFixedDistance.z)
		end
		return
	end

	self.stateMachine:runState(UnityEngine.Time.deltaTime)
end
--根据targetZ获取camera参数
function GameCamera:GetParamByTargetZ(targetZ )
	targetZ = GetRounding(targetZ)
	if targetZ == 16 then
		return self.zAxis16TailingTime,self.zAxis16BreakingSpeed,self.zAxis16CatchingUpTime
	elseif targetZ == 32 then
		return self.zAxis32TailingTime,self.zAxis32BreakingSpeed,self.zAxis32CatchingUpTime
	elseif targetZ == -16 then
		return self.zAxis_16TailingTime,self.zAxis_16BreakingSpeed,self.zAxis_16CatchingUpTime
	elseif targetZ == -32 then
		return self.zAxis_32TailingTime,self.zAxis_32BreakingSpeed,self.zAxis_32CatchingUpTime
	end
end
-- --改变状态
-- function GameCamera:changeState(state)
-- 	GamePrint("------------function GameCamera:changeState(state) "..tostring(state._name))

-- 	if self.stateMachine:getState() ~= nil and self.stateMachine:getState()._name == state._name then --同名不切换
-- 		return
-- 	end
    
--     if self.stateMachine:getState() ~= nil and 
--        self.stateMachine:getState()._name == "CameraYFixState" and
--        state._name == "CameraAutoFixState" then --CameraYFixState 状态不能切换到CameraAutoFixState

--     	return
--     end
-- 	--print ("---------function GameCamera:changeState(state) "..tostring(state._name))
-- 	return self.stateMachine:changeState(state)
-- end



