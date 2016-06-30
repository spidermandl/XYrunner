--[[
author:hanli_xiong
邮件系统
]]

require "game/scene/logic/building/EmailManagement"

EmailSystemView = class()

EmailSystemView.scene = nil -- 依附的场景对象
EmailSystemView.gameObject = nil -- UI对象
EmailSystemView.UserTxt = nil
EmailSystemView.charIcon = nil -- 玩家icon表
EmailSystemView.management = nil

EmailSystemView.uitween = nil -- UI动画
EmailSystemView.itemsScrollView = nil
EmailSystemView.itemsGrid = nil  -- 邮件列表根节点
EmailSystemView.friendItemPre = nil   -- 好友邮件预设
EmailSystemView.systemItemPre = nil -- 系统邮件预设
EmailSystemView.friendEmailBtn = nil -- 好友邮件按钮
EmailSystemView.systemEmailBtn = nil   -- 系统邮件按钮
EmailSystemView.systemEmailList = nil -- 系统邮件列表 {邮件item instanceID = 邮件 id}
EmailSystemView.sceneTarget = nil
EmailSystemView.curItem = nil -- 当前的邮件InstanceID

-- 初始化UI
function EmailSystemView:Init(targetscene)
	self.scene = targetscene
	self.sceneTarget = targetscene.sceneTarget
    self.UserTxt = TxtFactory:getTable(TxtFactory.UserTXT)
    self.charIconTxt = TxtFactory:getTable(TxtFactory.CharIconTXT)
    self.management = EmailManagement.new()
    self.management:Awake(targetscene)
    
    -- 初始化UI
    self.gameObject = self.scene:LoadUI("EmailSystemUI")
    local trans = self.gameObject.transform:Find("Wnd")
    -- self.uitween = self.gameObject:GetComponent("UIPlayTween")
    self.itemsScrollView = trans:Find("ScrollView"):GetComponent("UIScrollView")
    self.itemsGrid = trans:Find("ScrollView/Grid")
    self.friendItemPre = trans:Find("FriendItemPre").gameObject
    self.systemItemPre = trans:Find("SystemItemPre").gameObject
    self.friendEmailBtn = trans:Find("Btns/Email_Friend").gameObject
    self.systemEmailBtn = trans:Find("Btns/Email_System").gameObject
	self.friendEmailSpr =  trans:Find("Btns/Email_Friend/Sprite").gameObject
	self.systemEmailSpr =  trans:Find("Btns/Email_System/Sprite").gameObject
	--红点
	self.SystemRed =  getUIGameObject(self.gameObject,"Wnd/Btns/Email_System/red") 
	self.FriendRed = getUIGameObject(self.gameObject,"Wnd/Btns/Email_Friend/red")
	self.FriendRed.gameObject:SetActive(false)
	self.SystemRed.gameObject:SetActive(false)
    self.friendItemPre:SetActive(true)
    self.systemItemPre:SetActive(true)
    self.scene:boundButtonEvents(self.gameObject)
    self.friendItemPre:SetActive(false)
    self.systemItemPre:SetActive(false)
    -- 初始化邮件池
    self.systemEmailList = {}
    for i=1, 30 do
    	local go = newobject(self.friendItemPre)
    	self.systemEmailList[go:GetInstanceID()] = 0
    	go.gameObject.name = "emailItem" .. i
    	go.transform.parent = self.itemsGrid
    	go.transform.localScale = Vector3.one
    end
  	
	self.ToggleType = 1
	local eInfo = TxtFactory:getMemDataCacheTable(TxtFactory.EmailInfo)
	if eInfo == nil then
		self.management:SendSystemEmail()
	end
	self.gameObject:SetActive(false)
	--刷新系统邮件红点
 	local emailList = self:GetTypeEmailList(2)
	self:SetRedPoint(2,#emailList>0)

	--默认为系统
	self.systemEmailBtn:SendMessage("OnClick",self.systemEmailBtn,1);
	self:OnSwitchBtn(self.systemEmailBtn.name)
end

function EmailSystemView:SetRedPoint(ToggleType, active)
	if ToggleType == 1 then
		self.FriendRed.gameObject:SetActive(active)
	elseif ToggleType == 2 then
		self.SystemRed.gameObject:SetActive(active)
	end
end

function EmailSystemView:SetActive(enable)
	self.gameObject:SetActive(enable)
	-- self.uitween:Play(true)
	if enable then
		if self.ToggleType == 1 then
			self:OnSwitchBtn(self.friendEmailBtn.name)
		elseif self.ToggleType == 2 then
			self:OnSwitchBtn(self.systemEmailBtn.name)			
		end
		self.itemsGrid:GetComponent("UIGrid"):Reposition()

	end
end

-- 切换 好友／系统 邮件按钮
function EmailSystemView:OnSwitchBtn(buttonName)
	
	if buttonName == self.friendEmailBtn.name then
		
		self:UpdateEmail(1)
		self.friendEmailSpr:SetActive(true)
		self.systemEmailSpr:SetActive(false)
	elseif buttonName == self.systemEmailBtn.name then
		
		self:UpdateEmail(2)
		
		self.systemEmailSpr:SetActive(true)
		self.friendEmailSpr:SetActive(false)
	else
		self:OneKeyGet()
	end
end

function EmailSystemView:UpdateEmail(type)
	self.ToggleType = type
	local emailList = self:GetTypeEmailList(type)
	self:SetRedPoint(type,#emailList>0)
	self:SetEmailList(emailList)
end

function EmailSystemView:GetTypeEmailList(type)
	local eInfo = TxtFactory:getMemDataCacheTable(TxtFactory.EmailInfo)
	local EmailList = {}
	if eInfo == nil then
		return EmailList
	end
	for k,v in pairs(eInfo) do
		if type == 1 then
			if v.tid == 11 or  v.tid == 12 then
				table.insert(EmailList,v)
			end
		elseif type == 2 then
			if v.tid ~= 11 and v.tid ~=  12 then
				table.insert(EmailList,v)
			end
		end
	end
	return EmailList
end
-- 一键领取奖励
function EmailSystemView:OneKeyGet()
	print("一键领取")
	-- local emailList = {}
	-- for k,v in  pairs(self.systemEmailList) do 
	-- 	if v ~= 0 then
	-- 		print ("v : "..v)
	-- 		table.insert(emailList,tonumber(v))
	-- 	end
	-- end
	local emailList = self:GetTypeEmailList(self.ToggleType)
	self.management:SendEmailReward(emailList)
end

--[[
	//服务器和
message Mail2Info {
	optional int32 	id 				= 1;
	optional int32  tid         	= 2;
	optional string title 			= 3;
	optional int32  from_uid 		= 4;
	optional string from_name   	= 5;
	optional int32  to_uid      	= 6;
	optional string expire_time     = 7;
	optional int32  gold  			= 9;//金币
	optional int32  diamond         = 10;//钻石
	optional int32  strength        = 11;//体力
	optional int32  explorer_gold   = 12;//夺宝币
	repeated ItemInfo bin_items     = 13;//套装,宠物,装备和材料
	optional int32  create_time     = 14;//
}
	--]]

-- 设置邮件列表
function EmailSystemView:SetEmailList(tab)
	if tab == nil then
		warn("邮件列表为空")
		return
	end
	local i = 0
	for k, v in pairs(tab) do
		if v~=nil then
			local item = self.itemsGrid:GetChild(i)
			item.gameObject:SetActive(true)
			self.systemEmailList[item.gameObject:GetInstanceID()] = tonumber(v.id) -- 邮件item = 邮件ID
			item:Find("senderIcon"):GetComponent("UISprite").spriteName = "head_101"
			local senderName = "系统邮件"
			if v.tid == 1 then
				senderName = "公告"
			elseif v.tid == 11 or v.tid == 12 then		
				local err, ret = pcall(ZZBase64.decode, v.from_name)
				if err then
					senderName= ret
				end
			end
			item:Find("senderName"):GetComponent("UILabel").text = senderName
			item:Find("mailContent"):GetComponent("UILabel").text = tonumber(v.title)and "" or v.title
			item:Find("mailTime"):GetComponent("UILabel").text = self.ParseSecends(v.create_time)
			local rIcon = item:Find("EmailGetBtn/icon"):GetComponent("UISprite")
			local rLabel = item:Find("EmailGetBtn/Label"):GetComponent("UILabel")
			local icontab = self.charIconTxt.OtherIcon
			if v.gold > 0 then
				rIcon.spriteName = icontab.gold
			elseif v.diamond > 0 then
				rIcon.spriteName = icontab.diamond
			elseif v.strength > 0 then
				rIcon.spriteName = icontab.strength
			elseif v.explorer_gold>0 then
				rIcon.spriteName = icontab.explorer_gold
			end
			if v.tid == 12 then
				rIcon.spriteName = icontab.strength--"fangwen"
				rLabel.text = "应战"
			else
				rLabel.text = "领取"
			end
			i = i + 1
		 end
	end
	for j=i, 30-1 do
		self.itemsGrid:GetChild(j).gameObject:SetActive(false)
		self.systemEmailList[self.itemsGrid:GetChild(j).gameObject:GetInstanceID()] = 0
	end
	self.itemsGrid:GetComponent("UIGrid"):Reposition()
	self.itemsScrollView:ResetPosition()
end

-- 领取按钮
function EmailSystemView:GetReward(button)
	local index = button.transform.parent.gameObject:GetInstanceID()
	if self.systemEmailList[index] and self.systemEmailList[index] ~= 0 then
		print("领取邮件奖励" .. index)
		print("self.systemEmailList[index] :"..self.systemEmailList[index] )
		self.curItem = index
		local emailList = {}	
		table.insert(emailList,tonumber(self.systemEmailList[index]))
		self.management:SendEmailReward(emailList)
	end
end

function EmailSystemView:CloseWnd()
	self.scene.EmailSystemPanel = nil
	destroy(self.gameObject)
end

function EmailSystemView:OnGetRewardSucceed()
	self:UpdateEmail(self.ToggleType)
end
--应战成功，进入无尽
function EmailSystemView:SkipEndlessScene()
	TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,2)
    --self.scene:ChangScene(SceneConfig.endlessScene)
	self.gameObject:SetActive(false)
	self.scene:OpenEndlessScene()
end

function EmailSystemView.ParseSecends(secends)
	-- print("邮件发送时间：" .. os.date("%Y/%m/%d %H:%M:%S", secends))
	if secends == nil then
		return ""
	end
	local ss = os.time() - tonumber(secends) -- os.time{year=1970, month=1, day=1, hour=0} -- 时区差
	local timeStr = ""
	if ss > 60*60*24 then
		timeStr = math.floor(ss/(60*60*24)) .. "天前"
	elseif ss > 60*60 then
		timeStr = math.floor(ss/(60*60)) .. "小时前"
	elseif ss > 60 then
		timeStr = math.floor(ss/(60)) .. "分钟前"
	elseif ss > 0 then
		timeStr = "刚刚"
	end
	return timeStr
end


