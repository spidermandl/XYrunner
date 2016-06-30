
--[[
author:gaofei
夺宝奇兵换一批
]]

ExplorerReferMsg = class(BaseMsg)

function ExplorerReferMsg:Excute(response)
    self.callback:ExplorerReferMsgResponseMessageListen(response)
end