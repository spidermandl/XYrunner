--[[
主角类
author:Desmond
]]
Desmond = class(BaseBehaviour)

Desmond.tag = "Desmond"
Desmond.type = "Desmond"
Desmond.character =nil  --人物prefab可能包含坐骑
Desmond.roleModel = nil --人物的prefab
Desmond.property = nil  --人物属性
Desmond.stateMachine = nil --人物状态切换状态机
Desmond.hangingCollierCheck = nil --墙壁碰撞检测物件
Desmond.collider = nil --碰撞体
Desmond.rigidBody = nil --刚体
Desmond.animator = nil --动画
Desmond.suitModel = nil --3d模型

Desmond.stamina = nil --体力
Desmond.initStamina = nil --初始体力
--单局分数
Desmond.score = 0 --得分

Desmond.money = 0 --金币
Desmond.exp = 0 --经验
Desmond.holyPoint = 0 --神圣点数
Desmond.killCount =0 --击杀怪物数量


Desmond.ITEM_HOLY_MIN = 6 --收集物体神圣点数+1数量
Desmond.itemHoly = 0 --收集物体神圣点数累积
Desmond.HOLY_TRIGGER =100 --神圣点数触发值

Desmond.hpLostByTime = RoleProperty.hpLostByTime --单位掉体力速度
Desmond.expAddByTime = 5.6 --单位时间增加经验
Desmond.hitCount = 0  --被击中次数
Desmond.fallCount = 0 --掉坑次数
Desmond.aggregateATKTime = 0 --连续攻击次数

Desmond.roleName = nil--"desmond" --"dgirl"
Desmond.pets = nil --萌宠id
Desmond.mountID = nil --当前选中座骑
Desmond.equips = nil --当前装备的装备

Desmond.sceneListener = nil --场景接口


---------------------------[[在状态机中设置]]-----------------------------
Desmond.isFlyInDrop = false --第一次进入场景判断是否在surface上
Desmond.isBlocked = false --角色被物体挡住
Desmond.moveSpeedVect =1 -- 1 向右移动  -1 向左移动


-- 新手引导 标记
Desmond.isGuideJumped = false
Desmond.isGuideDoubleJumped = false
Desmond.isGuideAttacked = false
Desmond.isGuideHanged = false
Desmond.isGuideDoing = false

------------------------------------------------------------------------

function Desmond:Awake()
    --print("-----------------Desmond Awake--->>>-----------------")
    self.property = clone(RoleProperty)

    self:initMount() --写在状态机初始前
    --[[设置状态机]]
    self.stateMachine = RoleStateMachine.new()
    self.stateMachine.role = self

    self:initSuit()--写在状态机初始后
    self:initHangingCollider()

    LuaShell.DesmondID = self.gameObject:GetInstanceID()

end

--启动事件--
function Desmond:Start()
    --print("-----------------Desmond Start--->>>-----------------")
    self:startMount()

    self.stateMachine:changeState(RunState.new())
    local battleType = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE)
    if battleType ~= 1 and battleType ~= -1 then
        self.stateMachine:addSharedState(CheckBattleItemState.new()) --添加检测战斗道具状态
    end
    self.stateMachine:addSharedState(ThroughoutMagentState.new()) --添加全程磁铁状态
    self:initHP() --检测战斗道具后初始体力
    self:updateSkillIcon()
    self.stateMachine:setFlyInDrop()


    self.isGuideDoing = false
    local battleScene = GetCurrentSceneUI()
    if battleScene.BattleGuideView.isGuideLevel == true  then
        --battleScene.BattleGuideView:GuideIsFinish()
        self.isGuideDoing = true
    end

end

function Desmond:Update()
    --print("-----------------Desmond Update-->>>----------------- "..tostring(UnityEngine.Time.deltaTime))
    self.hangingCollierCheck:Update()
    --体力减少
    self:consumeHP()
    self:testHoly()

    if UnityEngine.Input.GetKeyDown(KeyCode.Q) then
        self.stateMachine:addSharedState(ChangeBigState.new())
    end

    if UnityEngine.Input.GetKeyDown(KeyCode.E) then
        local buff  = StealthState.new() 
                      -- CoinChangeFromPetState.new() 
        -- buff.type = 1
        -- buff.state = 1
        self.stateMachine:addSharedState(buff)
    end

    if UnityEngine.Input.GetKey(KeyCode.A) then
        self:DoAction('attack')
    end

    if UnityEngine.Input.GetKeyDown(KeyCode.K) then
        self:DoAction('jump')
    end

    if UnityEngine.Input.GetKeyDown(KeyCode.W) then
        self:DoAction('sprint')
    end
    
    if UnityEngine.Input.GetKeyDown(KeyCode.R) then
        local tab = UnityEngine.Physics.OverlapSphere(self.gameObject.transform.position,5)
        -- local c = System.Array.GetValue(tab,0)

        local length = tab.Length - 1 
        for i=0,length do
            local c = System.Array.GetValue(tab,i)
            print("Tab..  "..i.." :"..tostring(c.gameObject.name))
        end
        
    end

end

function Desmond:FixedUpdate()
    self.stateMachine:runState(UnityEngine.Time.fixedDeltaTime)
end

--ik 回调
function Desmond:OnAnimatorIK()
    --print ("-----------------function Desmond:OnAnimatorIK()--->>>-----------------")
    if self.mountID ~= nil then  --判断有座骑
        local mountstate = self:getMountState()--获取座骑状态
        if mountstate == nil then
            return
        end
        mountstate:OnIKAnimation(self)
        return
    end
end

--获取座骑状态
function Desmond:getMountState()
    return self.stateMachine:getMountState()
end

--获取飞行萌宠3d模型名字
function Desmond:getPlyPetTypeID()
--[[
    local mountTypeTxt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local mountTxt = TxtFactory:getTable(TxtFactory.MountTXT)
    
    --print ('----------------function Desmond:getPlyPetPrefabName() pet num '..tostring(#self.pets))
    for i=1,#self.pets do
        local type_id = mountTxt:GetData(self.pets[i],TxtFactory.S_MOUNT_TYPE)--种类id
        local t = mountTypeTxt:GetData(type_id,TxtFactory.S_ROLE_TYPE)
        --print ('----------------function Desmond:getPlyPetPrefabName() '..tostring(self.pets[i])..)
        if tonumber(t) == 1 then --飞行萌宠
            return type_id
        end
    end
]]--
    return RoleProperty.DefaultFlyPetId
end
--[[
13001  哈碧
13002  竹蜻蜓企鹅
13003  机械猫
13004  瞅瞅
13005  萌宠村长
13006  松鼠兄弟
13007  罗宾特
13008  乔巴
13009  伊丽莎白三世
13010  不良熊
13011  咪咪
13012  番长鸭
13013  多尾兔
13014  哈姆小子
13015  真萌宠村长
13016  呆呆狸
13017  塔玛希·魂
13018  猫老师
13019  黄金狸猫
13020  独眼怪
13021  提百万
13022  皮神
13023  草泥马
13024  定春
13025  UFO
13026  大黄鸭
13027  彩虹猫
13028  草泥马变色版
13029  UFO变色版
]]
--获取队长类型id
function Desmond:getCaptainPetTypeID()
    --GamePrint("我们的队长是 00000000")
    --test
    --do
    --    return "13002"
    --end
    --
    local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo) -- 萌宠数据表
    local duizhangId = petInfo[TxtFactory.DUI_ZHANG]
    local tid = nil
    if duizhangId == nil or duizhangId == 0 then --没有队长
        return nil
    end
    local petTab = petInfo[TxtFactory.BIN_PETS]
    for o = 1 , #petTab do
        if petTab[o].id == duizhangId then --tonumber(icon.name) 
            tid = petTab[o].tid
            break
        end
    end
    if tid == nil then
        return nil
    end
        local mountTxt = TxtFactory:getTable(TxtFactory.MountTXT)
        local ctid = mountTxt:GetData(tid, TxtFactory.S_MOUNT_TYPE) -- 种类id
        local petTxt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
        local skill_id = petTxt:GetData(ctid,TxtFactory.S_MOUNT_ACTIVE_SKILLS)
        if skill_id == nil or skill_id == "" then --该队长没有主动技能
            return nil
        end
        tid = tostring(ctid)
        --GamePrint("tid   :"..tostring(tid))
        return tid
   
    --return "13001"--哈比
end

--获得该萌宠有没有上场
function Desmond:isPetOn( pet_type )
    local mountTypeTxt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local mountTxt = TxtFactory:getTable(TxtFactory.MountTXT)
    
    --print ('----------------function Desmond:getPlyPetPrefabName() pet num '..tostring(#self.pets))
    for i=1,#self.pets do
        local type_id = mountTxt:GetData(self.pets[i],TxtFactory.S_MOUNT_TYPE)--种类id
        if type_id == pet_type then
            return true
        end
    end

    return false
end
--初始坐骑
function Desmond:initMount()
    self.pets = TxtFactory:getTable(TxtFactory.MemDataCache):getCurPetTab() --初始化萌宠
    self.mountID = TxtFactory:getTable(TxtFactory.MemDataCache):getCurMountID() --初始化座骑
    self.equips = TxtFactory:getTable(TxtFactory.MemDataCache):getCurEquipTab() --初始化装备
    self:initEquipAttributes()
end

--启动坐骑
function Desmond:startMount()
    if self.mountID ~= nil then --初始化座骑
        local txt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
        local name = txt:GetData(
                    math.floor(tonumber(self.mountID)/10000),
                    TxtFactory.S_ROLE_MODEL)
        if name == 'cnm_hourse' then
            self.stateMachine:addSharedState(CNMMountState.new()) --草泥马座骑
        elseif name == 'ufo_mount' then
            self.stateMachine:addSharedState(UFOMountState.new()) --ufo 座骑
        end
    end
end
--根据套装获取角色模型名字
function Desmond:getSuitName()
    local name = ""
    local config_suit_id = TxtFactory:getTable(TxtFactory.MemDataCache):getPlayerSuit()
    local suitTxt = TxtFactory:getTable(TxtFactory.SuitTXT)
    local uInfo = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    if uInfo[TxtFactory.USER_SEX] == 0 then
        name = suitTxt:GetData(config_suit_id,TxtFactory.S_SUIT_MALE_MODEL)
    elseif uInfo[TxtFactory.USER_SEX] == 1 then
        name = suitTxt:GetData(config_suit_id,TxtFactory.S_SUIT_FEMALE_MODEL)
    else
        name = suitTxt:GetData(config_suit_id,TxtFactory.S_SUIT_MALE_MODEL)
    end
    --GamePrint("-------------------------function Desmond:getSuitName() "..tostring(name))
    return name
end

--初始人物套装
function Desmond:initSuit()
    if self.roleName == nil then
        self.roleName = self:getSuitName()
    end
    local modelName = self.roleName..RoleProperty.defaultMount.."_generic"
    --加入模型
    if self.suitModel ~= nil then
        PoolFunc:inactiveObj(self.suitModel)
    end
    --GamePrint("-----------function Desmond:initSuit(mountName) "..tostring(mountName))
    self.suitModel = PoolFunc:pickObjByPrefabName("Player/"..modelName)
    self.suitModel.transform.parent = self.gameObject.transform
    self.suitModel.transform.localPosition = UnityEngine.Vector3.zero
    self.character = self.suitModel.transform
    --[[设置动画状态机]]
    self.animator = self.character.gameObject:GetComponent(UnityEngine.Animator.GetClassType())
    --[[设置碰撞体]]
    if self.collider == nil then
        self.collider = self.gameObject:AddComponent(UnityEngine.CapsuleCollider.GetClassType())
        self.collider.isTrigger = false
        self.collider.center=UnityEngine.Vector3(0,1,0)
        self.collider.radius=0.4
        self.collider.height=2
    end
    --[[设置刚体]]
    if self.rigidBody == nil then
        self.rigidBody = self.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
        self.rigidBody.useGravity = false
        self.rigidBody.isKinematic = true
        self.rigidBody.mass = 0
        self.stateMachine:addSharedState(SuitState.new())
    end
end

--初始化弹墙碰撞体
function Desmond:initHangingCollider()
    local obj = PoolFunc:pickObjByLuaName("HangingColliderItem") --从内存池中读取
    obj:SetActive(false)

    obj.transform.parent = self.gameObject.transform
    obj.transform.localPosition = UnityEngine.Vector3(0,0,0)
    obj.transform.localRotation = Quaternion.Euler(0,0,0)
    obj.transform.localScale = UnityEngine.Vector3(self.collider.radius*2,self.collider.height/2,self.collider.radius*2)
    
    local sub = obj:GetComponent(BundleLua.GetClassType())
    if sub == nil then --第一次创建物体
        local sub = obj:AddComponent(BundleLua.GetClassType())
        sub.luaName = "HangingColliderItem"
        LuaShell.setPreParams(obj:GetInstanceID(),self)--预置构造参数
    else --重用加载
       local lua = LuaShell.getRole(obj:GetInstanceID())
       lua.bundleParams = self
       lua:initParam()
    end
    obj:SetActive(true)
    self.hangingCollierCheck = LuaShell.getRole(obj:GetInstanceID())
    
end

--设置模型显示
function Desmond:setSuitVisible(isShow)
    if self.suitModel ~= nil then
        self.suitModel:SetActive(isShow)
    end
end
--ui按钮点击
function Desmond:DoAction(action)
    --print("-----------------Desmond DoAction-->>>-----------------")
    if self.stateMachine:getState()._name == "DefendState" then 
        return
    end
    if action == "jump" then
        if self.stateMachine.sharedStates["ConfusionState"] ~= nil then --  混乱状态 跳攻击反向
             self.stateMachine:startAttack()
             return
        end
        self.stateMachine:startJump()
    elseif action == "attack" then
        if self.stateMachine.sharedStates["ConfusionState"] ~= nil then --  混乱状态 跳攻击反向
             self.stateMachine:startJump()
             return
        end
        self.stateMachine:startAttack()
    elseif action == "dive" then
        self.stateMachine:startDive()    
    elseif action == "stop_diving" then
        self.stateMachine:stopDive() 
    elseif action == "sprint" then
        self.stateMachine:startSprint() 
    end

end

function Desmond:OnCollisionEnter( collision )
    --print("-----------------Desmond OnCollisionEnter-->>>-----------------")
    LuaShell.EliminateCollisionFromDesmond(collision)
end


function Desmond:itweenCallback()
    --print ("----------------------------->>>>> function Desmond:itweenCallback()")
    local state = self.stateMachine:getState()
    if state._name == "BouncingState" then
        iTween.Pause(self.gameObject)
        state.forceDisrupt = true --打开可以切换
        self.stateMachine:changeState(BouncingDropState.new()) 
    end
end

--
function Desmond:FailedText()
    if UnityEngine.Input.GetKey(KeyCode.A) then
        self.stateMachine:changeState(FailedState.new())
    end
end

--设置碰撞属性
function Desmond:isOnCollision( isCollision )
    --GamePrint("Desmond:isOnCollision")
    self.hangingCollierCheck.gameObject:SetActive(not isCollision)
    self.rigidBody.isKinematic = not isCollision
    self.collider.isTrigger = isCollision
    self.isBlocked = false
end
--主角复活
function Desmond:reborn()
    -- 若有坐骑，显示坐骑
    if self.mountID ~= nil then 
        local mountState = self:getMountState()
        if mountState ~= nil then
            mountState:playRoleAnimation()
            mountState:playExplode()
            -- mountState:SetActive(true)
        end
    end
    --转向
    self.moveSpeedVect = 1
    local vec = self.gameObject.transform.localScale
    vec.x = math.abs(vec.x)/self.moveSpeedVect
    self.gameObject.transform.localScale = vec
    -- 回到地面
    self.stateMachine:changeState(HolyDropState.new())
end
--是否拥有坐骑
function Desmond:hasMount()
    if self.mountID ~= nil then
        return true
    else
        return false
    end
end

--更新技能图标
function Desmond:updateSkillIcon(num)
    if self.sceneListener ~= nil then
        self.sceneListener:notifySkillInfo(num)
    end
end
--计算体力
function Desmond:initHP()
    self.stamina = TxtFactory:getTable(TxtFactory.MemDataCache):getFullHP()
    --print ("-------------------function Desmond:initHP() "..tostring(self.stamina))
    if self.stamina == nil or self.stamina < 0 then
        self.stamina = self.property.StaminaMax
    end 
    self.stamina = self.stamina + self.property.addMaxHp
    self.initStamina = self.stamina
    --GamePrint("self.stamina  :"..self.stamina.."self.initStamina   :"..self.initStamina)
end


--每帧数消耗体力／增加经验
function Desmond:consumeHP()
    if RoleProperty.unlimitedHP == true or self.stateMachine.sharedStates["HolyState"] ~= nil then --无限体力 or 神圣模式
        return
    end

    if self.stamina < 0 then --体力耗光
        if self.isGuideDoing  then
            self.stamina = 1
        else
            if self.sceneListener ~= nil then
                self.sceneListener:notifyFinish()
            end
            return
        end
    end

    self.stamina = self.stamina - UnityEngine.Time.deltaTime * 
                    (TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_HP_RATE) - 
                        TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_HP_SLOWDOWN))
    --print ("total stamina:"..tostring(self.initStamina).." current stamina:"..tostring(self.stamina).." "..tostring(TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_HP_SLOWDOWN)) )
    self.exp = self.exp + UnityEngine.Time.deltaTime * self.expAddByTime
end

--获取体力百分比
function Desmond:getStanimaPer()
    return self.stamina/self.initStamina
end

--初始化装备属性
function Desmond:initEquipAttributes()
    local equipTxt = TxtFactory:getTable(TxtFactory.EquipTXT)
    if #self.equips < 1 then
        return
    end
    for i=1, #self.equips do
        for k,v in pairs(equipTxt.Attribute) do
            local avalue = equipTxt:GetData(self.equips[i], v) 
            if avalue and avalue ~= "" then
                warn("Attribute:" .. v .. "=" .. self.property[v] .. "/" .. avalue)
                self.property[v] = tonumber(avalue)
            end
        end
    end
end

--累加得分
function Desmond:addScore(addVal)
    self.score = self.score + addVal
    if self.sceneListener ~= nil then
        self.sceneListener:addScore(addVal)
    end
end

--吸收收集物
--addVal 得分
function Desmond:absortItem(addVal,holyVal)
    self:addScore(addVal)
    holyVal = holyVal and holyVal * 100 or 0
    if self.holyPoint < 100 and self.stateMachine.sharedStates["HolyState"] == nil then
        self.holyPoint = self.holyPoint + holyVal
    end
end

--杀怪
--addVal 得分
function Desmond:killEnemy(enemyId)
    local addVal = TxtFactory:getTable(TxtFactory.MemDataCache):attackScore(enemyId)

    self:addScore(addVal) --加分数
    if self.holyPoint < 100 and self.stateMachine.sharedStates["HolyState"] == nil then
        --self.holyPoint = self.holyPoint + TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_HOLY_KILL_SUCK) --圣神点数＋1
    end
    self.killCount = self.killCount + 1
    local num = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_HP_KILL_SUCK) --吸血数值加成
    if tonumber(num) ~=nil and tonumber(num) > 0 then
        local integer,f = math.modf(self.killCount/num)
        if f==0 then
            self.stamina = self.stamina + 2
        end
    end


    local task = TxtFactory:getTable(TxtFactory.TaskManagement) --触发击杀怪物任务项
    task:SetTaskData(TaskType.ENEMY_COUNT,tonumber(enemyId),1)
end
--获取击杀次数
function Desmond:getKillCount()
    return self.killCount
end
--检测神圣体力
function Desmond:testHoly()
    local battleType = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE)
    if self.holyPoint >= self.HOLY_TRIGGER and battleType ~= 1 and battleType ~= 1  and self.stateMachine.sharedStates["HolyState"] == nil then
        if RoleProperty.isHolyOpen == true then
            self:playSkill("HolyState")
        end
    end
end
function Desmond:cleanHoly()
    self.holyPoint = 0
end

--获取神圣体力
function Desmond:getHoly()
    return self.holyPoint
end


--神圣模式进度
function Desmond:minusHolyPoint(point)
    self.holyPoint = self.holyPoint - point
    if self.holyPoint <= 0 then
        self.holyPoint = 0
    end
end

--累加金币
function Desmond:addMoney(addVal)
    self.money = self.money + addVal
end

--累加经验
function Desmond:addExp( addVal )
    self.exp = self.exp + addVal
end

--总得分计算
function Desmond:getScoreResult()
    local multi = 1+ TxtFactory:getTable(TxtFactory.MemDataCache):budgetScore()
    return self.score * multi
end
--总金币计算
function Desmond:getMoneyResult()
    local multi = 1+TxtFactory:getTable(TxtFactory.MemDataCache):budgetMoney()
    return self.money * multi
end
--总经验计算
function Desmond:getExpResult()
    local multi = 1+TxtFactory:getTable(TxtFactory.MemDataCache):budgetExp()
    return self.exp * multi
end

--被击次数
function Desmond:hitDefence()
    --print ("------------------function Desmond:hitDefence()")
    self.hitCount = self.hitCount + 1
    self.stamina = self.stamina - 8 * math.pow(1.25,self.hitCount) + 
                TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_MINUS_DAMAGE)

    local task = TxtFactory:getTable(TxtFactory.TaskManagement)--触发收击任务项
    task:SetTaskData(TaskType.NO_HURT ,1)
    
end

--掉坑
function Desmond:fallDown()
    --print ("------------------function Desmond:fallDown()")
    self.fallCount = self.fallCount + 1
    self.stamina = self.stamina - 8 * math.pow(1.8,self.fallCount) +
                TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_INMUNE_FALLDOWN)

    local task = TxtFactory:getTable(TxtFactory.TaskManagement)--触发收击任务项
    task:SetTaskData(TaskType.NO_HURT ,1)
end

--增加体力
function Desmond:addStamina( addVal )
    self.stamina = self.stamina + addVal
end

--返回移动速度
function Desmond:getMoveSpeed()
    if self.isBlocked == true then
        --GamePrint("Desmond.isBlocked == true")
        return 0
    end
    local txt = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    local moveSpeed = txt[TxtFactory.USER_MOVE_SPEED]
    if moveSpeed == nil then
        moveSpeed = self.property.moveSpeed
    end

    return moveSpeed * self.moveSpeedVect
end

--动态创建 跟随pet-- 为主角子节点
--[[
role: 主角
... 参数
]]
function Desmond:createPet( type_id,... )
    local txt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local luaName = txt:GetData(type_id,TxtFactory.S_ROLE_LUACLASS)
    ----GamePrint ('----------------function Desmond:getPlyPetPrefabName() pet num '..tostring(luaName))
    if luaName == nil then
        print ("no lua class")
        return
    end
    -- 创建飞行萌宠
    local obj = PoolFunc:pickObjByLuaName(luaName) --从内存池中读取
    obj:SetActive(false)
    local sub = obj:GetComponent(BundleLua.GetClassType())

    obj.transform.parent = self.gameObject.transform
    obj.transform.localPosition = UnityEngine.Vector3(0,0,0)
    if sub == nil then --第一次创建物体
        sub = obj:AddComponent(BundleLua.GetClassType())
        LuaShell.setPreParams(obj:GetInstanceID(),type_id)--(obj:GetInstanceID(),{...})--预置构造参数
    else --重用加载
        local lua = LuaShell.getRole(obj:GetInstanceID())
        lua.bundleParams = type_id
        lua:initParam()
    end
    sub.luaName = luaName
    obj:SetActive(true)

    return LuaShell.getRole(obj:GetInstanceID())
end

--记录攻击次数
function Desmond:countATK()
    self.aggregateATKTime = self.aggregateATKTime +1
end
--获取攻击次数
function Desmond:getATKCount()
    return self.aggregateATKTime
end
--释放技能
function Desmond:playSkill(skillId,petId)
    local skillTxt = TxtFactory:getTable(TxtFactory.PetSkillMainTXT) --技能表
    if petId ~= nil then --萌宠主动技能
        local skillState = PlayingSkillState.new()  --正在释放技能
        skillState.skillId = skillId
        self.stateMachine:addSharedState(skillState)
        if self.sceneListener ~= nil then
            self.sceneListener:showSkillInfo(skillId,petId) --show技能UI
        end
        return
    end
    if skillId == "101029" then --大黄鸭
        local state = OnRhubarbDuckSprintState.new()
        state.skillId = skillId
        self.stateMachine:changeState(state)

    elseif skillId == "101024" then  --引导技能（皮卡丘）
        if self.stateMachine.sharedStates["PathFindingState"] ~= nil then  --自动寻路状态
            return
        end
        local pet = self:createPet("13022")
        pet:triggerCaptainSkill()

    elseif skillId == "HolyState" then --神圣模式
        if self.stateMachine:getState()._name == "VictoryState" 
        or self.stateMachine:getState()._name == "EndlessRunningOutState" 
        or self.stateMachine:getState()._name == "FailedState"
        or self.stateMachine:getState()._name == "SprintState"
        or self.stamina <= 0 
        then
        return
        end
        local buff = SprintState.new()
        buff.duringTime = 1
        buff.connectState = HolyState.new()
        self.stateMachine:changeState(buff)

    elseif skillId == "101003" then --全程磁铁
        self.property.ThroughoutMagentDistance = 3

    elseif skillId == "101005" then --开局体力增加50
        local value = skillTxt:GetData(skillId,TxtFactory.S_MAIN_SKILL_GAIN_VALUE)
        self.property.addMaxHp = value

    elseif skillId == "101009" then --一次性护盾
        self.stateMachine:addSharedState(DisposableInvincibleState.new())

    elseif skillId == "101011" then --增加游戏内道具持续时间
        local value = skillTxt:GetData(skillId,TxtFactory.S_MAIN_SKILL_GAIN_VALUE)
        self.property.StateBonusTime = value 

    elseif skillId == "101010" then --死亡后冲刺
        if self.stateMachine.sharedStates["DeathSprintState"] == nil then
            self.stateMachine:addSharedState(DeathSprintState.new())
        else
            self.stateMachine:removeSharedStateByName("DeathSprintState")
            local state = OnRhubarbDuckSprintState.new()
            state.skillId = skillId
            self.stateMachine:changeState(state)
        end
    elseif skillId == "101031" then --银币冲击波 （怪物变金币）
        local state = MonsterIntoCoinState.new()
        state.skillId = skillId
        self.stateMachine:addSharedState(state)
    else

    end

end


