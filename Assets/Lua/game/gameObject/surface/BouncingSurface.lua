--[[
  author:Desmond
  1.弹跳地形
  2.触发弹跳动画
  3.可设定弹跳起点与终点（是否设定弹跳路线待定）
  4.弹跳速度
  5.考虑衔接

]]
BouncingSurface = class (BaseSurface)
BouncingSurface.type = "BouncingSurface" --收集道具类型

BouncingSurface.endPoint = nil --落地点
BouncingSurface.moveSpeed = 0 --移动速度
BouncingSurface.overTop = 0 --高于最高点的距离
BouncingSurface.rate = 0.5 --(0,1)  最高点的横向比例
BouncingSurface.itweenPaths = nil --弹跳路径
BouncingSurface.pureAnim = nil --是否只播放动画

BouncingSurface.beginPos = nil --起点位置
BouncingSurface.targetZ = nil --落点Z轴
BouncingSurface.targetX = nil --落点X轴
BouncingSurface.isReplace = nil --是否是默认动作 false 默认动作
BouncingSurface.actionSpeed = nil --角色动作播放速度
BouncingSurface.actionDelayTime = nil --蘑菇动作延迟时间
BouncingSurface.direction = nil --角色朝向

function BouncingSurface:Awake()
    self.super.Awake(self)
end

--设置参数
function BouncingSurface:initParam()
    
    if type(self.bundleParams) == "table" then  --参数从json中读入,动态加载时生效
        --[[ table参数
            param: 弹跳移动速度
                   弹跳高度偏移
                   弹跳最高点横向比例
            step_localPosition: 碰撞面中心位置 local
            step_localScale: 碰撞面大小
            bouncing_model_name: 碰撞物体prefab名字
            bouncing_model_localPosition: 碰撞物体位置 local 
            bouncing_model_localScale: 弹跳终点位置 local
            bouncing_path: 弹跳路径
            target_localPosition: 终点 
        ]]
        local config = self.bundleParams
        self.pureAnim = false
        if  type(config['bouncing_path']) ~= "table" then

            local param = lua_string_split(config['param'],";")
            --GamePrint ("------------function BouncingSurface:initParam() "..tostring(config['param']))
            if param == nil or #param < 3 then
                self.pureAnim = true
            end

            self.moveSpeed = tonumber(param[1])
            self.overTop = tonumber(param[2])
            self.rate = tonumber(param[3])
            self.itweenPaths = nil
        else
            local param = lua_string_split(config['param'],";")
            self.itweenPaths = config['bouncing_path'][1]
            -- for k,v in pairs(self.itweenPaths) do
            --     print (tostring(k).." "..tostring(v))
            -- end
        end

        local array = lua_string_split(config['step_localPosition'],",")
        --print ("------------function BouncingSurface:initParam() "..tostring(array))
        local colliderPos = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) --碰撞位置
        array =  lua_string_split(config['step_localScale'],",")
        local colliderScale = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) --碰撞大小
        local bouningPrefabName = config['bouncing_model_name']--self.bundleParams[6] --载入bouncing 物体名字
        array = lua_string_split(config['bouncing_model_localPosition'],",")
        local bouncingLocalPos = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) --bouncing物位置
        array = lua_string_split(config['bouncing_model_localRotation'],",")
        local bouncingLocalRot = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) --bouncing物角度
        array = lua_string_split(config['bouncing_model_localScale'],",")
        local bouncingScale = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) --bouncing物大小
        if self.itweenPaths == nil then
            array = lua_string_split(config['target_localPosition'],",")
            local targetPos = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) --目标点位置
            self.endPoint = self.gameObject.transform.position + targetPos
            --print ("------------function BouncingSurface:initParam() "..tostring(self.endPoint))
        end

        self.targetZ = tonumber(config['m_TargetZ'])
        self.isReplace = tonumber(config['m_isReplaceAction'])
        self.direction = tonumber(config['m_Direction'])
        self.actionSpeed = tonumber(config['m_ActionSpeed'])
        self.actionDelayTime = tonumber(config['m_ActionDelayTime'])
        --GamePrint("self.targetZ :"..self.targetZ.."  self.isReplace :"..self.isReplace.." self.direction:"..self.direction.."  self.actionSpeed:"..self.actionSpeed.."  self.actionDelayTime:"..self.actionDelayTime)
        
        if self.collider == nil then
            self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
        end
        self.collider.isTrigger = true
        self.collider.center=colliderPos
        self.collider.size=colliderScale
        
        if self.surface == nil then
            self.surface  = PoolFunc:pickObjByPrefabName("Surface/"..bouningPrefabName)
        end
        self.surface.transform.parent = self.gameObject.transform
        self.surface.transform.localPosition = bouncingLocalPos
        self.surface.transform.localRotation = Quaternion.Euler(bouncingLocalRot.x,bouncingLocalRot.y,bouncingLocalRot.z)
        self.surface.transform.localScale = bouncingScale

        

    else
        self.moveSpeed = tonumber(tostring(System.Array.GetValue(self.bundleParams,0)))
        self.overTop = tonumber(tostring(System.Array.GetValue(self.bundleParams,1)))
        self.rate = tonumber(tostring(System.Array.GetValue(self.bundleParams,2)))

        local step = self.gameObject.transform:Find("step")
        self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
        self.collider.isTrigger = true
        self.collider.center = step.transform.localPosition
        self.collider.size = step.transform.localScale
        
        self.surface = self.gameObject.transform:Find("bouncing").gameObject
        self.endPoint = self.gameObject.transform:Find("target").transform.position
    end

    if ConfigParam.FilterColliderMash == true then--去碰撞物mesh
        --destroy(self.gameObject:GetComponent(UnityEngine.MeshFilter.GetClassType()))
        --destroy(self.gameObject:GetComponent(UnityEngine.MeshRenderer.GetClassType()))
    end
    
    self.surface:GetComponent("Animator"):Play("idle");

    self.super.initParam(self)
end

function BouncingSurface:OnTriggerEnter(gameObj) 
	--GamePrint("-----------------BouncingSurface OnTriggerEnter 1")
	if gameObj.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --与主角碰撞
		return
	end
    if self.role.stateMachine.sharedStates["PathFindingState"] ~= nil 
    or self.role.stateMachine.sharedStates["HolyState"] ~= nil 
    then --是否有寻路状态
        return
    end
    
    self.collider.isTrigger = false
	self.role = LuaShell.getRole(gameObj.gameObject:GetInstanceID())
    if self.role.stateMachine:getState()._name == "DeadState"
    or self.role.stateMachine:getState()._name == "SprintState"
     then --死亡状态不能触发
        return
    end

    local state = BouncingState.new()
    state.targetX = self.targetX --落点x轴
    state.targetZ = self.targetZ --落点z轴
    state.isReplace = self.isReplace ~= 1--是否取代默认动作 1默认动作 0替换动作
    state.direction = self.direction --角色朝向
    state.actionSpeed = self.actionSpeed --角色动作速度
    --GamePrint("state.isReplace     :"..tostring(state.isReplace))
    self.role.stateMachine:changeState(state)
    coroutine.start(self.playAction,self)
    iTween.Stop(self.role.gameObject)
    if self.pureAnim == true then

    elseif self.itweenPaths == nil or type(self.itweenPaths) ~= "table" then
        self.targetX = self.endPoint.x
	    BundleTools.BouncingMove(self.role.gameObject,
    		--self.surface.transform.position,
    		self.role.gameObject.transform.position,
    		self.endPoint,
    		self.rate,
    		self.overTop,
    		self.moveSpeed)
    else
        self:playPathAnim()
    end

    

end
--播放动作和特效
function BouncingSurface:playAction()
    coroutine.wait(self.actionDelayTime) --延迟时间
    self.surface:GetComponent("Animator"):Play("viberating")
    self:createExplode()
end
--播放路径动画
function BouncingSurface:playPathAnim()
    local itweenNodePath = self.itweenPaths['nodes']
    local speed = self.itweenPaths['speed']
    local delay = self.itweenPaths['delay']
    local loopType = self.itweenPaths['loopType']
    local easeType = self.itweenPaths['easeType']
    local rotateAngle = self.itweenPaths['rotateAngle']

    local param = System.Collections.Hashtable.New()
    local path = System.Array.CreateInstance(UnityEngine.Vector3.GetClassType(),#itweenNodePath)
    for i=1,#itweenNodePath do
        --print ('node '..tostring(i)..': '..tostring(itweenNodePath[i]))
        local array =  lua_string_split(itweenNodePath[i],",")
        itweenNodePath[i] = self.gameObject.transform.position + UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) --碰撞大小
        if i == 1 then
            local beginPos = itweenNodePath[1]
            --GamePrint("self.beginPos   :"..tostring(beginPos))
            if beginPos ~= nil then
                --self.role.gameObject.transform:Translate(beginPos.x,beginPos.y,beginPos.z)
                self.role.gameObject.transform.position = beginPos
            end
        end
        if i == #itweenNodePath then
            self.targetX = itweenNodePath[i].x
        end
        path:SetValue(itweenNodePath[i],i-1)
    end
    
    --print ("--------------function BaseEnemy:playPathAnim() "..tostring(self.itweenSpeed))
    param:Add('path',path)
    param:Add('speed',speed)
    param:Add('easeType',easeType)
    param:Add('loopType',loopType)
    param:Add('delay',delay)
    param:Add('oncomplete','CallMethod')
    param:Add('oncompleteparams','itweenCallback')
    iTween.MoveTo(self.role.gameObject, param)
end

--打开爆炸特效
function BouncingSurface:createExplode()
    local effectGroup = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_prop_spring")
    effect.transform.parent = self.surface.transform
    effect.transform.localPosition = Vector3.zero
    effect.transform.localScale = Vector3.one
    effect.transform.localRotation = Quaternion.Euler(0,0,0)
    effectGroup:addObject(effect)

end

