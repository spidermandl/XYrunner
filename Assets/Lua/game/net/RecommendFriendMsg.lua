--[[
	author:赵名飞
	推荐好友
]]
RecommendFriendMsg = class(BaseMsg)

function RecommendFriendMsg:Excute(response)
	self.callback:GetFriendRecommendResp(response)
end