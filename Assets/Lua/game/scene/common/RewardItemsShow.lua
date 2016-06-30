--[[
	奖励物品通用类
	huqiuxiang
]]
RewardItemsShow = class()
RewardItemsShow.scene = nil
RewardItemsShow.panel = nil 
RewardItemsShow.uiRoot = nil
RewardItemsShow.sceneTarget = nil 
RewardItemsShow.itemsGrid = nil 

function RewardItemsShow:init(targetScene,items,isMerge)
	self.scene = targetScene
	self.sceneTarget = targetScene.sceneTarget
	self.uiRoot = targetScene.uiRoot
	
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/common/CommonRewardItemsGetUI"))
    	self.panel.gameObject.transform.parent = self.uiRoot.gameObject.transform
    	self.panel.gameObject.transform.localPosition = Vector3.zero
    	self.panel.gameObject.transform.localScale = Vector3.one

    	local btn = self.panel.gameObject.transform:FindChild("UI/CommonRewardItemsGetUI_OKBtn")
    	self.scene:SetButtonTarget(btn,self.sceneTarget)
	end
	self.itemsGrid = self.panel.gameObject.transform:FindChild("UI/CommonRewardItemsGetUI_Grid")
	self:creatItems(items)
	local uitable = getUIComponent(self.itemsGrid,"UITable")
	uitable:Reposition()
	uitable.repositionNow = true;
	if isMerge then
		local effect = self.panel.gameObject.transform:FindChild("ef_ui_ronghe"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
		SetEffectOrderInLayer(effect,501)
		effect = self.panel.gameObject.transform:FindChild("ef_ui_kj_buy"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
		effect.gameObject:SetActive(false)
	else
		local effect = self.panel.gameObject.transform:FindChild("ef_ui_kj_buy"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
		SetEffectOrderInLayer(effect,501)
		effect = self.panel.gameObject.transform:FindChild("ef_ui_ronghe"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
		effect.gameObject:SetActive(false)
	end
end

function RewardItemsShow:closePanel()
	destroy(self.panel)
end

function RewardItemsShow:creatItems(items)
	-- print("#items"..#items)
	for i = 1, #items do
	 	items[i].gameObject.transform.parent = self.itemsGrid.gameObject.transform
		items[i].gameObject.transform.localPosition = Vector3.zero
		items[i].gameObject.transform.localScale = Vector3.one
	end
end
