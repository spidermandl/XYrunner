--[[
	author:gaofei
	探险开始
]]
ExplorerStartMsg = class(BaseMsg)

function ExplorerStartMsg:Excute(response)
	self.callback:getStartRunning(response)
end