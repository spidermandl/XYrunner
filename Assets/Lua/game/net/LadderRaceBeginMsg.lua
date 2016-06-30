--[[
	author:gaofei
	定位赛开始
]]
LadderRaceBeginMsg = class(BaseMsg)

function LadderRaceBeginMsg:Excute(response)
	self.callback:getLadderRaceBeginMessage(response)
end