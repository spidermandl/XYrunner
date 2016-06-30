--FriendRemoveMsg.lua
--[[
	author:赵名飞
	删除好友
]]
FriendRemoveMsg = class(BaseMsg)

function FriendRemoveMsg:Excute(response)
	self.callback:GetFriendRemoveResp(response)
end