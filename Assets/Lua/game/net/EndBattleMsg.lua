--[[
author:孙凯
剧情关卡结束
]]
EndBattleMsg = class (BaseMsg)

function EndBattleMsg:Excute(response)
	self.callback:getStoryRunningResponse(response)
end