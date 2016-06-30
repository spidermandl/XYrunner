--[[
author:gaofei
晋级挑战开始 回复
]]
LadderUpgradeStartMsg = class(BaseMsg)

function LadderUpgradeStartMsg:Excute(response)
    self.callback:getLadderUpgradeStartMessage(response)
end