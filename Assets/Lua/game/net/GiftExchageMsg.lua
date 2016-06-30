--[[
author:hanli_xiong
兑换礼品消息
]]

GiftExchageMsg = class(BaseMsg)

function GiftExchageMsg:Excute(response)
	self.callback:GetExchangeGift(response)
end