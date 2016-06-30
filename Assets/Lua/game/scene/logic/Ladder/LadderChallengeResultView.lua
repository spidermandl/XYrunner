--[[
author:gaofei
天梯挑战结算界面
]]

LadderChallengeResultView = class ()
LadderChallengeResultView.name = "LadderChallengeResultView" --类名
LadderChallengeResultView.scene = nil --场景scene
LadderChallengeResultView.panel = nil -- 界面
LadderChallengeResultView.successView = nil -- 胜利界面
LadderChallengeResultView.failView = nil  -- 失败界面

-- 初始化
function LadderChallengeResultView:init(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Ladder/LadderChallengeResultView"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
	
	-------------------------------  胜利界面 --------------------------------------------
	self.successView =  self.panel.transform:Find("Anchors/Success")
	-- 得分
	self.successScoreLabel = self.successView:Find("Score"):GetComponent("UILabel")
	-- 加成得分
	self.successAddScoreLabel = self.successView:Find("AddScore"):GetComponent("UILabel")
	
	
	-------------------------------  失败界面 ----------------------------------------------
	self.failView =  self.panel.transform:Find("Anchors/Fail")
	-- 得分
	self.failScoreLabel =self.failView:Find("Score"):GetComponent("UILabel")
	-- 加成得分
	self.failAddScoreLabel = self.failView:Find("AddScore"):GetComponent("UILabel")
	
	
    self.scene:boundButtonEvents(self.panel)
	self.failView.gameObject:SetActive(false)
	self.successView.gameObject:SetActive(false)
	self:HiddenView()
end

-- 初始化数据
function LadderChallengeResultView:InitData()
	
   	self.battleresultdata = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_CHALLENGE_RESULT)
    
   printf("score ==="..self.battleresultdata.score)
   printf("gold ==="..self.battleresultdata.gold)
	if self.battleresultdata.result ~= 1 then
		-- 挑战失败
		self:InitFailInfo()
	else
		-- 挑战成功
		self:InitSuccessInfo()
	end
	
end

-- 初始化成功信息
function LadderChallengeResultView:InitSuccessInfo()

	
	self.successView.gameObject:SetActive(true)
	self.successScoreLabel.text =  self.battleresultdata.score
	--self.successScoreLabel.text  = 100000
	self.successAddScoreLabel.text =  self.battleresultdata.gold
	
end

-- 初始化失败信息
function LadderChallengeResultView:InitFailInfo()
	self.failView.gameObject:SetActive(true)
	printf("score ==="..self.battleresultdata.score)
	self.failScoreLabel.text =  self.battleresultdata.score
	--self.successScoreLabel.text  = 100000
	self.failAddScoreLabel.text =  self.battleresultdata.gold
	
end

-- 确定按钮
function LadderChallengeResultView:LadderChallengeResultViewOnBtnOnClick()
	printf("确定按钮")
	self.scene:ChangScene(SceneConfig.buildingScene)
end


--激活暂停界面
function LadderChallengeResultView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function LadderChallengeResultView:HiddenView()
	self.panel:SetActive(false)
end

-- 获取类名
function LadderChallengeResultView:getName()
    return self.name 
end