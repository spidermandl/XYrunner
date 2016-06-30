--[[
	author:gaofei
	探险结束汇报
]]
ExplorerEndMsg = class(BaseMsg)

function ExplorerEndMsg:Excute(response)
	self.callback:getStrongholdRequest(response)
end 