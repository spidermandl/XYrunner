--[[
author:赵名飞
好友列表item类
]]
FriendItem = class()
FriendItem.TargetScene = nil --场景
FriendItem.FriendTable = nil --该类型的好友列表
FriendItem.SelectType = 0 --操作类型 1好友列表 2申请列表 3添加列表 4删除列表
FriendItem.FriendItems = {} --存储item
FriendItem.AllPage = 0 --好友数据的总页数
--初始化
function FriendItem:init(targetScene,selectType)
	self.TargetScene = targetScene
	self.SelectType = selectType
	--self:checkData()
	self.TargetScene.friendManagement:SendFriendListReq(0,self.TargetScene.NowPage)
end
--检查是否需要请求数据
function FriendItem:checkData()
	if self.SelectType == 1 or self.SelectType == 4 then
		self.FriendTable = self.TargetScene.friendManagement:GetFriendInfo(0,self.TargetScene.NowPage) --好友列表 第一页
		if self.FriendTable == nil then
			self.TargetScene.friendManagement:SendFriendListReq(0,self.TargetScene.NowPage)
		else
			self:refresh()
		end
		--每次打开都重新请求数据
		--self.TargetScene.friendManagement:SendFriendListReq(0,self.TargetScene.NowPage)
	end
end
--提前获取下一页数据
function FriendItem:getNextPageData()
	
	if self.TargetScene.NowPage < self.AllPage-1 then
		local nextTab = self.TargetScene.friendManagement:GetFriendInfo(0,self.TargetScene.NowPage+1)
		if nextTab == nil then
			self.TargetScene.friendManagement:SendFriendListReq(0,self.TargetScene.NowPage+1)
		end
	end
end
--刷新
function FriendItem:refresh()
	self:ClearFriendItems()
	if self.FriendTable == nil then
		return
	end
	--print("FriendItem:refresh")
	self.AllPage = self.TargetScene.friendManagement:GetFriendInfo(TxtFactory.FRIEND_ALLPAGE)
	self:getNextPageData()
	for key, value in pairs(self.FriendTable) do
		if value == nil then
			break
		end
		local obj  = newobject(Util.LoadPrefab("UI/Friend/FriendItem"))
		obj.transform.parent = self.TargetScene.ScrollView.gameObject.transform
		
    	obj.transform.localScale = Vector3.one
    	obj.name = value.memberid
    	self.TargetScene:AddFriendItem(obj)
    	--根据操作类型显示不同的内容
    	local statusTab = {}
    	statusTab[1] = obj.transform:Find("status1") --状态对应操作类型
    	statusTab[1].gameObject:SetActive(false)
    	statusTab[2] = obj.transform:Find("status2")
    	statusTab[2].gameObject:SetActive(false)
    	statusTab[3] = obj.transform:Find("status3")
    	statusTab[3].gameObject:SetActive(false)
    	statusTab[4] = obj.transform:Find("status4")
    	statusTab[4].gameObject:SetActive(false)
    	statusTab[self.SelectType].gameObject:SetActive(true)
    	local name = obj.transform:Find("name"):GetComponent("UILabel")
    	name.text = GetFriendNameByNick(value.nickname)
    	local lvl = obj.transform:Find("level"):GetComponent("UILabel")
    	lvl.text = value.level
    	local time = obj.transform:Find("time"):GetComponent("UILabel")
    	local timelab = obj.transform:Find("time/Label"):GetComponent("UILabel")
    	timelab.text = self.TargetScene.textsConfigTXT:GetText(1017)
    	time.text = self.TargetScene:ParseSecends(value.last_time)
    	local icon = obj.transform:Find("senderIcon"):GetComponent("UISprite")
    	--如果服务器发的icon 为0 则 设置任意的ICON
    	icon.spriteName = TxtFactory:getTable(TxtFactory.CharIconTXT):GetData(value.icon == 0 and 101003 or value.icon, "ICON")
    	self:AddFriendItem(obj,value.memberid)
    	if value.give_str ~=nil and tonumber(value.give_str) > 0 then
    		self:HideBtnTili(value.memberid)
    	end
    	if value.challenge_cd ~=nil and tonumber(value.challenge_cd) > 0 then
    		self:HideBtnTiaozhan(value.memberid)
    	end
    	local btn = obj.transform:Find("status1/Friend_BtnTiaozhan")
    	local fun = function()
    		self.TargetScene.friendManagement:SendFriendChallengeReq(value)
    	end
    	AddonClick(btn,fun) --注册按钮
	end
	self:SetItemPos()
	self.TargetScene.ScrollView:ResetPosition()
	self.TargetScene.scene:boundButtonEvents(self.TargetScene.panel)
end
-- 排列位置
function FriendItem:SetItemPos()
	local pos_y = 180 --计算位置，此类不通过UIGrid排列位置
	if self.TargetScene.NowPage > 0 then --上一页按钮
		self.TargetScene.BtnLastPage.gameObject:SetActive(true)
		self.TargetScene.BtnLastPage.gameObject.transform.localPosition = Vector3(0,pos_y,0)
		pos_y = pos_y - 75
	else
		self.TargetScene.BtnLastPage.gameObject:SetActive(false)
	end 
	if self.FriendItems ~= nil then
		for k,v in pairs(self.FriendItems) do
			if v ~= nil then
				v.transform.localPosition = Vector3(0,pos_y,0)
				pos_y = pos_y - 100
			end
		end
	end
	if self.TargetScene.NowPage < self.AllPage-1 then	--下一页按钮
		self.TargetScene.BtnNextPage.gameObject:SetActive(true)
		self.TargetScene.BtnNextPage.gameObject.transform.localPosition = Vector3(0,pos_y+25,0)
	else
		self.TargetScene.BtnNextPage.gameObject:SetActive(false)
	end
end
-- 存储本类的Item对象 方便刷新状态
function FriendItem:AddFriendItem(item,key)

	table.insert(self.FriendItems,key,item) 
end
-- 清除对象
function FriendItem:ClearFriendItems()
	
	if self.FriendItems ~= nil then
		for k , v in pairs(self.FriendItems) do
			if v ~= nil then
				GameObject.Destroy(v)
			end
		end
	end
	self.FriendItems = {}
end

--点击挑战后隐藏挑战按钮
function FriendItem:HideBtnTiaozhan(friendId)
	local item = self.FriendItems[friendId]
	if item == nil then
		return
	end
	local btn = item.transform:Find("status1"):Find("Friend_BtnTiaozhan")
	if btn ~= nil then
		btn.gameObject:SetActive(false)
	end
end
--点击赠送体力后隐藏体力按钮
function FriendItem:HideBtnTili(friendId,toAll)
	if toAll == true then
		for key, value in pairs(self.FriendItems) do
			if value ~= nil then
				local btn = value.transform:Find("status1"):Find("Friend_BtnTili")
				if btn ~= nil then
					btn.gameObject:SetActive(false)
				end
			end
		end
	else
		local item = self.FriendItems[friendId]
		if item == nil then
			return
		end
		local btn = item.transform:Find("status1"):Find("Friend_BtnTili")
		if btn ~= nil then
			btn.gameObject:SetActive(false)
		end
	end
	
end
--删除好友
function FriendItem:RemoveFriendItem(friendId)
	local item = self.FriendItems[friendId]
	if item == nil then
		return
	end
	item.gameObject:SetActive(false)
	--table.remove(self.FriendItems, friendId)
	self.FriendItems[friendId] = nil
	self:SetItemPos()
	--self.FriendItems[friendId] = nil
end