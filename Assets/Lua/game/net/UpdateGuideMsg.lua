--[[
author:huqiuixang
新手引导进度
]]

UpdateGuideMsg = class(BaseMsg)

function UpdateGuideMsg:Excute(response)
	self.callback:getGuideProgress(response)
end