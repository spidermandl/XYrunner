--[[
author:gaofei
商城界面
]]
require "game/scene/logic/store/StoreManagement"	--商城数据类
require "game/scene/logic/store/StoreGiftBagView"
require "game/scene/logic/store/StorePayView"
require "game/scene/logic/store/StoreBuildView"
require "game/scene/logic/store/StoreResourceView"


StoreView = class ()

StoreView.scene = nil --场景scene
StoreView.panel = nil -- 界面
StoreView.storeManager = nil -- 商城数据类
StoreView.tabBackground = nil -- 商城页签背景对象
StoreView.storeType = 0 -- 当前选中的商城类型
StoreView.storeItems = nil -- 存储商城物品对象

StoreView.storeGiftBagView = nil -- 商城礼包界面
StoreView.storePayView = nil  -- 商城充值界面
StoreView.storeBuildView = nil -- 商城建设界面
StoreView.storeResourceView = nil --商城资源界面
StoreView.scrollView = nil --scrollView
StoreView.grid = nil --grid

-- 初始化
function StoreView:init(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Store/StoreView"))
	if self.scene.uiRoot == nil then
		self.scene.uiRoot =  find("UI Root")
	end
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
	
	self.tabBackground = {}
	self.tabBackground[1] = self.panel.transform:Find("Anchors/UI/Grid/StoreGiftBagBtn/SeleteBG"):GetComponent("UISprite")
	self.tabBackground[2] = self.panel.transform:Find("Anchors/UI/Grid/StoreBuildBtn/SeleteBG"):GetComponent("UISprite")
	self.tabBackground[3] = self.panel.transform:Find("Anchors/UI/Grid/StoreResourceBtn/SeleteBG"):GetComponent("UISprite")
	self.tabBackground[4] = self.panel.transform:Find("Anchors/UI/Grid/StorePayBtn/SeleteBG"):GetComponent("UISprite")
	
	-- 存储物品的父节点
	self.scrollView = self.panel.transform:Find("Anchors/UI/Scroll View"):GetComponent("UIScrollView")
	self.grid = self.panel.transform:Find("Anchors/UI/Scroll View/Grid")
	self.panel:SetActive(false)
    self.storeManager = StoreManagement.new()
    self.storeManager:Awake(self.scene)
	self.storeGiftBagView = StoreGiftBagView.new()
	self.scene.storeGiftBagView = self.storeGiftBagView
	self.storePayView = StorePayView.new()
	self.scene.storePayView = self.storePayView
	self.storeBuildView = StoreBuildView.new()
	self.scene.storeBuildView = self.storeBuildView
	self.storeResourceView = StoreResourceView.new()
	self.scene.storeResourceView = self.storeResourceView
end

-- 初始化数据
function StoreView:InitData(storeType)
	self.storeType = storeType
	self:SetTabSeleteState()
	self:InitItem()
end

-- 初始化商品列表
function StoreView:InitItem()
	self:ClearStoreItems()
	
	if self.storeType == 1 then
		self.storeGiftBagView:init(self)
	elseif self.storeType == 3 then
		self.storeResourceView:init(self)
	elseif self.storeType == 4 then
		self.storePayView:init(self)
	elseif self.storeType == 2 then
		self.storeBuildView:init(self)
	end
	self:ResetPos()
	
end
function StoreView:ResetPos()

	local itemGrid = self.grid:GetComponent("UIGrid")
	itemGrid:Reposition()
	itemGrid.repositionNow = true
	self.scrollView:ResetPosition()
	--local sv = self.scroolview:GetComponent("UIScrollView")
    --scrollView:ResetPosition()
	self.scene:boundButtonEvents(self.panel)
end

-- 插入物品对象
function StoreView:AddStoreItem(item)
	table.insert(self.storeItems,item) 
end

-- 清除对象
function StoreView:ClearStoreItems()
	
	if self.storeItems ~= nil then
		printf("count=="..#self.storeItems)
		for i = 1 , #self.storeItems do
			if self.storeItems[i] ~= nil then
				GameObject.Destroy(self.storeItems[i])
			end
		end
	end
	
	self.storeItems = {}
end

--激活暂停界面
function StoreView:ShowView()
	self.panel:SetActive(true)
	--self.scene:SetActive(false)
end

-- 冷藏界面
function StoreView:HiddenView()
	self.panel:SetActive(false)
	--self.scene:SetActive(true)
end

-- 设置页签背景
function StoreView:SetTabSeleteState()
	for i = 1 , #self.tabBackground do
		if self.storeType == i then
			self.tabBackground[i].spriteName = "scxuan2"
		else
			self.tabBackground[i].spriteName = "scxuan"
		end
	end
end

-- 礼包界面
function StoreView:StoreGiftBagBtnOnClick()
	printf("礼包界面")
	if self.storeType == 1 then
		return
	end
	self.storeType = 1
	self:SetTabSeleteState()
	self:InitItem()
end

-- 建设界面
function StoreView:StoreBuildBtnOnClick()
	printf("建设界面")
	if self.storeType == 2 then
		return
	end
	self.storeType = 2
	self:SetTabSeleteState()
	self:InitItem()
end

-- 资源界面
function StoreView:StoreResourceBtnOnClick()
	printf("资源界面")
	if self.storeType == 3 then
		return
	end
	self.storeType = 3
	self:SetTabSeleteState()
	self:InitItem()
end

-- 充值界面
function StoreView:StorePayBtnOnClick()
	printf("充值界面")
	if self.storeType == 4 then
		return
	end
	self.storeType = 4
	self:SetTabSeleteState()
	self:InitItem()
end

-- 购买界面
function StoreView:StoreBuyBtnOnClick(obj)
	local id = tonumber(obj.transform.parent.name)
	
	if self.storeType ~= 4 and self.storeType ~= 2 then
		self.storeManager:SendBuyItemReq(id)
	else
		-- 其他的商城暂时未开放
		self.scene:promptWordShow("该商城暂未开放")
	end
--[[
	printf("buttonName==="..obj.transform.parent.name)
	local id = tonumber(obj.transform.parent.name)
	self.buyId = id
	if self.storeType ~=4 and  self.storeType ~=2  then
			self.scene:ConsultBoxViewShow("是否购买",function (scene)
			local id = scene.storeView.buyId 
		 	scene.storeView.storeManager:SendBuyItemReq(id)
		 end)
	else
		self.scene:promptWordShow("未开放")
	end
	]]--
end
-- 点击显示所选物品的信息
function StoreView:StoreItemInfoOnClick(obj)
	--print("obj.transform.parent.name : "..obj.transform.parent.name)
	self.scene:ShowItemTips(tonumber(obj.transform.parent.name))

end

-- 设置购买所需消耗物品类型的Icon  1（金币）2（钻石)3（夺宝货币 4(RMB)
function StoreView:GetIconName(itemType)
	if itemType == 1 then
		return "jinbi"
	elseif itemType == 2 then
		return "zuanshi"
	elseif itemType == 3 then
		return "duobaobi"
	elseif itemType == 4 then
		return ""
	end
end