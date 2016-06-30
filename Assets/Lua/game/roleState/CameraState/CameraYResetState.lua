--[[
author:Desmond
y轴恢复到初始位置
]]
CameraYResetState = class(BaseCameraState)
CameraYResetState._name = "CameraYResetState"

CameraYResetState.isReset = nil
CameraYResetState.y_speed = nil --Y轴移动速度

function CameraYResetState:Enter(camera)
	--GamePrint("------------function CameraYResetState:Enter(camera) ")
	self.isReset = false
	if self:isYOutOfBound(camera) ~= true then
		camera.stateMachine:changeState(CameraNormalState.new())
		return
	end
end

--[[ role:camera 为lua对象 ]]
function CameraYResetState:Excute(camera,dTime)
	if self:isYOutOfBound(camera) ~= true then
		camera.stateMachine:changeState(CameraNormalState.new())
		return
	end

	self.super.Excute(self,camera,dTime)
	
	--camera.gameObject.transform:Translate(0,y_speed,0)

end

--[[ role:camera 为lua对象 ]]
function CameraYResetState:Exit(camera)

end

--处理y值变化
function CameraYResetState:dealChangeY( camera,del_y )
    -- GamePrint("player_y:"..tostring(self.role.gameObject.transform.position.y)..
    -- 	      " dis_y:"..tostring(camera.defaultFixedDistance.y)..
    -- 	      " camera_y:"..tostring(camera.gameObject.transform.position.y))
    local disY = self.role.gameObject.transform.position.y + camera.defaultFixedDistance.y - camera.gameObject.transform.position.y
    local disX = self.role.gameObject.transform.position.x + camera.defaultFixedDistance.x - camera.gameObject.transform.position.x
    local disZ = self.role.gameObject.transform.position.z + camera.defaultFixedDistance.z - camera.gameObject.transform.position.z
    --GamePrint("function CameraYResetState:dealChangeY( camera,del_y ) "..tostring(disY))
 	if math.abs(disY) > 0.1 then --or math.abs(disX) > 0.01 then --摄像机y方向没有移动到目标点,开始移动
		--print("------------function CameraAutoFixState:dealChangeY( del_y ) 2")
		--camera y轴距离矫正
		local moveDis = UnityEngine.Time.deltaTime * self.y_speed
		if math.abs(disY) > math.abs(moveDis) then --矫正gap数值
			disY = disY/math.abs(disY)*moveDis
		end
		camera.gameObject.transform:Translate(0,disY,0)

		if math.abs(disX) > moveDis then --矫正x lost frame gap 数值
			disX = disX/math.abs(disX) * moveDis
		end
		camera.gameObject.transform:Translate(disX,0,0)

		if math.abs(disZ) > moveDis then --矫正x lost frame gap 数值
			disZ = disZ/math.abs(disZ) * moveDis
		end
		camera.gameObject.transform:Translate(0,0,disZ)

	else
		--print("------------function CameraAutoFixState:dealChangeY( del_y ) 3")
		camera.stateMachine:changeState(CameraNormalState.new())
	end

end




