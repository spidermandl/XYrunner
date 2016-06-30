--FriendChallengeMsg.lua
--[[
	author:赵名飞
	好友挑战
]]
FriendChallengeMsg = class(BaseMsg)

function FriendChallengeMsg:Excute(response)
	self.callback:GetEndRunningChallengeResp(response)
end