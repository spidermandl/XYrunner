--[[
author:gaofei
天梯界面顶部信息
]]

LadderTopInfoView = class()
LadderTopInfoView.scene = nil --对应场景
LadderTopInfoView.panel = nil -- 界面preb

function LadderTopInfoView:Awake(targetScene)
	
	
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Ladder/LadderTopUI"))
	self.panel.transform.parent = targetScene.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one 
	-- 体力
	self.powerLabel = self.panel.transform:Find("Anchors/tili/Label"):GetComponent("UILabel")
	-- 天梯币
	self.ladderCoinLabel = self.panel.transform:Find("Anchors/coins/Label"):GetComponent("UILabel")
	-- 钻石
	self.diamondLabel = self.panel.transform:Find("Anchors/zuanshi/Label"):GetComponent("UILabel")
	targetScene.scene:boundButtonEvents(self.panel)
end

-- 初始化界面数据
function LadderTopInfoView:InitData()
	self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    self.diamondLabel.text = tonumber(self.UserInfo[TxtFactory.USER_DIAMOND])
    self.powerLabel.text = tonumber(self.UserInfo[TxtFactory.USER_STRENGTH])
	local ladderInfo = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO)
	self.ladderCoinLabel.text = ladderInfo.points
end

--激活暂停界面
function LadderTopInfoView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function LadderTopInfoView:HiddenView()
	self.panel:SetActive(false)
end


 