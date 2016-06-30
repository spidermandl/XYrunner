--[[
author:赵名飞
神圣模式下落点
]]
HolyLandingPointMark = class(BaseItem)
HolyLandingPointMark.type = "HolyLandingPointMark"

HolyLandingPointMark.player = nil --玩家

function HolyLandingPointMark:Awake()
	self.super.Awake(self)
end

function HolyLandingPointMark:initParam()
	self.super.initParam(self)
	--记录神圣模式降落的点
	self.itemManager:addHolyLandingPoint(self.gameObject.transform.position)
    self:inactiveSelf()
end


--获取和玩家的距离
function HolyLandingPointMark:getPlayerDistance()
	if self.player == nil then
		self.player = LuaShell.getRole(LuaShell.DesmondID)
	end
	return self.gameObject.transform.position.x - self.player.gameObject.transform.position.x

end