--[[
author:Desmond

]]
CameraFixState = class(BaseCameraState)
CameraFixState._name = "CameraFixState"
--[[ camera:camera 为lua对象 ]]
function CameraFixState:Enter(camera)
	--GamePrint("------------function CameraFixState:Enter(camera) ")
end

--[[ role:camera 为lua对象 ]]
function CameraFixState:Excute(camera,dTime)
	self.super.Excute(self,camera,dTime)
end

--[[ camera:camera 为lua对象 ]]
function CameraFixState:Exit(camera)
	-- body
end

--处理y值变化
function CameraFixState:dealChangeY(camera,del_y )
end