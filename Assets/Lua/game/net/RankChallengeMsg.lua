--[[
author:gaofei
请求天梯基础信息
]]

RankChallengeMsg = class(BaseMsg)

function RankChallengeMsg:Excute(response)
	self.callback:GetRankChallengeResponse(response)
end
