--[[
author:gaofei
定级赛界面
]]
LadderGradingView = class()

LadderGradingView.scene = nil --对应场景
LadderGradingView.panel = nil -- 定级赛界面

function LadderGradingView:Awake(targetScene)

	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Ladder/LadderMainUI"))
	self.panel.transform.parent = targetScene.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one 
	self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	
	self.gameConfigTXT = TxtFactory:getTable(TxtFactory.GameConfigTXT)
	-- 最高分
	self.maxScore = self.panel.transform:Find("Anchors/ScoreInfo/MaxScore"):GetComponent("UILabel")
	-- 挑战需要花的钱
	self.priceLabel = self.panel.transform:Find("Anchors/Btns/LadderMain_BtnGrading/priceIcon/priceLabel"):GetComponent("UILabel")
	-- 当前段位preb的父节点
	self.curLadderLevelItemParent = self.panel.transform:Find("Anchors/LadderLevelItemParent")
	-- 确定段位按钮(积分为0隐藏)
	self.ladderMain_BtnConfirm = self.panel.transform:Find("Anchors/Btns/LadderMain_BtnConfirm 1")
	-- 描述
	self.descLabel = self.panel.transform:Find("Anchors/ScoreInfo/Label"):GetComponent("UILabel")
	targetScene.scene:boundButtonEvents(self.panel)
	
	--self:HiddenView()
end

-- 初始化界面数据
function LadderGradingView:InitData()
	--local ladderInfo = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO)
	self.ladderInfo = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO)
	self.maxScore.text = self.ladderInfo.max_score
	
	
	self.priceLabel.text = self:GetGradingPrice()
	
	-- 新手(隐藏确定段位按钮)
	self.ladderMain_BtnConfirm.gameObject:SetActive(self.ladderInfo.max_score ~= 0)
	-- 加载自己的当前人物
	self.modelShow = ModelShow.new()
    self.modelShow:Init(self)
    self.modelShow:ChooseCharacter(self.UserInfo[TxtFactory.USER_SEX])
    self.modelShow:petShow()
	
	-- 创建自己当前的天梯等级
	local ladderLevel = self.scene.ladderManagement:GetDanGradingLevelByLadderScore()
	
	-- 暂时隐藏
	self.descLabel.text = ""
	--local desc = ""
	--[[
	if self.ladderInfo.max_score == 0 then
		-- 新手
		self.descLabel.text = "通过定级赛确定您的实力，匹配最适合您的对手."
	else
		self.descLabel.text = "您已击败全服51%的对手."
	end
	]]--
	local ladderData = TxtFactory:getTable(TxtFactory.LadderConfigTXT)
	self.scene.ladderManagement:CreateLadderLevelItem(self.curLadderLevelItemParent,ladderLevel,1,ladderData)
	
end


-- 获取到定位赛需要消耗的钻石
function LadderGradingView:GetGradingPrice()
	self.priceData = lua_string_split(self.gameConfigTXT:GetData(1001,"CONFIG3"), ";")
	local price = 0
	if self.ladderInfo.init_num +1 > #self.priceData then
		price = self.priceData[#self.priceData]
	else
		price = self.priceData[self.ladderInfo.init_num +1]
	end
	return tonumber(price)
end

-- 判断钻石是否够定位赛消耗
function LadderGradingView:IsHaveDiamondAttackGrading()
	if  tonumber(self.UserInfo[TxtFactory.USER_DIAMOND]) >= self:GetGradingPrice() then
		return true
	end
	return false
end

--激活暂停界面
function LadderGradingView:ShowView()
	self.panel:SetActive(true)
	self.modelShow:ChooseCharacter(self.UserInfo[TxtFactory.USER_SEX])
    self.modelShow:petShow()
end

-- 冷藏界面
function LadderGradingView:HiddenView()
	self.panel:SetActive(false)
	self.modelShow:SetActive(false)
end
