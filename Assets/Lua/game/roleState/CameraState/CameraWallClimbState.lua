CameraWallClimbState = class(BaseCameraState)
CameraWallClimbState._name = "CameraWallClimbState"
--[[ camera:camera 为lua对象 ]]
function CameraWallClimbState:Enter(camera)
	--GamePrint("------------function CameraWallClimbState:Enter(camera) ")
end

--[[ role:camera 为lua对象 ]]
function CameraWallClimbState:Excute(camera,dTime)
	self.super.Excute(self,camera,dTime)

    if self.role == nil then
    	return
    end

end

--[[ camera:camera 为lua对象 ]]
function CameraWallClimbState:Exit(camera)
	-- body
end

--处理y值变化
function CameraWallClimbState:dealChangeY(camera,del_y )
	camera.gameObject.transform:Translate(0,del_y,0, Space.World)
end