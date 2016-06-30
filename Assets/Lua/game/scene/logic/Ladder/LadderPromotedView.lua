--[[
author:gaofei
天梯晋级界面
]]

LadderPromotedView = class()
LadderPromotedView.scene = nil --对应场景
LadderPromotedView.panel = nil -- 界面preb


function LadderPromotedView:Awake(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Ladder/LadderPromotedUI"))
	self.panel.transform.parent = targetScene.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one 
	
	self.ladderData = TxtFactory:getTable(TxtFactory.LadderConfigTXT)
	self.ladderInfo = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO)
	-- 最大晋级次数
	self.gameConfigTXT = TxtFactory:getTable(TxtFactory.GameConfigTXT)
	self.maxPromotedCount = tonumber(self.gameConfigTXT:GetData(1001,"CONFIG2"))
	
	self.leftParent =  self.panel.transform:Find("Anchors/Left")  -- 目前段位的父节点
	self.rightParent =  self.panel.transform:Find("Anchors/Right")  -- 下一个段位的父节点
	self.centerParent =  self.panel.transform:Find("Anchors/Center")  -- 中间的段位父节点
	
	-- 箭头
	self.arrow = self.panel.transform:Find("Anchors/Arrow")
	
	-- 未到最高级显示的界面
	self.condition =self.panel.transform:Find("Anchors/Condition")
	
	-- 星星1
	self.star1 =  self.condition:Find("need1/Sprite"):GetComponent("UISprite")
	-- 星星2
	self.star2 =  self.condition:Find("need2/Sprite"):GetComponent("UISprite")
	
	-- 当前天梯跑的分数
	self.curScore = self.condition:Find("need1/Score 2"):GetComponent("UILabel")
	-- 目标分数
	self.targetScore = self.condition:Find("need1/Score 1"):GetComponent("UILabel")
	-- 胜利次数
	self.successCount = self.condition:Find("need2/SuccessCount"):GetComponent("UILabel")
	-- 晋级剩余次数
	self.promotedCount = self.condition:Find("Num"):GetComponent("UILabel")
	-- 最高等级显示的界面
	self.maxLevel =self.panel.transform:Find("Anchors/MaxLevel")
	
	
	
	targetScene.scene:boundButtonEvents(self.panel)
end

-- 初始化界面数据
function LadderPromotedView:InitData()
	-- 创建自己当前的天梯等级
	
	
	if self.ladderInfo.level == 7 then
		self:MaxLadderLevelShow()
	else
		self:OtherLadderLevelShow()
	end
end

-- 设置最大段位是界面的显示
function LadderPromotedView:MaxLadderLevelShow()
	self.scene.ladderManagement:CreateLadderLevelItem(self.centerParent,self.ladderInfo.level,0.55,self.ladderData)
	self.arrow.gameObject:SetActive(false)
	self.condition.gameObject:SetActive(false)
	self.maxLevel.gameObject:SetActive(true)
end

-- 其他段位界面显示
function LadderPromotedView:OtherLadderLevelShow()
	self.scene.ladderManagement:CreateLadderLevelItem(self.leftParent,self.ladderInfo.level,0.55,self.ladderData)
	self.scene.ladderManagement:CreateLadderLevelItem(self.rightParent,self.ladderInfo.level+1,0.55,self.ladderData)
	self.arrow.gameObject:SetActive(true)
	self.condition.gameObject:SetActive(true)
	self.maxLevel.gameObject:SetActive(false)
	self.curScore.text = self.ladderInfo.max_score
	self.targetScore.text = self.ladderInfo.level_score[self.ladderInfo.level+1]
	self.promotedCount.text = "[f6524c]"..self.ladderInfo.rise_num.."[-]".."[7D3D07]/"..self.maxPromotedCount.."[-]"
	-- 需要胜利的最大次数
	local maxSucceessCount = tonumber(self.ladderData:GetData(self.ladderInfo.level,"CHALLENGE"))
	local showSuccessCount = self.ladderInfo.win_num
	if self.ladderInfo.win_num >= maxSucceessCount then
		showSuccessCount = maxSucceessCount
	end
	self.successCount.text = "[f6524c]"..showSuccessCount.."[-]".."[7D3D07]/"..maxSucceessCount.."[-]"
	-- 设置星星
	self.star1.spriteName = self:SetStarSpriteName(self:IsCanPromotedByScore())
	self.star2.spriteName = self:SetStarSpriteName(self:IsCanPromotedBySuccessCount())
end

-- 判断是否满足晋级条件
function LadderPromotedView:IsCanPromoted()
	
	if self:IsCanPromotedByScore() and self:IsCanPromotedBySuccessCount() then
		return true
	end
	return false
end

-- 判断分数是否满足
function LadderPromotedView:IsCanPromotedByScore()
	if self.ladderInfo.max_score >= self.ladderInfo.level_score[self.ladderInfo.level+1] then
		return true
	end
	return false
end

-- 判断胜利次数是否满足
function LadderPromotedView:IsCanPromotedBySuccessCount()
	if self.ladderInfo.win_num >= tonumber(self.ladderData:GetData(self.ladderInfo.level,"CHALLENGE")) then
		return true
	end
	return false
end

-- 判断是否还有晋级次数
function LadderPromotedView:IsHavePromotedCount()
	if self:ResiduePromotedCount() > 0 then
		return true
	end
	return false
end

-- 获取星星图片名  value-- 条件
function LadderPromotedView:SetStarSpriteName(value)
	if value then
		return "xing"
	else
		return "xing2"
	end
end

-- 获得剩余挑战次数
function LadderPromotedView:ResiduePromotedCount()
	local maxPromotedCount = tonumber(self.gameConfigTXT:GetData(1001,"CONFIG2"))
	return maxPromotedCount -  self.ladderInfo.rise_num
end

--激活暂停界面
function LadderPromotedView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function LadderPromotedView:HiddenView()
	self.panel:SetActive(false)
end


 