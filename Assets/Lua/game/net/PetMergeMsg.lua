--[[
author:Huqiuxiang
融合萌宠反馈 PetMergeMsg
]]

PetMergeMsg = class(BaseMsg)
function PetMergeMsg:Excute(response)
	--GamePrintTable("12121212121212")
	if self.funName ~= nil then
		self.callback[self.funName](self.callback,response)
		self.funName = nil
	else
    	self.callback:getMergePets(response)
	end
end