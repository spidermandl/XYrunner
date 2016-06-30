--[[
author:Desmond
正在吸墙过程中
]]
HangingOnProgressState = class (IState)
HangingOnProgressState._name = "HangingOnProgressState"
HangingOnProgressState.layer = nil
HangingOnProgressState.hasXadjusted = nil

--[[ item:item 为lua对象 ]]
function HangingOnProgressState:Enter(item)
	GamePrint("---------------function HangingOnProgressState:Enter(item) ")
	item.collider.isTrigger = true
	self.hasXadjusted = false
	self.layer = UnityEngine.LayerMask.NameToLayer("Step")
end

--[[ 
item:item 为lua对象
dTime:update时间间隔
]]
function HangingOnProgressState:Excute(item,dTime)
	local pos_bot = item.gameObject.transform.position
	local pos_top = UnityEngine.Vector3(pos_bot.x,pos_bot.y+item.collider.height,pos_bot.z)
	--GamePrint("----------function HangingOnProgressState:Excute(item,dTime) "..tostring(pos_bot).." radius"..tostring(item.collider.radius+0.1))
	local 
	flag,hitinfo = UnityEngine.Physics.Raycast (pos_bot,UnityEngine.Vector3.left, nil, 2*item.collider.radius+0.1,2^self.layer)
	-- 任意一个触碰 则返回
	--GamePrint("---------------function HangingOnProgressState:Excute(item,dTime) 1 "..tostring(flag).." "..tostring(self:isHit(hitinfo)))
	if flag == true and self:isHit(hitinfo) == true then
		if self.hasXadjusted ~= true then
			self:setLeftFaceTouch(item,hitinfo,pos_bot.x)
		end
		return
	end
	flag,hitinfo = UnityEngine.Physics.Raycast (pos_top,UnityEngine.Vector3.left, nil, 2*item.collider.radius+0.1,2^self.layer)
	--GamePrint("---------------function HangingOnProgressState:Excute(item,dTime) 2 "..tostring(flag).." "..tostring(self:isHit(hitinfo)))
	if flag == true and self:isHit(hitinfo) == true then
		if self.hasXadjusted ~= true then
			self:setLeftFaceTouch(item,hitinfo,pos_top.x)
		end
		return
	end
	flag,hitinfo = UnityEngine.Physics.Raycast (pos_bot,UnityEngine.Vector3.right, nil, 2*item.collider.radius,2^self.layer)
	if flag == true and self:isHit(hitinfo) == true then
		if self.hasXadjusted ~= true then
			self:setRightFaceTouch(item,hitinfo,pos_bot.x)
		end
		return
	end

	flag,hitinfo = UnityEngine.Physics.Raycast (pos_top,UnityEngine.Vector3.right, nil, 2*item.collider.radius,2^self.layer)
	if flag == true and self:isHit(hitinfo) == true then
		if self.hasXadjusted ~= true then
			self:setRightFaceTouch(item,hitinfo,pos_top.x)
		end
		return
	end
    
    --没有任何触碰
    --GamePrint("---------------function HangingOnProgressState:Excute(item,dTime) ")
	item.player.stateMachine:changeState(DropState.new())
end

--[[ item:item 为lua对象 ]]
function HangingOnProgressState:Exit(item)
end

--检测是否碰撞
function HangingOnProgressState:isHit( hitinfo )
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

function HangingOnProgressState:setRightFaceTouch(item,hitinfo,player_x)
	local collider_x = hitinfo.collider.gameObject.transform.position.x
	local del_x = item.collider.radius - (collider_x - player_x)
	item.player.gameObject.transform:Translate(-del_x,0,0)
	self.hasXadjusted = true
end

function HangingOnProgressState:setLeftFaceTouch( item,hitinfo,player_x)
	local collider_x = hitinfo.collider.gameObject.transform.position.x
	local del_x = item.collider.radius - (player_x - collider_x)
	item.player.gameObject.transform:Translate(del_x,0,0)
	self.hasXadjusted = true
end


