--[[
author:gaofei
天梯主界面(用于管理天梯其他所有的小界面)
]]

require "game/scene/logic/Ladder/LadderGradingView"
require "game/scene/logic/snatch/SnatchExplainView"
require "game/scene/logic/Ladder/LadderTopInfoView"
require "game/scene/logic/Ladder/LadderSeekView"
require "game/scene/logic/Ladder/LadderManagement"
require "game/scene/logic/Ladder/LadderRankView"
require "game/scene/logic/Ladder/LadderPromotedView"
require "game/scene/logic/Ladder/LadderRankingRewardView"
require "game/scene/logic/snatch/SnatchStoreView"
require "game/scene/logic/store/StoreManagement"	--商城数据类


LadderMainView = class()

LadderMainView.scene = nil --对应场景

LadderMainView.ladderManagement = nil -- 数据管理类
LadderMainView.ladderGradingView = nil -- 定级赛界面
LadderMainView.ladderExplainView = nil -- 天梯说明界面
LadderMainView.ladderRankView = nil -- 天梯排行榜界面
LadderMainView.ladderTopInfoView = nil  -- 天梯顶部信息界面
LadderMainView.ladderSeekView = nil  -- 天梯等级列表界面
LadderMainView.ladderPromotedView = nil  -- 天梯晋级界面
LadderMainView.ladderRankingRewardView = nil  -- 天梯奖励界面
LadderMainView.ladderStoreView = nil  -- 天梯奖励界面


function LadderMainView:Awake(targetScene)

	self.scene = targetScene
	
	self.ladderManagement = LadderManagement.new()
	self.ladderManagement:Awake(self)
	
	self.storeManager = StoreManagement.new()
    self.storeManager:Awake(self.scene)
	
end

-- 初始化界面
function LadderMainView:InitView()

	local ladderInfo = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO)
	if ladderInfo.level == 0 then
		-- 新手(进入定级赛界面)
		self:OpenLadderGradingView()
	else
		-- 进入排行界面
		self:OpenLadderRankView()
	end
	
	
end

-- 发送获取基础信息命令
function LadderMainView:SendLadderBaseInfoMsg()
	self.ladderManagement:SendLadderInfoRequest()
end


--------------------------------------------------  天梯定级赛界面  ---------------------------------------------------
function LadderMainView:OpenLadderGradingView()
	if self.ladderGradingView == nil then
		self.ladderGradingView = LadderGradingView.new()
		self.ladderGradingView:Awake(self)
		self.ladderGradingView:InitData()
		
	end
	self.ladderGradingView:ShowView()
	-- 同时打开顶部信息界面
	self:OpenLadderTopInfoView()
end


--------------------------------------------------  天梯排行榜界面  ---------------------------------------------------
function LadderMainView:OpenLadderRankView()
	if self.ladderRankView == nil then
		self.ladderRankView = LadderRankView.new()
		self.ladderRankView:Awake(self)
		self.ladderRankView:InitData()
	end
	self.ladderRankView:SetLadderRedPointActive()
	self.ladderRankView:ShowView()
	-- 请求排行列表
	self.ladderRankView:RequestRankList()
	self:OpenLadderTopInfoView()
end

------------------------------------------------   天梯顶部信息界面  ------------------------------------------------
function LadderMainView:OpenLadderTopInfoView()
	if self.ladderTopInfoView == nil then
		self.ladderTopInfoView = LadderTopInfoView.new()
		self.ladderTopInfoView:Awake(self)
		-- 设置监听
		--self.ladderTopInfoView:BoundButtonEvents(self.scene)
	end	
	
	self.ladderTopInfoView:InitData()
	self.ladderTopInfoView:ShowView()
end


--------------------------------------------------  天梯等级列表界面  ----------------------------------------------
function LadderMainView:OpenLadderSeekView()
	if self.ladderSeekView == nil then
		self.ladderSeekView = LadderSeekView.new()
		self.ladderSeekView:Awake(self)
		self.ladderSeekView:InitData()
	end
	self.ladderSeekView:ShowView()
end

--------------------------------------------------  天梯晋级界面  ---------------------------------------------------
function LadderMainView:OpenLadderPromotedView()
	if self.ladderPromotedView == nil then
		self.ladderPromotedView = LadderPromotedView:new()
		self.ladderPromotedView:Awake(self)
		self.ladderPromotedView:InitData()
	end
	
	self.ladderPromotedView:ShowView()
end
--------------------------------------------------  天梯奖励界面  ---------------------------------------------------
function LadderMainView:OpenLadderRankingRewardView()
	if self.ladderRankingRewardView == nil then
		self.ladderRankingRewardView = LadderRankingRewardView:new()
		self.ladderRankingRewardView:Awake(self)
		self.ladderRankingRewardView:InitData()
	end
	self.ladderRankingRewardView:ShowView()
end


--------------------------------------------------   天梯说明界面  ---------------------------------------------------
function LadderMainView:OpenLadderExplainView()
	if self.ladderExplainView == nil then
		self.ladderExplainView = SnatchExplainView.new()
		self.ladderExplainView:init(self.scene)
		self.ladderExplainView:InitData("1002002")
	end
	self.ladderExplainView:ShowView()
end

--------------------------------------------------   天梯商城界面  ---------------------------------------------------
function LadderMainView:OpenLadderStoreView()
	if self.ladderStoreView == nil then
		self.ladderStoreView = SnatchStoreView.new()
		self.scene.ladderStoreView = self.ladderStoreView
		self.ladderStoreView:init(self.scene)
		--self.snatchStoreView:InitData()
		self.ladderStoreView:SetStoreType(11)
		--printf("gaofei"..tostring(self.storeManager))
		self.ladderStoreView:SetStoreMangement(self.storeManager)
		self.ladderStoreView:checkSend()
		self.ladderStoreView:BoundButtonEvents()
	end
	self.ladderStoreView:ShowView()
end




-------------------------------------------------  按钮点击事件  ------------------------------------------

-- 定级赛按钮(进入无尽模式)
function LadderMainView:LadderGradingBtnOnClick()
	-- 判断钻石是否够
	if not(self.ladderGradingView:IsHaveDiamondAttackGrading()) then
		self.scene:promptWordShow("钻石不足")
		return
	end
	TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,4)
	--self.scene:ChangScene(SceneConfig.endlessScene)
	self.ladderTopInfoView:HiddenView()
	self.ladderGradingView:HiddenView()
	self.scene:OpenEndlessScene()
end

-- 确定段位
function LadderMainView:LadderConfirmBtnOnClick()
	self.ladderManagement:SendLadderLevelConfirmRequest()
end

-- 段位列表界面
function LadderMainView:LadderDanGradingBtnOnClick()
	printf("段位列表界面")
	self:OpenLadderSeekView()
end

-- 段位列表界面关闭按钮
function LadderMainView:LadderSeekCloseBtnOnClick()
	self.ladderSeekView:HiddenView()
end

-- 打开晋级界面
function LadderMainView:LadderRankPromotionBtnOnClick()
	self:OpenLadderPromotedView()
end

-- 晋级按钮
function LadderMainView:LadderPromotedBtnOnClick()
	--printf("晋级按钮")
	if not(self.ladderPromotedView:IsCanPromoted()) then
		self.scene:promptWordShow("达成全部条件才能晋级")
		return
	end
	
	if not(self.ladderPromotedView:IsHavePromotedCount()) then
		self.scene:promptWordShow("晋级次数已用完")
		return
	end
	
	-- 进入晋级赛界面
	TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,6)
	--self.scene:ChangScene(SceneConfig.endlessScene)
	self.ladderTopInfoView:HiddenView()
	self.ladderRankView:HiddenView()
	self.ladderPromotedView:HiddenView()
	self.scene:OpenEndlessScene()
end


-- 关闭晋级界面
function LadderMainView:LadderPromotedCloseBtnOnClick()
	self.ladderPromotedView:HiddenView()
end

-- 打开说明界面
function LadderMainView:LadderRankingExplainBtnOnClick()
	self:OpenLadderExplainView()
end

-- 关闭说明界面
function LadderMainView:LadderExplainCloseBtnOnClick()
	self.ladderExplainView:HiddenView()
end

-- 打开天梯奖励说明界面
function LadderMainView:LadderRankingRewardBtnOnClick()
	self:OpenLadderRankingRewardView()
end

-- 关闭天梯奖励说明界面
function LadderMainView:LadderRankingRewardCloseBtnOnClick()
	self.ladderRankingRewardView:HiddenView()
end

-- 挑战好友
function LadderMainView:LadderRankingItemTiaozhanBtnOnClick(obj)
	-- 判断是否还有挑战次数
	if not(self.ladderRankView:IsHaveChallengeCount()) then
		self.scene:promptWordShow("挑战次数已用完")
		return
	end
	
	--printf("buttonName==="..obj.transform.parent.name)
	TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,5)
	-- 存储需要挑战对象的ID
	TxtFactory:setValue(TxtFactory.LadderInfo,TxtFactory.LADDER_RIVAL_MEMBERID,tonumber(obj.transform.parent.name))
	--self.scene:ChangScene(SceneConfig.endlessScene)
	self.ladderTopInfoView:HiddenView()
	self.ladderRankView:HiddenView()
	self.scene:OpenEndlessScene()
end

-- 打开商城界面
function LadderMainView:LadderRankingShopBtnOnClick()
	self:OpenLadderStoreView()
end

-- 返回主界面
function LadderMainView:LadderCloseBtnOnClick()
	if self.ladderGradingView ~= nil then
		self.ladderGradingView:HiddenView()
	end
	if self.ladderRankView ~= nil then
		self.ladderRankView:HiddenView()
	end
	self.ladderTopInfoView:HiddenView()
end


