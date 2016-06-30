--[[
author:gaofei
天梯结算段位变化界面
]]

LadderPromotionEndView = class()
LadderPromotionEndView.scene = nil --对应场景
LadderPromotionEndView.panel = nil -- 界面preb

function LadderPromotionEndView:Awake(targetScene)
	
	
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Ladder/LadderPromotionEndView"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one 
	
	self.ladderLevelParent = self.panel.transform:Find("Anchors/UI/LadderLevelParent")
	self.descLabel = self.panel.transform:Find("Anchors/UI/Desc"):GetComponent("UILabel")

	
	self.scene:boundButtonEvents(self.panel)
end

-- 初始化界面数据
function LadderPromotionEndView:InitData()
	-- 加载当前的段位信息
	local ladder_info =  TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO)
    local result = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_UPGRADE_RESULT)
	local ladderData = TxtFactory:getTable(TxtFactory.LadderConfigTXT)
	if result == 1 then
		-- 胜利
		self.descLabel.text = "通过您努力,段位提升为[ffff00]"..ladderData:GetData(ladder_info.level,"NAME").."[-]"
	else
		-- 失败
		self.descLabel.text = "您的段位为[ffff00]"..ladderData:GetData(ladder_info.level,"NAME").."[-],再接再厉哦"
	end
	self:CreateLadderLevelItem(self.ladderLevelParent,ladder_info.level,0.65,ladderData)
end


-- 确定
function LadderPromotionEndView:LadderPromotionEndOkBtnOnClick()
	self.scene:ChangScene(SceneConfig.buildingScene)
end

-- 分享
function LadderPromotionEndView:LadderPromotionEndShareBtnOnClick()


end

-- 创建一个天梯等级的对象
function LadderPromotionEndView:CreateLadderLevelItem(parent,ladderId,scaleValue,ladderTabel)
	local ladderLevelItem = nil
	ladderLevelItem = newobject(Util.LoadPrefab("UI/Ladder/TemplateLadderLevelItem"))
	ladderLevelItem.transform.parent = parent
    ladderLevelItem.transform.localPosition = Vector3.zero
    ladderLevelItem.transform.localScale = Vector3.one * scaleValue
	--local starName = ladderTabel:GetData(ladderId,"ICON_STAR") 
	ladderLevelItem.transform:Find("Icon"):GetComponent("UISprite").spriteName = ladderTabel:GetData(ladderId,"ICON_BIG")
	--ladderLevelItem.transform:Find("Icon"):GetComponent("UISprite").spriteName = ladderTabel:GetData(ladderId,"ICON_GROUP")
	--ladderLevelItem.transform:Find("Bg"):GetComponent("UISprite").spriteName = ladderTabel:GetData(ladderId,"ICON_BOX")
	--ladderLevelItem.transform:Find("Xing 1"):GetComponent("UISprite").spriteName =starName
	--ladderLevelItem.transform:Find("Xing 2"):GetComponent("UISprite").spriteName =starName
	--ladderLevelItem.transform:Find("Name"):GetComponent("UILabel").text = ladderTabel:GetData(ladderId,"NAME")
	return ladderLevelItem
end


 