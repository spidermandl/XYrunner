--CameraZMoveItem.lua
--[[
author:赵名飞
碰到该道具拉远摄像机，再次碰到恢复摄像机
]]
CameraZMoveItem = class (BaseBehaviour)
CameraZMoveItem.roleName = "CameraZMoveItem"
CameraZMoveItem.collider = nil 
CameraZMoveItem.zAxisFixedPoint = nil --相机拉远距离
CameraZMoveItem.zAxisMoveingTime = nil --相机拉远时间

function CameraZMoveItem:Awake()
    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,10,0)
    self.collider.size = Vector3(1,30,20)
    self.gameObject.transform.localScale = Vector3.one
    self.gameObject.transform.rotation = Quaternion.Euler(0,0,0)
    self:initParam()
end

--启动事件--
function CameraZMoveItem:Start()
end
--初始化参数配置
function CameraZMoveItem:initParam()
    if type(self.bundleParams) == "table" then  --参数从json中读入,动态加载时生效
        local config = self.bundleParams
        local param = lua_string_split(config['param'],";")
        self.zAxisMoveingTime = tonumber(param[1])
        if #param > 1 then
            local pos = lua_string_split(param[2],",")
            if #pos >= 3 then
                self.zAxisFixedPoint = Vector3(tonumber(pos[1]),tonumber(pos[2]),tonumber(pos[3]))
            else
                self.zAxisFixedPoint = Vector3(0,0,-10)
            end
        else
            self.zAxisFixedPoint = nil
        end
    end
    --GamePrint("self.zAxisFixedPoint :"..tostring(self.zAxisFixedPoint).."self.zAxisMoveingTime : "..self.zAxisMoveingTime)
end

function CameraZMoveItem:FixedUpdate()
end

function CameraZMoveItem:Update()
end
--创建特效
function CameraZMoveItem:CreateEffect()
    local effectManager = PoolFunc:pickSingleton("EffectGroup")
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_chuansong_jin")
    effect.name = "ef_chuansong_jin"
    effect.transform.parent = self.gameObject.transform
    effect.transform.localPosition = Vector3(0,-3,0)
    effectManager:addObject(effect)

end


function CameraZMoveItem:OnTriggerEnter( gameObj )
	if gameObj.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --与主角碰撞
        return
    end
    local des = LuaShell.getRole(LuaShell.DesmondID)
    if des.stateMachine.sharedStates["PathFindingState"] ~= nil then --寻路状态不触发
        return
    end
    local mainCamera = GetCurrentSceneUI().mainCamera
    if self.zAxisFixedPoint ~= nil then
        local state = CameraZBackState.new() --拉远状态
        state.zAxisFixedPoint = self.zAxisFixedPoint
        state.zAxisMoveingTime = self.zAxisMoveingTime
        mainCamera.stateMachine:changeState(state)
    else
        local state = CameraZForwardState.new() --恢复状态
        state.zAxisMoveingTime = self.zAxisMoveingTime
        mainCamera.stateMachine:changeState(state)
    end
end