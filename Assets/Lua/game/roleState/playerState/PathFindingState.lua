--PathFindingState.lua
--[[
	author:赵名飞
	自动寻路状态（共享状态）
	磁铁，无敌，不可控制
]]
PathFindingState = class (BasePlayerState)

PathFindingState._name = "PathFindingState"

PathFindingState.nextPoint = nil --下一个运动点
PathFindingState.startTime = 0 --开始时间
PathFindingState.duringTime = 0 --持续时间
PathFindingState.X_MoveSpeed = 0 --x轴移动速度
PathFindingState.Z_MoveSpeed = 0 --z轴移动速度
PathFindingState.MagnetState = nil --磁铁状态
PathFindingState.CleanState = nil --清屏状态
PathFindingState.CleanMonsterDistance = 0--清屏距离
--摆动模型
PathFindingState.isNeedSwing = false --是否上下摆动模型
PathFindingState.moveUp = true --是否向上移动
PathFindingState.UpSpeed = 1 --上升速度
PathFindingState.DownSpeed = 2 --下降速度
PathFindingState.MaxY = 1 --Y轴最高点
PathFindingState.MinY = 0 --Y轴最低点
function PathFindingState:Enter(role)

    GamePrint("------------PathFindingState:Enter ")
	self.super.Enter(self,role)
    --清除冲突状态
    role.stateMachine:removeSharedStateByName("InvincibleState")
    role.stateMachine:removeSharedStateByName("MagnetState")
    role.stateMachine:removeSharedStateByName("CleanMonsterState")
    --加入磁铁状态
    self.MagnetState = MagnetState.new()
    self.MagnetState.stage = 2
    self.MagnetState.distance = ConfigParam.CoinDistance * 2
    self.MagnetState.duringTime = 0--手动退出磁铁
    self.MagnetState.isShowEffect = false
    role.stateMachine:addSharedState(self.MagnetState)
    --加入清屏状态
    self.CleanState = CleanMonsterState.new()
    self.CleanState.CleanMonsterDistance = self.CleanMonsterDistance
    role.stateMachine:addSharedState(self.CleanState)

    --[[
    --设置boxCollider
    role.collider.radius=8
    role.collider.height=60
    role.collider.direction = 2
    ]]
    self.itemManager = PoolFunc:pickSingleton("ItemGroup")
    self.startTime = UnityEngine.Time.time
end
--上下移动模型
function PathFindingState:MoveModels(model,dTime)
   if self.moveUp then
        model.localPosition = Vector3(0,model.transform.localPosition.y + dTime*self.UpSpeed,0)
        if model.transform.localPosition.y >= self.MaxY then --到达最高点
            self.moveUp = false
        end
    else
        model.localPosition = Vector3(0,model.transform.localPosition.y - dTime*self.DownSpeed,0)
        if model.transform.localPosition.y <= self.MinY then --到达最低点
           self.moveUp = true
        end 
    end
end
function PathFindingState:Excute(role,dTime)
    if self.nextPoint == nil or role.stateMachine.sharedStates["HolyState"] ~= nil then --还未生成下一个移动点
            role.gameObject.transform:Translate(self.X_MoveSpeed*dTime,0,0)
            local point = self.itemManager:getNearestPointMarkByType("RhubarbDuckPointMark")
            self.nextPoint = point
            if point ~= nil then
                return
            end
            --[[
        if UnityEngine.Time.time - self.startTime < self.duringTime then
            role.gameObject.transform:Translate(self.X_MoveSpeed*dTime,0,0)
            if self.isNeedSwing then
            	self:MoveModels(role.character,dTime)
            end
            local point = self.itemManager:getNearestPointMarkByType("RhubarbDuckPointMark")
            self.nextPoint = point
            if point ~= nil then
                return
            end
        else
            --退出寻路状态
            self:ResetChange(role)
            role.stateMachine:changeState(HolyDropState.new())
        end
        ]]

    else --向下一个移动点移动
        local new_distance = UnityEngine.Vector3.Distance(role.gameObject.transform.position,self.nextPoint.transform.position)
		if new_distance < 0.1  then -- 到达一个路径点
	        self.nextPoint = nil
            --在到达路径点后判断时间
            if UnityEngine.Time.time - self.startTime < self.duringTime then
                role.gameObject.transform:Translate(self.X_MoveSpeed*dTime,0,0)
            else
                --退出寻路状态
                self:ResetChange(role)
                role.stateMachine:changeState(HolyDropState.new())
            end
        else
            local moveDir = self.nextPoint.transform.position - role.gameObject.transform.position
            if math.abs(moveDir.z) > 1 then -- z轴移动 速度不一样
                local new_position = Vector3.MoveTowards(role.gameObject.transform.position,self.nextPoint.transform.position,dTime * self.Z_MoveSpeed)
                role.gameObject.transform.position = new_position
            else
                if self.isNeedSwing then
            		self:MoveModels(role.character,dTime)
            	end
                local new_position = Vector3.MoveTowards(role.gameObject.transform.position,self.nextPoint.transform.position,dTime * self.X_MoveSpeed)
                role.gameObject.transform.position = new_position
            end
	    end

	    
    end
end
--在退出状态的时候重置collider
function PathFindingState:ResetChange(role)
    --[[
    role.collider.radius=0.8
    role.collider.height=2
    role.collider.direction = 1
    ]]
    role.character.localPosition = UnityEngine.Vector3(0,0,0)
    role.stateMachine:removeSharedState(self.CleanState)
    role.stateMachine:removeSharedState(self.MagnetState)
    role.stateMachine:removeSharedState(self)
    role.isBlocked = false
end