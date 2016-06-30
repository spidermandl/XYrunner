--[[
author:hanli_xiong
用户管理界面 (用户信息，游戏设置，兑换码)
]]

require "game/scene/logic/building/ExchangeManagement"

PlayerSettingView = class()

PlayerSettingView.scene = nil
PlayerSettingView.sceneTarget = nil 
PlayerSettingView.gameObject = nil
PlayerSettingView.management = nil
PlayerSettingView.UserTxt = nil
PlayerSettingView.charIconTxt = nil

PlayerSettingView.accountInfo = nil -- 用户信息
PlayerSettingView.gameSetting = nil -- 游戏设置
PlayerSettingView.exchangeCode = nil -- 兑换码
PlayerSettingView.accountBtn = nil -- 用户信息按钮
PlayerSettingView.setBtn = nil -- 游戏设置按钮
PlayerSettingView.exchangeBtn = nil -- 兑换码按钮
PlayerSettingView.Btn_View = nil -- 按钮－界面表

-- 用户信息
PlayerSettingView.playerIDInput = nil
PlayerSettingView.playerNameInput = nil
PlayerSettingView.PlayerIconSprite = nil
-- 游戏设置
PlayerSettingView.effectSound = nil
PlayerSettingView.backSound = nil
PlayerSettingView.setStrBtn = nil -- 设置赠送体力按钮
PlayerSettingView.setStrState = false -- 赠送体力状态
PlayerSettingView.setModelBtn = nil -- 设置流畅模式按钮
PlayerSettingView.setModelState = false -- 赠送体力状态
PlayerSettingView.setShowBtn = nil -- 设置按钮显示按钮
PlayerSettingView.setShowState = false -- 赠送体力状态
-- 兑换码
PlayerSettingView.exchangeCodeInput = nil
PlayerSettingView.excInfo = nil -- 兑换信息／结果
PlayerSettingView.GiftListView = nil -- 礼品领取界面
PlayerSettingView.giftGrid = nil -- 礼品列表
PlayerSettingView.giftPre = nil -- 单个礼品预设

-- 初始化
function PlayerSettingView:Init(targetscene)
	self.scene = targetscene
	self.sceneTarget = targetscene.sceneTarget
	self.management = ExchangeManagement.new()
	self.management:Awake(self)
    self.UserTxt = TxtFactory:getTable(TxtFactory.UserTXT)
    self.charIconTxt = TxtFactory:getTable(TxtFactory.CharIconTXT)

	self.gameObject = self.scene:LoadUI("PlayerSettingUI")
	local trans = self.gameObject.transform:GetChild(0):Find("mainboard")
	self.accountInfo = trans:Find("Content 1/AccountInfo").gameObject
	self.gameSetting = trans:Find("Content 2/GameSetting").gameObject
	self.exchangeCode = trans:Find("Content 3/ExchangeCode").gameObject
	self.accountBtn = trans:Find("Tab/Tab 1/Animation/PlyaerSettingBtn_Account").gameObject
	local accountBtn = trans:Find("Tab/Tab 1")
	self.setBtn = trans:Find("Tab/Tab 2/Animation/PlyaerSettingBtn_Set").gameObject
	local setBtn = trans:Find("Tab/Tab 1")
	self.exchangeBtn = trans:Find("Tab/Tab 3/Animation/PlyaerSettingBtn_Exchange").gameObject
	local exchangeBtn = trans:Find("Tab/Tab 1")
	self.Btn_View = {}
	self.Btn_View[self.accountBtn] = self.accountInfo
	self.Btn_View[self.setBtn] = self.gameSetting
	self.Btn_View[self.exchangeBtn] = self.exchangeCode
	-- self:OnBtnClick(self.accountBtn.name)   --fjc
	self.scene:boundButtonEvents(self.gameObject)
	-- 用户信息
	self.playerIDInput = trans:Find("Content 1/AccountInfo/PlayerID/content"):GetComponent("UILabel")
	self.playerNameInput = trans:Find("Content 1/AccountInfo/PlayerName"):GetComponent("UIInput")
	self.PlayerIconSprite = trans:Find("Content 1/AccountInfo/PlayerIcon/icon"):GetComponent("UISprite")
	self.playerNameInput.value = self.UserTxt:getValue('Username')
	self.playerIDInput.text = tostring(TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)[TxtFactory.USER_MEMBERID])
	--error("memberId:"..tostring(TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)[TxtFactory.USER_MEMBERID]))
	-- 游戏设置
	self.effectSound = trans:Find("Content 2/GameSetting/EffectSound"):GetComponent("UISlider")
	
	
	self.backSound = trans:Find("Content 2/GameSetting/BackSound"):GetComponent("UISlider")
	if(Util.HasKey("AudioEffect"))then
		self.effectSound.value =tonumber(Util.GetString("AudioEffect")) 
	else
		self.effectSound.value = 0.5
	end
	
	if(Util.HasKey("AudioSound"))then
		self.backSound.value =tonumber(Util.GetString("AudioSound")) 
	else
		self.backSound.value = 0.5
	end
	local btns = trans:Find("Content 2/GameSetting/GameSettingBtns")
	self.setStrBtn = btns:GetChild(0)
	self.setModelBtn = btns:GetChild(1)
	self.setShowBtn = btns:GetChild(2)
	-- 兑换码
	self.exchangeCodeInput = trans:Find("Content 3/ExchangeCode/ExchangeCodeInput"):GetComponent("UIInput")
	self.excInfo = trans:Find("Content 3/ExchangeCode/infoLabel"):GetComponent("UILabel")
	self.GiftListView = trans:Find("Content 3/ExchangeCode/giftList").gameObject
	self.giftGrid = self.GiftListView.transform:Find("giftGrid")
	self.giftPre = self.GiftListView.transform:Find("giftPre").gameObject
	for i=1, 8 do -- 生成礼物item池
		local go = newobject(self.giftPre)
		go.name = "giftItem" .. i
		go.transform.parent = self.giftGrid
		go.transform.localScale = Vector3.one
	end
	self:SetActive(false)
end

function PlayerSettingView:SetActive(enable)
	self.gameObject:SetActive(enable)
	self.GiftListView:SetActive(false)
	if enable == true then --fjc
		self:RefreshData()
	end
end


-- 选项按钮点击事件
-- function PlayerSettingView:OnBtnClick(buttonName)
-- 	if buttonName == nil then
-- 		return
-- 	end
-- 	for k, v in pairs(self.Btn_View) do
-- 		-- print(tostring(k))
-- 		if k.name == buttonName then
-- 			k:GetComponent("UIButton").normalSprite = "xuanxianganniu_2"
-- 			v:SetActive(true)
-- 		else
-- 			k:GetComponent("UIButton").normalSprite = "xuanxianganniu"
-- 			v:SetActive(false)
-- 		end
-- 	end
-- end

-- 确定兑换
function PlayerSettingView:OnExchangeGift()
	if self.exchangeCodeInput.value == "" then
		warn("输入的兑换码为空！")
		return
	end
	self.management:SendExchangeGift(self.exchangeCodeInput.value)
end

-- 兑换结果处理
function PlayerSettingView:OnExchangeResult(gifttab)
	local i = 0
	if gifttab.coins ~= nil then -- 金币
		self.giftGrid:GetChild(i).gameObject:SetActive(true)
		self.giftGrid:GetChild(i):Find("num"):GetComponent("UILabel").text = "金币\n" .. tostring(gifttab.coins)
		i = i + 1
	end
	if gifttab.diamond ~= nil then -- 钻石
		self.giftGrid:GetChild(i).gameObject:SetActive(true)
		self.giftGrid:GetChild(i):Find("num"):GetComponent("UILabel").text = "钻石\n" .. tostring(gifttab.diamond)
		i = i + 1
	end
	if gifttab.strength ~= nil then -- 体力
		self.giftGrid:GetChild(i).gameObject:SetActive(true)
		self.giftGrid:GetChild(i):Find("num"):GetComponent("UILabel").text = "体力\n" .. tostring(gifttab.strength)
		i = i + 1
	end
	if gifttab.pet_info ~= nil then -- 宠物／坐骑
		self.giftGrid:GetChild(i).gameObject:SetActive(true)
		self.giftGrid:GetChild(i):Find("num"):GetComponent("UILabel").text = "宠物\n" .. tostring(gifttab.pet_info)
		i = i + 1
	end
	if gifttab.bin_equips ~= nil then -- 装备
		self.giftGrid:GetChild(i).gameObject:SetActive(true)
		self.giftGrid:GetChild(i):Find("num"):GetComponent("UILabel").text = "装备\n" .. tostring(gifttab.bin_equips)
		i = i + 1
	end
	for j = i, 8-1 do
		self.giftGrid:GetChild(j).gameObject:SetActive(false)
	end
	--self.GiftListView:SetActive(true)
	-- self.giftGrid:GetComponent("UIGrid"):Reposition()
	self.exchangeCodeInput.value = ""

end

-- 确认礼品按钮
function PlayerSettingView:OnGetGiftOk()
	self.GiftListView:SetActive(false)
end

-- 调节音量
function PlayerSettingView:OnSetSound()
	--print("背景音：" .. self.backSound.value)
	--print("特效音：" .. self.effectSound.value)
	TxtFactory:getTable(TxtFactory.SoundManagement):SetEffectVolume(self.effectSound.value)
	TxtFactory:getTable(TxtFactory.SoundManagement):SetSoundVolume(self.backSound.value)
	-- MusicManager.volume = self.backSound.value
end

-- 其他开关设置
function PlayerSettingView:OnSwitchBtn(buttonName)
	local fun = function (trans, state)
		trans:GetChild(0).gameObject:SetActive(state)
		trans:GetChild(1).gameObject:SetActive(not state)
	end
	if buttonName == self.setStrBtn.gameObject.name then
		self.setStrState = not self.setStrState
		fun(self.setStrBtn, self.setStrState)
	elseif buttonName == self.setModelBtn.gameObject.name then
		self.setModelState = not self.setModelState
		fun(self.setModelBtn, self.setModelState)
	elseif buttonName == self.setShowBtn.gameObject.name then
		self.setShowState = not self.setShowState
		fun(self.setShowBtn, self.setShowState)
	end
end

--刷新界面fjc
function PlayerSettingView:RefreshData()
	local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	local iconId = UserInfo[TxtFactory.USER_ICON]
	if self.charIconTxt:GetLineByID(iconId) ~= nil then
    	self.PlayerIconSprite.spriteName = self.charIconTxt:GetData(iconId,"ICON")
    end
end

