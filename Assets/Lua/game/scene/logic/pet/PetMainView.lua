--[[
author:Huqiuxiang
萌宠主界面
]]

require "game/scene/logic/pet/ReplacePetView"

PetMainView = class()

PetMainView.scene = nil --场景scene
PetMainView.management = nil -- 数据model 
PetMainView.iconGrid = nil -- 图标list的根
PetMainView.iconBigroot = nil -- 左侧大icon的根

PetMainView.myGiftItemsGrid = nil --经验物品的list根
PetMainView.myGiftItems = nil 
PetMainView.sceneTarget = nil 

PetMainView.panel = nil -- 面板
PetMainView.buyPanel = nil -- 购买面板
PetMainView.petTable = nil -- 宠物种类表
PetMainView.mountTxt = nil -- 宠物信息表
PetMainView.MaterialTable = nil -- 物品配置表消息
PetMainView.btnState = nil
PetMainView.allBtnState = 1
PetMainView.aidBtnState = 2
PetMainView.flightBtnState = 3

PetMainView.items =  nil 
PetMainView.info = nil 
PetMainView.giftTab = nil -- 宠物礼品表(private)
PetMainView.mygiftPanel = nil  -- 我的礼物 面板
PetMainView.petPanel = nil  -- 宠物面板
PetMainView.replacePanel = nil  -- 替换宠物面板

PetMainView.selectBtn = nil -- 选中萌宠按钮
PetMainView.expItemSelectBtn = nil -- 选中经验物品
PetMainView.joinBtnLabel = nil -- 上场按钮
PetMainView.type = nil -- 判读主界面版

PetMainView.modelShow = nil -- 模型展

PetMainView.buyItemId = nil -- 当前购买id
PetMainView.buyItemsNum = nil -- 购买数量
PetMainView.buyItemsNumMax = nil -- 购买数量最大化
PetMainView.buyItemsNumLabel = nil
PetMainView.priceLabel = nil
PetMainView.priceType = nil 
PetMainView.itemPrice = nil 
PetMainView.effect = nil -- 升级特效

PetMainView.petInfo = nil -- 升级特效

PetMainView.DuizhangButton = nil
PetMainView.HaveNum = nil
-- 初始化
function PetMainView:init(target)
	self.scene = target
	self.management = self.scene.petManagement
	self.sceneTarget = self.scene.sceneTarget
	self.modelShow = self.scene.modelShow
	self.petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo) -- 萌宠数据表
	if self.petInfo[TxtFactory.MERGE_PETSSLOTTAB] == nil then
		self.petInfo[TxtFactory.MERGE_PETSSLOTTAB] = {}
	end
	self.MaterialTable = TxtFactory:getTable(TxtFactory.MaterialTXT) -- 材料背包数据表
	self.petTable = TxtFactory:getTable(TxtFactory.MountTypeTXT) -- 萌宠总数据表
	self.mountTxt = TxtFactory:getTable(TxtFactory.MountTXT) -- 宠物信息表
	self.panel = self.scene:LoadUI("Pet/PetMainUI") -- 当前界面
	--self.panel:SetActive(true)
	local trans = self.panel.transform:GetChild(0)
	self.petPanel = trans:Find("PetMainUI_petPanel") -- 宠物列表
	self.items = self.petPanel:Find("PetMainUI_items")
	self.iconGrid = self.items:GetChild(0)
	self.info = trans:Find("title/PetMainUI_info")
	--self.mygiftPanel = trans:Find("PetMainUI_giftPanel") -- 我的礼物面板
	--self.myGiftItems = self.mygiftPanel:Find("PetMainUI_myGiftItems") -- 礼物列表view
	--self.myGiftItemsGrid = self.myGiftItems:GetChild(0) -- 我的礼物按钮列表root
	
	self.replacePanel = ReplacePetView.new() -- 替换上场宠物界面
	local replacePanelObj = self.panel.transform:Find("ReplacePetUI")
	local ReplacePetCloseBtn = replacePanelObj.transform:FindChild("ReplacePetCloseBtn")
	AddonClick(ReplacePetCloseBtn,function( ... )
		-- body
		self.scene:uiReplacePetEvent("ShowReplaceView", false)
	end)
	self.replacePanel:init(target, replacePanelObj.gameObject)	--交换界面

	self.scene:boundButtonEvents(self.panel) -- 给相应的按钮赋值
	self.joinBtnLabel = trans:Find("title/PetMainUI_joinBtn"):FindChild("Label"):GetComponent("UILabel") 
	--self.mygiftPanel.gameObject:SetActive(false)
	self.HaveNum = self.panel.transform:FindChild("UI/HaveNum")
	self.selectBtn = self.panel.transform:FindChild("UI/PetMainUI_petPanel/PetMainUI_allBtn")
	--self:allBtn() -- 默认选中全部按钮
	self:panelUpdate()
    self.scene:SetUiAnChor()
--[[	-- 添加特效
	self.effect = trans:Find("title/ef_ui_shengji"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
	SetEffectOrderInLayer(self.effect,10)]]

	-- 设置分类按钮
	--GameWarnPrint("SetCheckPZPets SetCheckPZPets SetCheckPZPets")
	self:SetCheckPZPets(self.petPanel:Find("PetMainUI_ss"),"ssdengji")
	self:SetCheckPZPets(self.petPanel:Find("PetMainUI_s"),"sdengji")
	self:SetCheckPZPets(self.petPanel:Find("PetMainUI_a"),"adengji")
	self:SetCheckPZPets(self.petPanel:Find("PetMainUI_b"),"bdengji")
	self:InitPanelControl()
	-- 队长功能
	self:InitDuizhang()

	--主界面关闭
	local closeBtn = self.panel.transform:FindChild("UI/PetMainUI_close")
	AddonClick(closeBtn,function ( ... )
		-- body
		self.scene:petMainView_backBtn()
	end)
	destroyUIButtonMessage(self.panel)
end

--PetMainView.DuizhangID = nil
function PetMainView:InitDuizhang()

	self.DuizhangButton = self.info:GetChild(0):FindChild("icon/join/DuizhangButton")
--[[	if self.petInfo[TxtFactory.DUI_ZHANG] ~= nil then
		--self.DuizhangID = self.petInfo[TxtFactory.DUI_ZHANG]
	end]]
	AddonClick(self.DuizhangButton,function ( ... )
		-- body
		self.petInfo[TxtFactory.DUI_ZHANG] = self.petInfo[TxtFactory.PETMAIN_SELECTED]
		self:panelUpdate()
		self.management:sendPetSetHeroRequest()
		self.DuizhangButton.gameObject:SetActive(false)
	end)

end

-- 升级成功 boolLevelUP = true(升等级)false(仅升经验)
function PetMainView:OnUpgradeSucceed(boolLevelUP)
	--self.scene:petMainView_ListUpdate()
	self.scene:petMainView_expItemsListUpdate()
	if boolLevelUP then
		self.effect.gameObject:SetActive(boolLevelUP) -- 升级特效
		self.effect:Play()
	end

	if self.PetFunctionPanel ~= nil and self.PetFunctionPanel.activeSelf then
		self:UpdateCurPet0()
	end
end

function PetMainView:GetSoltWeightInfo(tid)
	-- body
	local ctid = self.mountTxt:GetData(tid, TxtFactory.S_MOUNT_TYPE) -- 种类id
	local potental = self.petTable:GetData(ctid,"POTENTIAL") -- 资质POTENTIAL
	local level = self.mountTxt:GetData(tid, TxtFactory.S_MOUNT_LVL) -- 等级
	return tonumber(potental), tonumber(level)
end
-- 萌宠列表更新
local duizhangSp = "xiaozhuazi"
local duiyuanSp = "xiaochibang"

function PetMainView:PaixuFun( petTab)
	-- body
	local sss = {}
    for o =1, #petTab do
    	local a = petTab[o]
    	local pta, la = self:GetSoltWeightInfo(a.tid)
    	local sa = pta *la * 10000000 + pta*10000 + la
    	table.insert(sss,{sa,petTab[o]})
    end
    --GamePrintTable(sss)
    table.sort(sss,function(a,b)

    	if tonumber(a[1]) == tonumber(b[1])  then
            return tonumber(a[2].tid) > tonumber(b[2].tid)
        else
            return tonumber(a[1]) > tonumber(b[1])
        end

	end)
	return sss
end
function PetMainView:listUpdate(petTab)
    local trans = self.iconGrid.transform
    for i=0, trans.childCount-1 do
    	trans:GetChild(i).gameObject:SetActive(false)
    end
    local sss = self:PaixuFun(petTab)
    --GamePrintTable(sss)

	--[[for k, v in ipairs(sss) do
		GamePrintTable(v[2].id)
	end]]

	local nnum = trans.childCount
    for o =1, #sss do
    	-- local path = "petMainIcon"
    	--GamePrintTable(sss[o][2].id)
    	local ddate = sss[o][2]
    	local id = ddate.id -- 获得id
    	local tid = ddate.tid -- 获得tid
    	local slot = ddate.slot -- 上下场
		local ctid = self.mountTxt:GetData(tid, TxtFactory.S_MOUNT_TYPE) -- 种类
		local level = self.mountTxt:GetData(tid, TxtFactory.S_MOUNT_LVL) -- 等级
    	local starNum = self.mountTxt:GetData(tid, TxtFactory.S_MOUNT_STAR) -- 星级
    	local icon =  nil --trans:Find(tostring(id))
    	if o >  nnum then
    		icon = self.scene:creatPetIcon(ddate.tid, self.iconGrid).transform -- 创建宠物icon
    	else
    		icon = trans:GetChild(o -1)
    		icon.gameObject:SetActive(true)
    		self.scene:UpdataPetIcon(ddate.tid,icon)
    	end
    	icon.gameObject.name = id
    	local levelLabel = icon:FindChild("levelLabel")-- 更新等级信息
		levelLabel.gameObject:SetActive(true)
		local plabel = levelLabel:GetChild(0):GetComponent("UILabel")
		plabel.text = "lv." .. tostring(level)
		local starGrid = icon:FindChild("starGrid")-- 更新星级
	    local starGridCo = starGrid.gameObject.transform:GetComponent("UIGrid")
	    for i=0, starGrid.childCount-1 do
	        starGrid:GetChild(i).gameObject:SetActive(i < starNum)
	    end
	    starGridCo:Reposition() -- 自动排列
	    local joinTag = icon:FindChild("tag") -- 上场标识
		-- 宠物上场图片
		local tTag = joinTag:GetComponent("UISprite") -- 上阵标记
		tTag.spriteName = ""
		if slot ~= 0 then
        	joinTag.gameObject:SetActive(true)
            if  self.petInfo[TxtFactory.DUI_ZHANG] == id then
                tTag.atlas = Util.PreLoadAtlas("UI/Picture/Pet")
                tTag.spriteName = duizhangSp
            else
                tTag.atlas = Util.PreLoadAtlas("UI/Picture/Pet")
                tTag.spriteName = duiyuanSp
            end
    	else
        	joinTag.gameObject:SetActive(false)
    	end

		--self.scene:SetButtonTarget(icon,self.sceneTarget)

		self:SetPetIconBtn(icon)

    end

    for o = #sss + 1, nnum do
    	trans:GetChild(o -1).gameObject:SetActive(false)
    end
	local grid = self.iconGrid:GetComponent("UIGrid")
    grid:Reposition() -- 自动排列

    local sv = self.items:GetComponent("UIScrollView")
    sv:ResetPosition()

    --背包数量 petInfo[TxtFactory.BIN_PETS]
    --GamePrintTable("背包数量")
    --GamePrintTable(self.petInfo)
    local num = #self.petInfo[TxtFactory.BIN_PETS]
    local mmax = self.petInfo[TxtFactory.Limit_NUM]
    self.HaveNum:FindChild("Label"):GetComponent("UILabel").text = "拥有数:"..tostring(num).."/"..tostring(mmax)

end

function PetMainView:SetPetIconBtn(item)
	-- body
	local btn = item.transform:FindChild("SeletePetIcon")
	AddonClick(btn,function(btn)
		self:listBtnOnClick(btn.transform.parent.gameObject)
	end)

end
function PetMainView:SetActive(enable)
--[[	if enable == false then
		self.sddd = 22222
	end]]
	--GameWarnPrint("PetMainView:SetActive ="..tostring(self.panel.activeSelf).."||"..tostring(enable))
	if self.panel.activeSelf == enable then
		return
	end
	self.panel:SetActive(enable)
	if enable then
		self:panelUpdate()
		self:updateLeftIcon()
		self:myGiftCloseBtn()
	else
		--self.effect.gameObject:SetActive(false)
		self.management:sendPetJoin()
	end
end

-- 初始化宠物礼品列表
function PetMainView:initPetGiftList()
    -- 获取礼物列表
	local storeTXT = TxtFactory:getTable(TxtFactory.StoreConfigTXT) -- 商城表
	local petStoreTxt = storeTXT:GetTableByType(3)
	self.giftTab = {}
	for i=1, #petStoreTxt do
		local itemName = storeTXT:GetData(petStoreTxt[i],TxtFactory.S_STORECONFIGTXT_SHOP_GOODS_NAME) --道具名字
		local itemIconName = storeTXT:GetData(petStoreTxt[i],TxtFactory.S_STORECONFIGTXT_GOODS_ICON) --道具icon
		local mat_str = storeTXT:GetData(petStoreTxt[i],TxtFactory.S_STORECONFIGTXT_MATERIAL_ID) --道具对应材料ID
		local item_mat_id = lua_string_split(mat_str, "=")[1]
		local item_price = storeTXT:GetData(petStoreTxt[i], TxtFactory.S_STORECONFIGTXT_PRICE_COUNT) -- 价钱
		local p_type = storeTXT:GetData(petStoreTxt[i], TxtFactory.S_STORECONFIGTXT_TYPE) -- 货币类型
		-- warn("itemName:"..tostring(itemName).."&itemIconName:"..tostring(itemIconName).."&item_mat_id:"..tostring(item_mat_id))
		local id = tonumber(item_mat_id)
		self.giftTab[id] = { tonumber(item_price), tonumber(p_type) }
		local path = "GiftitemIcoBack"
    	local icon = self:creatIcon(self.myGiftItemsGrid,self.sceneTarget,path).transform -- 创建icon
		icon.name = "petExpItemsBuy_"..item_mat_id
    	local expData = self.MaterialTable:GetData(tostring(item_mat_id) ,"ADD_PET_EXP") -- 读配置表获取经验
		local icoData = self.MaterialTable:GetData(tostring(item_mat_id) ,"MATERIAL_ICON") -- 读配置表获取icon
		local exp = icon:FindChild("ExpLabel"):GetComponent("UILabel")
		local num = icon:FindChild("NumLabel"):GetComponent("UILabel")
		local ico = icon:FindChild("icon"):GetComponent("UISprite")
		exp.text = expData
		num.text = 0
		ico.spriteName = icoData
		self:SetBuyItemBtn(icon)
	end
end

function PetMainView:SetBuyItemBtn(item)
	-- body
	AddonClick(item,function(button)
		-- body
		self.scene:petMainView_buyItems(button)
	end)
end
-- 筛选已经拥有的宠物经验材料
function PetMainView:getExpItemsTab()
	local BagItemsInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo)
	local tab = {}
	if not BagItemsInfo then return end
	-- 已拥有萌宠经验物品
	for i =1 , #BagItemsInfo.bin_items do
		local id = BagItemsInfo.bin_items[i].tid
		local num = BagItemsInfo.bin_items[i].num
		local materialType = self.MaterialTable:GetData(id,"MATERIAL_TYPE")
    	if materialType == "6" then
			tab[#tab + 1] = BagItemsInfo.bin_items[i]
		end
	end
	-- print("所有材料".. #BagItemsInfo.bin_items.."已经拥有的宠物经验材料"..#tab)
	return tab
end

-- 物品icon list更新
function PetMainView:itemsListUpdate(isNotSetPos)
	if self.myGiftItemsGrid.transform.childCount == 0 then
		self:initPetGiftList()
	end

	local itemsInfo = self:getExpItemsTab() -- 已拥有
	if itemsInfo == nil then
		return
	end

	local path = "GiftitemIcoBack"
	for i =1, #itemsInfo do
    	local id = itemsInfo[i].tid
    	local icon = self.myGiftItemsGrid.transform:Find("petExpItemsBuy_"..id)
    	if icon == nil then
	    	icon = self:creatIcon(self.myGiftItemsGrid,self.sceneTarget,path).transform
			icon.name = "petExpItemsBuy_"..id
		end
    	local expData = self.MaterialTable:GetData(tostring(id) ,"ADD_PET_EXP") -- 读配置表获取经验
    	local icoData = self.MaterialTable:GetData(tostring(id) ,"MATERIAL_ICON")-- 读配置表获取icon
		local exp = icon:FindChild("ExpLabel"):GetComponent("UILabel")
		local num = icon:FindChild("NumLabel"):GetComponent("UILabel")
		local ico = icon:FindChild("icon"):GetComponent("UISprite")
		exp.text = expData 
		num.text = itemsInfo[i].num -- 数量来自服务器数据
		ico.spriteName = icoData -- iocn图片赋值
		self:SetItemOnPress(icon)
	end
	destroyUIButtonMessage(self.myGiftItemsGrid)
	if isNotSetPos == true then
		return
	end
	local grid = self.myGiftItemsGrid:GetComponent("UIGrid")
    grid:Reposition() -- 自动排列
    local itemsScrollView = self.myGiftItemsGrid.transform.parent:GetComponent("UIScrollView")
    itemsScrollView:ResetPosition()
end
PetMainView.StarAutoBuy = false
PetMainView.ItemNum = 0
function PetMainView:SetItemOnPress(btn)
	-- body

	AddonPress(btn,function(btn,bl)
		-- body

		self.StarAutoBuy = bl
		self.ItemNum = 0
		if bl == true then
			local array = lua_string_split(tostring(btn.name), "_")
			if array[2] then
				local BagItemsInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo) -- 材料背包数据
				local itemsInfo = self.management:getExpItemsTab() -- 已拥有
				-- 如果已经拥有这个材料，则直接升级
				local iid = nil
				--local nnum = nil
				for i =1, #itemsInfo do
					if tonumber(itemsInfo[i].tid) == tonumber(array[2]) then
						iid = itemsInfo[i].id
						self.ItemNum = itemsInfo[i].num
						--GamePrintTable(itemsInfo[i])
						break
					end
				end
				if iid ~= nil then
					coroutine.start(AutoBuy,self,iid)
				end
			end
		end
	end)
end

function AutoBuy(self,id)
	-- body
	coroutine.wait(0.1)
	 while self.StarAutoBuy and self.ItemNum > 0 do
	 	--self.ItemNum = self.ItemNum - 1
	 	self:EatExpItems(id)
	 	coroutine.wait(0.02)
    end
end
-- 全部按钮
function PetMainView:allBtn(btn)
	self.selectBtn = btn
	--self.btnState = self.allBtnState -- 当前选择的是全部按钮
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo) -- 萌宠数据表
    local petTab = petInfo[TxtFactory.BIN_PETS]
	--GamePrintTable	("petTab petTab petTab222222")
	----GamePrintTable	(petTab)
	self:listUpdate(petTab)
	self:listBtnOnClick()
end

-- 支援按钮
function PetMainView:aidBtn(btn)
	self.btnState = self.aidBtnState -- 当前选择的是全部按钮
	self.management:getAidPetTab() -- 数据处理
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
    local petTab = petInfo[TxtFactory.AID_PETS]
	self:listUpdate(petTab)
	self:listBtnOnClick()
end

-- 飞行按钮
function PetMainView:flightBtn(btn)
	self.btnState = self.flightBtnState -- 当前选择的是全部按钮
	self.management:getFlightPetTab() -- 数据处理
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
    local petTab = petInfo[TxtFactory.FLY_PETS]
	self:listUpdate(petTab)
	self:listBtnOnClick()
end

-- 品质 分类按钮
function PetMainView:SetCheckPZPets(btn,pzSp)
	-- body
	--GameWarnPrint("btn ="..btn.gameObject.name)
	local uei = btn:GetComponent('UIEventListener')
	if uei == nil then
		uei = btn.gameObject:AddComponent(UIEventListener.GetClassType())
	end
	uei.onClick = function()
		local petTab = self.management:GetPetTablyByPZ(pzSp)
		self:listUpdate(petTab)
		self:listBtnOnClick()
		self.selectBtn = btn
	end
end
-- 当前面板更新
function PetMainView:panelUpdate()
	--GamePrintTable("当前面板更新 当前面板更新 当前面板更新")
	self.selectBtn = self.panel.transform:FindChild("UI/PetMainUI_petPanel/PetMainUI_allBtn")
	self.selectBtn.gameObject:SendMessage("OnClick",self.selectBtn,1)
	self:allBtn()
	--[[if self.btnState == self.allBtnState then
				self:allBtn()
			elseif self.btnState == self.aidBtnState then
				self:aidBtn()
			elseif self.btnState == self.flightBtnState then
				self:flightBtn()
			end]]
	-- self:setJoinBtn(tonumber(self.selectBtn))
end

-- 替换宠物ui 事件方法
function PetMainView:uiReplacePetEvent( fName,... )
	self.replacePanel[fName](self.replacePanel,...)
end

-- 显示替换上场萌宠界面
function PetMainView:ChooseOnePetToReplace(petId)
	self.replacePanel:ShowReplaceView(true)
	self.replacePanel:InitChoice(petId)
end

-- 上场按钮（发送）
function PetMainView:joinBtn()
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local selectId = petInfo[TxtFactory.PETMAIN_SELECTED]
	self.management:SetPetJoinState(selectId)
	--self:panelUpdate()
    self:updateLeftIcon()
    --GameWarnPrint("joinBtn")

	local _info = self.management:GetPetInfoById(selectId)
	if not _info then
		return
	end
	--GameWarnPrint("队长下场 123123123123x 队长下场")
	if _info.slot == 0 then
		-- 队长下场
		if self.petInfo[TxtFactory.DUI_ZHANG] == selectId then
			--GameWarnPrint("队长下场 队长下场 队长下场")
			self.petInfo[TxtFactory.DUI_ZHANG] = nil
			local petTab = petInfo[TxtFactory.BIN_PETS]
				GamePrintTable(petTab)
		    for o = 1 , #petTab do
		    	if petTab[o].slot ~= 0 and petTab[o].id ~= selectId then --tonumber(icon.name) 
		    		--GameWarnPrint("找到替补 ！！！！")
		    		self.petInfo[TxtFactory.DUI_ZHANG] = petTab[o].id
		    		self.management:sendPetSetHeroRequest()
		    		break
		    	end
		    end
		end
	end
	self:panelUpdate()
end

-- 送礼按钮（升级）
function PetMainView:giftBtn()
	self.petPanel.gameObject:SetActive(false)
	--self.mygiftPanel.gameObject:SetActive(true)
	self:itemsListUpdate()
end

-- 我的礼物关闭按钮
function PetMainView:myGiftCloseBtn()
	self.petPanel.gameObject:SetActive(true)
	--self.mygiftPanel.gameObject:SetActive(false)
end

-- 后退按钮
function PetMainView:backBtn()
	-- self.management:sendPetJoin()
end

-- 萌宠点击
--PetMainView.CurMainSelect_id = nil --当前选择的主宠物
function PetMainView:listBtnOnClick(btn)

	local select_id = nil
	if btn ~= nil then
		select_id = tonumber(btn.name)
		--self.CurMainSelect_id = select_id
		self.petInfo[TxtFactory.PETMAIN_SELECTED] = select_id
	else
		if self.petInfo[TxtFactory.PETMAIN_SELECTED] ~= nil then
			select_id = self.petInfo[TxtFactory.PETMAIN_SELECTED]
			--self.CurMainSelect_id = select_id
		else
			local trans = self.iconGrid.transform
			for i=0, trans.childCount-1 do
				if trans:GetChild(i).gameObject.activeSelf then
					select_id = tonumber(trans:GetChild(i).gameObject.name)
					--self.CurMainSelect_id = select_id
					break
				end
			end
			--self.CurMainSelect_id = select_id
			self.petInfo[TxtFactory.PETMAIN_SELECTED] = select_id
		end
	end

	if select_id == nil then
		return
	end

	local icon = self.info.gameObject.transform:GetChild(0).gameObject -- 左侧详细信息obj
	icon.name = tostring(select_id)

	
    local petTab = self.petInfo[TxtFactory.BIN_PETS]
	-- 显示宠物模型
	--GamePrintTable("slistBtnOnClick listBtnOnClick listBtnOnClick")
	--GamePrintTable	(petTab)
	local petid = self.management:idDataForTid(tonumber(select_id))
	if petid == nil or petid == 0 then
		return
	end
	petid = self.mountTxt:GetData(petid,TxtFactory.S_MOUNT_TYPE)
	if  self.panel.activeSelf then
		self.modelShow:ChoosePet(petid)
	end
	self:updateLeftIcon()

	local petIconInfoBtn = icon.transform:FindChild("petIconInfoBtn")
	AddonClick(petIconInfoBtn,function(button)
		-- body
		self.scene:creatIconInfoPanel(button)
	end)
end

--
--[[function PetMainView:setJoinBtn(id)

	

end]]

function PetMainView:ShowInfo(icon,iid)
	-- body
	if iid == nil then
		return
	end
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)

    --local icon = self.info.gameObject.transform:GetChild(0).gameObject -- 左侧详细信息obj
    local tid = nil -- 选中的宠物tid
    local slot = nil -- 选中的宠物上场信息
    local id  = 1 -- 选中的宠物id
    local exp = 0 -- 经验值

    local petTab = petInfo[TxtFactory.BIN_PETS]
    ------GamePrintTable	("petTab petTab petTab ="..iid);
    ------GamePrintTable	(petTab);

    for o = 1 , #petTab do
    	if petTab[o].id == iid then --tonumber(icon.name) 
    		id = petTab[o].id
    		tid = petTab[o].tid
    		slot = petTab[o].slot
    		exp = petTab[o].exp
    		break
    	end
    end

    -- 获取当前萌宠信息
	--print("tid="..tostring(tid).."&id="..id.."&slot="..tostring(slot))
    
    if tid == nil then
    	-- 该宠物已被吃掉
    	self.petInfo[TxtFactory.PETMAIN_SELECTED] = petTab[1].id
    	tid = petTab[1].tid
    	id = petTab[1].id
    	slot = petTab[1].slot
    	exp = petTab[1].exp
    end
    local lvtxt = self.mountTxt:GetData(tid, TxtFactory.S_MOUNT_LVL) -- 等级
    local ctid = self.mountTxt:GetData(tid, TxtFactory.S_MOUNT_TYPE) -- 种类id
    local starNum = self.mountTxt:GetData(tid, TxtFactory.S_MOUNT_STAR) -- 星级
    local nameData = self.petTable:GetData(ctid,"NAME") -- 名字
    local rankData = self.petTable:GetData(ctid,"RANK_ICON") -- 品质

    local ic = icon.gameObject.transform:FindChild("icon")
	local joinTag = ic:FindChild("join") -- 上场
	joinTag.gameObject:SetActive(slot ~= 0) -- 根据上下场状态判断 显示相应上下场图片
    local lvLabel = ic:FindChild("lvLabel"):GetComponent("UILabel") -- 等级
	lvLabel.text = tostring(lvtxt)
	local pank = ic:Find("pank"):GetComponent("UISprite") -- 品质
	pank.spriteName = self.petTable:GetData(ctid,"RANK_ICON_2")
	local typeTag = ic:Find("type"):GetComponent("UISprite") -- 类型/飞行支援
	typeTag.spriteName = ""--self.petTable:GetData(ctid,"TYPE_ICON")

	local nameLabel = ic:Find("nameLabel"):GetComponent("UILabel") -- 名字
	nameLabel.text = nameData
	local stars = ic:Find("starGrid") -- 星级
	for i=0, stars.childCount-1 do
		stars:GetChild(i).gameObject:SetActive(i < starNum)
	end
	stars:GetComponent("UIGrid"):Reposition()
	local expPro = icon.transform:Find("ExpProgress"):GetComponent("UISlider")
	local levelExp = self.mountTxt:GetData(tid, "GOODOPINION")
	exp = exp + tonumber(levelExp) - tonumber(self.mountTxt:GetData(tid, TxtFactory.S_MOUNT_EXP))
	expPro.value = tonumber(exp)/tonumber(levelExp)
	local expText = expPro.transform:Find("text"):GetComponent("UILabel")
	expText.text = exp.."/"..levelExp

end
-- 更新左侧icon 信息
--local nnnum = 0
function PetMainView:updateLeftIcon()
	local  id = self.petInfo[TxtFactory.PETMAIN_SELECTED]
	local icon  = self.info.gameObject.transform:GetChild(0).gameObject
	self:ShowInfo(icon,id)

	local slot =  self.management:idDataForSlot(id)
	local join = icon.transform:FindChild("icon/join")
	local ttype = icon.transform:FindChild("icon/type")
	if slot == 0 then
		self.joinBtnLabel.text = "上场"
		join.gameObject:SetActive(false)
		ttype.gameObject:SetActive(false)
	else
		self.joinBtnLabel.text = "下场"
		join.gameObject:SetActive(true)
		ttype.gameObject:SetActive(true)

		self.DuizhangButton = icon.transform:FindChild("icon/join/DuizhangButton")
		local isDuizhang = self.petInfo[TxtFactory.DUI_ZHANG] == id
		self.DuizhangButton.gameObject:SetActive(not isDuizhang)

		local tTag = ttype:GetComponent("UISprite") -- 上阵标记
        if  isDuizhang then
            tTag.atlas = Util.PreLoadAtlas("UI/Picture/Pet")
            tTag.spriteName = duizhangSp
        else
            tTag.atlas = Util.PreLoadAtlas("UI/Picture/Pet")
            tTag.spriteName = duiyuanSp
        end
	end

end

-------------------------------------------------------- 经验物品相关 --------------------------------

-- 萌宠吃经验物品
function PetMainView:EatExpItems(id)
	-- print("吃升级物品")
	self.expItemSelectBtn = id
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	petInfo[TxtFactory.EXPITEM_SELECTED] = tonumber(self.expItemSelectBtn)

	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local selectBtn = petInfo[TxtFactory.PETMAIN_SELECTED]
	if selectBtn == nil then
		-- print("选得宠物为空")
		local word = "选得宠物为空"
		self.scene:promptWordShow(word)
		return
	end

    local petTab = petInfo[TxtFactory.BIN_PETS]
    local tid = nil -- 选中的宠物tid
    local exp = 0 -- 经验值
    for o = 1 , #petTab do
    	if petTab[o].id == tonumber(selectBtn) then
    		tid = petTab[o].tid
    		exp = petTab[o].exp
    		break
    	end
    end
	
    local needexp = tonumber(self.mountTxt:GetData(tid, TxtFactory.S_MOUNT_EXP))
	if self.management:isNeedUpStar(tid) and exp >= needexp then
		
		--self.scene:promptWordShow("请先升星", self.scene.petMainView_mergeBtn)
		self.scene:promptWordShow("请先升星", function(scene)
			-- body
			self:Showshengxin()
			self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1] = tonumber(selectBtn)
			self:UpdateCurPet1(1)
		end)

		self.StarAutoBuy = false
		return
	end
	self.ItemNum = self.ItemNum - 1
	self.management:sendPetUpgrade()
end

-- 萌宠单个吃经验
function PetMainView:creatBuyExpItem(btn)
	local array = lua_string_split(tostring(btn.name), "_")
	if array[2] then
		local BagItemsInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo) -- 材料背包数据
		local itemsInfo = self.management:getExpItemsTab() -- 已拥有
		-- 如果已经拥有这个材料，则直接升级
		for i =1, #itemsInfo do
			if tonumber(itemsInfo[i].tid) == tonumber(array[2]) then
				self:EatExpItems(itemsInfo[i].id)
				return
			end
		end
		-- 如果没有这个材料，则跳转购买
		self:creatBuyPanel(tonumber(array[2]))
	end
end

-- 生成萌宠图标
function PetMainView:creatIcon(root,target,path)
	local icon = newobject(Util.LoadPrefab("UI/Pet/"..path))

    icon.gameObject.transform.parent = root.gameObject.transform
    icon.gameObject.transform.localScale = Vector3(1,1,1)

	-- 添加按钮监听脚本
	local  bm = icon:AddComponent(UIButtonMessage.GetClassType())
	bm.target = nil --target.gameObject
	bm.functionName = "OnClick"
    bm.trigger = 0
    local  bmp = icon:AddComponent(UIButtonMessage.GetClassType())
    bmp.target = nil --target.gameObject
    bmp.functionName = "OnPress"
    bmp.trigger = 1

    return icon
end

-- 创建购买面板
function PetMainView:creatBuyPanel(id)
	if self.buyPanel then
		self.buyPanel:SetActive(true)
	else
		self.buyPanel = self.scene:LoadUI("Pet/BuyItemUI")
		self.scene:boundButtonEvents(self.buyPanel)
		-- 点击事件
		local ttras = self.buyPanel.transform
		AddonClick(ttras:FindChild("UI/BuyItemUI_close"),function( ... )
			-- body
			self:buyItemPanelClose()
			--self.scene:buyItemPanelClose()
		end)
		AddonClick(ttras:FindChild("UI/BuyItemUI_buy"),function( ... )
			-- body
			--self.scene:petMainView_buyBtn()
			self:buyBtn()
		end)
		AddonClick(ttras:FindChild("UI/itemInfo/buyCount/Background/BuyItemUI_addBtn"),function( ... )
			-- body
			self.scene:buyItemJia()
		end)
		AddonClick(ttras:FindChild("UI/itemInfo/buyCount/Background/BuyItemUI_subtractBtn"),function( ... )
			-- body
			self.scene:buyItemJian()
		end)
		AddonClick(ttras:FindChild("UI/itemInfo/buyCount/Background/BuyItemUI_maxBtn"),function( ... )
			-- body
			self.scene:buyItemMax()
		end)
	end
	-- SetEffectOrderInLayer(self.buyPanel,100)
	local nameData = self.MaterialTable:GetData(tostring(id) ,"NAME") -- 配置表名字
	local desData = self.MaterialTable:GetData(tostring(id) ,"MATERIALDESC") -- 配置表描述
	local iconData = self.MaterialTable:GetData(tostring(id) ,"MATERIAL_ICON") -- 配置表icon

	-- ui对应obj
	local trans = self.buyPanel.transform:Find("UI")
	local nameLabel = trans:FindChild("itemInfo/info/name").gameObject.transform:GetComponent("UILabel")
	local desLabel = trans:FindChild("itemInfo/info/attDes").gameObject.transform:GetComponent("UILabel")
	local iconSprite = trans:FindChild("itemInfo/info/Background/icon").gameObject.transform:GetComponent("UISprite")
	local priceSprite = trans:FindChild("itemInfo/buyPrice/icon").gameObject.transform:GetComponent("UISprite")
	self.priceLabel = trans:FindChild("itemInfo/buyPrice/buyDes").gameObject.transform:GetComponent("UILabel")
	self.buyItemsNumLabel = trans:FindChild("itemInfo/buyCount/Background/count").gameObject.transform:GetComponent("UILabel")

	nameLabel.text = nameData
	desLabel.text = desData
	iconSprite.spriteName = iconData

	local priceData = self.giftTab[tonumber(id)] -- 配置表购买金币
	local priceIcon = "jinbi" 
	if priceData[2] == 2 then
		priceIcon = "zuanshi"
	end
	self.priceType = priceIcon -- 价格类型
	priceSprite.spriteName = priceIcon
	self.priceLabel.text = tostring(priceData[1])
	self.itemPrice = priceData[1]
	self.buyItemsNum = 1 -- 当前购买数量
	self.buyItemsNumMax = 99 -- 最大购买量
	self.buyItemsNumLabel.text = self.buyItemsNum -- 购买数量显示label
	-- self.buyItemId = tonumber(id) -- 当前购买物品的id
	local setItemId = function (id)
		local storeTXT = TxtFactory:getTable(TxtFactory.StoreConfigTXT) -- 商城表
		local petStoreTxt = storeTXT:GetTableByType(3)
		for i=1, #petStoreTxt do
			local mat_str = storeTXT:GetData(petStoreTxt[i],TxtFactory.S_STORECONFIGTXT_MATERIAL_ID) --道具对应材料ID
			local item_mat_id = lua_string_split(mat_str, "=")[1]
			if tonumber(item_mat_id) == tonumber(id) then
				--warn("petStoreTxt:"..petStoreTxt[i])
				return tonumber(petStoreTxt[i])
			end
		end
		return id
	end
	self.buyItemId = setItemId(id)
end

-- g购买礼品
function PetMainView:buyBtn()
	-- print("购买")
	-- 根据类型判断价格
	--GameWarnPrint("购买 ="..self.priceType)
	--GameWarnPrint("price ="..tostring(self.itemPrice))
	local pitemPrice = self.itemPrice * self.buyItemsNum
	local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo) -- 人物数据表
	if self.priceType == "zuanshi" then
		local price = user[TxtFactory.USER_DIAMOND] 
		if pitemPrice > price then
			local word = "钻石不够"
			self.scene:promptWordShow(word)
			return
		end
	elseif self.priceType == "jinbi" then
		local price = user[TxtFactory.USER_GOLD]
		if pitemPrice > price then
			local word = "金币不够"
			self.scene:promptWordShow(word)
			return
		end
	end
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	self.management:sendBugItems(self.buyItemId,self.buyItemsNum)
	self:buyItemPanelClose() -- 关闭面板
end

-- 关闭购买道具面板
function PetMainView:buyItemPanelClose()
	self.buyPanel:SetActive(false)
end

-- 减号按钮
function PetMainView:buyItemJian()
	if self.buyItemsNum <= 1 then
		return
	end
	self.buyItemsNum = self.buyItemsNum - 1 
	self.buyItemsNumLabel.text = self.buyItemsNum
	self.priceLabel.text = self.itemPrice * self.buyItemsNum
end

-- 加好按钮
function PetMainView:buyItemJia()
	if self.buyItemsNum >= self.buyItemsNumMax then
		return
	end
	self.buyItemsNum = self.buyItemsNum + 1 
	self.buyItemsNumLabel.text = self.buyItemsNum
	self.priceLabel.text = self.itemPrice * self.buyItemsNum
end

-- max按钮
function PetMainView:buyItemMax()



	self.buyItemsNum = self.buyItemsNumMax
	self.buyItemsNumLabel.text = self.buyItemsNumMax

	local pitemPrice = tonumber(self.itemPrice * self.buyItemsNum)

	self.priceLabel.text = tostring(pitemPrice)


	local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo) -- 人物数据表
	if self.priceType == "zuanshi" then
		local price = user[TxtFactory.USER_DIAMOND] 
		if pitemPrice > price then
			--local word = "钻石不够"
			self.buyItemsNum = math.max(1,math.floor(price/self.itemPrice))

			self.priceLabel.text = self.itemPrice * self.buyItemsNum
			self.buyItemsNumLabel.text = self.buyItemsNum
			return
		end
	elseif self.priceType == "jinbi" then
		local price = user[TxtFactory.USER_GOLD]
		if pitemPrice > price then
			--local word = "金币不够"
			self.buyItemsNum = math.max(1,math.floor(price/self.itemPrice))
			self.priceLabel.text = self.itemPrice * self.buyItemsNum
			self.buyItemsNumLabel.text = self.buyItemsNum
			return
		end
	end
end

PetMainView.PetFunctionPanel = nil
PetMainView.curShowItem = nil
PetMainView.PetShenji = nil
PetMainView.PetJIneng = nil
PetMainView.PetShenxin = nil
PetMainView.PetBianyi = nil

-- 成长培养界面按钮
function PetMainView:SetPetFunctionBtn()
	local btn = self.petPanel:Find("PetMainUI_chengzhang")
	AddonClick(btn,function()
		self.GoPetFunctionBtn(self)
			local PetFunction_close = self.PetFunctionPanel.transform:FindChild("UI/PetFunction_close")
			AddonClick(PetFunction_close,function( ... )
			self.PetFunctionPanel:SetActive(false)
			self.modelShow.modelRoot:SetActive(true)
			self:SetActive(true)
		end)
	end)
end
function PetMainView:SetGoMainBuild( ... )
	-- body
	local PetFunction_close = self.PetFunctionPanel.transform:FindChild("UI/PetFunction_close")
	AddonClick(PetFunction_close,function( ... )
		self.PetFunctionPanel:SetActive(false)
		--self:SetActive(false)
		self.scene:petMainView_backBtn()
	end)
end
function PetMainView:GoPetFunctionBtn(closefun)
	self:SetActive(false)
	if 	self.PetFunctionPanel == nil then
		self:InitPetFunctin()
	else
		self.PetFunctionPanel:SetActive(true)
		self.PetBtnSJObj:SendMessage("OnClick",self.PetBtnSJObj,1);
	end
	self:PetBtnSJ()
end
PetMainView.SelectPos = nil; 
function PetMainView:UpdateCurPet0()
	-- body
	local id = self.petInfo[TxtFactory.PETMAIN_SELECTED]
	local petTab = self.petInfo[TxtFactory.BIN_PETS]
	local  isHave = false
    for o = 1 , #petTab do
    	if petTab[o].id == id then --tonumber(icon.name) 
    		isHave = true
    		break
    	end
    end

    --宠物呗吃掉
    if not isHave then
    	self.petInfo[TxtFactory.PETMAIN_SELECTED] = petTab[1].id
    	id = petTab[1].id
    end

	self:ShowPetDataInfo(self.PetMainUI_info[1],id,0)

	local iicon = self.PetMainUI_info[1]:GetChild(0)
	local MainInfo = iicon:FindChild("MainInfo")
	local JinengInfo = iicon:FindChild("JinengInfo")
	MainInfo.gameObject:SetActive(true)
	JinengInfo.gameObject:SetActive(false)

	if id ~= nil then
		local petid = self.management:idDataForTid(tonumber(id))
		petid = self.mountTxt:GetData(petid,TxtFactory.S_MOUNT_TYPE)
		self.modelShow:ChoosePet2(petid,1)
	end

end

function PetMainView:UpdateCurPet1(pos)
	-- body
	local PetMainUI = self.PetMainUI_info[pos]
	local id = self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][pos]
	self:ShowPetDataInfo(PetMainUI,id,pos)
	if id ~= nil then

		local dData = nil

		local petTab = self.petInfo[TxtFactory.BIN_PETS]

		for i = 1, #petTab do
			if petTab[i].id == id then
				dData = petTab[i]
				break
			end
		end
		--GamePrintTable("当前 萌宠：")
		--GamePrintTable(dData)
		local petid = self.management:idDataForTid(tonumber(id))
		petid = self.mountTxt:GetData(dData.tid,TxtFactory.S_MOUNT_TYPE)
		self.modelShow:ChoosePet2(petid,pos)

		local iicon = PetMainUI:GetChild(0)
		local MainInfo = iicon:FindChild("MainInfo")
		local JinengInfo = iicon:FindChild("JinengInfo")

		if 	self.BtnType == 2 then
			--显示技能
			MainInfo.gameObject:SetActive(false)
			JinengInfo.gameObject:SetActive(true)
    		--计算技能费用
    		self:UpdataJiNeng(dData,JinengInfo,pos)
		else
			MainInfo.gameObject:SetActive(true)
			JinengInfo.gameObject:SetActive(false)
			if  self.BtnType == 3 then
				self:UpdataShengxing()
			end

			if self.BtnType == 4 then
				if pos == 1 then
				local mmoyeybtn = self.PetBianyi:FindChild("Money")

	 			mmoyeybtn:FindChild("Label"):GetComponent("UILabel").text = "100"
	 			end
			end
		end
	end

end

PetMainView.curMoney = nil
PetMainView.JiNengErroy = nil
PetMainView.isSameType = false
function  PetMainView:UpdataJiNeng(dData,JinengInfo,pos)
	if pos == 1 then
		self.JiNengErroy = {"",""}
	end
	local sNAME = self.petMainSkillTabel:GetData(dData.skill1,"SKILL_NAME") 
	local sLevel = tonumber(dData.skill1_lv)--self.petMainSkillTabel:GetSkillLevel(dData.skill1)
	local zd = JinengInfo:FindChild("Info 1")
	 if sNAME ~= nil then
	 	--zd.gameObject:SetActive(true)
		zd:FindChild("Label 6"):GetComponent("UILabel").text = tostring(sNAME)
		zd:FindChild("lvLabel").gameObject:SetActive(true)
		local maxLv = tonumber(self.petMainSkillTabel:GetData(dData.skill1,"SKILL_MAX_LV"))
		if sLevel >= maxLv then
			zd:FindChild("Maxlevel").gameObject:SetActive(true)
			zd:FindChild("lvLabel").gameObject:SetActive(false)
			if pos == 1 then
				self.JiNengErroy[1] = ("主动技能已经满级")
			end
		else
			zd:FindChild("Maxlevel").gameObject:SetActive(false)
			zd:FindChild("lvLabel"):GetComponent("UILabel").text = tostring(sLevel)
		end
	else
		zd:FindChild("Label 6"):GetComponent("UILabel").text = ""--tostring(sNAME)
		zd:FindChild("lvLabel").gameObject:SetActive(false)
		zd:FindChild("Maxlevel").gameObject:SetActive(false)
		--self.JiNengErroy[1] = ("没有主动技能")
		if pos == 1 then
			self.JiNengErroy[1] = ("没有主动技能")
		end
	end


	--GamePrintTable(dData)
	local sNAME2 = self.petPassiveSkillTabel:GetData(dData.skill2,"SKILL_DESC")
	--GamePrintTable("sNAME2"..sNAME2)
	sNAME2 = string.gsub(sNAME2,"*",tostring(dData.skill2_val))
	 --GamePrintTable("skill2_val =".. tostring(dData.skill2_val))
	local sLevel2 =  tostring(dData.skill1_lv)--self.petMainSkillTabel:GetSkillLevel(dData.skill2)
	local zd2 = JinengInfo:FindChild("Info 2")
	zd2:FindChild("Label 6"):GetComponent("UILabel").text = tostring(sNAME2)
	zd2:FindChild("lvLabel"):GetComponent("UILabel").text = tostring(sLevel2)

	--GamePrintTable("UpdatacurMoney UpdatacurMoney")
    if  self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1] == nil or 
        self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][2] == nil then
        	return
    end
    
    self.curMoney = { money = 1000, ty =1}
	local iid1 = self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1]
	local iid2 = self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][2]

	local petTab = self.petInfo[TxtFactory.BIN_PETS]
	local pet1,pet2 = nil,nil
	for i = 1, #petTab do
		local ppet = petTab[i]

		if  ppet.id == iid2 then
			pet2 = ppet
		elseif  ppet.id == iid1 then
			pet1 = ppet
		end
	end
        
    --GamePrintTable(pet1)
    --GamePrintTable(pet2)

	local ctid1 = self.mountTxt:GetData(pet1.tid, TxtFactory.S_MOUNT_TYPE) -- 种类id
	local ctid2 = self.mountTxt:GetData(pet2.tid, TxtFactory.S_MOUNT_TYPE) -- 种类id
	local rank1 = self.petTable:GetData(ctid1,"RANK") -- 品质1
	-- 副宠属性
    local starNum2 = self.mountTxt:GetData(pet2.tid, TxtFactory.S_MOUNT_STAR) -- 星级
    local rank2 = self.petTable:GetData(ctid2,"RANK") -- 品质2

    self.isSameType = (ctid1 == ctid2)
	--if ctid1 ~= ctid2 then
		--升级被动技能
		local lineData = self.petPassiveSkillTabel:GetLineByID(pet1.skill2)
		if lineData == nil then
			--GamePrintTable("被动 技能未配置 ＝"..tostring(pet1.skill2))
			lineData = self.petPassiveSkillTabel:GetLine(1)
			if pos == 1 then
				self.JiNengErroy[2] = ("没有被动技能")
			end
		end
		--GamePrintTable("skill2 ="..tostring(pet1.skill2))
		local  TxtTitle = self.petPassiveSkillTabel.TxtTitle
		local zhuPetTable = lineData[TxtTitle.ZHU_PET_MODULUS -1]

		local fuPetStarTable = lineData[TxtTitle.STAR_MODULUS -1]

		local zhuRankValue = self.petPassiveSkillTabel:GetZHU_PET_MODULUS(zhuPetTable,rank1)
		local fuStarValue = self.petPassiveSkillTabel:GetFu_PET_MODULUS(fuPetStarTable,starNum2)
		--GamePrintTable("zhuRankValue ="..tostring(zhuRankValue))
		local rankKey = "PET_"..rank2.."_EXP"
		local rankValue = tonumber(lineData[TxtTitle[rankKey] -1])
		local addValue = fuStarValue * rankValue
		--GamePrintTable("rankKey ="..tostring(rankKey))
		----GamePrintTable("zhuRankValue ="..zhuRankValue))
		--GamePrintTable("fuStarValue ="..tostring(fuStarValue))
		--GamePrintTable("rankKey Value ="..tostring(rankValue))


		local zhuPetCurvalue = tonumber(pet1.skill2_val) -- 主宠副技能 经验值

		local  endValue = tonumber(lineData[TxtTitle.SKILL_END -1])
		local  starValue = tonumber(lineData[TxtTitle.SKILL_START -1])

		--GamePrintTable("addValue ="..tostring(addValue))
		--GamePrintTable("zhuPetCurvalue ="..tostring(zhuPetCurvalue))
		local  sss = tonumber(lineData[TxtTitle.SKILL_80 -1])
		--(endValue - starValue)*0.8 + starValue;
		--tonumber(lineData[TxtTitle.SKILL_80 -1]) --(endValue - starValue)*0.8 + starValue
		GamePrintTable("SKILL_80 ="..tostring(sss))

		local  mmType = "UP_SKILL_GOLD"
		self.curMoney.ty = 1
		if addValue > 0 then
			if pos == 1 then
				if zhuPetCurvalue >= endValue then
					self.JiNengErroy[2] = ("被动技能已满")
				end
			end

			if 	zhuPetCurvalue + addValue  >= sss then
				mmType = "UP_SKILL_DIAMIND"
				self.curMoney.ty = 2
			end
		else
			if pos == 1 then
				if zhuPetCurvalue >= endValue then
					self.JiNengErroy[2] = ("被动技能已满")
				end
			end

			if 	zhuPetCurvalue + addValue  <= sss then
				mmType = "UP_SKILL_DIAMIND"
				self.curMoney.ty = 2
			end
		end
		-- 价钱
		local baseMoney = tonumber(lineData[TxtTitle[mmType] -1])
		--GamePrintTable("baseMoney ="..tostring(baseMoney))
		self.curMoney.money = math.floor(baseMoney*zhuRankValue*fuStarValue)
	--else
		--升级主动技能
		--self.petMainSkillTabel:GetLineByID(pet1.skill2)
		--local sNAME = self.petMainSkillTabel:GetData(pet1.skill2,"SKILL_NAME")
	--end
	local mmoyeybtn = self.PetJIneng:FindChild("Money")
	 if self.curMoney.ty  == 1 then
	 	mmoyeybtn:FindChild("Sprite"):GetComponent("UISprite").spriteName = "jinbi"
	 else
	 	mmoyeybtn:FindChild("Sprite"):GetComponent("UISprite").spriteName = "zuanshi"
	 end
	 mmoyeybtn:FindChild("Label"):GetComponent("UILabel").text = tostring(self.curMoney.money)
end

local RankToNum = {
	["SS"] = 4,
	["S"] = 3,
	["A"] = 2,
	["B"] = 1,
}
PetMainView.shengxErroy = ""
function  PetMainView:UpdataShengxing()
    if  self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1] == nil then
        return
    end
    self.shengxErroy = ""
    self.curMoney = { money = 1000, ty =1}
	local iid1 = self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1]
	local petTab = self.petInfo[TxtFactory.BIN_PETS]
	local pet1= nil
	for i = 1, #petTab do
		local ppet = petTab[i]
		if  ppet.id == iid1 then
			pet1 = ppet
		end
	end
        
	local ctid1 = self.mountTxt:GetData(pet1.tid, TxtFactory.S_MOUNT_TYPE) -- 种类id
	local rank1 = self.petTable:GetData(ctid1,"RANK") -- 品质1
    local starNum1 = self.mountTxt:GetData(pet1.tid, TxtFactory.S_MOUNT_STAR) -- 星级
    local petMergeTable = TxtFactory:getTable(TxtFactory.PetMergeTXT)
    local  rankNum  = tonumber(RankToNum[rank1])
    local xishu = petMergeTable:GetData(101001,"STAR_MODULUS")
    xishu = string.gsub(xishu,'"',"")
	xishu = lua_string_split(tostring(xishu),";")
	xishu = tonumber(xishu[rankNum])
    if  starNum1 < 2 then
    	self.curMoney.ty = 1
    	self.curMoney.money = tonumber(petMergeTable:GetData(101001,"GOLD_PRICE")) * xishu
    	self.curMoney.money = math.ceil(self.curMoney.money )
    else
    	self.curMoney.ty = 2
    	local ssMoney = petMergeTable:GetData(101001,"DIAMOND_PRICE")
    	local idTabd = string.gsub(ssMoney,'"',"")
		local array = lua_string_split(tostring(idTabd),",")
		local iid = starNum1 - 1

		if iid > #array then
			GamePrintTable("星星已满")
			self.shengxErroy = "已到最大星级"
			self.curMoney.money = 0
			return
		end
    	self.curMoney.money = math.floor(tonumber(array[iid]) * xishu)
    end
	
	local mmoyeybtn = self.PetShenxin:FindChild("Money")
	 if self.curMoney.ty  == 1 then
	 	mmoyeybtn:FindChild("Sprite"):GetComponent("UISprite").spriteName = "jinbi"
	 else
	 	mmoyeybtn:FindChild("Sprite"):GetComponent("UISprite").spriteName = "zuanshi"
	 end
	 mmoyeybtn:FindChild("Label"):GetComponent("UILabel").text = tostring(self.curMoney.money)
end

PetMainView.MainInfo = nil
PetMainView.PetMainUI_info = nil
PetMainView.PetBtnSJObj = nil
PetMainView.PetBtnSXObj = nil
PetMainView.petMainSkillTabel = nil 
PetMainView.petPassiveSkillTabel = nil 
function  PetMainView:InitPetFunctin()
	-- body
	self.PetFunctionPanel = self.scene:LoadUI("Pet/PetFunctionUI")

	local trans = self.PetFunctionPanel.transform:FindChild("UI/title")
	self.scene:boundButtonEvents(self.PetFunctionPanel) -- 给相应的按钮赋值
	self.PetShenji = trans:FindChild("PetShenji")
	self.PetJIneng = trans:FindChild("PetJIneng") 
	self.PetShenxin = trans:FindChild("PetShenxin") 
	self.PetBianyi = trans:FindChild("PetBianyi")
	self.PetShenji.gameObject:SetActive(false)
	self.PetJIneng.gameObject:SetActive(false)
	self.PetShenxin.gameObject:SetActive(false)
	self.PetBianyi.gameObject:SetActive(false)

	self.PetMainUI_info = {}
	self.PetMainUI_info[1] = trans:FindChild("PetMainUI_info1")
	self.PetMainUI_info[2] = trans:FindChild("PetMainUI_info2")
	--self.MainInfo = self.PetMainUI_info1:FindChild("LeftPetView/MainInfo")

	self.myGiftItems = self.PetShenji:Find("myGiftItems") -- 礼物列表view
	self.myGiftItemsGrid = self.myGiftItems:GetChild(0) -- 我的礼物按钮列表root


	self.effect = trans:FindChild("ef_ui_shengji"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
	SetEffectOrderInLayer(self.effect,10)

	-- 切换按钮
	trans = self.PetFunctionPanel.transform:FindChild("UI/PetFunctionPanel")
	self.PetBtnSJObj = trans:FindChild("PetBtnSJ").gameObject
	self.PetBtnSXObj = trans:FindChild("PetBtnSX").gameObject

	AddonClick(trans:FindChild("PetBtnSJ"),function() 
		self:PetBtnSJ()
	end)
	AddonClick(trans:FindChild("PetBtnJN"),function() 
		self:PetBtnJN()
	end)
	AddonClick(trans:FindChild("PetBtnSX"),function() 
		self:PetBtnSX()
	end)
	AddonClick(trans:FindChild("PetBtnBY"),function() 
		self:PetBtnBY()
	end)
--[[	self:SetCheckBtn(trans:FindChild("PetBtnSJ"),self.PetBtnSJ)
	self:SetCheckBtn(trans:FindChild("PetBtnJN"),self.PetBtnJN)
	self:SetCheckBtn(trans:FindChild("PetBtnSX"),self.PetBtnSX)
	self:SetCheckBtn(trans:FindChild("PetBtnBY"),self.PetBtnBY)]]

	self.petMainSkillTabel = TxtFactory:getTable("PetSkillMainTXT")	
    self.petPassiveSkillTabel = TxtFactory:getTable("PetSkillPassiveTXT")
    destroyUIButtonMessage(self.PetFunctionPanel)
end
function PetMainView:ChangShowItem(item)
	-- body
	if self.curShowItem ==  item then
		return
	end
	self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1] = nil
	self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][2] = nil
	self.iconBtn = item:FindChild("PetButton")
	if self.iconBtn ~= nil then
		self.iconRoot = self.iconBtn:FindChild("PetRoot")
	end
	if self.curShowItem ~= nil then
		self.curShowItem.gameObject:SetActive(false)
	end
	item.gameObject:SetActive(true)
	self.curShowItem =  item

	--还原一些默认设置
	--self.MainInfo.gameObject:SetActive(true)
	self.PetMainUI_info[2].gameObject:SetActive(true)
	--隐藏原来的 宠物
	--self.modelShow.modelRoot:SetActive(false)
end
--[[function PetMainView:SetCheckBtn(btn,dofun)
	AddonClick(btn,function() 
		--self[dofun](self)
		dofun(self)
	end)
end]]

function PetMainView:ShowPetDataInfo(pparent,iid,selectPos)
	local LeftPetView = pparent:GetChild(0)
	local PetButton = pparent:FindChild("PetButton")
	local changFun = function() 
		self:creatMyPetPanel(selectPos)
		self.SelectPos = selectPos
	end
	AddonClick(pparent,changFun)
	if iid ~= nil then
		LeftPetView.gameObject:SetActive(true)
		PetButton.gameObject:SetActive(false)
		LeftPetView.name = tostring(iid)
		self:ShowInfo(LeftPetView,iid)

		local desLabel = LeftPetView:FindChild("MainInfo/desLabel"):GetComponent("UILabel")
		local desKeyLabel = LeftPetView:FindChild("MainInfo/desKeyLabel"):GetComponent("UILabel")
		local petid = self.management:idDataForTid(iid)
		self.scene:iconInfoPanelDescript(petid,desKeyLabel,desLabel)

		local ChangeBtn = LeftPetView:FindChild("ChangeBtn")
	 	AddonClick(ChangeBtn,changFun)

	 	local petIconInfoBtn = LeftPetView:FindChild("petIconInfoBtn")
		AddonClick(petIconInfoBtn,function(button)
			-- body
			self.scene:creatIconInfoPanel(button)
		end)

	else
		LeftPetView.gameObject:SetActive(false)
		PetButton.gameObject:SetActive(true)
	end
end
PetMainView.BtnType = nil
function PetMainView:PetBtnSJ()
	self.BtnType = 1
	self:ChangShowItem(self.PetShenji)
	self:itemsListUpdate()
	self.PetMainUI_info[2].gameObject:SetActive(false)
	--self.modelShow.modelRoot:SetActive(true)
	self:UpdateCurPet0()

	self.SelectMyPetPanelFun = nil


end

function PetMainView:PetBtnJN()
	-- body
	self.BtnType = 2
	self:ChangShowItem(self.PetJIneng)
	self:UpdateCurPet1(1)
	self:UpdateCurPet1(2)

	local bbtn = self.PetJIneng.transform:FindChild("Button")
	AddonClick(bbtn,function() 
		self:JiNengMergeBtn()
	end)

	self.SelectMyPetPanelFun = function(dData,pos)
		if pos == 2 then
			return dData.slot == 0
		end
		return true
	end
	local mmoyeybtn = self.PetJIneng:FindChild("Money")

	 mmoyeybtn:FindChild("Label"):GetComponent("UILabel").text = " 0"

	 -- 文字
	local Label0 = self.PetJIneng:FindChild("Info/Label")
	local Label1 = self.PetJIneng:FindChild("Info/Label 1")
	local Label2 = self.PetJIneng:FindChild("Info/Label 2")
	local Label3 = self.PetJIneng:FindChild("Info/Label 3")
	local Label4 = self.PetJIneng:FindChild("Info/Label 5")
	local Label5 = self.PetJIneng:FindChild("Info/Label 4")
	
	local textsConfigTXT =  TxtFactory:getTable(TxtFactory.TextsConfigTXT)
	Label0:GetComponent("UILabel").text = textsConfigTXT:GetText(1001)
	Label1:GetComponent("UILabel").text = textsConfigTXT:GetText(1002)
	Label2:GetComponent("UILabel").text = textsConfigTXT:GetText(1001)
	Label3:GetComponent("UILabel").text = textsConfigTXT:GetText(1002)
	Label4:GetComponent("UILabel").text = textsConfigTXT:GetText(1001)
	Label5:GetComponent("UILabel").text = textsConfigTXT:GetText(1002)
end

function PetMainView:PetBtnSX()
	-- body
	self.BtnType = 3
	self:ChangShowItem(self.PetShenxin)
	self:UpdateCurPet1(1)
	self:UpdateCurPet1(2)

	local bbtn = self.PetShenxin.transform:FindChild("Button")
	AddonClick(bbtn,function() 
		self:coinMergeBtn()
	end)

	self.SelectMyPetPanelFun = function(dData,pos)
		-- body
		--[[if dData.id == self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1]  or 
		dData.id == self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][2] then
			return false
		end]]

		if pos == 2 then
			return dData.slot == 0
		end
		return true
	end
		local mmoyeybtn = self.PetShenxin:FindChild("Money")

	 mmoyeybtn:FindChild("Label"):GetComponent("UILabel").text = " 0"

	-- 文字
	local Label0 = self.PetShenxin:FindChild("Info/Label")
	local Label1 = self.PetShenxin:FindChild("Info/Label 1")
	local Label2 = self.PetShenxin:FindChild("Info/Label 2")
	local textsConfigTXT =  TxtFactory:getTable(TxtFactory.TextsConfigTXT)
	Label0:GetComponent("UILabel").text = textsConfigTXT:GetText(1001)
	Label1:GetComponent("UILabel").text = textsConfigTXT:GetText(1001)
	Label2:GetComponent("UILabel").text = textsConfigTXT:GetText(1002)
end

function PetMainView:PetBtnBY()
	-- body iconBtn
	self.BtnType = 4
	self:ChangShowItem(self.PetBianyi)
	self:UpdateCurPet1(1)
	self:UpdateCurPet1(2)
	local bbtn = self.PetBianyi.transform:FindChild("Button")
	AddonClick(bbtn,function() 
		self:diamondMergeBtn()
	end)

	self.SelectMyPetPanelFun = function(dData,pos)
		--GamePrintTable(dData)
		--return true
		--[[if dData.id == self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1]  or 
		   dData.id == self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][2] then
			return false
		end]]
		-- body
		return dData.slot == tonumber(0)
	end
	local mmoyeybtn = self.PetBianyi:FindChild("Money")

	 mmoyeybtn:FindChild("Label"):GetComponent("UILabel").text = " 0"

	 	-- 文字
	local Label0 = self.PetBianyi:FindChild("Info/Label")
	local Label1 = self.PetBianyi:FindChild("Info/Label 1")
	local Label2 = self.PetBianyi:FindChild("Info/Label 2")
	local textsConfigTXT =  TxtFactory:getTable(TxtFactory.TextsConfigTXT)
	Label0:GetComponent("UILabel").text = textsConfigTXT:GetText(1001)
	Label1:GetComponent("UILabel").text = textsConfigTXT:GetText(1001)
	Label2:GetComponent("UILabel").text = textsConfigTXT:GetText(1002)
end

-- 创建我的萌宠面板
PetMainView.iconBtn = nil
PetMainView.iconRoot = nil
PetMainView.myPetPanel = nil

PetMainView.desLabel = nil
PetMainView.desKeyLabel = nil

PetMainView.SelectMyPetPanelFun = nil
function PetMainView:creatMyPetPanel(pos)
	if self.myPetPanel ~= nil then
		destroy(self.myPetPanel)
	end

	self.myPetPanel = self.scene:LoadUI("Pet/PetMypetUI")
	-- 添加按钮监听脚本
	self.scene:boundButtonEvents(self.myPetPanel)
	local ui =  self.myPetPanel.transform:FindChild("UI")

	local grid = ui:FindChild("grid")
	local itemsGrid = grid:FindChild("PetMypetUI_itemsGrid")

	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]
	local _txt = TxtFactory:getTable(TxtFactory.MountTXT)
	--排序
	local sss = self:PaixuFun(petTab)
	--GamePrintTable(sss)

	local nnum = itemsGrid.childCount
	for i = 1, #sss do
		local ddate = sss[i][2]
		local tid = ddate.tid

		local icon = nil
		if i > nnum then
			icon = self.scene:creatPetIcon(tid,itemsGrid,self.panel)-- 创建宠物icon
		else
			icon = itemsGrid:GetChild(i -1).gameObject
			icon:SetActive(true)
			self.scene:UpdataPetIcon(tid,icon)
		end
		local id = ddate.id
		icon.name = id

		local canUse = true
		if self.SelectMyPetPanelFun  ~= nil then
			canUse = self.SelectMyPetPanelFun(ddate,pos)
		end

		if canUse then
			local level = _txt:GetData(tid, TxtFactory.S_MOUNT_LVL) -- 等级
			local levelLabel = icon.transform:FindChild("levelLabel")-- 更新等级信息
			levelLabel.gameObject:SetActive(true)
			local plabel = levelLabel:GetChild(0):GetComponent("UILabel")
			plabel.text = "lv." .. tostring(level)
			local joinTag = icon.transform:FindChild("tag") -- 上场标识
			--joinTag.gameObject:SetActive(ddate.slot ~= 0)

			-- 宠物类型图片
			-- 上场
    		local tTag = joinTag:GetComponent("UISprite") -- 上阵标记
    		tTag.spriteName = ""
    		if ddate.slot ~= 0 then
            	joinTag.gameObject:SetActive(true)
	            if  self.petInfo[TxtFactory.DUI_ZHANG] == id then
	                tTag.atlas = Util.PreLoadAtlas("UI/Picture/Pet")
	                tTag.spriteName = duizhangSp
	            else
	                tTag.atlas = Util.PreLoadAtlas("UI/Picture/Pet")
	                tTag.spriteName = duiyuanSp
	            end
        	else
            	joinTag.gameObject:SetActive(false)
        	end
        	-- 已选择
        	local joinTag1 = icon.transform:FindChild("tag1") -- 上场标识
        	if  id == self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1] or 
        		id == self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][2] then
        		joinTag1.gameObject:SetActive(true)
        	else
        		joinTag1.gameObject:SetActive(false)
        	end

        	self:SetMyPetBtn(icon)
		else
			icon.gameObject:SetActive(false)
		end
	end

	for o = #sss + 1, nnum do
    	itemsGrid:GetChild(o -1).gameObject:SetActive(false)
    end
	itemsGrid:GetComponent("UIGrid"):Reposition()
	grid:GetComponent("UIScrollView"):ResetPosition()
	-- 关闭
	local  closebtn  = self.myPetPanel.transform:FindChild("UI/PetMypetUI_close")
	AddonClick(closebtn,function( ... )
		-- body
		self:myPetPanel_closeBtn()
	end)

end

function PetMainView:SetMyPetBtn(btn)
	-- body
	local SeletePetIcon = btn.transform:FindChild("SeletePetIcon")
	AddonClick(SeletePetIcon,function(SeletePetIcon)
		-- body
		self:OnClickMyPetPanel(SeletePetIcon.transform.parent.gameObject)
	end)
	
end
function PetMainView:OnClickMyPetPanel(btn)
	--local curPetTab = self.petInfo[TxtFactory.CUR_PETS]
    local petTab = self.petInfo[TxtFactory.BIN_PETS]
	local id = tonumber(btn.name)
	local tid = nil
	local isShangchang = false
	local dData = nil
	for i = 1, #petTab do
		if petTab[i].id == id then
			dData = petTab[i]
			tid = dData.tid
			isShangchang = dData.slot ~= 0
			break
		end
	end

	if self.SelectPos == 2 then
		if self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1] == id then
			--self.scene:promptWordShow("已被选为主宠")
			--return
			self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1] = nil
			self:UpdateCurPet1(1)
		end
			self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][2] = id
			self:UpdateCurPet1(2)
		--end
	elseif self.SelectPos == 1 then
		if self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][2] == id then
			--self.scene:promptWordShow("已被选为副宠")
			--return
			self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][2] = nil
			self:UpdateCurPet1(2)
		end

		self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1] = id
		self:UpdateCurPet1(1)
	elseif self.SelectPos == 0 then
		self.petInfo[TxtFactory.PETMAIN_SELECTED] = id
		self:UpdateCurPet0()
	end


	-- 关闭我的萌宠界面
	self:myPetPanel_closeBtn()
end

-- 我的萌宠面板关闭按钮
function PetMainView:myPetPanel_closeBtn()
	destroy(self.myPetPanel)
end

PetMainView.isSendMessage = false
-- 技能融合
function PetMainView:JiNengMergeBtn()
	if self.isSendMessage == true then
		return
	end

	local iid1 = self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1]
	local iid2 = self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][2]

	if  iid1 == nil or iid2 == nil then
		return
	end

	if self.JiNengErroy[1] ~= ""  and self.JiNengErroy[2] ~= "" then
		self.scene:promptWordShow("技能已满级")
		return
	end

	if  not self.isSameType then
		if self.JiNengErroy[2] ~= "" then
			self.scene:promptWordShow(self.JiNengErroy[2])
		return
		end
	end
	
	local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	if  self.curMoney.ty == 1 and  UserInfo[TxtFactory.USER_GOLD] < self.curMoney.money then
		self.scene:promptWordShow("金币不足")
		return
	end

	if  self.curMoney.ty == 2 and  UserInfo[TxtFactory.USER_DIAMOND] < self.curMoney.money then
		--self.scene:promptWordShow("钻石不足")
		self.scene:OpenGotoStoreView("钻石不足,是否需要前往商城购买!",4)
		return
	end

	self.isSendMessage = true
	self.management:sendPetUpgradeSkillRequest()
end

-- 升星融合按钮 
function PetMainView:coinMergeBtn()
	if self.isSendMessage == true then
		return
	end

	local iid1 = self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1]
	local iid2 = self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][2]

	if  iid1 == nil or iid2 == nil then
		return
	end

	if self.shengxErroy ~= "" then
		self.scene:promptWordShow(self.shengxErroy)
		return
	end

	if self.curMoney == nil then
		return
	end
	local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	if  self.curMoney.ty == 1 and  UserInfo[TxtFactory.USER_GOLD] < self.curMoney.money then
		self.scene:promptWordShow("金币不足")
		return
	end

	if  self.curMoney.ty == 2 and  UserInfo[TxtFactory.USER_DIAMOND] < self.curMoney.money then
		--self.scene:promptWordShow("钻石不足")
		self.scene:OpenGotoStoreView("钻石不足,是否需要前往商城购买!",4)
		return
	end




	--GamePrintTable	("升星融合按钮 ,升星融合按钮 ,升星融合按钮")


	local petTab = self.petInfo[TxtFactory.BIN_PETS]
	local pet1 ,pet2 = nil,nil
	for i = 1, #petTab do
		local ppet = petTab[i]
		if  ppet.id == iid2 then
			pet2 = ppet
		elseif  ppet.id == iid1 then
			pet1 = ppet
		end
	end
	--GamePrintTable("主宠：")
	--GamePrintTable(pet1)
	--[[local petid1 = pet1.tid
	if not self.management:isMaxLevel(petid1) then
		local word = "主宠等级没满"
		self.scene:promptWordShow(word)
		return
	end]]
	--local needexp = tonumber(self.mountTxt:GetData(tid, TxtFactory.S_MOUNT_EXP))
	if not self.management:isNeedUpStar(pet1.tid) then
		local word = "主宠等级没满"
		self.scene:promptWordShow(word)
		return
	end

--[[	local ctid1 = self.mountTxt:GetData(pet1.tid, TxtFactory.S_MOUNT_TYPE) -- 种类id
	local ctid2 = self.mountTxt:GetData(pet2.tid, TxtFactory.S_MOUNT_TYPE) -- 种类id
	if ctid1 ~= ctid2 then
		local word = "副宠类型不匹配"
		self.scene:promptWordShow(word)
		return
	end ]]
	local  star1 = self.mountTxt:GetData(pet1.tid, TxtFactory.S_MOUNT_STAR) -- 种类id
	local  star2 = self.mountTxt:GetData(pet2.tid, TxtFactory.S_MOUNT_STAR) -- 种类id
	if star1 > star2 then
		local word = "副宠星级不足"
		self.scene:promptWordShow(word)
		return
	end

	self.management:sendMergePets()
	self.isSendMessage = true


end

-- 变异
function PetMainView:diamondMergeBtn()
	if self.isSendMessage == true then
		return
	end
	GamePrintTable("diamondMergeBtn diamondMergeBtn diamondMergeBtn")
	local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)

	if  UserInfo[TxtFactory.USER_DIAMOND] < 100 then
		--self.scene:promptWordShow("钻石不足")
		self.scene:OpenGotoStoreView("钻石不足,是否需要前往商城购买!",4)
		return
	end

	local iid1 = self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1]
	local iid2 = self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][2]

	if  iid1 == nil or 
		iid2 == nil then
		return
	end
	self.isSendMessage = true
	self.management:sendPetVariation(iid1,iid2)


end

-- 融合完毕 成功
function PetMainView:mergeEnd(newPet)
	--GamePrintTable("newPet GamePrintTable(newPet) GamePrintTable(newPet)")
	--GamePrintTable(newPet)
	--local newPet = self:ClearPetTableToNew(self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1])
	self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][2] = nil
	self:UpdateCurPet1(2)
	self.isSendMessage = false
	self.petInfo[TxtFactory.MERGE_PETSSLOTTAB][1] = nil --newPet ~= nil and  newPet.id or nil
	self:UpdateCurPet1(1)

		local mmoyeybtn = self.PetBianyi:FindChild("Money")
	 mmoyeybtn:FindChild("Label"):GetComponent("UILabel").text = " 0"

end
-- 清除掉已被融合的 萌宠
function PetMainView:ClearPetTableToNew(iid1)
	-- body
	local petTab = self.petInfo[TxtFactory.BIN_PETS]
	--GamePrintTable(petTab)
	local retab = {}
	local newtab = {}
	for o = 1 , #petTab do
		local id = petTab[o].id
		local index  = retab[id]
		if index == nil then
			table.insert(newtab,petTab[o])
			retab[id] = #newtab
		else
			newtab[index] = petTab[o]
		end
    end
    self.petInfo[TxtFactory.BIN_PETS] = newtab
    --GamePrintTable("newtab newtab")
    --GamePrintTable(newtab)
    if retab[iid1] == nil then
    	return nil
    end
    return newtab[retab[iid1]]
end

-- 融合完毕 失败
function PetMainView:mergeFail()
	self.isSendMessage = false
end
--   显示升星
function PetMainView:Showshengxin()
	self:SetActive(false)
	if 	self.PetFunctionPanel == nil then
		self:InitPetFunctin()
	end
	self.PetFunctionPanel:SetActive(true)
	--GameWarnPrint("self.PetBtnSXObj ="..self.PetBtnSXObj.name)
	self.PetBtnSXObj:SendMessage("OnClick",self.PetBtnSXObj,1);
	self.PetBtnSX(self)

end
PetMainView.TabeBtnLevel = {}
function PetMainView:SetUIPanelControl(name,fun)
	-- body
	local btn = find(name)
	if btn == nil then
		GamePrintTable("没有找到按钮："..name)
		self.TabeBtnLevel[name] = true
		return
	end
	AddonClick(btn.transform,fun)
end
function PetMainView:InitPanelControl()
 		
	self:SetPetFunctionBtn() -- 成长培养界面按钮

    self:SetUIPanelControl("PetMainUI_smelt",function()
    	self.scene:petMainView_extractBtn()
    end)
    self:SetUIPanelControl("PetMainUI_handBook",function()
    	self.scene:petMainView_handbookBtn()
    end)
        self:SetUIPanelControl("PetMainUI_joinBtn",function()
    	self.scene:petMainView_joinBtn()
    end)
--[[        self:SetUIPanelControl("PetMainUI_giftBtn",function()
    	self.scene:petMainView_giftBtn()
    end)]]
        self:SetUIPanelControl("petMainView_allBtn",function(btn)
    	self.scene:petMainView_allBtn(btn)
    end)


--[[        self:SetUIPanelControl("PetMainUI_myGiftCloseBtn",function()
    	self.scene.objectID:petMainView_myGiftCloseBtn()
    end)
        self:SetUIPanelControl("PetMainUI_handBook",function()
    	self.scene.objectID:petMainView_handbookBtn()
    end)]]

end