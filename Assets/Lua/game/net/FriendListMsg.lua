--[[
	author:赵名飞
	好友列表Msg
]]
FriendListMsg = class(BaseMsg)

function FriendListMsg:Excute(response)
	self.callback:GetFriendListResp(response)
end