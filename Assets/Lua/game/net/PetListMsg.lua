--[[
萌宠 列表返回
]]
PetListMsg = class(BaseMsg)
function PetListMsg:Excute(response)
	if self.funName ~= nil then
		self.callback[self.funName](self.callback,response)
	end
end