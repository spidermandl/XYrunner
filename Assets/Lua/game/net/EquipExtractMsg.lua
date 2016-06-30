--[[
author:Huqiuxiang
抽取物品反馈
]]

EquipExtractMsg = class(BaseMsg)

function EquipExtractMsg:Excute(response)

	self.callback:getEquipExtract(response)
end