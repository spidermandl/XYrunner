--[[
author:gaofei
异步PVP
]]

AsyncPvpView = class ()

AsyncPvpView.scene = nil --场景scene
AsyncPvpView.panel = nil -- 界面

AsyncPvpView.use_gold = nil -- 需要消耗的金币数量
AsyncPvpView.use_diamond = nil -- 需要消耗的钻石数量


-- 初始化
function AsyncPvpView:init(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/AsyncPvp/AsyncPvpView"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
    --self.scene:boundButtonEvents(self.panel)
	self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo) 
	local textsConfigTXT =  TxtFactory:getTable(TxtFactory.TextsConfigTXT) 
	local gameConfigTXT = TxtFactory:getTable(TxtFactory.GameConfigTXT)
	local info_label = self.panel.transform:Find("Anchors/UI/Info/Label"):GetComponent("UILabel")
	info_label.text = textsConfigTXT:GetText(1010)
	
	-- 金币静态数据
	local gold_title_label = self.panel.transform:Find("Anchors/UI/Gold/Label"):GetComponent("UILabel")
	gold_title_label.text = textsConfigTXT:GetText(1011)
	local gold_reward_gold_label = self.panel.transform:Find("Anchors/UI/Gold/Label 1"):GetComponent("UILabel")
	gold_reward_gold_label.text = textsConfigTXT:GetText(1013)
	local gold_reward_intrgtal_label = self.panel.transform:Find("Anchors/UI/Gold/Label 2"):GetComponent("UILabel")
	gold_reward_intrgtal_label.text = textsConfigTXT:GetText(1014)
	self.use_gold = tonumber(gameConfigTXT:GetData(1009,"CONFIG1"))
	local gold_reward_gold_count_label = self.panel.transform:Find("Anchors/UI/Gold/Reward_Gold/Label"):GetComponent("UILabel")
	gold_reward_gold_count_label.text = gameConfigTXT:GetData(1009,"CONFIG2")
	local gold_reward_intrgtal_count_label = self.panel.transform:Find("Anchors/UI/Gold/Reward_Integral/Label"):GetComponent("UILabel")
	gold_reward_intrgtal_count_label.text = gameConfigTXT:GetData(1009,"CONFIG3")
	local gold_entrance_fee_count_label = self.panel.transform:Find("Anchors/UI/Gold/Entrance_Fee/Label"):GetComponent("UILabel")
	gold_entrance_fee_count_label.text = self.use_gold
	-- 钻石静态数据
	local diamond_title_label = self.panel.transform:Find("Anchors/UI/Diamond/Label"):GetComponent("UILabel")
	diamond_title_label.text = textsConfigTXT:GetText(1012)
	local diamond_reward_diamond_label = self.panel.transform:Find("Anchors/UI/Diamond/Label 1"):GetComponent("UILabel")
	diamond_reward_diamond_label.text = textsConfigTXT:GetText(1013)
	local diamond_reward_intrgtal_label = self.panel.transform:Find("Anchors/UI/Diamond/Label 2"):GetComponent("UILabel")
	diamond_reward_intrgtal_label.text = textsConfigTXT:GetText(1014)
	self.use_diamond = tonumber(gameConfigTXT:GetData(1010,"CONFIG1"))
	local diamond_reward_diamond_count_label = self.panel.transform:Find("Anchors/UI/Diamond/Reward_Dismond/Label"):GetComponent("UILabel")
	diamond_reward_diamond_count_label.text = gameConfigTXT:GetData(1010,"CONFIG2")
	local diamond_reward_intrgtal_count_label = self.panel.transform:Find("Anchors/UI/Diamond/Reward_Integral/Label"):GetComponent("UILabel")
	diamond_reward_intrgtal_count_label.text = gameConfigTXT:GetData(1010,"CONFIG3")
	local diamond_entrance_fee_count_label = self.panel.transform:Find("Anchors/UI/Diamond/Entrance_Fee/Label"):GetComponent("UILabel")
	diamond_entrance_fee_count_label.text = gameConfigTXT:GetData(1010,"CONFIG1")
	-- 金币入场
	local gold_entrance_btn = self.panel.transform:Find("Anchors/UI/Gold/Gold_Entrance_Btn")
	local gold_entrance_btn_Listener= gold_entrance_btn:GetComponent("UIEventListener")
	if gold_entrance_btn_Listener == nil then
		gold_entrance_btn_Listener = gold_entrance_btn.gameObject:AddComponent(UIEventListener.GetClassType())
	end
	gold_entrance_btn_Listener.onClick = function( ... )
		--self:HiddenView()
		print("金币入场")
		if tonumber(self.UserInfo[TxtFactory.USER_GOLD]) < self.use_gold then
			-- 金币不足
			self.scene:promptWordShow("金币不足")
			return
		end
		self:OpenEndlessScene(7)
	end
	-- 钻石入场
	local diamond_entrance_btn = self.panel.transform:Find("Anchors/UI/Diamond/Diamond_Entrance_Btn")
	local diamond_entrance_btn_Listener= diamond_entrance_btn:GetComponent("UIEventListener")
	if diamond_entrance_btn_Listener == nil then
		diamond_entrance_btn_Listener = diamond_entrance_btn.gameObject:AddComponent(UIEventListener.GetClassType())
	end
	diamond_entrance_btn_Listener.onClick = function( ... )
		print("钻石入场")
		if tonumber(self.UserInfo[TxtFactory.USER_DIAMOND]) < self.use_diamond then
			-- 钻石不足
			--self.scene:promptWordShow("钻石不足")
			self.scene:OpenGotoStoreView("钻石不足,是否需要前往商城购买!",4)
			return
		end
		self:OpenEndlessScene(8)
	end
	-- 商城
	
	-- 关闭
	local backBtn = self.panel.transform:Find("Anchors/UI/AsyncPvpView_BackBtn")
	local backBtn_Listener= backBtn:GetComponent("UIEventListener")
	if backBtn_Listener == nil then
		backBtn_Listener = backBtn.gameObject:AddComponent(UIEventListener.GetClassType())
	end
	backBtn_Listener.onClick = function( ... )
		self:HiddenView()
	end
end

-- 进入无尽界面  
function AsyncPvpView:OpenEndlessScene(battleType)
	-- 判断体力是否够
	if tonumber(self.UserInfo[TxtFactory.USER_STRENGTH])<1 then
		self.scene:promptWordShow("体力不足")
	end
	self:HiddenView()
	TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,battleType)
	self.scene:OpenEndlessScene()
end


--激活界面
function AsyncPvpView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function AsyncPvpView:HiddenView()
	self.panel:SetActive(false)
end

