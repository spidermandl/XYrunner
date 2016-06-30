--[[
	author:赵名飞
	好友添加Msg
]]
FriendAddMsg = class(BaseMsg)

function FriendAddMsg:Excute(response)
	self.callback:GetFriendAddResp(response)
end