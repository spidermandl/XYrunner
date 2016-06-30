--[[
author:huqiuxiang
萌宠变异
]]

PetVariationMsg = class(BaseMsg)

function PetVariationMsg:Excute(response)
	self.callback:getPetVariation(response)
end