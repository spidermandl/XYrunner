--[[
author:赵名飞
复活点
]]
RevivePointMark = class(BaseItem)
RevivePointMark.type = "RevivePointMark"

RevivePointMark.player = nil --玩家

function RevivePointMark:Awake()
	self.super.Awake(self)
end

function RevivePointMark:initParam()
	self.super.initParam(self)
	--记录大黄鸭的点
	self.itemManager:addRevivePoint(self.gameObject.transform.position)
    self:inactiveSelf()
end


--获取和玩家的距离
function RevivePointMark:getPlayerDistance()
	if self.player == nil then
		self.player = LuaShell.getRole(LuaShell.DesmondID)
	end
	return self.gameObject.transform.position.x - self.player.gameObject.transform.position.x

end