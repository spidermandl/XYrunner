--[[
	author:gaofei
	获取当前分配给玩家的探险点
]]
ExplorerListMsg = class(BaseMsg)

function ExplorerListMsg:Excute(response)
	self.callback:ExplorerListMessageListen(response)
end