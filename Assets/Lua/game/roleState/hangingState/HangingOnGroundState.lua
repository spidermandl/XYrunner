--[[
author:Desmond
碰到墙壁并且落地
]]
HangingOnGroundState = class (IState)
HangingOnGroundState._name = "HangingOnGroundState"
HangingOnGroundState.layer = nil
HangingOnGroundState.hasXadjusted = false
--[[ item:item 为lua对象 ]]
function HangingOnGroundState:Enter(item)
	GamePrint("---------------function HangingOnGroundState:Enter(item) ")
	item.collider.isTrigger = true
	self.layer = UnityEngine.LayerMask.NameToLayer("Step")
end

--[[ 
item:item 为lua对象
dTime:update时间间隔
]]
function HangingOnGroundState:Excute(item,dTime)
	local pos_bot = item.gameObject.transform.position
	if self.hasXadjusted == true then
		return
	end
	
	local flag,hitinfo = UnityEngine.Physics.Raycast (pos_bot,UnityEngine.Vector3.right, nil, item.collider.radius,2^self.layer)
	if flag == true and self:isHit(hitinfo) == true then
		local collider_x = hitinfo.collider.gameObject.transform.position.x
		local del_x = item.collider.radius - (collider_x - pos_bot.x)
		item.player.gameObject.transform:Translate(-del_x,0,0)
		self.hasXadjusted = true
		return
	end

	local pos_top = UnityEngine.Vector3(pos_bot.x,pos_bot.y+item.collider.height,pos_bot.z)
	--GamePrint("----------function HangingOnProgressState:Excute(item,dTime) "..tostring(pos_bot).." radius"..tostring(item.collider.radius+0.1))
	local 
	flag,hitinfo = UnityEngine.Physics.Raycast (pos_top,UnityEngine.Vector3.left, nil, 2*item.collider.radius,2^self.layer)
	if flag == true and self:isHit(hitinfo) == true then
		return
	end

	flag,hitinfo = UnityEngine.Physics.Raycast (pos_top,UnityEngine.Vector3.right, nil, 2*item.collider.radius,2^self.layer)
	if flag == true and self:isHit(hitinfo) == true then
		return
	end

	item.stateMachine:changeState(HangingNormalState.new())

end

--[[ collider:collider 为lua对象 ]]
function HangingOnGroundState:Exit(item)
end

function HangingOnGroundState:isHit( hitinfo )
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