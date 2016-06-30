--[[
author:Desmond
主角状态机
]]
RoleStateMachine = class (StateMachine)

RoleStateMachine.previousState = nil
RoleStateMachine.currentState = nil
RoleStateMachine.sharedStates = nil--公共状态
RoleStateMachine.role = nil  --不可为nil
RoleStateMachine.jumpStage = 0 --连续跳跃次数
RoleStateMachine.gameIsOver = 0 --游戏结束状态不起作用
RoleStateMachine.stateChangeListeners = nil --状态切换监听器
RoleStateMachine.diveOnce = false --最后一段跳滑行 只能滑行一次
RoleStateMachine.AirAttack = 0 --空中攻击 只能攻击二次

function RoleStateMachine:changeState( iState )
    if  self.gameIsOver == 1 then
        return
    end

    local flag = self:preCheck(iState) --状态切换前，检测切换条件
    if flag == false then 
        return
    end

    if self.currentState ~= nil then
        self.currentState:Exit(self.role)
    end

    if self.stateChangeListeners ~= nil then
        for key,value in pairs(self.stateChangeListeners) do  --执行状态切换监听器
            if value ~= nil then  
                if self.currentState ~= nil then
                    value:stateChange(self.role,self.currentState,iState)
                    -- print("value._name"..value._name)
                end
            end
        end 
    end

    -- if self.currentState ~= nil then
    --     GamePrint (" --------------   change state 2 "..tostring(self.currentState._name).." "..tostring(iState._name))
    -- end
    self.previousState  = self.currentState
    self.currentState = iState

    self.currentState:Enter(self.role)
end

function RoleStateMachine:runState( dTime )
    if self.sharedStates ==nil then
        self.sharedStates = {}
    end
    
    if self.stateChangeListeners ==nil then
        self.stateChangeListeners = {}
    end

    if self.currentState ~= nil then
        self.currentState:Excute(self.role,dTime)

        for key,value in pairs(self.sharedStates) do  
            -- if key == "UnstopableState" then
            if value ~= nil then  
                if value.multiple == nil then --单一状态
                    --print ("---------- "..tostring(value._name))
                    if value._name ~= nil then
                        value:Excute(self.role,dTime)
                    end
                else --多个状态
                    for i=1,#value do
                        if value[i] ~= nil then
                            value[i]:Excute(self.role,dTime)
                        end
                    end
                end
            end
            -- end
        end  

    end

end
function RoleStateMachine:getState()
    return self.currentState
end

function RoleStateMachine:getPreState()
    return self.previousState
end
--------------------------------------------------------------------------------------------------------------------
--[[逻辑代码]]   
--------------------------------------------------------------------------------------------------------------------
--设置状态关联
function RoleStateMachine:preCheck( iState )
    if self.currentState == nil then 
        return true
    end
    
    if self.currentState._name == iState._name 
        and self.currentState._name ~= "DoubleJumpState"
        and self.currentState._name ~= "BouncingState" --可以切换相同状态
        then
        return false
    end

    if self.currentState._name == "BouncingState" then
        if iState._name ~= "BouncingState" 
        and self.currentState.forceDisrupt ~= true 
        then --不能切换 BouncingState

        --GamePrint("--------------function RoleStateMachine:preCheck( iState ) ")
            return false
        end
    end

    if self.sharedStates["PathFindingState"] ~= nil --自动寻路状态不切换其他状态
    or (self.currentState._name == "EndlessRunningOutState" and iState._name ~= "OnRhubarbDuckSprintState") --已经是死亡状态除了大黄鸭状态不能切换其他状态
    then 
        return false 
    end


    local name = iState._name
    if name == "RunState" then --切换到run状态
        if self.currentState._name == "DropState" or self.currentState._name == "DoubleDropState"  or self.currentState._name == "HolyDropState" then
            if self.currentState.dropDistance <= RoleProperty.DropBreakDistance then --下降高度大于设定阀值
                iState.preAnim = "single drop land"
            else
                iState.preAnim = "multi drop land"
            end
        elseif self.currentState._name == "BouncingDropState" then
            iState.preAnim = "multi drop land"
        end
        self.jumpStage = 0
        self.diveOnce = false
        self.AirAttack = 0
        --print ("-------------------------- self.jumpStage =  "..tostring(self.jumpStage))
    elseif name =="JumpState" then
        -- print("self.currentState._name  :"..self.currentState._name)
        if self.currentState._name == "WallClimbState" then --处于吸墙状态
            -- if self.currentState:isOnGround(self.role) == true then --角色在地面

            -- else --角色在半空
                self:addSharedState(TurnAroundState.new()) --转身
            --end
        end
        self.jumpStage = 1
        local task = TxtFactory:getTable(TxtFactory.TaskManagement) --任务跳跃计数
        task:SetTaskData(TaskType.JUMP_COUNT_MAX,1)
        --print ("-------------------------- self.jumpStage =  "..tostring(self.jumpStage))
    elseif name == "DoubleJumpState" then --多段跳纪录次数
        if self.currentState._name == "WallClimbState" then --角色被墙吸住，不能进入下段跳
            return false
        end

        self.jumpStage = self.jumpStage + 1
        --多段跳分数加成
        if self.jumpStage == 2 then
            local score = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_SECOND_JUMP_SCORE)
            self.role:addScore(score)
        end

        local cap = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_JUMP_CAP)
        if cap >2 then --最多大于2段跳
            local score = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_MULTI_JUMP_SCORE)
            self.role:addScore(score)
        end
        local task = TxtFactory:getTable(TxtFactory.TaskManagement)--任务跳跃计数
        task:SetTaskData(TaskType.JUMP_COUNT_MAX,1)

        --print ("-------------------------- self.jumpStage =  "..tostring(self.jumpStage))
    elseif name == "DropState" then --切换到单跳下降状态
        --self.jumpStage = 1
    elseif name == "DoubleDropState" then --切换到多跳下降状态

    elseif name == "AttackState" then --切换到攻击状态
        local s = self:getSharedState("FlyATKBlockState") --空中停顿
        if s ~= nil then
            return false
        end
    elseif name =="SprintState" then

    elseif name =="DefendState" then
        if self.sharedStates["UnstopableState"] ~= nil --无敌状态不能被攻击
            or self.sharedStates["ChangeBigState"] ~= nil 
            or self.sharedStates["StealthState"] ~= nil 
            or self.currentState._name == "DeadState" then --死亡状态不能被攻击
             return false
        end
        if self.sharedStates["ElectricBallState"] ~= nil then
             self.sharedStates["ElectricBallState"]:changeState()
             return false 
        end
        if self.sharedStates["DisposableInvincibleState"] ~= nil then --一次性护盾状态
            self:removeSharedStateByName("DisposableInvincibleState")
            return false 
        end
        self:addSharedState(UnstopableState.new())--加入无敌状态
    elseif name == "FailedState" then --失败状态
        -- if self.currentState._name ~= "RunState" then
        --     return false
        -- end
        self.gameIsOver = 1
    elseif name == "DiveState" then
        if self:getSharedState("BlockState") ~= nil then --角色被墙吸住，不能进入下段跳
            return false
        end

        if self.diveOnce == true then --已经滑行过
            return false
        end
        self.diveOnce = true
    elseif name == "WallClimbState" then
        self.jumpStage = 0
    elseif name == "VictoryState" then
        self.gameIsOver = 1
    elseif name == "DeadState" then  -- 掉入坑受击状态
         if self.sharedStates["ElectricBallState"] ~= nil then
              self.sharedStates["ElectricBallState"]:changeState()
         end
    elseif name =="StopState" then
        -- self.jumpStage = 0
    -- elseif name == "BouncingState" then
    --     --print ("---------------elseif name == BouncingState then ")
    --     if self.currentState._name == "DeadState" then
    --         return false
    --     end
    elseif name =="AirAttackState" then
        self.AirAttack = self.AirAttack + 1
        if self.AirAttack > RoleProperty.airAtkMaxTime then
            return false
        end
    elseif name =="BouncingState" then

    elseif name =="EndlessRunningOutState" then  --切换无尽死亡状态时，需要保证在地面
        if self.currentState:isOnGround(self.role) == false then --角色在地面
            --GamePrint("角色死亡，不再地面")
            return false
        end
    elseif name ==nil then 

    end

    return true
end
--设置第一次飞入场景
function RoleStateMachine:setFlyInDrop()
    self.role.isFlyInDrop = true
end


--主角起跳动作
function  RoleStateMachine:startJump()
    -- print("Enter startJump  "..self.currentState._name)
    local state = self.currentState
    if state == nil then--状态不能为空
        return
    end

    if state._name == "BouncingState" or 
       state._name == "SprintState" or 
       state._name == "OnRhubarbDuckSprintState" or 
       state._name == "DeadState" then --弹跳状态不能切换
        return
    end

    if self.sharedStates["CantJumpState"] ~= nil  or 
       self.sharedStates["PathFindingState"] ~= nil --检测是否有自动寻路状态
       then --无法跳跃状态不能跳跃
        return 
    end
    
    -- if self.role.moveSpeedVect < 0 then --角色移动方向向右
    --     self:addSharedState(TurnAroundState.new()) --转身
    -- end

    --print ("---------------------function  RoleStateMachine:startJump() "..tostring(self.jumpStage))
    if self.jumpStage ==0 then
        -- print("-----------------RunState-->>>-----------------")
        self:changeState(JumpState.new())
        return
    elseif self.jumpStage >0 and self.jumpStage < TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_JUMP_CAP) then
                                 --self.role.property.jumpAllow then 
    --根据人物属性中最大连跳，限定连跳状态
        -- print("-----------------JumpState or DropState-->>>-----------------")
        self:changeState(DoubleJumpState.new())
        return
    elseif self.jumpStage >= TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_JUMP_CAP) then --最后一段跳，再点跳press，滑翔
        --self:startDive()
        return
    end
end

--主角攻击动作
function RoleStateMachine:startAttack()
    local state = self.currentState
    if state == nil then--状态不能为空
        return
    end

    if state._name == "BouncingState" or --弹跳状态不能切换
       state._name == "SprintState" or --冲刺状态不能切换
       state._name == "WallClimbState" or --弹墙状态
       state._name == "DeadState" or --死亡状态
       self.sharedStates["CantAttackState"] ~= nil or --不能攻击状态
       self.sharedStates["PathFindingState"] ~= nil  --自动寻路状态 无法攻击状态不能攻击
       then 

        return
    end

    
    if self.role.moveSpeedVect < 0 then --角色移动方向向右
        self:addSharedState(TurnAroundState.new()) --转身
    end

    --self:changeState(AttackState.new())
    
    local atkState = self:getSharedState("GroundAttackState")
    --GamePrint ("---------------function RoleStateMachine:startAttack()")
    if state._name == "RunState" then
        if atkState == nil then
            self:addSharedState(GroundAttackState.new())
        else
            atkState:commbo(self.role)
        end
    else
        self:removeSharedStateByName("GroundAttackState")
        if self:getSharedState("AirAttackState") == nil 
            and not(self.previousState._name == "RunState" and state._name == "DropState")
            then
            local state = AirAttackState.new()
            if self.AirAttack == 1 then
                state.isCombo = true
                self:changeState(state)
            else
                self:changeState(state)
            end
        end
    end
end
--主角滑翔
function RoleStateMachine:startDive()
    local state = self.currentState
    if state == nil then
        return
    end

    if state._name == "BouncingState" or 
       state._name == "DeadState"then --弹跳状态不能切换
        return
    end

    if self.sharedStates["CantDiveState"] ~= nil or 
       self.sharedStates["PathFindingState"] ~= nil or --检测是否有自动寻路状态
       self.jumpStage~=TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_JUMP_CAP) --不是最后一段
       then -- 无法滑翔
        return 
    end

    if  state._name == "DoubleDropState" 
        or state._name == "DropState" 
        or state._name == "JumpTopState"
        
        then
        
        if self.role.moveSpeedVect < 0 then --角色移动方向向右
            self:addSharedState(TurnAroundState.new()) --转身
        end

        self:changeState (DiveState.new())
    end


end

function RoleStateMachine:stopDive()
    local state = self.currentState
    if state == nil then
        return
    end

    if state._name == "BouncingState" or 
       state._name == "DeadState"then --弹跳状态不能切换
        return
    end

    if state._name == "DiveState" then
        if self.jumpStage == 1 then
            self:changeState (DropState.new())
        elseif self.jumpStage >1 then
            self:changeState (DoubleDropState.new())
        end
    end
end

function RoleStateMachine:startSprint()
    local state = self.currentState
    if state == nil then
        print("state == nil")
        return
    end
    if state._name == "BouncingState" or 
       state._name == "PlayerHideState" or 
       state._name == "WallClimbState" or
       state._name == "SprintState" or --原本就是冲刺模式不切换
       self.role.moveSpeedVect < 0 or --向左移动不能切换
       self.sharedStates["PathFindingState"] ~= nil or  --自动寻路状态
       self.sharedStates["PlayingSkillState"] ~= nil or  --释放技能状态
       state._name == "DeadState"then --弹跳状态不能切换
        return
    end


    if self.sharedStates["CantSkillState"] ~= nil then --无法发技能状态不能发技能
        return 
    end
    if self.sharedStates["HolyState"] ~= nil then
        if self.role:getCaptainPetTypeID() ~= nil and self.role:getCaptainPetTypeID() == "13013" then
            return
        end
    end

    local battleScene = GetCurrentSceneUI()
    if battleScene.uiCtrl.skillCDOver == true then
        GamePrint("CD中。。。")
       return
    end
    if battleScene.BattleGuideView.isGuideLevel then
        GamePrint("新手引导中。。。")
        return
    end
    --test code
    if self.role:getCaptainPetTypeID() ~= nil then
        local pet = self.role:createPet(self.role:getCaptainPetTypeID())
        pet:triggerCaptainSkill()
    end
    --end
    do
        return
    end
    local suitState = self:getSharedState("SuitState")
    suitState:activateState(self.role)
    

end

------------------------------------------------------------------------------------------------
function RoleStateMachine:addSharedState( iState )
    --GamePrint ("------------------------------------ function RoleStateMachine:addSharedState( iState ) "..tostring(iState._name))
    if self.sharedStates == nil then
        self.sharedStates = {}
    end
    
    if iState.multiple ~= true then --单一状态
        self.sharedStates[iState._name] = iState
    else --多状态
        local multi = self.sharedStates[iState._name]
        if multi == nil then
            multi = {}
            self.sharedStates[iState._name] = multi
        end
        --print ("------------function RoleStateMachine:addSharedState( iState ) 2")
        table.insert(multi,iState)
    end
    iState:Enter(self.role)
end

function RoleStateMachine:removeSharedState( iState )
    --GamePrint ("------------------------------------ function RoleStateMachine:removeSharedState( iState ) "..tostring(iState.multiple).." "..tostring(iState._name))
    if iState._name ~=nil then
        if iState.multiple == true then --多状态
            --GamePrint("------------------function RoleStateMachine:removeSharedState( iState ) 1")
            local multi = self.sharedStates[iState._name]
            for i=1,#multi do
                if multi[i] == iState then
                    table.remove(multi,i)
                    break
                end
            end
        else --单一状态
            --GamePrint("------------------function RoleStateMachine:removeSharedState( iState ) 2")
            self.sharedStates[iState._name] = nil
        end
        iState:Exit(self.role)
    end
end
function RoleStateMachine:removeSharedStateByName( name )
    if self.sharedStates ==nil then
        return
    end
    local iState = nil
    for k, v in pairs(self.sharedStates) do 
        if v ~= nil and v._name == name then
            iState = v
            break
        end
    end
    if iState ~= nil then
        self:removeSharedState(iState)
    end
end

function RoleStateMachine:getSharedState(name)
    if name == nil then
        return
    end
    return self.sharedStates[name]
end

--获取坐骑共享状态
function RoleStateMachine:getMountState()
    if self.sharedStates == nil then
        return nil
    end
    
    for key,value in pairs(self.sharedStates) do
        if value ~= nil then
            if value._name == 'CNMMountState' 
                or value._name == "UFOMountState" then
                return value
            end
        end
    end
end

function RoleStateMachine:addStateChangeListener( listener )
    if self.stateChangeListeners == nil then
        self.stateChangeListeners = {}
    end

    if self.stateChangeListeners[listener._name] ~= nil then
        return
    end

    self.stateChangeListeners[listener._name] =listener
end

function RoleStateMachine:removeStateChangeListener( listener )
    if listener._name ~=nil then
        self.stateChangeListeners[listener._name] = nil
    end
end


