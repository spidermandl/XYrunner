--[[
author:huqiuxiang
无尽排名结算界面
]]
EndlessSettlementView = class()

EndlessSettlementView.scene = nil --场景scene
EndlessSettlementView.management = nil -- 数据model
EndlessSettlementView.panel = nil -- 面板 

-- 初始化界面
function EndlessSettlementView:init()
	self.panel = self.scene:LoadUI("Endless/EndlessSettlementUI")
end

