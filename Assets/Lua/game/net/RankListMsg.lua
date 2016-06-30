--RankListMsg
--[[
author:Huqiuxiang
排行榜数据反馈
]]

RankListMsg = class(BaseMsg)

function RankListMsg:Excute(response)
    self.callback:getRankData(response)
end