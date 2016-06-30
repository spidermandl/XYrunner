--[[
author:hanli_xiong
开始酷跑消息
]]

StartRunningMsg = class(BaseMsg)

function StartRunningMsg:Excute(response)
	self.callback:getStartRunning(response)
end