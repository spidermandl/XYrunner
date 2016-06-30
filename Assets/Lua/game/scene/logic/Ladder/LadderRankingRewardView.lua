--[[
author:gaofei
天梯排行奖励信息
]]

LadderRankingRewardView = class()
LadderRankingRewardView.scene = nil --对应场景
LadderRankingRewardView.panel = nil -- 界面preb

function LadderRankingRewardView:Awake(targetScene)
	
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Ladder/LadderRankingRewardUI"))
	self.panel.transform.parent = targetScene.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one 
	self.ladderRewardTXT = TxtFactory:getTable(TxtFactory.LadderRewardConfigTXT) -- 天梯奖励表
	self.ladderInfo = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO)
	targetScene.scene:boundButtonEvents(self.panel)
end

-- 初始化界面数据
function LadderRankingRewardView:InitData()
	
	-- 代码测试
	local rewardIndex = self:GetRewardIndex()
	printf("rewardIndex"..rewardIndex)
	local day_reward = lua_string_split(self.ladderRewardTXT:GetData(1,"GROUP"..self.ladderInfo.level.."_DAY"),",")
	local week_reward = lua_string_split(self.ladderRewardTXT:GetData(1,"GROUP"..self.ladderInfo.level.."_WEEK"),",")
	--printf("count ==="..#week_reward)
	local dayPrizeParent =  self.panel.transform:Find("DayPrize/Table")
	local weekPrizeParent =  self.panel.transform:Find("WeekPrize/Table")
	
	self:CreateRewardItem(dayPrizeParent,day_reward)
	
	self:CreateRewardItem(weekPrizeParent,week_reward)
	
end

-- 创建掉落物品
function LadderRankingRewardView:CreateRewardItem(rewardParentObj,rewards)
	
	local   materialTabel = TxtFactory:getTable("MaterialTXT")  -- 材料表
	
	for j = 1,#rewards do
		local rewardObj  = newobject(Util.LoadPrefab("UI/Snatch/RewardItem"))
		local strs = lua_string_split(rewards[j],"=")
		rewardObj.transform:Find("Label"):GetComponent("UILabel").text = strs[2]
		rewardObj.transform:Find("Icon"):GetComponent("UISprite").spriteName = materialTabel:GetData(strs[1],"MATERIAL_ICON")
		rewardObj.transform.parent = rewardParentObj.transform
		rewardObj.transform.localPosition = Vector3.zero
		rewardObj.transform.localScale = Vector3.one * 0.8
	end
	local itemTable = rewardParentObj:GetComponent("UITable")
	itemTable:Reposition()
	itemTable.repositionNow = true
end

-- 获取到当前的奖励下表
function LadderRankingRewardView:GetRewardIndex()
	
	 for i = 1 ,self.ladderRewardTXT:GetLineNum() do
	 	local min_level = tonumber(self.ladderRewardTXT:GetData(i,"RANK_MIN"))
		local max_level = tonumber(self.ladderRewardTXT:GetData(i,"RANK_MAX"))
		if self.ladderInfo.rank <= max_level and self.ladderInfo.rank >= min_level then
			return i
		end
	 end
end

--激活暂停界面
function LadderRankingRewardView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function LadderRankingRewardView:HiddenView()
	self.panel:SetActive(false)
end


 