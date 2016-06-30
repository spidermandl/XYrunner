
--[[
author:Huqiuxiang
获得角色反馈
]]

EquipInfoGetMsg = class(BaseMsg)

function EquipInfoGetMsg:Excute(response)
    self.callback:getEquipInfo(response)
end