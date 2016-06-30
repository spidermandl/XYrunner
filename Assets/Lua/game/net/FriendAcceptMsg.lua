--[[
	author:赵名飞
	好友 接受或者拒绝某申请Msg
]]
FriendAcceptMsg = class(BaseMsg)

function FriendAcceptMsg:Excute(response)
	self.callback:GetFriendAcceptResp(response)
end