--[[
author:赵名飞
好友查找类
]]
FriendInfoView = class()
FriendInfoView.TargetScene = nil --场景
FriendInfoView.panel = nil -- 界面
FriendInfoView.friendInfo = nil --本界面显示的好友的数据
--初始化
function FriendInfoView:init(targetScene)
	self.TargetScene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Friend/FriendInfoUI"))
	self.panel.transform.parent = self.TargetScene.panel.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
    self.panel:SetActive(false)
end
--设置信息
function FriendInfoView:SetInfo(friendId)
	
	self.friendInfo = self.TargetScene.friendManagement:GetFriendInfoByPage(tonumber(friendId))
	if self.friendInfo == nil then
		error("找不到该好友数据："..friendId)
		return
	end
	self:ShowView()
	local icon = self.panel.transform:Find("Anchors/icon").gameObject.transform:GetComponent("UISprite")
	icon.spriteName = TxtFactory:getTable(TxtFactory.CharIconTXT):GetData(self.friendInfo.icon, "ICON")
	local name = self.panel.transform:Find("Anchors/name").gameObject.transform:GetComponent("UILabel")
	if self.friendInfo.nickname == nil or self.friendInfo.nickname == "" then --服务器添加的电脑人，没名字
    		name.text = "教官"
    	else
    		local str = self.friendInfo.nickname
    		if pcall(ZZBase64.decode,self.friendInfo.nickname) then--检查是否能转换为汉字
    			str = ZZBase64.decode(self.friendInfo.nickname)
    		end
    		name.text = str
    	end
	local lvl = self.panel.transform:Find("Anchors/level").gameObject.transform:GetComponent("UILabel")
	lvl.text = self.friendInfo.level
	local time = self.panel.transform:Find("Anchors/time").gameObject.transform:GetComponent("UILabel")
	time.text = self.TargetScene:ParseSecends(self.friendInfo.last_time)
end
--激活暂停界面
function FriendInfoView:ShowView()
	self.panel:SetActive(true)
	self.TargetScene.scene:boundButtonEvents(self.panel)
end
-- 冷藏界面
function FriendInfoView:HideView()
	self.panel:SetActive(false)
end
-- 冷藏界面
function FriendInfoView:FriendInfoBtnDelete()
	self.TargetScene.friendManagement:SendFriendRemoveReq(self.friendInfo.memberid)
end