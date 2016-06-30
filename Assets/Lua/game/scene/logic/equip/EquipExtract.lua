--[[
author : Huqiuxiang
抽取物品装备界面
]]

EquipExtract = class()

EquipExtract._name = "EquipExtract"
EquipExtract.scene = nil --场景scene
EquipExtract.management = nil -- 数据model

EquipExtract.coin = nil
EquipExtract.diamond = nil 

EquipExtract.extractEquipPanel = nil -- 界面obj
EquipExtract.LotteryDataTXT = nil -- 抽奖配置

EquipExtract.animView = nil -- 动画逻辑类
EquipExtract.UserInfo = nil -- 人物动态表
EquipExtract.state = false -- 抽取状态


-- 创建界面
function EquipExtract:init(target)
	self.scene = target
	self.sceneTarget = target.sceneTarget
	self.extractEquipPanel = self.scene:LoadUI("Equip/EquipExtractUI")  -- 创建界面
	self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	self.management = self.scene.EquipManagement
	self.LotteryDataTXT = TxtFactory:getTable(TxtFactory.LotteryDataTXT)
	self:priceShow()
	self.animView = ExtractUIAnim.new() -- 创建动画类
	self.animView:init(self)
	self.scene:SetUiAnChor()
    self.scene:boundButtonEvents(self.extractEquipPanel)


end

function EquipExtract:SetActive(enable)
    self.extractEquipPanel:SetActive(enable)
end

function EquipExtract:Update()
	self.animView:iconAnim()
end

-- 按钮显示
function EquipExtract:priceShow()
	local coinOne = self.extractEquipPanel.gameObject.transform:FindChild("UI/gold/EquipExtractUI_goldOne/goldIconOne/count"):GetComponent("UILabel")
	coinOne.text = self.LotteryDataTXT:GetData(self.LotteryDataTXT:GetFixedIdByFeatureName("coinOneByEquip"), "GOLD_PRICE")
	local coinTen = self.extractEquipPanel.gameObject.transform:FindChild("UI/gold/EquipExtractUI_goldTen/goldIconTen/count"):GetComponent("UILabel")
	coinTen.text = self.LotteryDataTXT:GetData(self.LotteryDataTXT:GetFixedIdByFeatureName("coinTenByEquip"), "GOLD_PRICE")
	local diamondOne = self.extractEquipPanel.gameObject.transform:FindChild("UI/diamond/EquipExtractUI_diamondOne/diamondIconOne/count"):GetComponent("UILabel")
	diamondOne.text = self.LotteryDataTXT:GetData(self.LotteryDataTXT:GetFixedIdByFeatureName("diamondOneByEquip"), "DIAMOND_PRICE")
	local diamondTen = self.extractEquipPanel.gameObject.transform:FindChild("UI/diamond/EquipExtractUI_diamondTen/diamondIconTen/count"):GetComponent("UILabel")
	diamondTen.text = self.LotteryDataTXT:GetData(self.LotteryDataTXT:GetFixedIdByFeatureName("diamondTenByEquip"), "DIAMOND_PRICE")
end

--关闭所有窗口，包括装备抽取窗口和装备信息窗口
function EquipExtract:DestroySelf()
    self:extractEquipPanel_closeBtn()
end

-- 关闭按钮
function EquipExtract:extractEquipPanel_closeBtn()
	-- local modelShow = self.scene.modelShow
	-- modelShow:SetActive(true, modelShow.equip)
	self:SetActive(false)
	self.scene.mainView:SetActive(true) -- 打开主界面 
    local modelShow = self.scene.modelShow -- 打开模型展
    modelShow:SetActive(true, modelShow.equip)
end

-- 金币抽一次按钮
function EquipExtract:extractEquipPanel_coinForOneBtn()
	if self.state == true then
		return
	end
	local id = self.LotteryDataTXT:GetFixedIdByFeatureName("coinoneRewardByEquip") -- 奖池金币单抽id
	local coin = tonumber(self.LotteryDataTXT:GetData(id, "GOLD_PRICE")) -- 读配置表获取相应金币价格
	local flag = self.scene:coinPriceCheck(coin) -- 检查当前钱收否购买
	if flag == false then
		return
	end

	local prop_id = tonumber(self.LotteryDataTXT:GetData(id, "LOTTERY_TYPE")) -- 读配置表获取相应奖池类型id
	local diamond = 0
    self.state = self.management:sendEquipExtract(prop_id,coin,diamond,1) -- 发送协议
    
end

-- 金币抽十次按钮
function EquipExtract:extractEquipPanel_coinForTenBtn()
	if self.state == true then
		return
	end
	local id = self.LotteryDataTXT:GetFixedIdByFeatureName("cointenRewardByEquip") -- 奖池金币十连抽id
	local coin = tonumber(self.LotteryDataTXT:GetData(id, "GOLD_PRICE")) -- 读配置表获取相应金币价格
	local flag = self.scene:coinPriceCheck(coin) -- 检查当前钱收否购买
	if flag == false then
		return
	end
	local prop_id = tonumber(self.LotteryDataTXT:GetData(id, "LOTTERY_TYPE")) -- 读配置表获取相应奖池类型id
	local diamond = 0 
    self.state = self.management:sendEquipExtract(prop_id,coin,diamond,10) -- 发送协议
    --self.state = true
end

-- 钻石抽一次按钮
function EquipExtract:extractEquipPanel_diamondForOneBtn()
	if self.state == true then
		return
	end
	local id = self.LotteryDataTXT:GetFixedIdByFeatureName("diamondoneRewardByEquip") -- 奖池钻石单抽id
	local coin = 0
	local diamond = tonumber(self.LotteryDataTXT:GetData(id, "DIAMOND_PRICE")) -- 读配置表获取相应钻石价格
	local flag = self.scene:diamondPriceCheck(diamond) -- 检查当前钱收否购买
	if flag == false then
		return
	end
	local prop_id = tonumber(self.LotteryDataTXT:GetData(id, "LOTTERY_TYPE")) -- 读配置表获取相应奖池类型id
    self.state = self.management:sendEquipExtract(prop_id,coin,diamond,1) -- 发送协议
    --self.state = true
end

-- 钻石抽十次按钮
function EquipExtract:extractEquipPanel_diamondForTenBtn()
	if self.state == true then
		return
	end
	local id = self.LotteryDataTXT:GetFixedIdByFeatureName("diamondtenRewardByEquip") -- 奖池钻石十连抽
	local coin = 0
	local diamond = tonumber(self.LotteryDataTXT:GetData(id, "DIAMOND_PRICE")) -- 读配置表获取相应钻石价格
	local flag = self.scene:diamondPriceCheck(diamond) -- 检查当前钱收否购买
	if flag == false then
		return
	end
	local prop_id = tonumber(self.LotteryDataTXT:GetData(id, "LOTTERY_TYPE"))  -- 读配置表获取相应奖池类型id
    self.state = self.management:sendEquipExtract(prop_id,coin,diamond,10) -- 发送协议
    --self.state = true
end

-- 消息返回 生成物品
--[[function EquipExtract:extractEquipInfoFromSer()
 --    print("更新列表")
	self.scene:updateEquipList()
    self.management.isSendEquipEmail = false
    self.scene.sceneParent:GetMailList()
    self:UpdatePlayerInfo()
end]]

-- 装备抽取动画 单抽
function EquipExtract:creatPetExtractAnim(tab,anType)
	local id = tab.id
	self.rewardId = id
 	local root = self.animView:getItemRoot() -- 获取奖励界面 物品生成root

 	-- 生成item
 	local obj = self.scene:creatVolumeList("icoBack",root,self.extractEquipPanel)
 	obj.gameObject.transform.localPosition = Vector3.zero
 	if obj.transform:FindChild("ef_ui_mc_bg") == nil then
		local effect = newobject(Util.LoadPrefab("Effects/UI/ef_ui_mc_bg"))
		effect.gameObject.name = "ef_ui_mc_bg"
		effect.transform.parent = obj.transform
		effect.transform.localPosition = Vector3.zero
		effect.transform.localScale = Vector3.one
	end

 	self.scene:setIcon(obj,tab.tid)

	self.extractEquipPanel.gameObject:SetActive(false) -- 隐藏当前界面
	-- print("priceType"..priceType)
	self.animView.extractType = 1  -- 动画类型十连抽
	self.animView.animType = anType -- 抽取类型  0 为蛋 1 为宝箱左  2 为宝箱右
	-- print("抽取动画类型"..anType)
	-- 播放动画
	self.animView:startAnim()
end

-- 装备抽取动画 十抽
function EquipExtract:creatPetExtractAnim_ten(tab,anType)
	local root = self.animView:getItemRoot() -- 获取奖励界面 物品生成root

	-- 生成items
	for i = 1, #tab do 
		local obj = self.scene:creatVolumeList("icoBack",root,self.extractEquipPanel)
 		obj.gameObject.transform.localPosition = Vector3.zero
 		self.scene:setIcon(obj,tab[i].tid)
	end

	self.extractEquipPanel.gameObject:SetActive(false) -- 隐藏当前界面
	self.animView.extractType = 10 -- 动画类型十连抽
	self.animView.animType = anType -- 抽取类型  0 为蛋 1 为宝箱左  2 为宝箱右
	-- 播放动画
	self.animView:startAnim() 
end
-- 装备抽取 失败 返回
function EquipExtract:extractEquipInfoErr(errType)

	if errType == 2 then
        self.scene:promptWordShow("当前装备格子已满，无法抽取")
    elseif errType == 3 then
        self.scene:promptWordShow("当前装备格子已满，无法抽取")
    end

	self.state = false
	--[[if  self.management.isSendEquipEmail then
        self.scene:promptWordShow("当前装备格子不足，奖励装备已发送邮件")
    end]]
end

-- 装备获得确定按钮
function EquipExtract:rewardItemOkBtn()
	--self:UpdatePlayerInfo()
	self.animView:okBtn() -- 动画类ok事件
	self.extractEquipPanel.gameObject:SetActive(true) -- 显示当前界面
	self.state = false
	--[[if  self.management.isSendEquipEmail then
        self.scene:promptWordShow("当前装备格子不足，奖励装备已发送邮件")
    end]]
end


