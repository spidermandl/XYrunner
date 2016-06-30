--[[
author:gaofei
七日活动界面
]]

SveneDayActivityView = class ()

SveneDayActivityView.scene = nil --场景scene
SveneDayActivityView.panel = nil -- 界面

SveneDayActivityView.activityItem = nil -- 存储七个活动物品
SveneDayActivityView.itemGrid = nil -- 存储礼包item的父节点


-- 初始化
function SveneDayActivityView:init(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Activity/SveneDayActivity"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
	
	self.sveneDayActivityData = TxtFactory:getTable(TxtFactory.SveneDayActivityConfigTXT)
	
	-- 初始化默认天数(测试专用 该天数应该由服务器提供)
	
	self.userInfo = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	self.curActivityDay = self.userInfo[TxtFactory.USER_LOGIN_NUM]
	--GamePrint("self.curActivityDay =="..self.curActivityDay)
	
	self.activityItem = {}
	for i = 1 , 7 do
		self.activityItem[i] = self.panel.transform:Find("Anchors/UI/RewardItems/Item"..i)
	end
	self.itemGrid = self.panel.transform:Find("Anchors/UI/Scroll View/Grid")
	self:InitRewardList()
	self:InitActivityItemIcon()
    self.scene:boundButtonEvents(self.panel)
end

-- 初始化可以领取的奖励列表
function SveneDayActivityView:InitRewardList()
	-- 测试阶段默认显示第一天奖励(以后根据服务器给的数据显示)
	--self.curActivityDay+1
	if self:IsCanGetSveneDayReward() then
		self.curActivityDay = self.curActivityDay + 1
	end
	if self.curActivityDay > 7 then
		self.curActivityDay = 7
	end
	local gift_id = self.sveneDayActivityData:GetData(self.curActivityDay,"ACTIVITY_GIFT_ID")
	
	--local gift_id = self.sveneDayActivityData:GetData(2,"ACTIVITY_GIFT_ID")
	self:CreateItems(gift_id)
end

-- 初始化七天奖励的Icon
function SveneDayActivityView:InitActivityItemIcon()
	local login_num = self.userInfo[TxtFactory.USER_LOGIN_NUM]
	for i = 1 , #self.activityItem do
		local iconName =  self.sveneDayActivityData:GetData(i,"ACTIVITY_ICON")
		local atlasName = "UI/Picture/".. self.sveneDayActivityData:GetData(i,"ATLAS_NAME")
		local iconSprite = self.activityItem[i].transform:Find("Icon"):GetComponent("UISprite")
		local bg = self.activityItem[i].transform:Find("BG"):GetComponent("UISprite")
		--GamePrint("======="..atlasName)
		iconSprite.atlas = Util.PreLoadAtlas(atlasName)
		local gouObj = self.activityItem[i].transform:Find("Gou").gameObject
		iconSprite.spriteName = iconName
		iconSprite:MakePixelPerfect()
		-- 设置领取状态
		gouObj:SetActive(i <= login_num)
		if i == self.curActivityDay then
			-- 当天
			bg.spriteName = "hongtiaofu"
		else
			bg.spriteName = "huangtiaofu"
		end
		
	end
end

-- 领取奖励
function SveneDayActivityView:SveneDayActivityGetBtnOnClick()
	GamePrint("领取活动")
	if self:IsCanGetSveneDayReward() then
		self:SendSevenLoginRequest()
		return
	end
	-- 今日的奖励是否已经领取
	self.scene:promptWordShow("今天已经领取过奖励了,明天再来吧!!!")
end 

-- 今日的奖励是否已经领取
function SveneDayActivityView:IsCanGetSveneDayReward()
	
	local get_login_gift = self.userInfo[TxtFactory.USER_GET_LOGIN_GIFT]
	--GamePrint("login_num ==="..login_num)
	if get_login_gift == 0 then
		return false
	end
	return true
end

-- 关闭活动界面
function SveneDayActivityView:SveneDayActivityCloseBtnOnClick()
	self:HiddenView()
end

--激活暂停界面
function SveneDayActivityView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function SveneDayActivityView:HiddenView()
	self.panel:SetActive(false)
end

-- 根据奖池id生成物品列表
function SveneDayActivityView:CreateItems(gift_id)
	local storeGiftBagData = TxtFactory:getTable(TxtFactory.StoreGiftBagConfigTXT)
	local materialData  = TxtFactory:getTable(TxtFactory.MaterialTXT)
           
	local items = storeGiftBagData:GetData(gift_id,"ALL_GOODS")
	local ids = lua_string_split(items, ",")
	local itemObj = nil
	for i = 1 , #ids do
		local itemInfo = lua_string_split(ids[i], "=")
		itemObj = newobject(Util.LoadPrefab("UI/Activity/GiftItem"))
		local icon = itemObj.transform:Find("icon"):GetComponent("UISprite")
		itemObj.transform:Find("num"):GetComponent("UILabel").text = itemInfo[2]
		--GamePrint("id ===="..itemInfo[1])
		--materialData:GetItemIcon(itemInfo[1])
		--icon.spriteName = materialData:GetData(itemInfo[1],"MATERIAL_ICON")
		local iconName,atlasName = materialData:GetItemIconById(itemInfo[1])
		atlasName = "UI/Picture/"..atlasName
		icon.atlas =  Util.PreLoadAtlas(atlasName)
		icon.spriteName = iconName
		icon:MakePixelPerfect()
		-- 暂时特殊处理(精确需要美术出一套宠物头像Icon)
		if atlasName == "UI/Picture/PetIcon" then
			GamePrint("--------------------")
			itemObj.transform:Find("icon").localScale = UnityEngine.Vector3(0.65,0.65,0.65)
			itemObj.transform:Find("icon").localPosition = UnityEngine.Vector3(0,7,0)
		end
		
		itemObj.transform.parent = self.itemGrid.transform
		itemObj.transform.localPosition = Vector3.zero
    	itemObj.transform.localScale = Vector3.one
	end
	local grid = self.itemGrid:GetComponent("UIGrid")
	grid:Reposition()
	grid.repositionNow = true
end

--领取七日奖励 请求
function SveneDayActivityView:SendSevenLoginRequest()
	local json = require "cjson"
    local userTable = TxtFactory:getTable(TxtFactory.UserTXT)
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {class=0}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = charinfo_pb.SevenLoginRequest()
		message.class=0
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.SevenLoginRequest,
              data = strr, -- strr
             }
    MsgFactory:createMsg(MsgCode.SevenLoginResponse,self)
    NetManager:SendPost(NetConfig.STORE_BUYITEM,json.encode(param)..'|'..userTable:getValue('Username')..':'..userTable:getValue('access_token'))
end

-- 领取七日奖励  回复
function SveneDayActivityView:getSevenLoginResponse(resp)
    local json = require "cjson"
    local tab = json.decode(resp.data)
  	if tab.result == 1 then
    	local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)  --扣除金币钻石
    	--local userInfo = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
		self.userInfo[TxtFactory.USER_GET_LOGIN_GIFT] = tab.get_login_gift
		self.curActivityDay =  tab.login_num
		self.userInfo[TxtFactory.USER_LOGIN_NUM] = tab.login_num
		if not tab.gold then
			tab.gold = 0
		end
		if not tab.diamond then
			tab.diamond = 0
		end
      
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
		local itemObjList =   self.scene:CreatItemList(serverData)
		self.scene:rewardItemsShow(itemObjList)
		
		-- 刷新顶部资源
		self.scene.PlayerInfoPanel.playerTopInfoPanel:InitData()
		 -- 刷新七日活动红点
		self.scene.PlayerInfoPanel:SetSignInRedPointActivity()
		-- 刷新界面
		self:InitActivityItemIcon()
    end
   
end

