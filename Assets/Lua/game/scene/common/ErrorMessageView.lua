
--[[
	服务器异常 需要返回登录界面
	gaofei
]]
ErrorMessageView = class()
ErrorMessageView.name = "ErrorMessageView"
ErrorMessageView.panel = nil
ErrorMessageView.sceneTarget = nil
ErrorMessageView.scene = nil

function ErrorMessageView:init(targetScene,word)
	self.scene = targetScene
	self.sceneTarget = targetScene.sceneTarget
	self.uiRoot = targetScene.uiRoot
	local trans = self.uiRoot.transform:Find(self.name)
	if trans ~= nil then
		self.panel = trans.gameObject
	end
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/common/ErrorMessageView"))
		self.panel.name = self.name
    	self.panel.transform.parent = self.uiRoot.transform
    	self.panel.transform.localPosition = Vector3(0,0,-400)
    	self.panel.transform.localScale = Vector3.one
	end
	
	--self.scene:SetButtonTarget(btn,self.sceneTarget)
	self.panel:SetActive(true)
	local wordLabel = self.panel.transform:Find("Main/Label"):GetComponent("UILabel")
	wordLabel.text = word
	local btn = self.panel.transform:Find("Main/ErrorMessage_OnBtn")
	local uie = btn:GetComponent("UIEventListener")
	if uie == nil then
		uie = btn.gameObject:AddComponent(UIEventListener.GetClassType())
	end
	uie.onClick = function( ... )
		--返回登录界面
		self.scene:ChangScene("ui_login")
	end

end
