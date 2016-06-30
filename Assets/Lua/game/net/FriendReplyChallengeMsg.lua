--FriendReplyChallengeMsg.lua
--[[
	author:赵名飞
	好友应战
]]
FriendReplyChallengeMsg = class(BaseMsg)

function FriendReplyChallengeMsg:Excute(response)
	self.callback:GetEndRunningReplyChallengeResp(response)
end