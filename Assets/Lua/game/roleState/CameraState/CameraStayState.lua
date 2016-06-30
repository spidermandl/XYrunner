--CameraStayState.lua
--[[
author:赵名飞
摄像机静止状态
]]
CameraStayState = class(BaseCameraState)
CameraStayState._name = "CameraStayState"

function CameraStayState:Enter(camera)
end

--[[ role:camera 为lua对象 ]]
function CameraStayState:Excute(camera,dTime)
end

--[[ role:camera 为lua对象 ]]
function CameraStayState:Exit(camera)
end