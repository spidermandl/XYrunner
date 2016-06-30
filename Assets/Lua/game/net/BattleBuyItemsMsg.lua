--[[
author:Huqiuxiang
跑酷前道具购买返回 BattleBuyItemsMsg
]]

BattleBuyItemsMsg = class(BaseMsg)
function BattleBuyItemsMsg:Excute(response)
    self.callback:getBuyItems(response)
end
