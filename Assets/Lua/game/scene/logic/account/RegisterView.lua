--[[
author:gaofei
注册界面
]]

RegisterView = class ()
RegisterView.scene = nil --场景scene
RegisterView.panel = nil -- 界面


-- 初始化
function RegisterView:init(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/RegisterUI"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
	
	self.UsernameText = getObjectComponent(self.panel,"UIInput","UI/UIGame/Center/RegisterUICenter/usernameText")
		--self.panel.transform:Find("UI/UIGame/Center/RegisterUICenter/usernameText"):GetComponent("UIInput")
    self.PasswordText = getObjectComponent(self.panel,"UIInput","UI/UIGame/Center/RegisterUICenter/passwordText")
    	--self.panel.transform:Find("UI/UIGame/Center/RegisterUICenter/passwordText"):GetComponent("UIInput")
	
    AddonClick(getChildByPath(self.panel,"UI/UIGame/Center/RegisterUIBackBtn"),
        function()
        	TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.button)
            self.scene:RegisterUIBackBtnOnClick()
        end
    )
    AddonClick(getChildByPath(self.panel,"UI/UIGame/Center/RegisterUIRegisterBtn"),
        function()
        	TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.button)
            self:RegisterUIRegisterBtnOnClick()
        end
    )

	self.scene:boundButtonEvents(self.panel)
end

-- 注册按钮
function RegisterView:RegisterUIRegisterBtnOnClick()
	
	   
  	if self.UsernameText.value == "" or string.len(self.UsernameText.value) < 4 then
         --  print("用户名不能为空")
		   self.scene:promptWordShow("用户名至少六个字符")
           return
  	end
  	if self.PasswordText.value == "" or string.len(self.PasswordText.value) < 4 then
  		-- print("密码不能为空")
		 self.scene:promptWordShow("密码至少四个字符")
  		 return
  	end
	--self:HiddenView()
    self.scene:RegisterBtnAction(self.UsernameText.value,self.PasswordText.value)
end

--激活暂停界面
function RegisterView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function RegisterView:HiddenView()
	self.panel:SetActive(false)
end
