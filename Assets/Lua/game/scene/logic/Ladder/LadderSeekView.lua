--[[
author:gaofei
天梯等级列表
]]

LadderSeekView = class()
LadderSeekView.scene = nil --对应场景
LadderSeekView.panel = nil -- 界面preb
LadderSeekView.ladderLevelItems = nil -- 天梯等级列表

function LadderSeekView:Awake(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Ladder/LadderSeekUI"))
	self.panel.transform.parent = targetScene.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one 
	
	self.grid = self.panel.transform:Find("Anchors/View/Grid")
	
	targetScene.scene:boundButtonEvents(self.panel)
end

-- 初始化界面数据
function LadderSeekView:InitData()
	-- 创建列表
	local ladderData = TxtFactory:getTable(TxtFactory.LadderConfigTXT)
	local ladderInfo = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO)
	--printf("count"..ladderData:GetLineNum())
	--local index = 1
	self.ladderLevelItems = {}
	for i = 1 , ladderData:GetLineNum() - 1 do
		self.ladderLevelItems[i] = self.scene.ladderManagement:CreateLadderLevelItem(self.grid,i,0.6,ladderData)
		self.ladderLevelItems[i].transform:Find("Score").gameObject:SetActive(true)
		self.ladderLevelItems[i].transform:Find("Score/Label"):GetComponent("UILabel").text = ladderInfo.level_score[i]
		-- 设置当前值
		if ladderInfo.level == i then
			self.ladderLevelItems[i].transform:Find("RankingIcon 3").gameObject:SetActive(true)
		end
		--index = index + 1
	end
	local itemGrid = self.grid:GetComponent("UIGrid")
	itemGrid:Reposition()
	itemGrid.repositionNow = true
end

--激活暂停界面
function LadderSeekView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function LadderSeekView:HiddenView()
	self.panel:SetActive(false)
end

 