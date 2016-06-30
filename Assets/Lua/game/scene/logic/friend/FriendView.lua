--[[
author:赵名飞
好友界面
]]
require "game/scene/logic/friend/FriendManagement"
require "game/scene/logic/friend/FriendItem"
require "game/scene/logic/friend/FriendRecommendItem"
require "game/scene/logic/friend/FriendRequestItem"
require "game/scene/logic/friend/FriendSeekView"
require "game/scene/logic/friend/FriendInfoView"
FriendView = class()
FriendView.scene = nil --场景scene
FriendView.panel = nil -- 界面
FriendView.ScrollView = nil --scrollView
FriendView.Grid = nil --Grid
FriendView.TopToggleBtns = nil --顶部的toggle按钮
FriendView.FriendItems = nil -- 存储商城物品对象
FriendView.SelectType = 0 -- 当前选中的类型 1好友 2申请 3添加 4删除
FriendView.NowPage = 0 --好友界面现在显示的页数
FriendView.friendManagement = nil --好友逻辑类
FriendView.FriendItem = nil --好友Item类
FriendView.FriendRecommendItem = nil --推荐好友列表Item类
FriendView.FriendRequestItem = nil --好友申请列表item类
FriendView.FriendSeekView = nil --查找界面
FriendView.FriendInfoView = nil --好友界面
FriendView.BtnLastPage = nil --上一页按钮
FriendView.BtnNextPage = nil --下一页按钮
FriendView.BtnQuit = nil -- 退出按钮
FriendView.BtnAll = nil -- 赠送全部
FriendView.textsConfigTXT = nil --文字配表
--初始化
function FriendView:init(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Friend/FriendMainUI"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
    self.panel:SetActive(false)
	self.textsConfigTXT =  TxtFactory:getTable(TxtFactory.TextsConfigTXT)
    self.TopToggleBtns = {}
    self.TopToggleBtns[1] = self.panel.transform:Find("Anchors/Btns/Friend_TopBtnFriend")
    self.TopToggleBtns[2] = self.panel.transform:Find("Anchors/Btns/Friend_TopBtnReq")
    self.TopToggleBtns[3] = self.panel.transform:Find("Anchors/Btns/Friend_TopBtnAdd")
    self.BtnLastPage = self.panel.transform:Find("Anchors/View/Friend_LastPage")
    self.BtnLastPage.gameObject:SetActive(false)
    self.BtnNextPage = self.panel.transform:Find("Anchors/View/Friend_NextPage")
	self.BtnNextPage.gameObject:SetActive(false)
	self.BtnQuit = self.panel.transform:Find("Anchors/Btns/Friend_TopBtnQuit")
	self.BtnAll = self.panel.transform:Find("Anchors/Btns/Friend_TopBtnAll")
	self.BtnDelete = self.panel.transform:Find("Anchors/Btns/Friend_TopBtnDelete")
	-- 存储物品的父节点
	self.ScrollView = self.panel.transform:Find("Anchors/View"):GetComponent("UIScrollView")
	self.Grid = self.panel.transform:Find("Anchors/View/Grid")
	self.friendManagement = FriendManagement.new()
    self.friendManagement:Awake(self)
	self.FriendItem = FriendItem.new()
	self.FriendRecommendItem = FriendRecommendItem.new()
	self.FriendRequestItem = FriendRequestItem.new()
	self.FriendRequestItem:init(self)
	self.FriendSeekView = FriendSeekView.new()
	self.FriendSeekView:init(self)
	self.FriendInfoView = FriendInfoView.new()
	self.FriendInfoView:init(self)
end
--激活暂停界面
function FriendView:ShowView()
	self.panel:SetActive(true)
	self.scene:boundButtonEvents(self.panel)
	self.scene:SetFarmActive(false)
end
-- 冷藏界面
function FriendView:HideView()
	self.panel:SetActive(false)
	self.scene:SetFarmActive(true)
end
function FriendView:FriendBtnLastPage()
	self.NowPage = self.NowPage-1
	self.FriendItem:checkData()
end
function FriendView:FriendBtnNextPage()
	self.NowPage = self.NowPage+1
	self.FriendItem:checkData()
end
--点击选择好友
function FriendView:FriendTopBtnFriendClick()	
	if self.SelectType == 1 then
		return
	end
	self.SelectType = 1
	self:InitItem()
end
--点击选择申请
function FriendView:FriendTopBtnReqClick( ... ) 
	if self.SelectType == 2 then
		return
	end
	self.SelectType = 2
	self:InitItem()
end
--点击选择添加
function FriendView:FriendTopBtnAddClick( ... ) 
	if self.SelectType == 3 then
		return
	end
	self.SelectType = 3
	self:InitItem()
end
--点击选择删除
function FriendView:FriendTopBtnDeleteClick( ... ) 
	if self.SelectType == 4 then
		return
	end
	self.SelectType = 4
	self:InitItem()
end
--点击赠送全部
function FriendView:FriendTopBtnAllClick( ... ) 

	--do
	--	self.scene:promptWordShow("暂不支持~！")
	--	return
	--end
	self.friendManagement:SendGiveStrengthReq()
end
--点击离开申请界面
function FriendView:FriendTopBtnQuitClick() 
	self:InitData(1)
end
--点击查找好友
function FriendView:FriendTopBtnSeekClick( ... ) 
	self.FriendSeekView:ShowView()
end
--点击查找界面的查找按钮
function FriendView:FriendSeekBtnSeek( ... ) 
	--[[
	do
		self.scene:promptWordShow("暂不支持~！")
		return
	end]]
	self.FriendSeekView:FriendSeekBtnSeek()
end
--点击查找界面的关闭按钮
function FriendView:FriendSeekBtnClose( ... ) 
	self.FriendSeekView:HideView()
end
--点击赠送体力
function FriendView:FriendItemBtnTiliClick( btn )
	self.friendManagement:SendGiveStrengthReq(btn.transform.parent.transform.parent.name)
end
--点击挑战
function FriendView:FriendItemBtnTiaozhanClick( btn ) 
	--self.friendManagement:SendFriendChallengeReq(btn.transform.parent.transform.parent.name)
end
--发起挑战成功，进入无尽
function FriendView:SkipEndlessScene( ... )
	TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,2)
    --self.scene:ChangScene(SceneConfig.endlessScene)
	self.panel:SetActive(false)
	self.scene:OpenEndlessScene()
end
--点击访问
function FriendView:FriendItemBtnFangwenClick( btn ) 
	do
		self.scene:promptWordShow("暂不支持~！")
		return
	end
	print("点击访问，好友ID是："..btn.transform.parent.transform.parent.name)
end
--点击好友信息界面的删除按钮
function FriendView:FriendInfoBtnDelete( ... ) 
	self.FriendInfoView:FriendInfoBtnDelete()
end
--点击好友信息界面的关闭按钮
function FriendView:FriendInfoBtnClose( ... ) 
	self.FriendInfoView:HideView()
end
--点击同意
function FriendView:FriendItemBtnYesClick( btn ) 
	local friendID = tonumber(btn.transform.parent.transform.parent.name)
	--print("点击同意，好友ID是："..friendID)
	self.friendManagement:SendFriendAcceptReq(friendID,true)
end
--点击拒绝
function FriendView:FriendItemBtnNoClick( btn ) 
	local friendID = tonumber(btn.transform.parent.transform.parent.name)
	--print("点击拒绝，好友ID是："..friendID)
	self.friendManagement:SendFriendAcceptReq(friendID,false)
end
--点击添加
function FriendView:FriendItemBtnAddClick( btn ) 
	local friendID = tonumber(btn.transform.parent.transform.parent.name)
	--print("点击添加，好友ID是："..friendID)
	self.friendManagement:SendFriendAddReq(friendID)
end
--点击删除
function FriendView:FriendItemBtnDeleteClick( btn ) 
	--print("点击删除，好友ID是："..btn.transform.parent.transform.parent.name)
	self.FriendInfoView:SetInfo(tonumber(btn.transform.parent.transform.parent.name))
end
-- 插入物品对象，管理所有的Item对象，不分种类，切换标签后清除
function FriendView:AddFriendItem(item)

	table.insert(self.FriendItems,item) 
end
-- 清除对象
function FriendView:ClearFriendItems()
	
	if self.FriendItems ~= nil then
		printf("count=="..#self.FriendItems)
		for i = 1 , #self.FriendItems do
			if self.FriendItems[i] ~= nil then
				GameObject.Destroy(self.FriendItems[i])
			end
		end
	end
	self.FriendItems = {}
end
-- 初始化数据
function FriendView:InitData(SelectType)
	self.SelectType = SelectType
	if self.TopToggleBtns[SelectType] ~= nil then
		self.TopToggleBtns[SelectType]:GetComponent("UIToggle").value = true
	end
	self:InitItem()
end
--刷新好友数量申请数
function FriendView:RefreshNum()
	
	local myId = self.panel.transform:Find("Anchors/myId"):GetComponent("UILabel")
	myId.text = self.textsConfigTXT:GetText(1015)..tostring(TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)[TxtFactory.USER_MEMBERID])
	local num = self.friendManagement:GetFriendInfo(TxtFactory.FRIEND_FRIENDNUM)
	local friendNum = self.panel.transform:Find("Anchors/friendNum"):GetComponent("UILabel")
	friendNum.text = "[7d3800]"..self.textsConfigTXT:GetText(1016).."[FF3030]"..tostring(num or 0).."[-]/50"
	local req = self.friendManagement:GetFriendInfo(TxtFactory.FRIEND_REQNUM) or 0
	local reqNum = self.panel.transform:Find("Anchors/reqNum")
	if req == 0 then
		reqNum.gameObject:SetActive(false)
	else
		reqNum.gameObject:SetActive(true)
		reqNum.gameObject:GetComponent("UILabel").text = req 
	end
end
--初始化好友Item
function FriendView:InitItem()
	self.BtnAll.gameObject:SetActive(false)
	self.BtnQuit.gameObject:SetActive(false)
	self.BtnDelete.gameObject:SetActive(false)
	self:ClearFriendItems()
	if self.SelectType == 1 then
		self.BtnAll.gameObject:SetActive(true)
		self.BtnDelete.gameObject:SetActive(true)
		self.FriendItem:init(self,1)
		--print("好友列表")
	elseif self.SelectType == 2 then
		self.FriendRequestItem:init(self,2)
		self.BtnNextPage.gameObject:SetActive(false)
		self.BtnLastPage.gameObject:SetActive(false)
		--print("申请列表")
	elseif self.SelectType == 3 then
		self.FriendRecommendItem:init(self,3)
		self.BtnNextPage.gameObject:SetActive(false)
		self.BtnLastPage.gameObject:SetActive(false)
		--print("添加列表")
	elseif self.SelectType == 4 then
		self.BtnQuit.gameObject:SetActive(true)
		self.FriendItem:init(self,4)
		--print("删除列表")
	end
end
--重置位置
function FriendView:ResetPos()

	local itemGrid = self.Grid.gameObject:GetComponent(UIGrid.GetClassType())
	itemGrid:Reposition()
	itemGrid.repositionNow = true
	self.ScrollView:ResetPosition()
	self.scene:boundButtonEvents(self.panel)
end
--传入秒数返回时间
function FriendView:ParseSecends( secends )
	-- print("邮件发送时间：" .. os.date("%Y/%m/%d %H:%M:%S", secends))
	if secends == nil or tonumber(secends) == -1 then
		return self.textsConfigTXT:GetText(1018)
	elseif tonumber(secends) == 0 then
		return self.textsConfigTXT:GetText(1019)
	end
	local ss =  tonumber(secends) 
	local timeStr = ""
	if ss > 60*60*24 then
		timeStr = math.floor(ss/(60*60*24)) .. self.textsConfigTXT:GetText(1020)
	elseif ss > 60*60 then
		timeStr = math.floor(ss/(60*60)) .. self.textsConfigTXT:GetText(1021)
	elseif ss > 60 then
		timeStr = math.floor(ss/(60)) .. self.textsConfigTXT:GetText(1022)
	elseif ss > 0 then
		timeStr = self.textsConfigTXT:GetText(1019)
	end
	return timeStr
end