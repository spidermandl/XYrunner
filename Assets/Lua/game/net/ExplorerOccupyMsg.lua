--[[
author:gaofei
抢占夺宝成功的据点
]]
ExplorerOccupyMsg = class (BaseMsg)

function ExplorerOccupyMsg:Excute(response)
	self.callback:getExplorerOccupyRequest(response)
end