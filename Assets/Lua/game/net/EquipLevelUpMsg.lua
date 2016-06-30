--[[
author:Huqiuxiang
卸载物品反馈 EquipLevelUpMsg
]]

EquipLevelUpMsg = class(BaseMsg)
function EquipLevelUpMsg:Excute(response)
   self.callback:getEquiplevelUp(response)
end