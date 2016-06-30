--[[
	author:赵名飞
	领取七日奖励
]]
SevenLoginMsg = class(BaseMsg)

function SevenLoginMsg:Excute(response)
	self.callback:getSevenLoginResponse(response)
end