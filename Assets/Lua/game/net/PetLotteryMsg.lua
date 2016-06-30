--[[
author:Huqiuxiang
融合萌宠反馈 PetLotteryMsg
]]

PetLotteryMsg = class(BaseMsg)
function PetLotteryMsg:Excute(response)
    self.callback:getPetLettory(response)
end