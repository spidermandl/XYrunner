--[[
	author:gaofei
	确定段位
]]
LadderLevelConfirmMsg = class(BaseMsg)

function LadderLevelConfirmMsg:Excute(response)
	self.callback:GetLadderLevelConfirmResponse(response)
end