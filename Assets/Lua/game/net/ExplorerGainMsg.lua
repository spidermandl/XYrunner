--[[
author:gaofei
收获自己据点的金币消息
]]

ExplorerGainMsg = class(BaseMsg)

function ExplorerGainMsg:Excute(response)
	self.callback:ExplorerGainMessageListen(response)
end