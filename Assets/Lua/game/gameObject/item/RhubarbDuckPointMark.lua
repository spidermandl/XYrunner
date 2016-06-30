--[[
author:Desmond
大黄鸭飞行路径点
]]
RhubarbDuckPointMark = class(BaseItem)
RhubarbDuckPointMark.type = "RhubarbDuckPointMark"

RhubarbDuckPointMark.player = nil --玩家

function RhubarbDuckPointMark:Awake()
	self.super.Awake(self)
end

--获取和玩家的距离
function RhubarbDuckPointMark:getPlayerDistance()
	if self.player == nil then
		self.player = LuaShell.getRole(LuaShell.DesmondID)
	end
	return self.gameObject.transform.position.x - self.player.gameObject.transform.position.x
end