
--[[
	ui提示咨询是否确定返回
	sunkai
]]
ConsultBoxView = class()
ConsultBoxView.name = "ConsultBoxView"
ConsultBoxView.panel = nil
ConsultBoxView.sceneTarget = nil
ConsultBoxView.scene = nil
ConsultBoxView.model = nil --传入的模型，显示提示界面时候隐藏，关闭提示界面时显示

function ConsultBoxView:init(targetScene,word,OkDelegate,model)
	self.scene = targetScene
	self.sceneTarget = targetScene.sceneTarget
	self.uiRoot = targetScene.uiRoot
	if model ~= nil then
		self.model = model
		self.model.gameObject:SetActive(false)
	end
	local trans = self.uiRoot.transform:Find(self.name)
	if trans ~= nil then
		self.panel = trans.gameObject
	end
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/common/ConsultBoxView"))
		self.panel.name = self.name
    	self.panel.transform.parent = self.uiRoot.transform
    	self.panel.transform.localPosition = Vector3(0,0,-400)
    	self.panel.transform.localScale = Vector3.one
	end
	self.OkDelegate = OkDelegate
	self.scene:boundButtonEvents( self.panel,self.sceneTarget)
	self.panel:SetActive(true)
	local wordLabel = self.panel.transform:FindChild("Label"):GetComponent("UILabel")
	wordLabel.text = word

end

function ConsultBoxView:close()
	if self.model ~= nil then
		self.model.gameObject:SetActive(true)
		self.model = nil
	end
	self.panel:SetActive(false)
end

function ConsultBoxView:OkBtnClick()
	self:close()
	self.OkDelegate(self.scene)
end