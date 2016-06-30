--EquipItemMsg
--[[
author:Huqiuxiang
装备物品反馈
]]

EquipItemMsg = class(BaseMsg)

function EquipItemMsg:Excute(response)
    self.callback:getEquipItem(response)

end