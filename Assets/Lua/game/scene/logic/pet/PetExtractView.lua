--[[
author:Huqiuxiang
萌宠抽取功能逻辑
]]

PetExtractView = class ()

PetExtractView.scene = nil --场景scene
PetExtractView.management = nil -- 数据model
PetExtractView.sceneTarget = nil 
PetExtractView.panel = nil -- 面板
PetExtractView.animPanel = nil -- 动画播放面板
PetExtractView.lotteryTXT = nil -- 抽奖配置
PetExtractView.UserInfo = nil

PetExtractView.infoRoot = nil -- 
PetExtractView.coinbtn = nil -- 金币按钮
PetExtractView.diamondbtn = nil -- 钻石按钮
PetExtractView.piecebtn = nil -- 碎片按钮
PetExtractView.coinPrice = nil
PetExtractView.diamondPrice = nil
PetExtractView.coinFreeLabel = nil -- 金币免费时间文本
PetExtractView.diamondFreeLabel = nil -- 钻石免费时间文本
PetExtractView.petShowPanel = nil -- 模型展示面板
PetExtractView.rewardId = nil 
PetExtractView.pieceLabel = nil -- 萌宠碎片
PetExtractView.piecePrice = nil -- 萌宠碎片价格
PetExtractView.animView = nil -- 动画逻辑类
PetExtractView.state = false -- 是否在抽取状态
PetExtractView.modelShow = nil -- 模型展
PetExtractView.egg_effect = nil -- 宠物蛋动画

-- 初始化
function PetExtractView:init(target)
	self.scene = target
	self.modelShow = self.scene.modelShow
	self.management = self.scene.petManagement
	self.sceneTarget = self.scene.sceneTarget
	self.panel = self.scene:LoadUI("Pet/PetExtractUI")
	self.scene:boundButtonEvents(self.panel)
	self.pieceLabel = self.panel.transform:FindChild("UI/pieceSource/Label"):GetComponent("UILabel")
	self.egg_effect = self.panel.transform:Find("UI/ef_ui_egg_bg")
	SetEffectOrderInLayer(self.egg_effect, 3)
	self.lotteryTXT = TxtFactory:getTable(TxtFactory.LotteryDataTXT)
	self:bottonTargetFind() 
	self:bottonLabelShow() -- 金币价格显示
	self.animView = ExtractUIAnim.new() -- 创建动画类
	self.animView.animType = 1
	self.animView:init(self)
	self.management:getPetPieces() -- 获取碎片
	self:updatePetPieceUI() -- 碎片刷新
	self.scene:SetUiAnChor()


	local PetExtractPetShowUI_close = self.panel.transform:FindChild("UI/left/PetExtractUI_close")
	AddonClick(PetExtractPetShowUI_close,function( ... )
		--GamePrint("petExtractView_closeBtn 11111111111")
		self.scene:petExtractView_closeBtn()
	end)
	self:SetActive(false)
end

function PetExtractView:SetActive(enable)
	self.panel:SetActive(enable)
	if enable then
		coroutine.start(self.SetFreeTime, self)
--[[		local closeBtn = self.panel.transform:FindChild("UI/left/PetExtractUI_close")
		--关闭
		AddonClick(closeBtn,function( ... )
			-- body
			GamePrint("petExtractView_closeBtn 11111111111")
			self.scene:petExtractView_closeBtn()
		end)]]
	end
end

-- 给按钮赋监听obj
function PetExtractView:bottonTargetFind()
	self.coinbtn = self.panel.transform:FindChild("UI/coinExtract/PetExtractUI_coinBtn")
	self.scene:SetButtonTarget(self.coinbtn,self.sceneTarget)
	self.coinFreeLabel = self.panel.transform:Find("UI/coinExtract/time/wordLabel"):GetComponent("UILabel")
	self.diamondbtn = self.panel.transform:FindChild("UI/diamonExtract/PetExtractUI_diamondBtn")
	self.scene:SetButtonTarget(self.diamondbtn,self.sceneTarget)
	self.diamondFreeLabel = self.panel.transform:Find("UI/diamonExtract/time/wordLabel"):GetComponent("UILabel")
	self.piecebtn = self.panel.transform:FindChild("UI/pieceExtract/PetExtractUI_pieceBtn")
	self.scene:SetButtonTarget(self.piecebtn,self.sceneTarget)
	local closeBtn = self.panel.transform:FindChild("UI/left/PetExtractUI_close")
	self.scene:SetButtonTarget(closeBtn,self.sceneTarget)
	self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	-- self:SetFreeTime()

--[[	--关闭
	AddonClick(closeBtn,function( ... )
		-- body
		GamePrint("petExtractView_closeBtn 11111111111")
		self.scene:petExtractView_closeBtn()
	end)]]

	local PetExtractUI_coinBtn = self.panel.transform:FindChild("UI/coinExtract/PetExtractUI_coinBtn")
	AddonClick(PetExtractUI_coinBtn,function( ... ) -- 抽取界面 金币按钮
		-- body
		self.scene:petExtractView_coinBtn()
	end)

	local PetExtractUI_diamondBtn = self.panel.transform:FindChild("UI/diamonExtract/PetExtractUI_diamondBtn")
	AddonClick(PetExtractUI_diamondBtn,function( ... ) -- 抽取界面 钻石按钮
		-- body
		self.scene:petExtractView_diamondBtn()
	end)

	local PetExtractUI_pieceBtn = self.panel.transform:FindChild("UI/pieceExtract/PetExtractUI_pieceBtn")
	AddonClick(PetExtractUI_pieceBtn,function( ... ) -- 抽取界面 碎片按钮
		-- body
		self.scene:petExtractView_pieceBtn()
	end)

end

PetExtractView.coroutine_running = false -- 协程锁
-- 设置免费时间
function PetExtractView:SetFreeTime()
	if self.coroutine_running then return end
	self.coroutine_running = true
	while self.panel.activeSelf do
		local coinFree = self.UserInfo[TxtFactory.USER_LOTT_GOLD]
		local diamondFree = self.UserInfo[TxtFactory.USER_LOTT_DIAMOND]
		local timeNow = os.time()
		if timeNow < coinFree then
			--self.coinFreeLabel.text = "[FF0000]"..(coinFree-timeNow).."[-]s后免费抽取"
			self.coinFreeLabel.text = "[FF0000]"..self:SerializeTime(coinFree-timeNow).."[-]后免费"
		else
			self.coinFreeLabel.text = "免费抽取一次"
		end
		if timeNow < diamondFree then
			--self.diamondFreeLabel.text = "[FF0000]"..(diamondFree-timeNow).."[-]s后免费抽取"
			self.diamondFreeLabel.text = "[FF0000]"..self:SerializeTime(diamondFree-timeNow).."[-]后免费"
		else
			self.diamondFreeLabel.text = "免费抽取一次"
		end
		local boolCoinFree = timeNow > coinFree -- 金币是否免费
		local boolDiamondFree = timeNow > diamondFree -- 钻石是否免费
		self:setButtonState(boolCoinFree, boolDiamondFree)
		if boolCoinFree and boolDiamondFree then
			break
		end
		coroutine.wait(1)
	end
	self.coroutine_running = false
end

function PetExtractView:SerializeTime(time)
	local hour = 0
	local minutes = 0
	local seconds = 0
    local hour,minutes = math.modf(time/3600)
	minutes = time - hour*3600
	minutes,seconds = math.modf(minutes/60)
	seconds = time - minutes*60-hour*3600
	if hour < 10 then
		hour = "0"..hour
	end
    if minutes < 10 then
        minutes = "0"..minutes
    end
    if seconds < 10 then
        seconds = "0"..seconds
    end
    return hour..":"..minutes..":"..seconds
end

-- 设置按钮免费
function PetExtractView:setButtonState(boolCoinFree, boolDiamondFree)
	local coinLabel = self.coinbtn.transform:FindChild("Label") -- 找到金币按钮label
	local diamondLabel = self.diamondbtn.transform:FindChild("Label") -- 找到钻石按钮label
	coinLabel.gameObject:SetActive(not boolCoinFree)
	diamondLabel.gameObject:SetActive(not boolDiamondFree)
	local coinFree = self.coinbtn.transform:FindChild("free") -- 找到金币按钮label
	local diamondFree = self.diamondbtn.transform:FindChild("free") -- 找到钻石按钮label
	coinFree.gameObject:SetActive(boolCoinFree)
	diamondFree.gameObject:SetActive(boolDiamondFree)
end

-- 文字显示
function PetExtractView:bottonLabelShow()
	local coinLabel = self.coinbtn.gameObject.transform:FindChild("Label"):GetComponent("UILabel") -- 找到金币按钮label
	local diamondLabel = self.diamondbtn.gameObject.transform:FindChild("Label"):GetComponent("UILabel") -- 找到钻石按钮label
	local pieceLabel = self.piecebtn.gameObject.transform:FindChild("Label"):GetComponent("UILabel") -- 找到碎片按钮label
	local coinId = self.lotteryTXT:GetFixedIdByFeatureName("coinoneRewardByPet") -- 奖池id
	self.coinPrice = tonumber(self.lotteryTXT:GetData(coinId,"GOLD_PRICE")) -- 配置表价格
	local diamondId = self.lotteryTXT:GetFixedIdByFeatureName("diamondoneRewardByPet") -- 奖池id
	self.diamondPrice = tonumber(self.lotteryTXT:GetData(diamondId,"DIAMOND_PRICE")) -- 配置表价格
	coinLabel.text =  self.coinPrice -- 显示金币价格
	diamondLabel.text = self.diamondPrice -- 显示钻石价格
	-- local pieceId = 100106
	-- self.diamondPrice = tonumber(self.lotteryTXT:GetData(coinId,"DIAMOND_PRICE")) 
	local ticket = self.lotteryTXT:GetData(self.lotteryTXT:GetFixedIdByFeatureName("priceReward"),"TICKET") -- 配置碎片属性
	-- print("ticket: "..ticket)
	local idTabd = string.gsub(ticket,'"',"") -- 去引号
    local array = lua_string_split(tostring(idTabd),",") 
    local num = tonumber(array[2]) -- 碎片数量
    self.piecePrice = num 
    pieceLabel.text = num
end

-- 金币抽取按钮
function PetExtractView:coinBtn()
	-- print("金币抽取")
	--GamePrint("111111111111111111111")
	if self.state == true then
		return
	end
	--GamePrint("22222222222222222")
	local id = self.lotteryTXT:GetFixedIdByFeatureName("coinoneRewardByPet") -- 奖池id
	local l_type = 2 -- 1免费 2金币抽取 3钻石抽取 4碎片抽取 （以废弃）
	local l_id = self.lotteryTXT:GetData(id,"LOTTERY_TYPE") -- 奖池类型
	local l_diamond = 0

	-- 是否有钱 判断
	local isFree = self.management:isCoinFree()
	if isFree == false then
		local flag = self.scene:coinPriceCheck(self.coinPrice)
		if not flag then return end
	end
	self.management:sendPetLettory(l_type,tonumber(l_id),self.coinPrice,l_diamond) -- 发送协议
	self.state = true
end

-- 钻石抽取按钮
function PetExtractView:diamondBtn()
	-- print("钻石抽取")
	if self.state == true then
		return
	end
	local id = self.lotteryTXT:GetFixedIdByFeatureName("diamondoneRewardByPet") -- 奖池id
	local l_type = 3 -- 1免费 2金币抽取 3钻石抽取 4碎片抽取 （以废弃）
	local l_id = self.lotteryTXT:GetData(id,"LOTTERY_TYPE") -- 奖池类型
	local l_coin = 0

	-- 是否有钱 判断
	local isFree = self.management:isDiamondFree()
	if isFree == false then
		local flag = self.scene:diamondPriceCheck(self.diamondPrice)
		if not flag then return end
	end

	self.management:sendPetLettory(l_type,tonumber(l_id),tonumber(l_coin),self.diamondPrice) -- 发送协议
	self.state = true
end

 -- 碎片抽取
function PetExtractView:pieceBtn()
	if self.state == true then
		return
	end
	local id = self.lotteryTXT:GetFixedIdByFeatureName("priceRewardByPet")  -- 奖池id
	local l_type = 4 -- 1免费 2金币抽取 3钻石抽取 4碎片抽取 （以废弃）
	local l_id = self.lotteryTXT:GetData(id,"LOTTERY_TYPE") -- 奖池类型
	local l_coin = 0
	local l_diamond = 0

	-- 是否有碎片 判断
	local flag = self:pieceCheck()
	if flag == false then
		return
	end

	self.management:sendPetLettory(l_type,tonumber(l_id),tonumber(l_coin),tonumber(l_diamond)) -- 发送协议
	self.state = true
end

-- 免费抽
function PetExtractView:freeDropCheck()
	
end

-- 萌宠抽取动画 单抽
function PetExtractView:creatPetExtractAnim(gold,diamond,equips,items,pets)
		--Okbtn
	if self.animView ~= nil then
		local OkBtn = self.animView:getOkBtn()
		AddonClick(OkBtn,function( ... )
			-- body
			self.scene:petExtractView_rewardItemOkBtn()
		end)
	end
	if pets ~= nil then
		local id = pets[1].id
		self.rewardId = id
		self.animView.extractType = 1 -- 抽取类型 判断单抽 十连抽  1 为单抽 10 为十连抽
		local root = self.animView:getItemRoot() --
	
		-- 生成单个item
		local tid = pets[1].tid
		local icon = self.scene:creatPetIcon(tid,root,self.sceneTarget)
		icon.transform.localPosition = Vector3.zero
		icon.name = id
		icon:SetActive(false)
		local infoBtn = icon.transform:FindChild("petIconInfoBtn")
		infoBtn.gameObject:SetActive(false)
		local mountTxt = TxtFactory:getTable(TxtFactory.MountTXT) -- 宠物信息表
		local petid = mountTxt:GetData(tid, TxtFactory.S_MOUNT_TYPE)
		
		self.animView:ShowPetOrShowItem(true)
		self.modelShow:ChoosePet(petid, Vector3(1.3, 1.3, 1.3),true)
		self:SetActive(false)
		-- 播放动画
		self.animView:startAnim(function (animView) animView:ShowRewardModel(true) end,true)
		return
	end
	if gold ~= nil and gold > 0 then
		-- 播放动画
		
		self.animView:ShowPetOrShowItem(false)
		
		self:SetActive(false)
		self.animView:startAnim(function (animView) animView:ShowRewardModel(true) end)
		self.animView:ShowItem("GiftIcon","jinbi",gold)
		return
	end
	
	if diamond ~= nil and diamond > 0 then
		-- 播放动画
		
		self.animView:ShowPetOrShowItem(false)
		
		self:SetActive(false)
		self.animView:startAnim(function (animView) animView:ShowRewardModel(true) end)
		self.animView:ShowItem("GiftIcon","zuanshi",diamond)
		return
	end
	if items ~= nil then
		local materialData  = TxtFactory:getTable(TxtFactory.MaterialTXT)
		local iconName,atlasName = materialData:GetItemIconById(items[1].tid)
		self.animView:ShowPetOrShowItem(false)
		
		self:SetActive(false)
		self.animView:startAnim(function (animView) animView:ShowRewardModel(true) end)
		self.animView:ShowItem(atlasName,iconName,items[1].add_num)
		return
	end
	if equips ~= nil then
		local equipData = TxtFactory:getTable(TxtFactory.EquipTXT)
		local iconName,atlasName = equipData:GetItemIconById(equips[1].tid)
		self.animView:ShowPetOrShowItem(false)
		
		self:SetActive(false)
		self.animView:startAnim(function (animView) animView:ShowRewardModel(true) end)
		self.animView:ShowItem(atlasName,iconName,1)
		return
	end
	--gold,diamond,equips,items,pets

end

function PetExtractView:creatPetExtractAnim_ten(gold,diamond,equips,items,pets)
		--Okbtn
	local OkBtn = self.animView:getOkBtn()
	AddonClick(OkBtn,function( ... )
		-- body
		self.scene:petExtractView_rewardItemOkBtn()
	end)


end


-- 萌宠获得确定按钮
function PetExtractView:rewardItemOkBtn()
	self.animView:okBtn()
	self:SetActive(true) -- 显示当前面板
	self.state = false
	self:updatePetPieceUI() -- 更新碎片ui 
end

-- 刷新碎片UI
function PetExtractView:updatePetPieceUI()
	local material = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo) -- 背包内存表数据
	local pieceNum = material[TxtFactory.ITEMS_PETPIECE] -- 碎片对应数据
	self.pieceLabel.text =  pieceNum.num -- 碎片数量显示
end

-- 碎片检查
function PetExtractView:pieceCheck()
	local flag = nil
	local material = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo) -- 背包内存表数据
	local piece = material[TxtFactory.ITEMS_PETPIECE] -- 碎片对应数据

	if self.piecePrice > piece.num then -- 抽取需要的数量大于碎片当前拥有碎片的数量 判断
		local word = " 碎片不足,可前往剧情模式获得"
        self.scene:promptWordShow(word)
        flag = false
        return flag
    else 
    	flag = true
        return flag
	end
end


-- 时间刷新
function PetExtractView:extractTimeUpdate()
	
	
end