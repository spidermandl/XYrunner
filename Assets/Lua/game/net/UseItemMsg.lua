--[[
	author:赵名飞
	关卡消耗道具
]]
UseItemMsg = class(BaseMsg)

function UseItemMsg:Excute(response)
	self.callback:GetUseItemResp(response)
end