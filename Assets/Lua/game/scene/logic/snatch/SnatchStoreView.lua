--[[
author:gaofei
商城通用界面2(2 - 夺宝奇兵商城  11 - 天梯商场)
]]

SnatchStoreView = class ()

SnatchStoreView.scene = nil --场景scene
SnatchStoreView.panel = nil -- 界面

SnatchStoreView.storeType = nil -- 商场类型

-- 初始化
function SnatchStoreView:init(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Snatch/SnatchStoreView"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
	self.grid = self.panel.transform:Find("Anchors/UI/Scroll View/Grid")
	self.scroolview = self.panel.transform:Find("Anchors/UI/Scroll View")
	
	self.title = self.panel.transform:Find("Anchors/UI/Title"):GetComponent("UILabel")
    --self:checkSend()
	--self:HiddenView()
end
--如果本地没有这个商城类型的数据就请求这个类型的商城数据
function SnatchStoreView:checkSend()
	
	self.storeTable = self.storeManager:GetStoreTabel(self.storeType)
	if self.storeTable == nil then
		self.storeManager:SendStoreInfoReq(self.storeType)  
	else
		self:refresh()
	end
end

-- 设置管理类
function SnatchStoreView:SetStoreMangement(storemanager)
	printf("aress =="..tostring(storemanager))
	self.storeManager = storemanager
end

-- 设置商城类型
function SnatchStoreView:SetStoreType(storetype)
	self.storeType = storetype
	self:SetTitleName()
end

-- 设置标题名称
function SnatchStoreView:SetTitleName()
	if self.storeType == 2 then
		self.title.text = "夺宝商城"
	elseif self.storeType == 11 then
		self.title.text = "天梯商城"
	end
end
-- 设置商城监听
function SnatchStoreView:BoundButtonEvents()
	self.scene:boundButtonEvents(self.panel)
end

-- 刷新界面
function SnatchStoreView:refresh()
	
	if self.storeTable == nil then
		return
	end
	local storeTXT = TxtFactory:getTable(TxtFactory.StoreConfigTXT) -- 商城表
	
	for i = 1 , #self.storeTable do
		--if tonumber(storeTabels:GetData(i,"SHOP_TYPE")) == 2 then
			local id = self.storeTable[i].id --该道具的id
			local object_id = self.storeTable[i].object_id	--购买的道具ID
			local object_num = self.storeTable[i].object_num	--购买的道具数量
			local money_type = self.storeTable[i].money_type	--货币类型
			local money_num = self.storeTable[i].money	--货币数量
			local itemName = storeTXT:GetData(id,TxtFactory.S_STORECONFIGTXT_SHOP_GOODS_NAME) --道具名字
			local itemIconName = storeTXT:GetData(id,TxtFactory.S_STORECONFIGTXT_GOODS_ICON) --道具icon
			local limitType = self.storeTable[i].limit_type --限制的方式(1打折时限2购买时限3限购数量)
			local moneyOff = self.storeTable[i].money_off	--折扣
			local limitTime = self.storeTable[i].limit_time --限制时间

			local obj  = newobject(Util.LoadPrefab("UI/Snatch/TemplateStoreItem"))
			obj.transform.parent = self.grid.transform
			obj.transform.localPosition = Vector3.zero
    		obj.transform.localScale = Vector3.one
			obj.name = id
			
			obj.transform:Find("Name"):GetComponent("UILabel").text = itemName
			obj.transform:Find("StoreBuyBtn/Label"):GetComponent("UILabel").text = money_num
			obj.transform:Find("Icon"):GetComponent("UISprite").spriteName = itemIconName
			if tonumber(object_num) == 1 then
				obj.transform:Find("Count"):GetComponent("UILabel").text = ""
			else
				obj.transform:Find("Count"):GetComponent("UILabel").text = "x"..object_num
			end
			obj.transform:Find("StoreBuyBtn/Background 1"):GetComponent("UISprite").spriteName = self.storeManager:GetIconName(money_type)
			--限购折扣
			local discount = obj.transform:Find("discount")
			local time = obj.transform:Find("time"):GetComponent("UILabel")
			discount.gameObject:SetActive(false)
			time.text = ""
			
			if limitType == 1 then  
				if moneyOff < 10 then --如果小于10才显示折扣，现价是 原价*折扣
					discount:SetActive(true)
					discount:GetComponent("UILabel").text = money_num
					obj.transform:Find("StoreBuyBtn/Label"):GetComponent("UILabel").text = money_num * moneyOff / 10
				end
			elseif limitType == 2 then
				time.text = "剩余购买时间："..limitTime
			elseif limitType == 3 then
				time.text = "剩余购买次数："..limitTime
			end
			obj.transform:Find("StoreBuyBtn").gameObject.name = "StoreBuyBtn_1"
			obj.transform:Find("StoreItemInfo").gameObject.name = "StoreItemInfo_1"
		--end
	end
	self:BoundButtonEvents()
	local itemGrid = self.grid:GetComponent("UIGrid")
	itemGrid:Reposition()
	itemGrid.repositionNow = true
	local sv = self.scroolview:GetComponent("UIScrollView")
    sv:ResetPosition()
end

-- 购买物品
function SnatchStoreView:StoreBuyBtnOnClick(obj)
	printf("buttonName==="..obj.transform.parent.name)
	local buyID = tonumber (obj.transform.parent.name)
	self.storeManager:SendBuyItemReq(buyID)
end
-- 点击显示所选物品的信息
function SnatchStoreView:StoreItemInfoOnClick(obj)
	self.scene:ShowItemTips(tonumber(obj.transform.parent.name))
end
--激活暂停界面
function SnatchStoreView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function SnatchStoreView:HiddenView()
	self.panel:SetActive(false)
end