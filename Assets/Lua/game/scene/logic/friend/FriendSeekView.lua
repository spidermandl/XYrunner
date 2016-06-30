--[[
author:赵名飞
好友查找类
]]
FriendSeekView = class()
FriendSeekView.TargetScene = nil --场景
FriendSeekView.panel = nil -- 界面
FriendSeekView.input = nil -- 输入框
--初始化
function FriendSeekView:init(targetScene)
	self.TargetScene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Friend/FriendSeekUI"))
	self.panel.transform.parent = self.TargetScene.panel.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
    self.panel:SetActive(false)
    self.input = self.panel.transform:Find("Anchors/inputText").gameObject.transform:GetComponent("UIInput")
end
--搜索功能
function FriendSeekView:FriendSeekBtnSeek( ... )

	if self.input.value == "" then
		self.TargetScene.scene:promptWordShow("请输入好友ID！")
		return
	elseif tonumber(self.input.value) == TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)[TxtFactory.USER_MEMBERID] then
		self.TargetScene.scene:promptWordShow("不能添加自己噢！")
		return
	end
	self.TargetScene.friendManagement:SendFriendFindReq(self.input.value)
end
--激活暂停界面
function FriendSeekView:ShowView()
	self.panel:SetActive(true)
	self.TargetScene.scene:boundButtonEvents(self.panel)
end
-- 冷藏界面
function FriendSeekView:HideView()
	self.input.value = ""
	self.panel:SetActive(false)
end