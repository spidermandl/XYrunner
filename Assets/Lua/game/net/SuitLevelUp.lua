--[[
author:Desmond
套装升级协议
]]
SuitLevelUp = class(BaseMsg)

function SuitLevelUp:Excute(response)

    local json = require "cjson"
 	local tab = json.decode(response.data)
    self.callback:getSuitUpgrade(tab) -- 通知升级信息回调
end