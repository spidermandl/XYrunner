--[[
	购买道具
]]
BuyItemMsg = class(BaseMsg)

function BuyItemMsg:Excute(response)
	self.callback:getBuyItems(response)
end