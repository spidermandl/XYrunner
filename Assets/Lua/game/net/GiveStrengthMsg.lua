--GiveStrengthMsg.lua
--[[
	author:赵名飞
	赠送体力
]]
GiveStrengthMsg = class(BaseMsg)

function GiveStrengthMsg:Excute(response)
	self.callback:GetGiveStrengthResp(response)
end