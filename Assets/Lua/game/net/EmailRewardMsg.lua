--[[
author:hanli_xiong
领取邮件奖励
]]

EmailRewardMsg = class(BaseMsg)

function EmailRewardMsg:Excute(response)
	self.callback:GetEmailReward(response)
end
