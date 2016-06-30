--[[
author:huqiuxiang
萌宠召唤
]]

PetCallingMsg = class(BaseMsg)

function PetCallingMsg:Excute(response)
	self.callback:getCallPet(response)
end