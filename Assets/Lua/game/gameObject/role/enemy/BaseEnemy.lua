--[[
敌人基类
author:Desmond
]]
BaseEnemy = class (BaseBehaviour)

BaseEnemy.type = "enemy"  --物件类型 敌人类别
BaseEnemy.enemyId = nil --敌人配表id
BaseEnemy.character =nil  --prefab
BaseEnemy.collider = nil --碰撞体
BaseEnemy.animator = nil
BaseEnemy.roleName = nil --模型名字
BaseEnemy.stateMachine = nil
BaseEnemy.player = nil -- 主角
BaseEnemy.stage = nil --生命阶段 0 未被激活;1 激活;2死亡
BaseEnemy.DISABLE = 0
BaseEnemy.ACTIVATED = 1
BaseEnemy.DESTROY = 2
BaseEnemy.isDefend = false
BaseEnemy.HP = 0 --血量
BaseEnemy.distance = 0

BaseEnemy.itweenDelayTime = nil --itween延迟时间
BaseEnemy.itweenLoopType = nil --itween循环类型
BaseEnemy.itweenEaseType = nil --itween时间曲线
BaseEnemy.itweenNodePath =nil

BaseEnemy.enemyManager = nil --怪物管理器

BaseEnemy.GoldWaveDistance = 10 --  金币冲击波距离

function BaseEnemy:Awake()
    --print("-----------------BaseEnemy Awake--->>>----------------- 1 "..tostring(self.bundleParams))
    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self
    if type(self.bundleParams) == "table" then  --参数从json中读入,动态加载时生效
        --[[ table参数
            怪物id
        ]]
        self.enemyId = self.bundleParams.param
        --print ("--------------function BaseEnemy:Awake() "..tostring(self.enemyId))
        local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
        self.roleName = txt:GetData(self.enemyId,TxtFactory.S_MATERIAL_MODEL)
        --print("-----------------BaseEnemy Awake--->>>----------------- ")
    end
    self:CreateDynamicEnemy()
    self.enemyManager = PoolFunc:pickSingleton("EnemyGroup") --获取怪物管理器
    local lua = self.gameObject:GetComponent(BundleLua.GetClassType()) --移除lua update
    lua.isUpdate = false
    if self.player == nil then
        self.player = LuaShell.getRole(LuaShell.DesmondID) 
    end 
    self:initParam()
end

--初始化参数 外部调用
function BaseEnemy:initParam()
    self.distance = 0
    self.stage = self.DISABLE
    self:goActiveState()
    self:initITween()
    self.isDefend = false
    self.enemyManager:addObject(self) --加入怪物
    --GamePrint("---------------function BaseEnemy:initParam() "..tostring(self.gameObject.transform.localPosition))
end

function BaseEnemy:Update()
    if self.player == nil then
        self.player = LuaShell.getRole(LuaShell.DesmondID) 
        return
    end 
    self.stateMachine:runState(UnityEngine.Time.deltaTime)


    self.distance = self.gameObject.transform.position.x - self.player.character.transform.position.x  -- 与主角距离

    if self.distance < ConfigParam.objectDestroyByCameraDis then
        --LuaShell.OnDestroy(self.gameObject:GetInstanceID()) --销毁敌对象
        --PoolFunc:inactiveObj(self.gameObject)
        self:inactiveSelf()
    end

    if self.stage == self.DESTROY then 
        --LuaShell.OnDestroy(self.gameObject:GetInstanceID()) --销毁敌对象
        --PoolFunc:inactiveObj(self.gameObject)
        self:inactiveSelf()
	end
    --不改变boxCollider 清屏
    --[[
    local CleanState = self.player.stateMachine.sharedStates["CleanMonsterState"]
    if self.isDefend == false  
    and ( CleanState ~= nil and CleanState.distance ~= nil  and math.abs(self.distance) < CleanState.distance)  --移动中清屏
    then
        self:defend(self.player)
        self.isDefend = true
    end
    ]]
end

function BaseEnemy:FixedUpdate()    

end

function BaseEnemy:OnTriggerEnter(gameObj)
    -- print("gameObj ------- name :"..gameObj.name)
    local lua = LuaShell.getRole(gameObj.gameObject:GetInstanceID())
    if lua ~= nil and lua.type ~= nil and lua.type == "AttackAffectItem" then
        self:defend(self.player)
        return
    end

    if gameObj.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --与主角碰撞
        return
    end
    
    
    if self.player.stateMachine:getState()._name == "AttackState" or 
        self.player.stateMachine:getState()._name == "SprintState" or 
        self.player.stateMachine.sharedStates["ChangeBigState"] ~= nil or 
        self.player.stateMachine.sharedStates["CleanMonsterState"] ~= nil or
        self.player.stateMachine.sharedStates["InvincibleState"] ~= nil 
    then --攻击 冲刺 无敌 变大 状态受击 
    -- print(self.role.stateMachine.sharedStates["ChangeBigState"]._name)
        self:defend(self.player)
    else
        self:attack(self.player)
    end

end

--初始化动画
function BaseEnemy:initITween()
    self.itweenNodePath = nil
    if type(self.bundleParams) == "table" then  
        --[[
            delay time
            loop time
            ease type
            rotate angle
            node count
        ]] 
        local paths = self.bundleParams['path']
        if paths == nil then
            return
        end
        
        local path = paths[1]
        self.itweenSpeed = tonumber(path['speed'])
        self.itweenDelayTime = tonumber(path['delay'])
        self.itweenLoopType = path['loopType']
        self.itweenEaseType = path['easeType']
        if path['rotateAngle'] ~= nil then
            local array = lua_string_split(path['rotateAngle'],",")
            self.itweenRotateAngle = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3]))
        end
        self.itweenNodePath = {}
        local nodes = path['nodes']
        for i=1,#nodes do --初始化 itemGroup
            array = lua_string_split(nodes[i],",") --参数间分割符
            table.insert(self.itweenNodePath,
                UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])))
        end
    end
end

--播放路径动画
function BaseEnemy:playPathAnim()
    if self.player == nil then
        self.player = LuaShell.getRole(LuaShell.DesmondID) 
        return
    end 
    if self.player.stateMachine.sharedStates["CleanMonsterState"] ~= nil then
        return
    end

    if self.itweenNodePath ==nil or #self.itweenNodePath == 0 then 
        return
    end

    local param = System.Collections.Hashtable.New()

    local path = System.Array.CreateInstance(UnityEngine.Vector3.GetClassType(),#self.itweenNodePath)
    for i=1,#self.itweenNodePath do
        --print ('node '..tostring(i)..': '..tostring(self.itweenNodePath[i]))
        self.itweenNodePath[i] = self.gameObject.transform.position + self.itweenNodePath[i]
        path:SetValue(self.itweenNodePath[i],i-1)
    end
    param:Add('path',path)
    param:Add('speed',self.itweenSpeed)
    param:Add('easeType',self.itweenEaseType)
    param:Add('loopType',self.itweenLoopType)
    param:Add('delay',self.itweenDelayTime)
    iTween.MoveTo(self.gameObject, param)
end

--冷藏自身
function BaseEnemy:inactiveSelf()
    --关闭动画
    if self.itweenNodePath ~=nil and #self.itweenNodePath > 0 then
        iTween.Stop(self.gameObject)
    end

    --销毁特效
    local state = self.stateMachine:getState()
    if state ~= nil then
        state:Exit(self)
    end

    self.enemyManager:removeObject(self)
end

--获取角色
function BaseEnemy:getPlayer()
    if self.player == nil then
        self.player = LuaShell.getRole(LuaShell.DesmondID)
    end 
    return self.player
end
--创建模型
function BaseEnemy:CreateDynamicEnemy()
end
-- 金币冲击波
function BaseEnemy:GoldWave()

end

--激活场景中敌人
function BaseEnemy:goActiveState()
	-- body
end

--场景中敌人活动
function BaseEnemy:doActiveState()
	-- body
end

--攻击
function BaseEnemy:attack(player)
    -- body
end

--受到攻击
function BaseEnemy:defend(player)
end
--龙猫普通攻击
function  BaseEnemy:attackEnemy(player)
    self:defend(player)
end
