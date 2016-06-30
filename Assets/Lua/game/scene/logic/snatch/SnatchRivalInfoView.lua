--[[
author:gaofei
夺宝奇兵对手信息界面
]]

SnatchRivalInfoView = class ()

SnatchRivalInfoView.scene = nil --场景scene
SnatchRivalInfoView.panel = nil -- 界面

SnatchRivalInfoView.modelShow = nil -- 3D模型

SnatchRivalInfoView.lotteryItemObjects = nil -- 掉落的物品

SnatchRivalInfoView.defineObject = nil -- 限定据点对象
SnatchRivalInfoView.restrictionObject = nil -- 自由据点按钮


-- 初始化
function SnatchRivalInfoView:init(targetScene)
	self.scene = targetScene
	--printf("SnatchRivalInfoView")
	self.userTable = TxtFactory:getTable("UserTXT")
	self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	self.charIconTxt = TxtFactory:getTable(TxtFactory.CharIconTXT)
	self.panel = newobject(Util.LoadPrefab("UI/Snatch/SnatchRivalInfoView"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
	self.rivalIcon =  self.panel.transform:Find("Anchors/UI/Icon"):GetComponent("UISprite")
	self.rivalLevel = self.panel.transform:Find("Anchors/UI/Level"):GetComponent("UILabel")
	self.rivalScore = self.panel.transform:Find("Anchors/UI/Score"):GetComponent("UILabel")
	self.rivalCoinValue = self.panel.transform:Find("Anchors/UI/CoinValue"):GetComponent("UILabel")
	self.rivalName = self.panel.transform:Find("Anchors/UI/Name"):GetComponent("UILabel")
	self.lotteryPondTabel = self.panel.transform:Find("Anchors/UI/RewardTabel")
	self.restrictionObject = self.panel.transform:Find("Anchors/UI/Restriction")
	self.defineObject = self.panel.transform:Find("Anchors/UI/Define")
	self.scene:boundButtonEvents(self.panel)
	--self:HiddenView()
    
end

-- 初始化数据  -- rivalInfo(对手的据点信息)
function SnatchRivalInfoView:InitData(rivalInfo)
	self.rivalInfo = rivalInfo
	if tonumber(rivalInfo.memberid) == 0 then
		-- 无主之地
		self.rivalLevel.text =1
		self.rivalScore.text = 0
		self.rivalCoinValue.text = 0
		self.rivalName.text = "据点占领者"
		-- Icon
		--[[
		if self.charIconTxt:GetLineByID(rivalInfo.icon) ~= nil then
        	self.rivalIcon.spriteName = self.charIconTxt:GetData(rivalInfo.iconId, "ICON")
    	end
		]]--
	else
		self.rivalLevel.text = rivalInfo.level
		self.rivalScore.text = rivalInfo.score
		self.rivalCoinValue.text = rivalInfo.gold
		
		local err, ret = pcall(ZZBase64.decode, rivalInfo.name)
    	if err then
        	self.rivalName.text = ret
    	end
		-- Icon
		if self.charIconTxt:GetLineByID(rivalInfo.icon) ~= nil then
        	self.rivalIcon.spriteName = self.charIconTxt:GetData(rivalInfo.icon, "ICON")
    	end
	end
	
	
	self:AddRoleMode()
	
	
	-- 初始化据点掉落
	local snatchData = TxtFactory:getTable("SnatchConfigTXT") -- 据点表
	local lotteryPondData = TxtFactory:getTable(TxtFactory.LotteryPondTXT) -- 奖池表
	local   materialTabel = TxtFactory:getTable("MaterialTXT")  -- 材料表
	local rewardId = tonumber(snatchData:GetData(rivalInfo.tid,"TERRITORY_REWARD"))
	
	--printf("rewardId==="..rewardId)
	
	-- 用于存储掉落信息
	local lotteryItemInfos = {}
	
	if tonumber(lotteryPondData:GetData(rewardId,"FOR_OBJECT_TYPE")) == 1 then
		-- 材料
		local lotteryItems = lua_string_split(lotteryPondData:GetData(rewardId,"PRIZEPOOL"),";")
		for i = 1, #lotteryItems do
			local prizepools = lua_string_split(lotteryItems[i],"=")
			local itemIds = lua_string_split(prizepools[1],",")
			for i = 1,#itemIds do
				local lotteryItemInfo = {}
				lotteryItemInfo.itemId = itemIds[i]
				lotteryItemInfo.count = prizepools[3]
				table.insert(lotteryItemInfos,lotteryItemInfo)
			end
		end
	end
	
	-- 加载掉落数据
	self:ClearLotteryItemObject()
	self.lotteryItemObjects = {}
	for i =1 ,#lotteryItemInfos do
		local rewardObj  = newobject(Util.LoadPrefab("UI/Snatch/RewardItem"))
		--local strs = lua_string_split(rewards[j],"=")
		self.lotteryItemObjects[i] = rewardObj
		rewardObj.transform:Find("Label"):GetComponent("UILabel").text = lotteryItemInfos[i].count
		rewardObj.transform:Find("Icon"):GetComponent("UISprite").spriteName = materialTabel:GetData(lotteryItemInfos[i].itemId,"MATERIAL_ICON")
		rewardObj.transform.parent = self.lotteryPondTabel.transform
		rewardObj.transform.localPosition = Vector3.zero
    	rewardObj.transform.localScale = Vector3.one
	end
	local itemTable = self.lotteryPondTabel:GetComponent("UITable")
	itemTable:Reposition()
	itemTable.repositionNow = true
	
	-- 判断关卡类型  
	if snatchData:GetData(rivalInfo.strongholdID,"DRESS_ID") == "" then
		-- 自由关卡
		self.defineObject.gameObject:SetActive(false)
		self.restrictionObject.gameObject:SetActive(true)
	else
		-- 限定关卡
		self.restrictionObject.gameObject:SetActive(false)
		self.defineObject.gameObject:SetActive(true)
	end
	
	
end

-- 清除掉落的对象
function SnatchRivalInfoView:ClearLotteryItemObject()
	if self.lotteryItemObjects ~= nil then
		for i = 1 , # self.lotteryItemObjects do
			if self.lotteryItemObjects[i] ~= nil then
				GameObject.Destroy(self.lotteryItemObjects[i])
			end
		end
	end
	--self.lotteryItemObjects = {}
end

-- 加载模型
function SnatchRivalInfoView:AddRoleMode()

	
	--模型
	self.modelShow = ModelShow.new()
    self.modelShow:Init(self)

	-- 显示人物模型预览
   -- self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    self.modelShow:ChooseCharacter(self.UserInfo[TxtFactory.USER_SEX])
    self.modelShow:petShow()
end

-- 战斗界面
function SnatchRivalInfoView:SnatchBattleBtnOnClick()
	printf("战斗界面")
	-- 判断是否还有剩余次数
	if  self.scene:GetSnatchCount() <= 0 then
		self.scene:promptWordShow("体力不足")
		return 
	end
	self:sendStartRunning()
end

--激活界面
function SnatchRivalInfoView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function SnatchRivalInfoView:HiddenView()
	if self.modelShow ~= nil then
		self.modelShow:DestroyPet()
	end
	self.scene.snatchMianView:ShowView()
	self.panel:SetActive(false)
	
end


--开始跑酷信息 (发送)
function SnatchRivalInfoView:sendStartRunning()
    local json = require "cjson"
	
	 local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {id=self.rivalInfo.id}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = explorer_pb.ExplorerStartRequest()
		message.id = self.rivalInfo.id
        strr = ZZBase64.encode(message:SerializeToString())
    end
   -- local msg = {id=self.rivalInfo.id}
  --  local strr = json.encode(msg)
    local param = {
              code = MsgCode.ExplorerStartRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.ExplorerStartResponse, self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    --print("开始跑酷信息 发送")
end

--开始跑酷信息 (回复)
function SnatchRivalInfoView:getStartRunning(info)
    local json = require "cjson"
  	local tab = json.decode(info.data)
	if tab.result == 1 then
		-- 设置跑酷场景类型
		TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,3)
		local snatchInfo =TxtFactory:getMemDataCacheTable(TxtFactory.SnatchInfo)
		if snatchInfo == nil then
			local snatch_info = {}
			local memCache = TxtFactory:getTable("MemDataCache")
  			memCache:setTable(TxtFactory.SnatchInfo,snatch_info)
		end
		TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_STRONGHOLDID,self.rivalInfo.id)
		self.scene:ChangScene("level_endless")
	end
end

