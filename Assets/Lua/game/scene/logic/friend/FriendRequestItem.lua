--[[
author:赵名飞
好友申请列表item类
]]
FriendRequestItem = class()
FriendRequestItem.TargetScene = nil --场景
FriendRequestItem.FriendTable = nil --该类型的好友列表
FriendRequestItem.SelectType = 0 --操作类型 1好友列表 2申请列表 3添加列表 4删除列表
FriendRequestItem.FriendItems = {} --存储item
--初始化
function FriendRequestItem:init(targetScene,selectType)
	self.TargetScene = targetScene
	self.SelectType = selectType
	self:checkData()
end
--检查是否需要请求数据
function FriendRequestItem:checkData()
--[[
	self.FriendTable = self.TargetScene.friendManagement:GetFriendListTable(1,1) --申请列表 第一页
		if self.FriendTable == nil then
			self.TargetScene.friendManagement:SendFriendListReq(1,1)
		end]]
	self.TargetScene.friendManagement:SendFriendListReq(1,0)
end
--刷新
function FriendRequestItem:refresh()
	self:ClearFriendItems()
	self.FriendTable = self.TargetScene.friendManagement:GetFriendInfo(1,0) --申请列表 第一页
	if self.FriendTable == nil then
		return
	end
	for key,value in pairs(self.FriendTable) do
		if value == nil then
			break
		end
		local obj  = newobject(Util.LoadPrefab("UI/Friend/FriendItem"))
		obj.transform.parent = self.TargetScene.Grid.gameObject.transform
		obj.transform.localPosition = Vector3.zero
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
    	icon.spriteName = TxtFactory:getTable(TxtFactory.CharIconTXT):GetData(value.icon == 0 and 101003 or value.icon, "ICON")
    	self:AddFriendItem(obj,value.memberid)
	end
	self.TargetScene:ResetPos()
end
-- 存储本类的Item对象 方便刷新状态
function FriendRequestItem:AddFriendItem(item,key)

	table.insert(self.FriendItems,key,item) 
end
-- 清除对象
function FriendRequestItem:ClearFriendItems()
	
	if self.FriendItems ~= nil then
		for k , v in pairs(self.FriendItems) do
			if v ~= nil then
				GameObject.Destroy(v)
			end
		end
	end
	self.FriendItems = {}
end
--点击申请后隐藏申请按钮
function FriendRequestItem:ChangeStatus(friendId)
	local item = self.FriendItems[friendId]
	if item == nil then
		return
	end
	item.gameObject:SetActive(false)
	self.TargetScene:ResetPos()
	local btn = item.transform:Find("status3")
	if btn ~= nil then
		btn.gameObject:SetActive(false)
	end
end