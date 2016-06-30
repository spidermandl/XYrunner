--[[
	author:gaofei
	请求天梯排行列表
]]
LadderListMsg = class(BaseMsg)

function LadderListMsg:Excute(response)
	self.callback:GetLadderListResponse(response)
end