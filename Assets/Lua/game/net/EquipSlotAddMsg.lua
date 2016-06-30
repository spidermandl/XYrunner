--EquipSlotAddMsg
--[[
author:Huqiuxiang
获得角色反馈
]]
EquipSlotAddMsg = class(BaseMsg)

function EquipSlotAddMsg:Excute(response)
    self.callback:getExtendSlot(response)
end