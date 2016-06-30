
--[[
	sunkai
]]
LevelSelectView = class()
LevelSelectView.panel = nil
LevelSelectView.scene = nil 

function LevelSelectView:init(targetScene)
	self.scene = targetScene
	self.uiRoot = targetScene.uiRoot
	
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/Chapter/LevelSelectView"))
    	self.panel.gameObject.transform.parent = self.uiRoot.gameObject.transform
    	self.panel.gameObject.transform.localPosition = Vector3.zero
    	self.panel.gameObject.transform.localScale = Vector3.one
	end

	self.scene:boundButtonEvents(self.panel)
	self:SetShowView(false)
	
end


function LevelSelectView:SetShowView(active)
	self.scene:SetModelShow(false)
	 print("LevelSelectView:SetShowView(active) false ")
	self.panel.gameObject:SetActive(active)
	-- if active then
	-- 	self.scene :ShowLevelEffect()
	-- end
end


