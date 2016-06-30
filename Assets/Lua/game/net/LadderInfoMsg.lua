--[[
author:gaofei
请求天梯基础信息
]]

LadderInfoMsg = class(BaseMsg)

function LadderInfoMsg:Excute(response)
	self.callback:GetLadderInfoResponse(response)
end
