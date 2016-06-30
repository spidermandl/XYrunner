--[[
	author:赵名飞
	获取城建数据
]]
BuildingInfoMsg = class(BaseMsg)

function BuildingInfoMsg:Excute(response)
	self.callback:GetBuildingInfo(response)
end