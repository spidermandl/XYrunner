--[[
	author:gaofei
	定位赛结算
]]
LadderRaceEndMsg = class(BaseMsg)

function LadderRaceEndMsg:Excute(response)
	self.callback:getLadderRaceEndResponse(response)
end