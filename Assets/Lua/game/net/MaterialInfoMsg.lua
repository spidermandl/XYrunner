--[[
author:hanli_xiong
材料列表返回消息
]]


MaterialInfoMsg = class(BaseMsg)

function MaterialInfoMsg:Excute(response)
    self.callback:getMaterialList(response)
end
