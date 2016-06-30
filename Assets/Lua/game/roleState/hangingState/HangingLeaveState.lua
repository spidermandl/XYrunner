--[[
author:Desmond
弹墙离开的瞬间
]]
HangingLeaveState = class (IState)
HangingLeaveState._name = "HangingLeaveState"
HangingLeaveState.layer = nil
HangingLeaveState.startTime = nil

--[[ item:item 为lua对象 ]]
function HangingLeaveState:Enter(item)
	GamePrint("---------------function HangingLeaveState:Enter(item) ")
	item.player.stateMachine:removeSharedState(HangingBlockState.new())
	item.collider.isTrigger = true
	self.layer = UnityEngine.LayerMask.NameToLayer("Step")
    
    self.startTime = UnityEngine.Time.time
end

--[[ 
item:item 为lua对象
dTime:update时间间隔
]]
function HangingLeaveState:Excute(item,dTime)
    
    -- if UnityEngine.Time.time - self.startTime >0.5 then
    -- 	GamePrint("----------function HangingLeaveState:Excute(item,dTime) 1 ")
    -- 	item.stateMachine:changeState(HangingNormalState.new())
    -- end
	local pos_bot = item.gameObject.transform.position
	local pos_top = UnityEngine.Vector3(pos_bot.x,pos_bot.y+item.collider.height,pos_bot.z)
	--GamePrint("----------function HangingLeaveState:Excute(item,dTime) 1 ")
	if item.player.moveSpeedVect > 0 then
		local 
		flag,hitinfo = UnityEngine.Physics.Raycast (pos_bot,UnityEngine.Vector3.left, nil, item.collider.radius+0.1,2^self.layer)
		-- 任意一个触碰 则返回
		--GamePrint("----------function HangingLeaveState:Excute(item,dTime) 2 ")
		if flag == true and self:isHit(hitinfo) == true then
			--GamePrint("----------function HangingLeaveState:Excute(item,dTime) 3 ")
			return
		end
		flag,hitinfo = UnityEngine.Physics.Raycast (pos_top,UnityEngine.Vector3.left, nil, item.collider.radius+0.1,2^self.layer)
		--GamePrint("----------function HangingLeaveState:Excute(item,dTime) 4 ")
		if flag == true and self:isHit(hitinfo) == true then
			--GamePrint("----------function HangingLeaveState:Excute(item,dTime) 5 ")
			return
		end

		item.stateMachine:changeState(HangingNormalState.new())

	else
		local
		flag,hitinfo = UnityEngine.Physics.Raycast (pos_bot,UnityEngine.Vector3.right, nil, item.collider.radius,2^self.layer)
		--GamePrint("----------function HangingLeaveState:Excute(item,dTime) 6 ")
		if flag == true and self:isHit(hitinfo) == true then
			--GamePrint("----------function HangingLeaveState:Excute(item,dTime) 7 ")
			return
		end
        --GamePrint("----------function HangingLeaveState:Excute(item,dTime) 8 ")
		flag,hitinfo = UnityEngine.Physics.Raycast (pos_top,UnityEngine.Vector3.right, nil, item.collider.radius,2^self.layer)
		if flag == true and self:isHit(hitinfo) == true then
			--GamePrint("----------function HangingLeaveState:Excute(item,dTime) 9 ")
			return
		end

		item.stateMachine:changeState(HangingNormalState.new())

	end
    
    --没有任何触碰
    --GamePrint("---------------function HangingOnProgressState:Excute(item,dTime) ")
end

--[[ item:item 为lua对象 ]]
function HangingLeaveState:Exit(item)
	item.collider.isTrigger = false
end

--检测是否碰撞
function HangingLeaveState:isHit( hitinfo )
	if hitinfo == nil or hitinfo.collider == nil then
		return false
	end
	
	local obj = LuaShell.getRole(hitinfo.collider.gameObject:GetInstanceID())
    if obj ~= nil then
    	if tostring(obj.type) == "HangingSurface" then
            return true
    	end
    end

	return false
end


