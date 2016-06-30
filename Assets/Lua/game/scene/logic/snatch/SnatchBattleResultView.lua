--[[
author:gaofei
夺宝奇兵战斗结算界面
]]

SnatchBattleResultView = class ()
SnatchBattleResultView.name = "SnatchBattleResultView" --类名
SnatchBattleResultView.scene = nil --场景scene
SnatchBattleResultView.panel = nil -- 界面
SnatchBattleResultView.occupationView = nil -- 占领确定界面
SnatchBattleResultView.successView = nil -- 胜利界面
SnatchBattleResultView.failView = nil  -- 失败界面

SnatchBattleResultView.modelShow = nil -- 3D模型

-- 初始化
function SnatchBattleResultView:init(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Snatch/SnatchBattleResultView"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
	
	-------------------------------  胜利界面 --------------------------------------------
	self.successView =  self.panel.transform:Find("Anchors/Success")
	-- 得分
	self.successScoreLabel = self.successView:Find("Score"):GetComponent("UILabel")
	-- 加成得分
	self.successAddScoreLabel = self.successView:Find("AddScore"):GetComponent("UILabel")
	-- 获得据点积分
	self.successIntegralLabel = self.successView:Find("Integral"):GetComponent("UILabel")
	-- 获得奖励物品
	
	-- 获得的夺宝币
	self.successSnatchCoinValueLabel = self.successView:Find("SnatchCoinValue"):GetComponent("UILabel")
	
	-- 获得的经验
	self.successExpLabel = self.successView:Find("AddExp"):GetComponent("UILabel")
	
	-- 是否是本周最佳
	self.successWeekBest = self.successView:Find("WeekBest")
	
	-------------------------------  失败界面 ----------------------------------------------
	self.failView =  self.panel.transform:Find("Anchors/Fail")
	-- 得分
	self.failScoreLabel =self.failView:Find("Score"):GetComponent("UILabel")
	-- 加成得分
	self.failAddScoreLabel = self.failView:Find("AddScore"):GetComponent("UILabel")
	-- 获得据点积分
	self.failIntegralLabel = self.failView:Find("Integral"):GetComponent("UILabel")
	
	-- 获得的经验
	self.failExpLabel = self.failView:Find("AddExp"):GetComponent("UILabel")
	
	------------------------------- 占领确定界面  ----------------------------------------
	self.occupationView = self.panel.transform:Find("Anchors/OccupationView")
	
	
	--self.snatchInfo =TxtFactory:getMemDataCacheTable(TxtFactory.SnatchInfo)
    self.scene:boundButtonEvents(self.panel)
	self.occupationView.gameObject:SetActive(false)
	self.failView.gameObject:SetActive(false)
	self.successView.gameObject:SetActive(false)
	self:HiddenView()
end

-- 初始化数据
function SnatchBattleResultView:InitData()
	
   
   -- 据点抢夺服务器返回的信息
   --[[
   	optional RESULT result 			= 1;
	optional ExplorerInfo explorer 	= 2;//这个探险点的最终状态
	optional int32 score 			= 3;//取得的分数
	optional int32 gold             = 4;//收集得到的金币
	optional int32 sgold            = 5;//抢劫得到的金币
	]]--
	
	self:AddRoleMode()
	self.battleresultdata = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_BATTLERESULT)
	if self.battleresultdata.result ~= 1 then
		-- 抢夺失败
		self:InitFailInfo()
	else
		-- 抢夺成功
		self:InitSuccessInfo()
	end
	
end

-- 设置3d模型
function SnatchBattleResultView:AddRoleMode()

	
	--模型
	self.modelShow = ModelShow.new()
    self.modelShow:Init(self)

	-- 显示人物模型预览
    local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    self.modelShow:ChooseCharacter(UserInfo[TxtFactory.USER_SEX])
    self.modelShow:petShow()
end


-- 初始化成功信息
function SnatchBattleResultView:InitSuccessInfo()

	
	self.successView.gameObject:SetActive(true)
	self.successScoreLabel.text =  self.battleresultdata.score
	self.successAddScoreLabel.text =  self.battleresultdata.gold
	self.successSnatchCoinValueLabel.text =  self.battleresultdata.sgold
	
	self.successIntegralLabel.text = self.battleresultdata.explorer_score
	self.successExpLabel.text = self.battleresultdata.exp
end

-- 初始化失败信息
function SnatchBattleResultView:InitFailInfo()
	self.failView.gameObject:SetActive(true)
	self.failScoreLabel.text =  self.battleresultdata.score
	self.failAddScoreLabel.text =  self.battleresultdata.gold
	self.failIntegralLabel.text = self.battleresultdata.explorer_score
	self.failExpLabel.text = self.battleresultdata.exp
end

-- 确定按钮
function SnatchBattleResultView:SnatchBattleOkBtnOnClick()
	printf("确定按钮")
	self.scene:ChangScene(SceneConfig.buildingScene)
end

-- 占领按钮
function SnatchBattleResultView:SnatchBattleOccupationBtnOnClick()
	printf("占领按钮")
	--self.scene:ChangScene(SceneConfig.buildingScene)
	self.occupationView.gameObject:SetActive(true)
	--self:sendExplorerOccupyRequest()
end

-- 确认占领
function SnatchBattleResultView:SnatchBattleOkOccupationBtnOnClick()
	
	self:sendExplorerOccupyRequest()
end

-- 取消占领
function SnatchBattleResultView:SnatchBattleCanelOccupationBtnOnClick()
	self.scene:ChangScene(SceneConfig.buildingScene)
end


--激活暂停界面
function SnatchBattleResultView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function SnatchBattleResultView:HiddenView()
	if self.modelShow ~= nil then
		self.modelShow:DestroyPet()
	end
	self.panel:SetActive(false)
end

-- 获取类名
function SnatchBattleResultView:getName()
    return self.name 
end

--占领抢夺到的据点 (发送)
function SnatchBattleResultView:sendExplorerOccupyRequest()
    local json = require "cjson"
	
	 local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {id=self.battleresultdata.explorer.id}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = explorer_pb.ExplorerOccupyRequest()
		message.id = self.battleresultdata.explorer.id
        strr = ZZBase64.encode(message:SerializeToString())
    end
  --  local msg = {id=self.battleresultdata.explorer.id}
  --  local strr = json.encode(msg)
    local param = {
              code = MsgCode.ExplorerOccupyRequest,
              data = strr, -- strr
             }

	local userTable = TxtFactory:getTable("UserTXT")
    MsgFactory:createMsg(MsgCode.ExplorerOccupyResponse, self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..userTable:getValue('Username')..':'..userTable:getValue('access_token'))
    --print("开始跑酷信息 发送")
end

--占领抢夺到的据点 (回复)
function SnatchBattleResultView:getExplorerOccupyRequest(info)
		local json = require "cjson"
		local tab = json.decode(info.data)
		printf("reuslt===="..tab.result)
		-- 占领成功  跳转界面
		self.scene:ChangScene(SceneConfig.buildingScene)
end