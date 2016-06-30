--[[
author:gaofei
天梯排行界面
]]

LadderRankView = class()
LadderRankView.scene = nil --对应场景
LadderRankView.panel = nil -- 界面preb

LadderRankView.ladderRankItems = nil -- 存放排行榜对象

function LadderRankView:Awake(targetScene)
	
	
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Ladder/LadderRankingUI"))
	self.panel.transform.parent = targetScene.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one 
	self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	self.ladderInfo = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO)
	-- 最大挑战次数
	self.gameConfigTXT = TxtFactory:getTable(TxtFactory.GameConfigTXT)
	self.maxChallengeCount = tonumber(self.gameConfigTXT:GetData(1001,"CONFIG1"))
	self.rankPanel = self.panel.transform:Find("Anchors/View")
	self.grid = self.panel.transform:Find("Anchors/View/Grid")
	self.scroolview = self.panel.transform:Find("Anchors/View")
	-- 当前段位的icon
	self.ladderIcon = self.panel.transform:Find("Anchors/LadderRank_PromotionBtn/HeadIcon"):GetComponent("UISprite")
	-- 当前段位的名字
	self.ladderName = self.panel.transform:Find("Anchors/LadderRank_PromotionBtn/Name"):GetComponent("UILabel")
	-- 可以晋级的提示
	self.ladderRedPoint = self.panel.transform:Find("Anchors/LadderRank_PromotionBtn/RedPoint").gameObject
	-- 挑战剩余次数
	self.residueChallengeCount = self.panel.transform:Find("Anchors/RankingNum/num"):GetComponent("UILabel")
	self.charIconTxt = TxtFactory:getTable(TxtFactory.CharIconTXT)
	
	
	
end

-- 初始化界面数据
function LadderRankView:InitData()
	-- 加载自己的当前人物
	self.modelShow = ModelShow.new()
    self.modelShow:Init(self)
    self.modelShow:ChooseCharacter(self.UserInfo[TxtFactory.USER_SEX])
    self.modelShow:petShow()
	
	--local ladderInfo = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO)
	--self.ladderInfo = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO)
	self.ladderData = TxtFactory:getTable(TxtFactory.LadderConfigTXT)
	
	self.ladderIcon.spriteName = self.ladderData:GetData(self.ladderInfo.level,"ICON_GROUP")
	self.ladderName.text = self.ladderData:GetData(self.ladderInfo.level,"NAME")
	
	self.residueChallengeCount.text = "[f6524c]"..self.ladderInfo.challenge_num.."[-]/"..self.maxChallengeCount

	
end

function LadderRankView:SetLadderRedPointActive()
	self.ladderRedPoint:SetActive(false)
	if not(self:IsCanPromoted()) or not(self:IsHavePromotedCount()) then
		return
	end
	self.ladderRedPoint:SetActive(true)
end

-- 刷新排行列表
function LadderRankView:RefreshRankList()
	--  应该获取到数据后显示
	self:ClearLadderRankItems()
	local rankList =  TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_RANKLIST)
	-- 刷新panel位置
	--self.rankPanel.localPosition = UnityEngine.Vector3(202,-56,0)
	if rankList == nil then
		printf("rankList is nil")
		return
	end
	--printf("count ===="..#rankList)
	for i = 1 ,#rankList do
		self.ladderRankItems[i] = self:CreataRankItem(rankList[i])
	end
	
	local itemGrid = self.grid:GetComponent("UIGrid")
	itemGrid:Reposition()
	itemGrid.repositionNow = true
	local sv = self.scroolview:GetComponent("UIScrollView")
    sv:ResetPosition()
	-- 添加监听
	self.scene.scene:boundButtonEvents(self.panel)
end

-- 创建一个排行对象
function LadderRankView:CreataRankItem(rank_info)
	local ladderRankItem = nil
	
	ladderRankItem = newobject(Util.LoadPrefab("UI/Ladder/LadderRankingItem"))
	ladderRankItem.transform.parent = self.grid
    ladderRankItem.transform.localPosition = Vector3.zero
    ladderRankItem.transform.localScale = Vector3.one 
	ladderRankItem.name = rank_info.memberid
	-- 名字
	local err, ret = pcall(ZZBase64.decode, rank_info.username)
    if err then
       ladderRankItem.transform:Find("Name"):GetComponent("UILabel").text = ret
    end
	-- 名次
	ladderRankItem.transform:Find("reward"):GetComponent("UISprite").spriteName = self:GeTtrophyByRank(rank_info.rank)
	
	
	if rank_info.score == 0 then
		-- 上周得分
		ladderRankItem.transform:Find("Score2").gameObject:SetActive(false)
		ladderRankItem.transform:Find("Score1"):GetComponent("UILabel").text = rank_info.pre_score
	else
		-- 本周得分
		ladderRankItem.transform:Find("Score1").gameObject:SetActive(false)
		ladderRankItem.transform:Find("Score2"):GetComponent("UILabel").text = rank_info.score
	end
	-- icon	
	if self.charIconTxt:GetLineByID(rank_info.icon) ~= nil then
        ladderRankItem.transform:Find("icon"):GetComponent("UISprite").spriteName = self.charIconTxt:GetData(rank_info.icon, "ICON")
    end
	-- 排名的值
	if rank_info.rank > 3 then
		 ladderRankItem.transform:Find("Rank"):GetComponent("UILabel").text = rank_info.rank
	end
	
	if tonumber(self.UserInfo[TxtFactory.USER_MEMBERID]) == tonumber(rank_info.memberid) then
		-- 自己
		ladderRankItem.transform:Find("background"):GetComponent("UISprite").spriteName = "xuanxiangtiao_lan"
		ladderRankItem.transform:Find("LadderRankingItem_BtnTiaozhan").gameObject:SetActive(false)
	end
	
	
	return ladderRankItem
end

-- 获取剩余挑战次数
function LadderRankView:ResidueChallengeCount()
	return self.maxChallengeCount - self.ladderInfo.challenge_num

end

-- 是否有挑战次数
function  LadderRankView:IsHaveChallengeCount()
	if self:ResidueChallengeCount() > 0 then
		return true
	end
	return false
end

-- 根据排行获取当前奖杯的图片名字
function LadderRankView:GeTtrophyByRank(rank)
	if rank == 1 then
		return "no1"
	elseif rank == 2 then
		return "no2"
	elseif rank == 3 then
		return "no3"
	else
		return "no4"
	end
end



-- Destry对象
function LadderRankView:ClearLadderRankItems()
	if self.ladderRankItems ~= nil then
		for i = 1 , # self.ladderRankItems do
			if self.ladderRankItems[i] ~= nil then
				GameObject.Destroy(self.ladderRankItems[i])
			end
		end
	end
	self.ladderRankItems = {}
end

-- 请求排行列表
function LadderRankView:RequestRankList()
--[[
	if TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_RANKLIST) == nil then
		self.scene.ladderManagement:SendLadderListRequest()
	end
]]--	
	self.scene.ladderManagement:SendLadderListRequest()
end

--激活暂停界面
function LadderRankView:ShowView()
	self.panel:SetActive(true)
	self.modelShow:ChooseCharacter(self.UserInfo[TxtFactory.USER_SEX])
    self.modelShow:petShow()
end

-- 冷藏界面
function LadderRankView:HiddenView()
	self.panel:SetActive(false)
	self.modelShow:SetActive(false)
end

---------------------------------------------------  判断是否可以参加晋级赛 -------------------

-- 获得剩余挑战次数
function LadderRankView:ResiduePromotedCount()
	local maxPromotedCount = tonumber(self.gameConfigTXT:GetData(1001,"CONFIG2"))
	return maxPromotedCount -  self.ladderInfo.rise_num
end

-- 判断胜利次数是否满足
function LadderRankView:IsCanPromotedBySuccessCount()
	if self.ladderInfo.win_num >= tonumber(self.ladderData:GetData(self.ladderInfo.level,"CHALLENGE")) then
		return true
	end
	return false
end

-- 判断分数是否满足
function LadderRankView:IsCanPromotedByScore()
	if self.ladderInfo.max_score >= self.ladderInfo.level_score[self.ladderInfo.level+1] then
		return true
	end
	return false
end

-- 判断是否还有晋级次数
function LadderRankView:IsHavePromotedCount()
	if self:ResiduePromotedCount() > 0 then
		return true
	end
	return false
end

-- 判断是否满足晋级条件
function LadderRankView:IsCanPromoted()
	
	if self:IsCanPromotedByScore() and self:IsCanPromotedBySuccessCount() then
		return true
	end
	return false
end

 