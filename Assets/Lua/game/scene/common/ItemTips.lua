--[[
	道具信息
	赵名飞
]]
ItemTips = class()
ItemTips.panel = nil
ItemTips.sceneTarget = nil
ItemTips.scene = nil 

function ItemTips:init(targetScene,itemId)
	self.scene = targetScene
	self.sceneTarget = targetScene.sceneTarget
	self.uiRoot = targetScene.uiRoot
	
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/Store/ItemTips"))
    	self.panel.gameObject.transform.parent = self.uiRoot.gameObject.transform
    	self.panel.gameObject.transform.localPosition = Vector3(0,0,-400)
    	self.panel.gameObject.transform.localScale = Vector3.one

    	local btn = self.panel.gameObject.transform:FindChild("itemTipBg")
    	self.scene:SetButtonTarget(btn,self.sceneTarget)
	end
	self.panel:SetActive(false)
	self:SetInfo(itemId)
end
function ItemTips:SetInfo(itemId)
	local tableTXT = TxtFactory:getTable(TxtFactory.StoreConfigTXT)
	local name = self.panel.gameObject.transform:FindChild("topName"):GetComponent("UILabel")
	local info = self.panel.gameObject.transform:FindChild("info"):GetComponent("UILabel")
	name.text = tableTXT:GetData(itemId,TxtFactory.S_STORECONFIGTXT_SHOP_GOODS_NAME)
	info.text = tableTXT:GetData(itemId,TxtFactory.S_STORECONFIGTXT_GOODS_DESC)
	self.panel:SetActive(true)
end

function ItemTips:close()
	self.panel:SetActive(false)
end