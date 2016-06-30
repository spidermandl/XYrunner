--[[
author:Desmond
摄像机Y方向矫正状态
]]
CameraAutoFixState = class(BaseCameraState)
CameraAutoFixState._name = "CameraAutoFixState"

function CameraAutoFixState:Enter(camera)
	--GamePrint("------------function CameraAutoFixState:Enter(camera) ")
end
--[[ role:camera 为lua对象 ]]
function CameraAutoFixState:Excute(camera,dTime)
	self.super.Excute(self,camera,dTime)
end

--[[ role:camera 为lua对象 ]]
function CameraAutoFixState:Exit(camera)
	-- body
end


--处理y值变化
function CameraAutoFixState:dealChangeY( camera,del_y )
	--print("------------function CameraAutoFixState:dealChangeY( del_y )")
    local disY = self.role.gameObject.transform.position.y + ConfigParam.CameraDisVector.y - camera.gameObject.transform.position.y
    local disX = self.role.gameObject.transform.position.x + ConfigParam.CameraDisVector.x - camera.gameObject.transform.position.x
    local disZ = self.role.gameObject.transform.position.z + ConfigParam.CameraDisVector.z - camera.gameObject.transform.position.z
 	if math.abs(disY) > 0.01 or math.abs(disX) > 0.01 then --摄像机y方向没有移动到目标点,开始移动
		--print("------------function CameraAutoFixState:dealChangeY( del_y ) 2")
		--camera y轴距离矫正
		local moveDis = UnityEngine.Time.deltaTime*ConfigParam.CameraMoveToYSpeed
		if math.abs(disY) > moveDis then --矫正gap数值
			disY = disY/math.abs(disY) * moveDis
		end
		camera.gameObject.transform:Translate(0,disY,0)

		if math.abs(disX) > moveDis then --矫正gap数值
			disX = disX/math.abs(disX) * moveDis
		end
		camera.gameObject.transform:Translate(disX,0,0)

		if math.abs(disZ) > moveDis then --矫正gap数值
			disZ = disZ/math.abs(disZ) * moveDis
		end
		camera.gameObject.transform:Translate(0,0,disZ)

	else
		--print("------------function CameraAutoFixState:dealChangeY( del_y ) 3")
		camera.stateMachine:changeState(CameraYFixState.new())
	end
end
