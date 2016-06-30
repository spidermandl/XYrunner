--[[
author:Huqiuxiang
萌宠上下场反馈 PetJoinMsg
]]

PetJoinMsg = class(BaseMsg)
function PetJoinMsg:Excute(response)
    self.callback:getPetJoin(response)
end
