--[[
author:Desmond
默认摄像机状态
]]
CameraNormalState= class(BaseCameraState)

CameraNormalState._name = "CameraNormalState"
CameraNormalState.role = nil --player

function CameraNormalState:Enter(camera)
	--GamePrint ("-------------function CameraNormalState:Enter(camera) ")
end

--[[ role:camera 为lua对象 ]]
function CameraNormalState:Excute(camera,dTime)
    self.super.Excute(self,camera,dTime)
end
--修复x轴误差
function CameraNormalState:dealChangeY( camera,del_y )
    local disY = self.role.gameObject.transform.position.y + ConfigParam.CameraDisVector.y - camera.gameObject.transform.position.y
    local disX = self.role.gameObject.transform.position.x + ConfigParam.CameraDisVector.x - camera.gameObject.transform.position.x
    local disZ = self.role.gameObject.transform.position.z + ConfigParam.CameraDisVector.z - camera.gameObject.transform.position.z
 	if  math.abs(disX) > 0.1 then
		local moveDis = UnityEngine.Time.deltaTime*ConfigParam.CameraMoveToYSpeed
		if math.abs(disX) > moveDis then --矫正gap数值
			disX = disX/math.abs(disX) * moveDis
		end
		camera.gameObject.transform:Translate(disX,0,0)
	end
end

--[[ role:camera 为lua对象 ]]
function CameraNormalState:Exit(camera)
	-- body
end

