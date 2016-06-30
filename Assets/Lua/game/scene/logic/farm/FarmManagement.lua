--[[
author:Desmond
城建管理类
]]
require "game/scene/common/TouchEvent"

FarmManagement = class ()
FarmManagement.scene = nil --building 场景
FarmManagement.farmCamera = nil --城建摄像头
FarmManagement.cameraView = nil --摄像头镜头
FarmManagement.uiCamera = nil --ui camera
FarmManagement.farmLand = nil  --城镇地面
FarmManagement.castle = nil --3d背景

FarmManagement.selectionType = nil --点击类型
FarmManagement.selectNone = 0 --没有点中
FarmManagement.selectLand = 1 --点中地面
FarmManagement.selectBuilding =2 --点中建筑

FarmManagement.moveBasePoint = nil --移动基准点
FarmManagement.moveBaseBlock = nil --移动起始地块

FarmManagement.carmaFov = 0 --记录上次改变后的视距
FarmManagement.lastDist = 0    --  记录上次移动 距离
FarmManagement.curDist = 0    --  记录本次移动 距离

FarmManagement.pos = Vector3.zero
FarmManagement.PreMouseMPos = Vector3.zero
FarmManagement.CurMouseMPos = Vector3.zero
FarmManagement.touchEvent = nil --点击事件

FarmManagement.allBuilds = nil --所有城建模型的父类
FarmManagement.moveLater = 0 --以后摄像头后计时
FarmManagement.needRefresh = false --是否需要刷新城建名字位置
function FarmManagement:Awake()
	--print("-----------------FarmManagement Awake--->>>-----------------")
	self.farmCamera = find("Camera") --查找场景的摄像头
	self.cameraView = self.farmCamera:GetComponent(UnityEngine.Camera.GetClassType())
    self.cameraView.fieldOfView = ConfigParam.UIbuiildingMaxFov
    self.uiCamera = find("CameraUI"):GetComponent(UnityEngine.Camera.GetClassType())
	self.farmLand = self:initLand()
    self.castle = newobject(Util.LoadPrefab("Building/building_scene_bg"))
    self.allBuilds = find("allBuilds")
	self.selectionType = selectNone

    touchEvent = TouchEvent.new() --注册触碰事件
    touchEvent:setListener(self)
end

--启动事件--
function FarmManagement:Start()
    --print("-----------------FarmManagement Start--->>>-----------------")
end

function FarmManagement:Update()
    --print ("-----------------function FarmManagement:Update() ")
    if not(self.scene.isBuildScene) then
        return
    end
    touchEvent:Update()
    if Input.touchCount > 1 then 
        self:CameraZoomByTouch() --多点触控
    else
        self:CameraZoom() --滚轮
    end
    --[[
    --计时刷新城建名字位置
    if self.needRefresh then
        if self.moveLater < ConfigParam.ShowBuildNameTime then
            self.moveLater = self.moveLater + UnityEngine.Time.deltaTime
        else
            if self.scene ~= nil then
                self.scene:RefreshBuildingNames()
                self.needRefresh = false
                self.moveLater = 0
            end
        end
    end
    ]]
end

function FarmManagement:FixedUpdate()
	-- body
end

--创建地面
function FarmManagement:initLand()
    local land = UnityEngine.GameObject.New()
    land:SetActive(false)
    local item = land:AddComponent(BundleLua.GetClassType())
    item.luaName ="LandMap"
    land.transform.position = UnityEngine.Vector3.zero
    land.name = "land"
    land:SetActive(true)

    return LuaShell.getRole(land:GetInstanceID())
end
-- 地形显隐 hanli_xiong
function FarmManagement:SetActive(enable)
    self.castle:SetActive(enable)
    self.allBuilds:SetActive(enable)
end

--电脑端滚轮缩放视距
function FarmManagement:CameraZoom()
    local fov = self.cameraView.fieldOfView --获取摄像机的视距
    fov = fov - Input.GetAxis("Mouse ScrollWheel") * ConfigParam.UIbuiildingSensitivity
    if fov ~= self.carmaFov then
        fov = UnityEngine.Mathf.Clamp(fov, ConfigParam.UIbuiildingMinFov, ConfigParam.UIbuiildingMaxFov)
        self.cameraView.fieldOfView = fov
        self.carmaFov = fov

        --[[
        --隐藏名字
        if self.scene ~= nil then
            self.scene:HideBuildingNames()
        end
        --开始计时
        self.needRefresh = true
        self.moveLater = 0
        ]]
        if self.scene ~= nil then
            self.scene:RefreshBuildingNames()
        end
    end
end
--移动端触屏缩放视距
function FarmManagement:CameraZoomByTouch()

        if Input.GetTouch(0).phase == TouchPhase.Moved or Input.GetTouch(1).phase == TouchPhase.Moved then
            local tempPos1 = Input.GetTouch (0).position
            local tempPos2 = Input.GetTouch (1).position
            local fov = self.cameraView.fieldOfView --获取摄像机的视距
            --获取两点之间的距离
            self.curDist = UnityEngine.Vector2.Distance(tempPos1, tempPos2)
            if self.curDist > self.lastDist then
                fov = fov - ConfigParam.CameraZoomSpeed
            else
                fov = fov + ConfigParam.CameraZoomSpeed
            end
            if fov <= ConfigParam.UIbuiildingMinFov then
                fov = ConfigParam.UIbuiildingMinFov
            elseif fov >= ConfigParam.UIbuiildingMaxFov then
                fov = ConfigParam.UIbuiildingMaxFov
            end
            self.cameraView.fieldOfView = fov
            self.lastDist = self.curDist
            --[[
            --隐藏名字
            if self.scene ~= nil then
                self.scene:HideBuildingNames()
            end
            --开始计时
            self.needRefresh = true
            self.moveLater = 0
            ]]
            if self.scene ~= nil then
                self.scene:RefreshBuildingNames()
            end
        end
end
--按下
function FarmManagement:press()
    --print ("---------------function FarmManagement:press()")
end
--点击
function FarmManagement:click()
    local flag,building = self:buildingSelected()
    if flag == true then --选中建筑
        return
    end
    if self:uiSelected() == false then 
        if self.scene ~= nil then
            self.scene:ShowAllBtns(true) --展示左下角所有按钮
        end
    end

    --if self.scene ~= nil then
    --    self.scene:UIBuilding_BtnTurn() --展示左下角所有按钮
    --end
    self:buildingHarvest()
end
--移动
function FarmManagement:move()
    --print ("---------------function FarmManagement:move()")
    self:CameraMove(Input.mousePosition)
end
--长按
function FarmManagement:longClick()
    --print ("---------------function FarmManagement:longClick()")
end

--拖动场景
function FarmManagement:CameraMove(mousePosition)
    --print ("---------------------function FarmManagement:CameraMove(mousePosition) ")
    if  Input.touchCount > 1 then return end -- 保证单指拖拽时候才移动
	if  self.PreMouseMPos.x <= 0  then         
       	self.PreMouseMPos = Vector3(Input.mousePosition.x, Input.mousePosition.y, Input.mousePosition.y)                       
	else 
        if self:uiSelected() == false then --判断是否点中ui
            local delta_x = Input.GetAxis("Mouse X") * (ConfigParam.UIbuiildingMovSpeed)
            local delta_y = Input.GetAxis("Mouse Y") * (ConfigParam.UIbuiildingMovSpeed)
            local rotation = Quaternion.Euler(0, self.farmCamera.transform.rotation.eulerAngles.y,0 )
            local pos = self.farmCamera.transform.position + rotation * Vector3(- delta_x,0,- delta_y)
            local size = ConfigParam.UIbuiildingMovSize
            --pos.x = UnityEngine.Mathf.Clamp(pos.x, -size, size)
            --pos.z = UnityEngine.Mathf.Clamp(pos.z, -size, size)
            if pos.x >= size then
                pos.x = size
            elseif pos.x <= -size then
                pos.x = -size
            end
            if pos.z >= size then
                pos.z = size
            elseif pos.z <= -size then
                pos.z = -size
            end
            self.farmCamera.transform.position = pos
            --[[
            --隐藏名字
            if self.scene ~= nil then
                self.scene:HideBuildingNames()
            end
            --开始计时
            self.needRefresh = true
            self.moveLater = 0
            ]]
            if self.scene ~= nil then
                self.scene:RefreshBuildingNames()
            end
        end
 	end

             

end

--是否选中ui
--true:选中 false:未选中
function FarmManagement:uiSelected()
    local ray = self.uiCamera:ScreenPointToRay (Input.mousePosition)
    local flag,hitinfo = UnityEngine.Physics.Raycast (ray, nil,UnityEngine.Mathf.Infinity,2^UnityEngine.LayerMask.NameToLayer("UI"))
    if flag == true then --判断是否点中ui、
        return true
    end
    return false
end

--判断是否选中建筑物
--true:选中、建筑物 false:未选中
function FarmManagement:buildingSelected()
    --print("点击按钮")
    if self:uiSelected() == true then
        --print("选中了UI层")
        return false
    end
    --print("发射射线")
   	local ray = self.cameraView:ScreenPointToRay (Input.mousePosition)
    local flag,hitinfo = UnityEngine.Physics.Raycast (ray, nil,UnityEngine.Mathf.Infinity,2^UnityEngine.LayerMask.NameToLayer("Default"))
    self.selectionType = self.selectLand       
    if flag == false then
        return false
    end

    if flag == true then
        local obj = LuaShell.getRole(hitinfo.collider.gameObject:GetInstanceID())
        if obj == nil then
        	return false
        end
        
        if obj.type == "BaseBuilding" then
        	self.selectionType = self.selectBuilding
        	self.farmLand.selectedBuilding = obj

            if self.scene ~= nil then
                self.scene:showBuildingOperation(obj)
            end

            return true,obj
    	end
    end

    return false
end  
-- 点击收获城建产出
function FarmManagement:buildingHarvest()
    if self:uiSelected() == true then
        return
    end
    local ray = self.cameraView:ScreenPointToRay (Input.mousePosition)
    local flag,hitinfo = UnityEngine.Physics.Raycast (ray, nil,UnityEngine.Mathf.Infinity)
    if flag == true then
        local obj = hitinfo.collider.gameObject
        if obj == nil then
            return false
        end
        local fetchId = TxtFactory:getValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_FETCHID)
        if obj.name == tostring(fetchId) then
            if self.scene ~= nil then
                self.scene:FecthHarvest(obj.name)
            end
        end
    end
end 

--判断是否选中地面移动建筑
function FarmManagement:LandSelected()
   	local ray = self.cameraView:ScreenPointToRay (Input.mousePosition)
   	--print ("-----------------   >>>>>>>>>> "..tostring(self.farmLand.gameObject.layer))
    local flag,hitinfo = UnityEngine.Physics.Raycast (ray, nil,UnityEngine.Mathf.Infinity,2^self.farmLand.gameObject.layer)    
    if flag == false then
        return
    end   

    if flag == true then
        local obj = LuaShell.getRole(hitinfo.collider.gameObject:GetInstanceID())

        if obj == nil then
        	return
        end
        
        if obj.name == "LandMap" then
        	if self.moveBasePoint == nil then --纪录初始点
        		self.moveBasePoint = hitinfo.point 
        		return
        	end

        	local dir = self.farmLand:moveBuild(hitinfo.point-self.moveBasePoint)
        	if dir ~= nil then
        		self.moveBasePoint = self.moveBasePoint + dir
        	end
    	end
    end
end

--返回选中建筑
function FarmManagement:getSelectedBuilding()
    return self.farmLand.selectedBuilding
end

