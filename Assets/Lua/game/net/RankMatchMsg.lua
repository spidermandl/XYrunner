--[[
	author:gaofei
	异步pvp 匹配对手
]]
RankMatchMsg = class(BaseMsg)

function RankMatchMsg:Excute(response)
	self.callback:getRankMatchResponse(response)
end