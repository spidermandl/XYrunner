--[[
author:gaofei
获取自己占的据点信息
]]
ExplorerInfoMsg = class (BaseMsg)

function ExplorerInfoMsg:Excute(response)
	self.callback:getExplorerInfoRequest(response)
end