--[[
	author:赵名飞
	购买道具
]]
StoreBuyItemMsg = class(BaseMsg)

function StoreBuyItemMsg:Excute(response)
	self.callback:BuyItem_resp(response)
end