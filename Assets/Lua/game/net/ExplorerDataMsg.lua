
--[[
author:gaofei
获得夺宝奇兵信息
]]

ExplorerDataMsg = class(BaseMsg)

function ExplorerDataMsg:Excute(response)
    self.callback:ExplorerDataResponseMessageListen(response)
end