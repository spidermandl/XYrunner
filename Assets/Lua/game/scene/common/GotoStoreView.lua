
--[[
	服务器异常 需要返回登录界面
	gaofei
]]
GotoStoreView = class()
GotoStoreView.name = "GotoStoreView"
GotoStoreView.panel = nil
GotoStoreView.scene = nil
GotoStoreView.storeType = nil -- 商城类型
-- 购买类型 3--体力和金币商城 4-钻石商城
function GotoStoreView:init(targetScene,word,type)
	self.scene = targetScene
	self.uiRoot = targetScene.uiRoot
	local trans = self.uiRoot.transform:Find(self.name)
	GamePrint("type ==="..type)
	self.storeType = type
	if trans ~= nil then
		self.panel = trans.gameObject
	end
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/common/GotoStoreView"))
		self.panel.name = self.name
    	self.panel.transform.parent = self.uiRoot.transform
    	self.panel.transform.localPosition = Vector3(0,0,-400)
    	self.panel.transform.localScale = Vector3.one
	end
	
	--self.scene:SetButtonTarget(btn,self.sceneTarget)
	self.panel:SetActive(true)
	local wordLabel = self.panel.transform:Find("Main/Label"):GetComponent("UILabel")
	wordLabel.text = word
	local ok_btn = self.panel.transform:Find("Main/GotoStoreView_OnBtn")
	local obBtn_uie = ok_btn:GetComponent("UIEventListener")
	if obBtn_uie == nil then
		obBtn_uie = ok_btn.gameObject:AddComponent(UIEventListener.GetClassType())
	end
	obBtn_uie.onClick = function( ... )
		self:HiddenView()
		self.scene:ShowShop(self.storeType)
	end
	
	local canel_btn = self.panel.transform:Find("Main/GotoStoreView_CanelBtn")
	local canelBtn_uie = canel_btn:GetComponent("UIEventListener")
	if canelBtn_uie == nil then
		canelBtn_uie = canel_btn.gameObject:AddComponent(UIEventListener.GetClassType())
	end
	canelBtn_uie.onClick = function( ... )
		self:HiddenView()
	end
end

--激活暂停界面
function GotoStoreView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function GotoStoreView:HiddenView()
	self.panel:SetActive(false)
end