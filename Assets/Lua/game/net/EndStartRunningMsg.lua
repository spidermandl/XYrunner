--[[
author:Desmond
无尽开始酷跑消息
]]

EndStartRunningMsg = class(BaseMsg)

function EndStartRunningMsg:Excute(response)
	self.callback:getStartRunning(response)
end