--[[
	author:赵名飞
	获取商城数据
]]
StoreInfoMsg = class(BaseMsg)

function StoreInfoMsg:Excute(response)
	self.callback:GetStoreInfoResp(response)
end