--FriendFindMsg.lua
--[[
	author:赵名飞
	好友添加Msg
]]
FriendFindMsg = class(BaseMsg)

function FriendFindMsg:Excute(response)
	self.callback:GetFriendFindResp(response)
end