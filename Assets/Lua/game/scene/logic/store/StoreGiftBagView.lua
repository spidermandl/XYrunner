--[[
author:gaofei
商城礼包界面
]]


StoreGiftBagView = class ()
StoreGiftBagView.targetScene = nil --场景
StoreGiftBagView.storeTable = nil --该类型的商店道具

--初始化
function StoreGiftBagView:init(targetScene)
	self.targetScene = targetScene
	self:checkSend()
end
--检查是否需要请求数据
function StoreGiftBagView:checkSend()
	self.storeTable = self.targetScene.storeManager:GetStoreTabel(4)
	if self.storeTable == nil then
		self.targetScene.storeManager:SendStoreInfoReq(4)  --如果本地没有这个商城类型的数据就请求这个类型的商城数据
	else
		self:refresh()
	end
end

-- 刷新
function StoreGiftBagView:refresh()

	if self.storeTable == nil then
		return
	end
	local storeTXT = TxtFactory:getTable("StoreConfigTXT") -- 商城表
	for i = 1 , #self.storeTable  do
		--if tonumber(storeTabels:GetData(i,"SHOP_TYPE")) == 4 then
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
			self.targetScene:AddStoreItem(obj)
			obj.transform.parent = self.targetScene.grid.gameObject.transform
			obj.transform.localPosition = Vector3.zero
    		obj.transform.localScale = Vector3.one
			obj.name = id
			--print("object_id:"..object_id.."   object_num:"..object_num.."   money_type:"..money_type.."   money_num:"..money_num)
			--print("   itemName:"..itemName.."   itemIconName:"..itemIconName)
			obj.transform:Find("Name"):GetComponent("UILabel").text = itemName
			if tonumber(object_num) == 1 then
				obj.transform:Find("Count"):GetComponent("UILabel").text = ""
			else
				obj.transform:Find("Count"):GetComponent("UILabel").text = "x"..object_num
			end
			obj.transform:Find("StoreBuyBtn/Label"):GetComponent("UILabel").text = money_num
			obj.transform:Find("StoreBuyBtn/Background 1"):GetComponent("UISprite").spriteName = self.targetScene.storeManager:GetIconName(money_type)
			local iconSprite = obj.transform:Find("Icon"):GetComponent("UISprite")
			iconSprite.spriteName = itemIconName
			iconSprite:MakePixelPerfect()
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


		--end
	end
	self.targetScene:ResetPos()
end
