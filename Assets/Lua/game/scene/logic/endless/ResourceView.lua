--[[
author:huqiuxiang
资源图标面板
]]

require "game/scene/common/PlayerTopInfo"

ResourceView = class()

ResourceView.scene = nil --场景scene
ResourceView.management = nil -- 数据model

ResourceView.panel = nil  -- 开头界面面板

-- 初始化界面
function ResourceView:init()
	self.panel = self.scene:LoadUI("common/CommonTopUI")
	-- self.panel.gameObject.transform.localPosition = Vector3(300,50,0)

	self.management = self.scene.endlessManagement
	self.scene:boundButtonEvents(self.panel)	
end

function ResourceView:SetActive(active)
	self.panel:SetActive(active)
end