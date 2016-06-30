--[[
author:huqiuxiang
无尽排名上升界面
]]
RankUpView = class()

RankUpView.scene = nil --场景scene
RankUpView.management = nil -- 数据model
RankUpView.panel = nil -- 面板 

-- 初始化界面
function RankUpView:init()
	self.panel = self.scene:LoadUI("Endless/EndlessRankUpUI")
end

