--[[
author:hanli_xiong
邮件列表消息
]]

EmailListMsg = class(BaseMsg)

function EmailListMsg:Excute(response)
	self.callback:GetSystemEmail(response)
end
