--[[
author:hanli_xiong
账号激活界面
]]

ActiveAccountView = class()

ActiveAccountView.scene = nil
ActiveAccountView.gameObject = nil
ActiveAccountView.management = nil

-- ui
ActiveAccountView.step1View = nil -- 激活步骤1 (激活中／出错)
ActiveAccountView.step2View = nil -- 激活步骤2 (激活成功)
ActiveAccountView.activeCodeInput = nil -- 激活码输入框
ActiveAccountView.activeInfo = nil -- 激活结果信息显示

function ActiveAccountView:Init(targetScene)
	self.scene = targetScene
	self.gameObject = newobject(Util.LoadPrefab("UI/Login/ActiveAccountUI"))
	local trans = gameObject.transform:Find("Camera/UI")
 	self.step1View = trans:Find("Wnd/activeStep1")
 	self.step2View = trans:Find("Wnd/activeStep2")
 	self.activeCodeInput = self.step1View:Find("ActiveCodeInput")
 	self.activeInfo = self.step1View:Find("activeTip")
end

function ActiveAccountView:SetActive(enable)
	self.gameObject:SetActive(enable)
end

-- 确认激活
function ActiveAccountView:OnOk()
	-- body
end

-- 取消激活
function ActiveAccountView:OnCancel()
	-- body
end

function ActiveAccountView:OnActiveSuccess()
	self.step1View.gameObject:SetActive(false)
	self.step2View.gameObject:SetActive(true)
end
