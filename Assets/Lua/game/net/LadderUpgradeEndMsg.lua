--[[
author:gaofei
晋级挑战汇报
]]
LadderUpgradeEndMsg = class(BaseMsg)

function LadderUpgradeEndMsg:Excute(response)
    self.callback:getLadderUpgradeEndResponse(response)
end