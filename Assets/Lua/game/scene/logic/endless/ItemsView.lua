--[[
author:huqiuxiang
无尽道具界面
]]
ItemsView = class()

ItemsView.scene = nil --场景scene
ItemsView.management = nil -- 数据model

ItemsView.panel = nil  -- 开头界面面板
ItemsView.uiRoot = nil 
ItemsView.itemsGrid  = nil 
ItemsView.items  = nil 
ItemsView.BattleItemsTable = nil 
ItemsView.challenge = nil
ItemsView.challangeInfo = nil --挑战信息
ItemsView.effectTab = nil --特效tab
-- 初始化界面
function ItemsView:init()
	self.BattleItemsTable = TxtFactory:getTable(TxtFactory.StoreConfigTXT)
	self.panel = self.scene:LoadUI("Endless/EndlessItemsUI")
	self.items = find("EndlessItemsUI_items")
	self.itemsGrid = find("EndlessItemsUI_itemsGrid")
	self.challenge = self.panel.transform:Find("UI/Challange")
	self.uiRoot = self.scene.uiRoot
	self.panel.gameObject.transform.localPosition = Vector3(300,50,0)
	self:bottonTargetFind()
	self.management = self.scene.endlessManagement
	self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	-- self.management:getItems() -- 数据处理 

	self.storeManager = StoreManagement.new()
    self.storeManager:Awake(self.scene)
	--[[
	self.storeManager:SetBuyItemDelegate(function (self)
		self.itemsView:listUpdate()
		self:boundButtonEvents(self.itemsView.panel)	
	 end)
	 ]]--
	self.scene.CurretView = "itemsView"
	self:listUpdate()
	self.scene:boundButtonEvents(self.panel)

	--if active == true then
      -- 夺宝奇兵,等级开启
      -- if self.scene.FunctionOpen == nil then
      --   self.scene.FunctionOpen = FunctionOpenView.new()
      --     self.scene.FunctionOpen:Init(self.scene,true)
      -- end
      -- local bbtn = self.panel.transform:FindChild("UI/btn")
      -- self.scene.FunctionOpen:UpdataOtherBtn("套装",bbtn:FindChild("ChapterUI_role"))
      -- self.scene.FunctionOpen:UpdataOtherBtn("萌宠",bbtn:FindChild("ChapterUI_pet"))
      -- self.scene.FunctionOpen:UpdataOtherBtn("装备",bbtn:FindChild("ChapterUI_equip"))
      -- self.scene.FunctionOpen:UpdataOtherBtn("坐骑",bbtn:FindChild("ChapterUI_mount"))
      self:Refresh()
      local btn = find("EndlessItemsUI_BtnReturn")
      local fun = function()
      		if   self.scene.CurretView == "RankView" then
            self.scene:ClearChallangeInfo()
            self.scene:SetActive(false)
            self.scene.sceneParent:SetActive(true)
            self.scene.rankView.effect:SetActive(false)
        elseif self.scene.CurretView == "itemsView" then
            self.scene.itemsView:destroy()
            self.scene.rankView:init()
        end
      end
      AddonClick(btn,fun)
   --end
end
function ItemsView:Refresh()
	--对战信息 
	self.challenge.gameObject:SetActive(true)
	self.challangeInfo = find("itemChallangeInfo"):GetComponent("UILabel")
	local friendName = ""
	local battleType = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE)
    if TxtFactory:getMemDataCacheTable(TxtFactory.ChallengeInfo) ~= nil and battleType == 2 then
    	GamePrint("TxtFactory:getMemDataCacheTable(TxtFactory.ChallengeInfo) ~= nil")
    	local friendInfo = TxtFactory:getValue(TxtFactory.ChallengeInfo,TxtFactory.CHALLENGE_FRIENDINFO)
    	if friendInfo ~= nil then
	    	friendName = GetFriendNameByNick(friendInfo.nickname)
	    end
	elseif TxtFactory:getMemDataCacheTable(TxtFactory.ReplyChallengeInfo) ~= nil and battleType == 2 then
		local friendNick = TxtFactory:getValue(TxtFactory.ReplyChallengeInfo,TxtFactory.REPLYCHALLENGE_FRIENDNAME)
		if friendNick ~= nil then
			friendName = GetFriendNameByNick(friendNick)
		end
	else
		self.challenge.gameObject:SetActive(false)
    end
 	self.challangeInfo.text = friendName
end
--
function ItemsView:bottonTargetFind()
	local ui = self.panel.gameObject.transform:FindChild("UI")
	local nextBtn = ui.gameObject.transform:FindChild("EndlessItemsUI_next")
	self.effect = newobject(Util.LoadPrefab("Effects/UI/ef_ui_button"))
	self.effect.gameObject.transform.parent = nextBtn.gameObject.transform
	self.effect.gameObject.transform.localPosition = Vector3.zero
	self.effect.gameObject.transform.localScale = Vector3.one
	SetEffectOrderInLayer(self.effect,2)
end

-- next按钮
function ItemsView:nextBtn()
	-- 根据类型判断当前无尽的类型
	local endBattleType = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE)
	--对战信息 
	
 	if TxtFactory:getMemDataCacheTable(TxtFactory.ChallengeInfo) ~= nil then
 		local friendInfo = TxtFactory:getValue(TxtFactory.ChallengeInfo,TxtFactory.CHALLENGE_FRIENDINFO)
 		local tab = {}
 		tab["icon"] = friendInfo.icon
 		tab["name"] = friendInfo.nickname
 		self.scene:ShowChallengeVSView(self,tab)
	elseif TxtFactory:getMemDataCacheTable(TxtFactory.ReplyChallengeInfo) ~= nil then
		local friendName = TxtFactory:getValue(TxtFactory.ReplyChallengeInfo,TxtFactory.REPLYCHALLENGE_FRIENDNAME)
 		local tab = {}
 		tab["icon"] = "101003"
 		tab["name"] = friendName
 		self.scene:ShowChallengeVSView(self,tab)
	elseif endBattleType == 7 or endBattleType == 8 then
		-- 世界对战
		self:SendRankMatchRequest(endBattleType)
		--coroutine.start(self.join,self)
		--[[
		local tab = {}
 		tab["icon"] = "101003"
 		tab["name"] = "世界第一等"
 		self.scene:ShowAsyncPvpVSView(self,tab)
		 ]]--
	else
		coroutine.start(self.join,self)
    end
end
function ItemsView:join()
	-- 判断体力是否够
	if   tonumber(self.UserInfo[TxtFactory.USER_STRENGTH]) < 1 then
        self.scene:promptWordShow("体力不够")
		return
    end
	local effect = self.panel.transform:FindChild("ef_ui_kj_jixu")
	if effect ~= nil then
		return
	end
	effect = newobject(Util.LoadPrefab("Effects/UI/ef_ui_kj_jixu"))
	effect.gameObject.transform.parent = self.panel.transform
	effect.gameObject.name = "ef_ui_kj_jixu"
	effect.gameObject.transform.localPosition = Vector3(0,0,0)
	effect.gameObject.transform.localRotation = Quaternion.Euler(0,0,0)
	effect.gameObject.transform.localScale = Vector3.one
	SetEffectOrderInLayer(effect,5)
	coroutine.wait(2)
	-- 判断需要放的技能
	self:CanUseItem()
	
	local endBattleType = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE)
	
	--printf("endBattleType ======"..endBattleType)
	if endBattleType == 2 or endBattleType == 7 or endBattleType == 8 then
		-- 无尽模式   
		self.management:sendStartRunning()
	elseif endBattleType == 4 then  
		-- 天梯定位赛
		self.management:sendLadderRaceBeginMessage()
	elseif endBattleType == 5 then  
		-- 天梯挑战赛
		self.scene:StartRunning()
	elseif endBattleType == 6 then
		-- 天梯晋级赛
		self.management:sendLadderUpgradeStartMessage()
	
	end
end

function ItemsView:destroy()
	destroy(self.panel)
end

--  列表更新
function ItemsView:listUpdate()
	local BagItemsInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo)
	self.management:getBattleItemsDataTid()
	self.battleItemsDataInfo = BagItemsInfo[TxtFactory.ITEMS_BATTLEINFODATATAB]
	-- print("道具列表"..#battleItemsDataInfo)
	destroy(self.itemsGrid)
	self.itemsGrid = GameObject.New()

    local  ms = self.itemsGrid:AddComponent(UIGrid.GetClassType())
	-- ms.cellWidth = 150
	ms.cellHeight = 125
	ms.maxPerLine = 1
    self.itemsGrid.name =  "EndlessItemsUI_itemsGrid"
    self.itemsGrid.gameObject.transform.parent = self.items.gameObject.transform
    self.itemsGrid.gameObject.transform.localPosition = Vector3(-198,168,0)
    self.itemsGrid.gameObject.transform.localScale = Vector3(1,1,1)
	
	self.battleItemCount = {}

	for i = 1, #self.battleItemsDataInfo do
		local tid = tonumber(self.battleItemsDataInfo[i])
		--printf("tid==="..tid)
		local itemCount = self:creatItemsIcon(tid,BagItemsInfo.bin_items)
		-- 存储物品数量和ID
		self.battleItemCount[i] = itemCount
	end

	local grid = self.itemsGrid.gameObject.transform:GetComponent("UIGrid")
    grid:Reposition() -- 自动排列

end

-- 单个物品生成
function ItemsView:creatItemsIcon(tid,data)
	local icon = newobject(Util.LoadPrefab("UI/Endless/endlessItemsListIcon"))
	icon.gameObject.transform.parent = self.itemsGrid.gameObject.transform
	icon.gameObject.transform.localScale = Vector3.one
	local coinBtn = icon.gameObject.transform:FindChild("givePowerBtn")
	local fun = function()
		local effect = newobject(Util.LoadPrefab("Effects/UI/ef_ui_kj_buy"))
		effect.gameObject.transform.parent = self.itemsGrid.gameObject.transform.parent
		effect.gameObject.transform.position = icon.gameObject.transform.position
		effect.gameObject.transform.localRotation = Quaternion.Euler(0,0,0)
		effect.gameObject.transform.localScale = Vector3.one
		if self.effectTab == nil then
			self.effectTab = {}
		end
		table.insert(self.effectTab,effect)
		SetEffectOrderInLayer(effect,5)
	end
    AddonClick(coinBtn,fun)
	coinBtn.name = "ItemsView_itemBuyBtn".."_"..tid
	local coinBtnMes = coinBtn.gameObject.transform:GetComponent("UIButtonMessage")
    coinBtnMes.target = self.uiRoot

    -- icon图片
    local iconChild = icon.gameObject.transform:FindChild("icon"):GetComponent("UISprite")
    local materialTXT = TxtFactory:getTable(TxtFactory.MaterialTXT)
	--printf("tid=="..tid)
    local MATERIAL_ID = lua_string_split(self.BattleItemsTable:GetData(tid,"MATERIAL_ID"),"=")
	 
	--printf("MATERIAL_ID"..MATERIAL_ID)
 	local iconData = materialTXT:GetData(tonumber(MATERIAL_ID[1]),"MATERIAL_ICON")
 	iconChild.spriteName = iconData

    -- local priceData = self.BattleItemsTable:GetData(tid,"PRICE_GOLD")
 	
 	-- local array = lua_string_split(priceData,":")
	 --[[
 	local array = {}
 	local goldPrice = self.BattleItemsTable:GetData(tid,"PRICE_GOLD")
 	local diamondPrice = self.BattleItemsTable:GetData(tid,"PRICE_DIAMOND")
 	if goldPrice == "" then
		array[1] = "PRICE_DIAMOND"
		array[2] = diamondPrice
 	elseif diamondPrice == "" then
		array[1] = "PRICE_GOLD"
		array[2] = goldPrice
 	end
	 ]]--
 	-- print("tid"..tid.." titleData "..titleData)
 	-- 钱类型
	local priceType = self.BattleItemsTable:GetData(tid,"TYPE")
 	local priceValue = self.BattleItemsTable:GetData(tid,"PRICE_COUNT")
 	local priceIcon = coinBtn.gameObject.transform:FindChild("icon"):GetComponent("UISprite")
 	priceIcon.spriteName = self:GetIconName(tonumber(priceType))

	-- 描述
	local titleData = self.BattleItemsTable:GetData(tid,"GOODS_DESC")
	local title = icon.gameObject.transform:FindChild("title"):GetComponent("UILabel")
	title.text = titleData

	-- 物品数量
	local numLabel = icon.gameObject.transform:FindChild("numLabel"):GetComponent("UILabel")
	local itemCount =  self:getItemsNum(tonumber(MATERIAL_ID[1]),data) -- 根据服务器 填物品数量
	numLabel.text = itemCount -- 根据服务器 填物品数量

	-- 钱数量
    local priceLabel = coinBtn.gameObject.transform:FindChild("Label"):GetComponent("UILabel")
    priceLabel.text = priceValue


	return itemCount
end

ItemsView.coinDiamondTab = {["PRICE_GOLD"] = "jinbi" ,["PRICE_DIAMOND"] = "zuanshi"} -- 按钮类型icon


-- 设置购买所需消耗物品类型的Icon  1（金币）2（钻石)3（夺宝货币 4(RMB)
function ItemsView:GetIconName(itemType)
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

-- 根据服务器 填物品数量
function ItemsView:getItemsNum(tid,data)
	local num = 0 
	if data == nil then
		num = 0
		return num
	end
	for i = 1 , #data do 
		if tid == data[i].tid then
			num = data[i].num
		end

	end
	return num
end


-- 道具购买 按钮
function ItemsView:itemBuyBtn(Btn)
	--print(Btn.gameObject.transform.parent.name)
	local strArray = string.split(Btn.name,"_")
	print("tid : "..strArray[3])
	--self.storeManager:SendBuyItemReq(tonumber(strArray[3]))
	self:SendBuyItemReq(tonumber(strArray[3]))
	
end

-- 计算可以使用的道具
function ItemsView:CanUseItem()

	self.petSkillTxt = TxtFactory:getTable(TxtFactory.PetSkillMainTXT) -- 技能表
	
	local materialTXT = TxtFactory:getTable("MaterialTXT")  -- 材料表

	local useItemIDTab = {}  -- 这次跑酷需要使用的物品
	
	local useSkillIDTab = {} -- 这次跑酷可以使用的技能ID

	local useBattleItem = {} --这次跑酷需要使用的物品 对应 skillId
	-- 宠物技能
	
	-- 装备技能
	
	-- 坐骑技能
	
	-- 套装技能
	
	-- 物品技能
	local skillId = 0
	for i = 1 , #self.battleItemsDataInfo do
		local MATERIAL_ID = lua_string_split(self.BattleItemsTable:GetData(self.battleItemsDataInfo[i],"MATERIAL_ID"),"=")
		skillId = materialTXT:GetData(MATERIAL_ID[1],"SKILL_ID")
		while true do
		 	if self.battleItemCount[i] <= 0 then  -- 实现循环的continue功能
				-- 没有该道具
				break
			end
			
			if tonumber(skillId) == -1 then
				-- 该物品没有技能
				break
			end
			-- 不可以使用该道具
			local reult = self:CanUseSkill(skillId,useSkillIDTab)  -- 技能判断的结果 -1(不可以使用)其他(替换技能)
			if self:CanUseSkill(skillId,useSkillIDTab) == -1 then
			 	break
			end
			--  可以使用该道具(存储该技能ID , 需要消耗的物品ID)
			useItemIDTab[reult] = self.battleItemsDataInfo[i]
			useSkillIDTab[reult] = skillId
			useBattleItem[MATERIAL_ID[1]] = skillId
			break
		end
	end
	-- 保存信息
	local memCache = TxtFactory:getTable("MemDataCache")
	memCache:setTable(TxtFactory.BattleUseItemInfo,useBattleItem)
	--memCache:setTable(TxtFactory.BattleUseSkillInfo,useSkillIDTab)
	
end

-- 判断该技能是否可以使用
function ItemsView:CanUseSkill(skillId,skillIdTab)
	
	-- 判断该技能类型是否已经存在
	local skillType = self.petSkillTxt:GetData(skillId,"SKILL_GAIN_TYPE")
	local skillWeight = self.petSkillTxt:GetData(skillId,"SKILL_WEIGHTS")
	for i = 1 , #skillIdTab do
		if skillType == self.petSkillTxt:GetData(skillIdTab[i],"SKILL_GAIN_TYPE") then
			-- 判断权重
			if skillWeight <= self.petSkillTxt:GetData(skillIdTab[i],"SKILL_WEIGHTS") then
				-- 不可以使用该技能
				return -1
			else
				-- 替换数据
				return i
			end
		end
	end
	-- 保存数据
	return #skillIdTab+1
end

function ItemsView:SetActive(active)
	--GameWarnPrint("self.panel ="..self.panel.name)
	if self.panel ~= nil then
		self.panel.gameObject:SetActive(active)
	end

	if active == true then
      -- 夺宝奇兵,等级开启
      -- if self.scene.FunctionOpen == nil then
      --   self.scene.FunctionOpen = FunctionOpenView.new()
      --     self.scene.FunctionOpen:Init(self.scene,true)
      -- end
      -- local bbtn = self.panel.transform:FindChild("UI/btn")
      -- self.scene.FunctionOpen:UpdataOtherBtn("套装",bbtn:FindChild("ChapterUI_role"))
      -- self.scene.FunctionOpen:UpdataOtherBtn("萌宠",bbtn:FindChild("ChapterUI_pet"))
      -- self.scene.FunctionOpen:UpdataOtherBtn("装备",bbtn:FindChild("ChapterUI_equip"))
      -- self.scene.FunctionOpen:UpdataOtherBtn("坐骑",bbtn:FindChild("ChapterUI_mount"))
      self:Refresh()
  	else
  		if self.effectTab ~= nil and type(self.effectTab) == "table" then
  			for i=1,#self.effectTab do
  				self.effectTab[i]:SetActive(false)
  			end
  		end
   	end
end

-----------------------------------  新加的购买逻辑 --------------------------------
--购买道具请求
function ItemsView:SendBuyItemReq(id,num)
	local json = require "cjson"
	--local msg = { item_tid =  id,item_num = num or 1}
   -- local strr = json.encode(msg)
   local userTable = TxtFactory:getTable(TxtFactory.UserTXT)
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = { item_tid = id, item_num = num or 1 }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.BuyItemRequest()
        message.item_tid = id
        message.item_num = num or 1
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.BuyItemRequest,
              data = strr, -- strr
             }
    MsgFactory:createMsg(MsgCode.BuyItemResponse,self)
    NetManager:SendPost(NetConfig.STORE_BUYITEM,json.encode(param)..'|'..userTable:getValue('Username')..':'..userTable:getValue('access_token'))
end
--购买道具回复
function ItemsView:getBuyItems(resp)
    local json = require "cjson"
    local tab = json.decode(resp.data)
  	if tab.result == 1 then
  		print("购买成功")

      local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)  --扣除金币钻石
      if not tab.use_coins then
  			tab.use_coins = 0
  		end
  		if not tab.use_diamond then
  			tab.use_diamond = 0
  		end
      
      if not tab.gold then
  			tab.gold = 0
  		end
  		if not tab.diamond then
  			tab.diamond = 0
  		end
      
      memData:AddUserInfo(-tab.use_coins, -tab.use_diamond)
      memData:AddUserInfo(tab.gold, tab.diamond)
      
      memData:AddUserInfoItemForType(TxtFactory.BagItemsInfo,tab.bin_items)
     --结算装备
      memData:AddUserInfoItemForType(TxtFactory.EquipInfo ,tab.bin_equips)
     --结算宠物
      memData:AddUserInfoItemForType(TxtFactory.PetInfo,tab.bin_pets)
      
      local serverData = {}
      serverData.gold = tab.gold
      serverData.diamond = tab.diamond
      serverData.itemInfoList = tab.bin_items
      serverData.equipInfoList = tab.bin_equips
      serverData.petInfoList = tab.bin_pets
        
     -- local itemObjList =   self.scene:CreatItemList(serverData)
     -- self.scene:rewardItemsShow(itemObjList)
      self.scene:UpdatePlayerInfo()
       --if self.BuyItemFinish ~= nil then
       --   self.BuyItemFinish(self.scene)
      -- end
	  
	  self:listUpdate()
	  self.scene:boundButtonEvents(self.panel)
       
    elseif tab.result == 2 then
        self.scene:promptWordShow("没有足够的金币！")
    elseif tab.result == 3 then
        self.scene:promptWordShow("没有足够的钻石！")
    elseif tab.result == 4 then
        self.scene:promptWordShow("无效的商城道具！")
  	elseif tab.result == 5 then
        self.scene:promptWordShow("没有足够的夺宝币")
    elseif tab.result == 6 then
        self.scene:promptWordShow("没有足够的天梯币")
    else
      self.scene:promptWordShow("返回无效！")
    end
    
end


-- 异步pvp 匹配玩家 请求
function ItemsView:SendRankMatchRequest(battleType)
	local json = require "cjson"
    local userTable = TxtFactory:getTable(TxtFactory.UserTXT)
    local use_diamond = 0
    if battleType == 8 then
		use_diamond = 1
    end
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = { use_diamond = use_diamond}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = rank_pb.RankMatchRequest()
        message.use_diamond = use_diamond
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.RankMatchRequest,
              data = strr, -- strr
             }
    MsgFactory:createMsg(MsgCode.RankMatchResponse,self)
    NetManager:SendPost(NetConfig.STORE_BUYITEM,json.encode(param)..'|'..userTable:getValue('Username')..':'..userTable:getValue('access_token'))
end
-- 异步pvp 匹配玩家 回复
function ItemsView:getRankMatchResponse(resp)
    local json = require "cjson"
    local tab = json.decode(resp.data)
  	if tab.result == 1 then
	  	-- 扣除体力
		local txt = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
		if tab.strength ~= nil then
			txt[TxtFactory.USER_STRENGTH] = tab.strength
		end
		if tab.strength_time ~= nil then
			txt[TxtFactory.USER_STRENGTH_TIME] = tab.strength_time
		end
		if tab.gold ~= nil then
			self.UserInfo[TxtFactory.USER_GOLD] = tab.gold
		end
		if tab.diamond ~= nil then
			self.UserInfo[TxtFactory.USER_DIAMOND] = tab.diamond
		end
    	--[[
		TxtFactory.ASYNCPVPVINFO_MEMBERID = "ASYNCPVPVINFO_MEMBERID" -- 挑战的对手id
		TxtFactory.ASYNCPVPVINFO_NICKNAME = "ASYNCPVPVINFO_NICKNAME" -- 挑战的对手名称
		TxtFactory.ASYNCPVPVINFO_ICON = "ASYNCPVPVINFO_ICON" 		 -- 挑战的对手名称ICON
		TxtFactory.ASYNCPVPVINFO_ACATOR = "ASYNCPVPVINFO_ACATOR" 	 -- 挑战的对手套装ID
		TxtFactory.ASYNCPVPVINFO_ACATORS = "ASYNCPVPVINFO_ACATORS" -- 挑战的对手名称套装列表
		TxtFactory.ASYNCPVPVINFO_CURPETS = "ASYNCPVPVINFO_CURPETS" -- 挑战的对手的宠物上阵列表
		TxtFactory.ASYNCPVPVINFO_BINPETS = "ASYNCPVPVINFO_BINPETS" -- 挑战的对手宠物列表
		]]--
		
		-- 保存对手数据
		
		local asyncPvpInfo =TxtFactory:getMemDataCacheTable(TxtFactory.AsyncPvpInfo)
		if asyncPvpInfo == nil then
			asyncPvpInfo = {}
			local memCache = TxtFactory:getTable("MemDataCache")
  			memCache:setTable(TxtFactory.AsyncPvpInfo,asyncPvpInfo)
		end
		
		TxtFactory:setValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_MEMBERID,tab.rank_memberid)
		TxtFactory:setValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_NICKNAME,tab.rank_nickname)
		TxtFactory:setValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_ICON,tab.rank_icon)
		TxtFactory:setValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_ACATOR,tab.rank_cur_avator)
		TxtFactory:setValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_ACATORS,tab.rank_bin_avators)
		TxtFactory:setValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_CURPETS,tab.rank_cur_pets)
		TxtFactory:setValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_BINPETS,tab.rank_bin_pets)
		
		
		self.scene:UpdatePlayerInfo()
		-- 打开匹配界面
 		self.scene:ShowAsyncPvpVSView(self)
	else
		self.scene:promptWordShow("对手匹配失败……")
	end
end