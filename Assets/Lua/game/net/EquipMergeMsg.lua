--[[
author:Huqiuxiang
装备融合反馈 EquipMergeMsg
]]
local json = require "cjson"
EquipMergeMsg = {}

EquipMergeMsg = class(BaseMsg)
function EquipMergeMsg:Excute(response)
   self.callback:getEquipMerge(response)
end