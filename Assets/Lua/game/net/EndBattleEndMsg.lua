--[[
author:Desmond
无尽关卡结束
]]
EndBattleEndMsg = class (BaseMsg)

function EndBattleEndMsg:Excute(response)
	self.callback:getEndRunningResponse(response)
end