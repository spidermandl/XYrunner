--UIPetScene
--[[
	ui提示类
	Huqiuxiang
]]
PromptWordShowView = class()
PromptWordShowView.name = "CommonPromptUI"
PromptWordShowView.panel = nil
PromptWordShowView.sceneTarget = nil
PromptWordShowView.scene = nil
PromptWordShowView.model = nil --传入的模型，显示提示界面时候隐藏，关闭提示界面时显示

function PromptWordShowView:init(targetScene,word,model)
	self.scene = targetScene
	self.sceneTarget = targetScene.sceneTarget
	self.uiRoot = targetScene.uiRoot
	if model ~= nil  then
		self.model = model
		if self:CheackModesType() then
			self.model.gameObject:SetActive(false)
		end
		
	end
	local trans = self.uiRoot.transform:Find(self.name)
	if trans ~= nil then
		self.panel = trans.gameObject
	end
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/common/CommonPromptUI"))
		self.panel.name = self.name
    	self.panel.transform.parent = self.uiRoot.transform
    	self.panel.transform.localPosition = Vector3(0,0,-400)
    	self.panel.transform.localScale = Vector3.one
	end
	local btn = self.panel.transform:FindChild("CommonPromptUI_Background")
	self.scene:SetButtonTarget(btn,self.sceneTarget)

	AddonClick(getChildByPath(self.panel,"CommonPromptUI_Background"),
		function()
		    self.scene:promptWordShowClose()
		end
	)
	self.panel:SetActive(true)
	getObjectComponent(self.panel,"UILabel","Label").text = word

end

function PromptWordShowView:close()
	if self.model ~= nil and self:CheackModesType() then
		self.model.gameObject:SetActive(true)
		self.model = nil
	end
	self.panel:SetActive(false)
end

function PromptWordShowView:CheackModesType()
	if type(self.model) == "number" then
		return false
	end 
	
	return true
end