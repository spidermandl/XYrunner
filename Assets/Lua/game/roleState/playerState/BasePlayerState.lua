--[[
author:Desmond
玩家基础状态
]]
BasePlayerState = class (IState)
BasePlayerState.animator = nil --人物动作或坐骑动作

--IState._name = "IState"
--[[ role:角色 为lua对象 ]]
function BasePlayerState:Enter(role)
    --print ("-----------------------function BasePlayerState:Enter(role) 1")
	self.animator = role.character:GetComponent("Animator")
    if role:hasMount() == true then  --判断有座骑
        local mountstate = role:getMountState()--获取座骑状态
        --print ("-----------------------function BasePlayerState:Enter(role) "..tostring(mountstate).." "..mountstate._name)
        self.animator = mountstate:getMountAnimator()
    end
	
end

--[[ 
role:角色 为lua对象
dTime:update时间间隔
]]
function BasePlayerState:Excute(role,dTime,xSpeed)
    if xSpeed ~= nil then
        role.property.moveDir.x = xSpeed
    else
        role.property.moveDir.x = role:getMoveSpeed()
    end
end

--[[ role:角色 为lua对象 ]]
function BasePlayerState:Exit(role)
	-- body
end

--[[
攻击状态进入调用
]]
function BasePlayerState:BaseAttackEnter(role,isFly)
    role:countATK() --记录攻击次数
    local ackTimes = role:getATKCount()
    --and role:isPetOn(TxtFactory.S_ROLE_CHINCHILLAS_ID) == true
    --if (ackTimes % RoleProperty.AttackTimesMax) == 0 and role:isPetOn(TxtFactory.S_ROLE_CHINCHILLAS_ID) == true then --满足龙猫触发条件
    --    role:createPet(TxtFactory.S_ROLE_CHINCHILLAS_ID)
    --end

    local config_id =TxtFactory:getTable(TxtFactory.MemDataCache):getPlayerSuit()
    local sSuit = TxtFactory:getTable(TxtFactory.SuitTXT)
    config_id = sSuit:GetData(config_id,TxtFactory.S_SUIT_TYPE)
    local sex =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)[TxtFactory.USER_SEX]
    
    local atkTable = TxtFactory:getTable(TxtFactory.ATKAnimTXT)
    --GamePrint("--------function BasePlayerState:BaseAttackEnter(role,isFly) "..tostring(config_id).." "..tostring(sex))
    if isFly == nil then
        return atkTable:getATKarrayBySuitAndSex(config_id,sex)
    else
        return atkTable:getAirATKBySuitAndSex(config_id,sex)
    end

    -- if role:hasMount() == true then --有座骑
    --     self.super.playAnimation(self,role,"attack on ground")
    --     return
    -- end
    
    -- self.isLanded = self.super.isOnGround(self,role)
end

--[[-------------------------------------------------------逻辑------------------------------------------------------------------------------]]
--播放主角动画
function BasePlayerState:playAnimation(role,name)
    --print ("------------------function BasePlayerState:playAnimation(role,name) "..tostring(name))
    if role:hasMount() == true then  --判断有座骑
        local mountstate = role:getMountState()--获取座骑状态
        --print ("-----------------function BasePlayerState:playAnimation(role,name) 2")
        mountstate:playMountAnimation(name)
        return
    end
    --GamePrint ("-------------------------------->>>>>>>>>> function BasePlayerState:playAnimation(role,name) "..name )
    self.animator:Play(name)
end

--[[ 下降base逻辑 
     返回 多地高度,是否碰地面]]
function BasePlayerState:BaseDrop(role,dTime)
	--print ("-------------------------------->>>>>>>>>> function BasePlayerState:BaseDrop(role,dTime)")
	local dHeight = (role.property.moveDir.y + role.property.dropACC* dTime) * dTime--这一时刻y执行距离
    local pos = role.gameObject.transform.position
    pos.y=pos.y + role.collider.height/2 
    local layer = UnityEngine.LayerMask.NameToLayer("Step")
	local flag,hitinfo = UnityEngine.Physics.Raycast (
        pos, UnityEngine.Vector3.down, nil, role.collider.height/2 + dHeight,2^layer)
    local road = nil --碰撞的路面
    if flag ==true then --判断碰撞物是否为地面
    	flag = false
        road = LuaShell.getRole(hitinfo.collider.gameObject:GetInstanceID())
        if road ~= nil then
            --GamePrint ("-------------------------------->>>>>>>>>> function BasePlayerState:BaseDrop(role,dTime) "..tostring(obj.type))
        	if tostring(road.type) == "MonoSurface" or tostring(road.type) == "RoadSurface" then
                --GamePrint ("-------------------------------->>>>>>>>>> function BasePlayerState:BaseDrop(role,dTime) 1")
        		flag = true
        	end
        end
    end

	--下降过程:
	--一直下降直到撞击平面
	if flag == false then
		role.property.moveDir.y = role.property.moveDir.y + role.property.dropACC* dTime
        role.gameObject.transform:Translate(role.property.moveDir.x*dTime,-dHeight,0, Space.World)
	-- 下降至地面:
	else
        --GamePrint("触碰地面!!!!")
        local del_y = hitinfo.point.y - role.gameObject.transform.position.y
        role.gameObject.transform:Translate(role.property.moveDir.x*dTime,del_y+0.001,0, Space.World)
        role.property.moveDir.y = 0
        --GamePrint ("-------------------------------->>>>>>>>>> function BasePlayerState:BaseDrop(role,dTime) 2")
        role.stateMachine:changeState(RunState.new())
	end

	return role.gameObject.transform.position.y,flag,road
end


--[[ 落地判断,下一帧即将落地 ]]
function BasePlayerState:isLanding(role,dTime)
	local dHeight = (math.abs(role.property.moveDir.y) + role.property.dropACC* dTime) * dTime--这一时刻y执行距离
    local layer = UnityEngine.LayerMask.NameToLayer("Step")
	local flag,hitinfo = UnityEngine.Physics.Raycast (role.gameObject.transform.position, UnityEngine.Vector3.down, nil, dHeight,2^layer)

    if flag ==true then
    	flag = false
        local obj = LuaShell.getRole(hitinfo.collider.gameObject:GetInstanceID())
        if obj ~= nil then
        	if tostring(obj.type) == "MonoSurface" or tostring(obj.type) == "RoadSurface" then
        		flag = true
        	end
        end
    end

	return flag
end

--[[ 地面判断 ]]
function BasePlayerState:isOnGround(role)
	local pos = role.gameObject.transform.position
	pos.y=pos.y + role.collider.height/2 
    local layer = UnityEngine.LayerMask.NameToLayer("Step")
	local flag,hitinfo = UnityEngine.Physics.Raycast (pos, 
		UnityEngine.Vector3.down, nil, role.collider.height/2+0.01,2^layer)

    if flag ==true then
    	flag = false
        local obj = LuaShell.getRole(hitinfo.collider.gameObject:GetInstanceID())
        if obj ~= nil then
        	if tostring(obj.type) == "MonoSurface" or tostring(obj.type) == "RoadSurface"  then
                --print ("--------------->>>>>>> BasePlayerState:isOnGround "..tostring(hitinfo.point.y).." "..tostring(role.gameObject.transform.position.y))
    		    --防止陷入地里
                --print (tostring(hitinfo.point.y - role.gameObject.transform.position.y))
                local del_y = hitinfo.point.y - role.gameObject.transform.position.y
                if del_y > 0.01 then
                    role.gameObject.transform:Translate(0,del_y - 0.001,0)
                end
                flag = true
        	end
        end
    end

	return flag
end