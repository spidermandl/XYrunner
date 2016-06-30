--[[
author:Huqiuxiang
升级萌宠反馈 PetLevelUpMsg
]]

PetLevelUpMsg = class(BaseMsg)
function PetLevelUpMsg:Excute(response)
	if self.callback.GetUpgradeMount ~= nil then
		self.callback:GetUpgradeMount(response)
	else
    	self.callback:getPetUpgrade(response)
    end
end
