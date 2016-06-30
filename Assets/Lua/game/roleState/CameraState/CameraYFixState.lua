--[[
author:Desmond
摄像机y轴固定状态
]]
CameraYFixState = class(BaseCameraState)
CameraYFixState._name = "CameraYFixState"

function CameraYFixState:Enter(camera)
	--GamePrint ("-------------function CameraYFixState:Enter(camera) ")
end

--[[ role:camera 为lua对象 ]]
function CameraYFixState:Excute(camera,dTime)
	self.super.Excute(self,camera,dTime)
end

--[[ role:camera 为lua对象 ]]
function CameraYFixState:Exit(camera)
	-- body
end

--处理y值变化
function CameraYFixState:dealChangeY(camera, del_y )
	
	local dis = self.role.gameObject.transform.position.y - camera.gameObject.transform.position.y
	
	if math.abs(dis) > ConfigParam.CameraTailingTriggerY then
		--print ("---------function CameraYFixState:dealChangeY(camera, del_y1 ) "..tostring(dis))
		camera.stateMachine:changeState(CameraFollowState.new())
	end
	--print ("---------CameraYFixState "..tostring(self.role.gameObject.transform.position.x - camera.gameObject.transform.position.x))
end