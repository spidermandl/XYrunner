--[[
author:Desmond
神圣模式 集磁铁状态 无敌状态 金币雨 之大成
]]
HolyState = class (BasePlayerState)

HolyState._name = "HolyState"
HolyState.startTime = nil --开始时间
HolyState.battleScene = nil --战斗场景
HolyState.lastPosition = Vector3.zero --记录角色位置
HolyState.effectManager = nil --特效管理器
HolyState.mainCamera = nil--主摄像机
HolyState.landingPoint = nil --降落点
function HolyState:Enter(role)
    --GamePrint("   HolyState:Enter(   ")
	self.super.Enter(self,role)
    role.stateMachine:removeSharedStateByName("ItemChangeCloverState")
	self.battleScene = GetCurrentSceneUI()
    self.mainCamera = self.battleScene.mainCamera
	--print("播放  ef_chuansong_jinshan ")
	self.battleScene.uiCtrl:ShowWhite() 	--show白背景
	self.battleScene:LoaderHolyMap() 	--加载神圣地图
	self.lastPosition = role.gameObject.transform.position --记录角色位置
	role.gameObject.transform.position = ConfigParam.HolyMapPosition + ConfigParam.HolyStateRolePos --改变角色位置

    self.mainCamera.stateMachine:changeState(CameraStayState.new())
    self.mainCamera.gameObject.transform.position = ConfigParam.HolyMapPosition + self.mainCamera.defaultFixedDistance 
    + Vector3(4,0,0) --偏差
    --self.mainCamera.stateMachine:changeState(CameraYResetState.new())
	self.startTime = UnityEngine.Time.time
	--[[
	--附加状态
	local invincible = InvincibleState.new() --无敌状态
    invincible.duringTime = RoleProperty.HolyDuringTime
    invincible.effectType = 1 -- 特效类型
    invincible.state = 1
    invincible.isShowEffect = true
    role.stateMachine:addSharedState(invincible)

    local buff = MagnetState.new() --磁铁状态
    buff.stage = 2
    buff.distance = ConfigParam.CoinDistance * 2
    buff.duringTime = RoleProperty.HolyDuringTime
    buff.isShowEffect = true
    role.stateMachine:addSharedState(buff)
    ]]
    self.effectManager = PoolFunc:pickSingleton("EffectGroup")
    --创建神圣模式特效
    self.suduxianEffect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_candy_suduxian")
    self.suduxianEffect.transform.parent = role.gameObject.transform
    self.suduxianEffect.transform.position = role.gameObject.transform.position + Vector3(0,0,0)
    self.effectManager:addObject(self.suduxianEffect,true)
    self.suduxianxlEffect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_candy_suduxianxl")
    self.suduxianxlEffect.transform.parent = self.mainCamera.gameObject.transform
    self.suduxianxlEffect.transform.localPosition = Vector3(0,0,0)
    self.suduxianxlEffect.transform.localScale = Vector3.one
    self.suduxianxlEffect.transform.localRotation = Quaternion.Euler(0,0,0)
    self.effectManager:addObject(self.suduxianxlEffect,true)
    --强制转变角色的朝向
    role.moveSpeedVect = 1
    local vec = role.gameObject.transform.localScale
    vec.x = math.abs(vec.x)/role.moveSpeedVect
    role.gameObject.transform.localScale = vec
    role.isBlocked = false
end

function HolyState:Excute(role,dTime)
	local currentTime = UnityEngine.Time.time
	if currentTime - self.startTime > RoleProperty.HolyDuringTime then --超过时间
		--role.stateMachine:removeSharedState(self)
	else
		local point = dTime*100/RoleProperty.HolyDuringTime
		role:minusHolyPoint(point)
	end
end
function HolyState:Exit(role)
	self.battleScene:QuitHolyMap() 	--退出神圣模式地图
    local itemManager = PoolFunc:pickSingleton("ItemGroup")
    
    role:cleanHoly() -- 清空神圣点数
    role.gameObject.transform.position = self.lastPosition+Vector3(0,5,0) --恢复位置
    local point = itemManager:getNearestPointMarkByType("RevivePointMark")
    if point ~= nil then
        self.lastPosition = point.gameObject.transform.position--获取最近的复活点位置
    end
    if self.landingPoint ~= nil then --如果有下落点，用下落点
        self.lastPosition = self.landingPoint
        GamePrint("             下落点   :"..tostring(self.lastPosition))
    end
    
    
    role.gameObject.transform.position = self.lastPosition+Vector3(0,5,0) --恢复位置
    --self.mainCamera.gameObject.transform.position = role.gameObject.transform.position + self.mainCamera.defaultFixedDistance 
    --+ Vector3(2,0,0) + Vector3(0,-5,0)
	self.battleScene.uiCtrl:ShowWhite() 	--show白背景
    role.stateMachine:changeState(HolyDropState.new())
    if role.stateMachine.currentState._name == "HolyDropState" then
        self.mainCamera.gameObject.transform.position = role.gameObject.transform.position + self.mainCamera.defaultFixedDistance 
         + Vector3(2,-5,0)
        self.mainCamera.stateMachine:changeState(CameraStayState.new())
    end
    role.isBlocked = false
	--创建出口特效
	self.chuEffect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_chuansong_chu")
    self.chuEffect.transform.parent = role.gameObject.transform.parent
    self.chuEffect.transform.position = role.gameObject.transform.position
    self.effectManager:addObject(self.chuEffect)
    self.effectManager:removeObject(self.suduxianEffect)
    self.effectManager:removeObject(self.suduxianxlEffect)
end