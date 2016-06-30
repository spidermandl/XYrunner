--UnEquipMsg
--[[
author:Huqiuxiang
卸载物品反馈
]]

UnEquipMsg = class(BaseMsg)

function UnEquipMsg:Excute(response)
	
    self.callback:getUnequip(response)

end