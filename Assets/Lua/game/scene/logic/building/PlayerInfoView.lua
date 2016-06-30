--[[
author:hanli_xiong
玩家信息面板
]]

require "game/scene/common/PlayerTopInfo"

PlayerInfoView = class()

PlayerInfoView.scene = nil -- 依附的场景对象
PlayerInfoView.gameObject = nil -- UI对象
PlayerInfoView.UserTxt = nil
PlayerInfoView.charIconTxt = nil -- 玩家icon表

-- 玩家信息
--PlayerInfoView.playerDiamond = nil  -- 钻石数量
--PlayerInfoView.playerGold = nil   -- 金币数量
--PlayerInfoView.playerStrength = nil -- 玩家体力
PlayerInfoView.playerName = nil -- 玩家昵称
PlayerInfoView.playerLevel = nil   -- 玩家等级
PlayerInfoView.playerExpProcess = nil -- 玩家经验进度
PlayerInfoView.playerIcon = nil -- 玩家图标

PlayerInfoView.onlineTimeLabel = nil -- 在线倒计时
PlayerInfoView.IsGetOnlineRewad = nil -- 是否可以领取在线奖励
PlayerInfoView.onlineTime = nil -- 可以领取在线奖励的时间
PlayerInfoView.onlineRedPoint = nil -- 可以领取在线奖励显示小红点
PlayerInfoView.signInRedPoint = nil  -- 签到红点
PlayerInfoView.onlineBtn = nil -- 在线奖励按钮

PlayerInfoView.powerResumeTimeLabel = nil -- 体力恢复倒计时
PlayerInfoView.powerResumeTimeObj = nil -- 体力恢复Obj
PlayerInfoView.IsAddPower = nil -- 是否需要增加体力
PlayerInfoView.addPowerTime = nil -- 添加一点体力需要的时间
PlayerInfoView.maxPowerValue = nil -- 最大体力上限
PlayerInfoView.alreadyTime = nil -- 恢复下一个体力剩余时间 (服务器发送)

-- 初始化UI
function PlayerInfoView:Init(targetscene)
	self.scene = targetscene
    self.charIconTxt = TxtFactory:getTable(TxtFactory.CharIconTXT)

    -- 初始化角色信息UI
    self.gameObject = self.scene:LoadUI("Building/BuildingTopUI")
    local leftup = self.gameObject.transform:Find("UI/LeftUp") -- 左上角模块
    local rightup = self.gameObject.transform:Find("UI/RightUp") -- 右上角模块
    local top = self.gameObject.transform:Find("UI/Top") -- 顶部模块
    self.scene:boundButtonEvents(self.gameObject)
    self.playerName = leftup:Find("playerInfo/name/label"):GetComponent("UILabel")
    self.playerLevel = leftup:Find("playerInfo/lv/label"):GetComponent("UILabel")
    self.playerExpProcess = leftup:Find("playerInfo/exp"):GetComponent("UISlider")
    self.playerIcon = leftup:Find("playerInfo/BuildingTop_PlayserSetting/icon"):GetComponent("UISprite")
    self.onlineTimeLabel = rightup:Find("Building_OnlineReward/Sprite/Label"):GetComponent("UILabel")
    self.onlineTimeObj = rightup:Find("Building_OnlineReward/Sprite").gameObject
    self.onlineRedPoint = rightup:Find("Building_OnlineReward/redPoint").gameObject
    self.signInRedPoint = rightup:Find("Building_SignIn/redPoint").gameObject
    self.onlineBtn = rightup:Find("Building_OnlineReward").gameObject
    
    -- 暂时隐藏活动按钮
    
    leftup:Find("Waves/Building_Activity").gameObject:SetActive(false)
    self.powerResumeTimeLabel = rightup:Find("PowerResumeTime/Label"):GetComponent("UILabel")
    self.powerResumeTimeObj = rightup:Find("PowerResumeTime").gameObject
    -- 添加体力 钻石 金币 
    self.playerTopInfoPanel = PlayerTopInfo.new()
    self.playerTopInfoPanel:Init("NoneReturn")
    self.playerTopInfoPanel:SetParent( self.scene.uiRoot)
    targetscene.playerTopInfoPanel = self.playerTopInfoPanel

    --local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    self.userInfo = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
   -- GamePrint("---"..self.userInfo[TxtFactory.USER_NAME])
    self.playerName.text = self.userInfo[TxtFactory.USER_NAME]
    self.playerLevel.text = self.userInfo[TxtFactory.USER_LEVEL]
    
    local playerLevelUpTXT =  TxtFactory:getTable(TxtFactory.PlayerLevelUpTXT)
    
    local currentTotalExp = playerLevelUpTXT:getTotalExpByLevel(self.userInfo[TxtFactory.USER_LEVEL] - 1)
    local nextTotalExp = playerLevelUpTXT:getTotalExpByLevel(self.userInfo[TxtFactory.USER_LEVEL])
            
    self.playerExpProcess.value = (self.userInfo[TxtFactory.USER_EXP] - currentTotalExp)/nextTotalExp
    self:SetSignInRedPointActivity()
    self:InitPowerData()
    self:InitOnlineData()
    self:StarOnlineTime()
    local iconId = self.userInfo[TxtFactory.USER_ICON]
    --print("iconId : "..iconId)
    if self.charIconTxt:GetLineByID(iconId) ~= nil then
        self.playerIcon.spriteName = self.charIconTxt:GetData(iconId, "ICON")
    end
    self:GetRedPoint()
end
--红点
function PlayerInfoView:GetRedPoint()
    --email
     local emailManagement= EmailManagement.new()
    emailManagement:Awake(self.scene)
    emailManagement:SendSystemEmail()
    self.EmailRed = getUIGameObject(self.gameObject,"UI/LeftUp/Waves/Building_Email/redPoint")
    self.EmailRed.gameObject:SetActive(false)
    
    
    local taskManagement = TaskDialyManagement.new()
	taskManagement:Awake(self.scene)
	taskManagement:SendSystemTask()
    self.TaskRed = getUIGameObject(self.gameObject,"UI/LeftUp/Waves/Building_Task/redPoint")
    self.TaskRed.gameObject:SetActive(false)
end


function PlayerInfoView:SetRedPoint(type,active)
      --邮件红点
    if  type == "email" then
         self.EmailRed.gameObject:SetActive(active)
    elseif type == "task" then
        self.TaskRed.gameObject:SetActive(active)
    end
end

-- 刷新玩家信息－重新读取并显示
function PlayerInfoView:RefreshPlayerInfo()
	-- body
end

function PlayerInfoView:SetActive(enable)
    self.gameObject:SetActive(enable)
end

-- 初始化体力数据
function PlayerInfoView:InitPowerData()
    local vipFeatureConfigTXT = TxtFactory:getTable(TxtFactory.VipFeatureConfigTXT)
  --  self.IsAddPower = false
    --self.userInfo[TxtFactory.USER_STRENGTH] =1
    
    self.addPowerTime = tonumber(vipFeatureConfigTXT:GetData(1,"RESUME_SPEED"))
    self.maxPowerValue = tonumber(vipFeatureConfigTXT:GetData(1,"LIGHT_MAX"))
    
    self.alreadyTime = self.userInfo[TxtFactory.USER_STRENGTH_TIME] + os.time()
    self.powerResumeTimeObj:SetActive(self:IsNeedAddPower())
    --self:StarOnlineTime()
end

-- 初始化在线活动数据
function PlayerInfoView:InitOnlineData()
    
    local onlineActivityConfigTXT = TxtFactory:getTable(TxtFactory.OnlineActivityConfigTXT)
     
	local alive_time = self.userInfo[TxtFactory.USER_ALIVE_TIME]
    local alive_reward = self.userInfo[TxtFactory.USER_ALIVE_REWARD]
    
    -- 判断是否全部领取
    if onlineActivityConfigTXT:GetLineNum() <= alive_reward then
        -- 已经全部领取
        self.IsGetOnlineRewad = true
        -- 隐藏在线按钮
        self.onlineBtn:SetActive(false)
        return
    end
    local needTime = tonumber(onlineActivityConfigTXT:GetData(alive_reward+1,"ONLINE_TIME"))
    
    self.onlineTime = self.userInfo[TxtFactory.USER_GAME_STAR_TIME]+needTime-alive_time
    self.IsGetOnlineRewad = false 
    self:SetOnlineObjActive()
    --self:StarOnlineTime()
end

-- 设置红点和时间
function PlayerInfoView:SetOnlineObjActive()
    self.onlineRedPoint:SetActive(self.IsGetOnlineRewad)
    self.onlineTimeObj:SetActive(not(self.IsGetOnlineRewad))
end
-- 开始在线活动时间倒计时
function PlayerInfoView:StarOnlineTime()

    coroutine.start(self.SetOnlineTimeValue, self)
end

-- 每一秒调用一次 刷新时间
function PlayerInfoView:SetOnlineTimeValue()
    if self.IsGetOnlineRewad and not(self:IsNeedAddPower()) then
        return
    end
    if not(self.IsGetOnlineRewad) then
        local time = self.onlineTime - os.time()
        --GamePrint("time ===="..time)
        if time <= 0 then
            self.IsGetOnlineRewad = true
            self:SetOnlineObjActive()
           -- return
        end
        -- 设置时间
        self.onlineTimeLabel.text = self:SerializeTime(time)
    end
    -- 刷新体力冷却时间
    if self:IsNeedAddPower() then
        -- 刷新数据
        local time = self.alreadyTime - os.time()
       -- GamePrint("time ======="..time)
        if time <= 0 then
             
             self.userInfo[TxtFactory.USER_STRENGTH] = tonumber(self.userInfo[TxtFactory.USER_STRENGTH]) +1
             -- 刷新界面
             self.playerTopInfoPanel:InitData()
             self.powerResumeTimeObj:SetActive(self:IsNeedAddPower())
             self.alreadyTime = self.addPowerTime + os.time()
        end
        -- 设置时间
        self.powerResumeTimeLabel.text = self:SerializeTime(time)  
    end
    coroutine.wait(1)
    self:StarOnlineTime()
end

-- 判断是否需要添加体力
function PlayerInfoView:IsNeedAddPower()
   -- return false

    if tonumber(self.userInfo[TxtFactory.USER_STRENGTH]) >= self.maxPowerValue then
        -- 不需要添加
        return false
    end
    -- 需要添加
    return true

end

-- 将秒数序列化成00:00
function PlayerInfoView:SerializeTime(time)
    local integer,f = math.modf(time/60)
    f = time - integer*60
    local minutes = tostring(integer)
    local seconds = tostring(f)
    if integer < 10 then
        minutes = "0"..integer
    end
    if f < 10 then
        seconds = "0"..f
    end
    return minutes..":"..seconds
end

--领取在线奖励 请求
function PlayerInfoView:SendSevenLoginRequest()
	local json = require "cjson"
    local userTable = TxtFactory:getTable(TxtFactory.UserTXT)
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {class=1}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = charinfo_pb.SevenLoginRequest()
        message.class=1
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.SevenLoginRequest,
              data = strr, -- strr
             }
    MsgFactory:createMsg(MsgCode.SevenLoginResponse,self)
    NetManager:SendPost(NetConfig.STORE_BUYITEM,json.encode(param)..'|'..userTable:getValue('Username')..':'..userTable:getValue('access_token'))
end

-- 领取在线奖励 回复
function PlayerInfoView:getSevenLoginResponse(resp)
    local json = require "cjson"
    local tab = json.decode(resp.data)
  	if tab.result == 1 then
    	local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)  --扣除金币钻石
    	--local userInfo = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
		self.userInfo[TxtFactory.USER_ALIVE_TIME] = 0
		self.userInfo[TxtFactory.USER_ALIVE_REWARD] = tab.alive_reward
        self.userInfo[TxtFactory.USER_GAME_STAR_TIME] = os.time() -- 重置奖励开始时间
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
		self.playerTopInfoPanel:InitData()
		-- 刷新界面
		--self:InitActivityItemIcon()
        self:InitOnlineData()
        self:StarOnlineTime()
    end
    
end

-- 设置七日活动红点
function PlayerInfoView:SetSignInRedPointActivity()
    
    local get_login_gift = self.userInfo[TxtFactory.USER_GET_LOGIN_GIFT]
    GamePrint(" ---"..get_login_gift)
	--GamePrint("login_num ==="..login_num)
	if get_login_gift == 0 then
		self.signInRedPoint:SetActive(false)
        return
	end
    self.signInRedPoint:SetActive(true)
end





