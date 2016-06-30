--[[
	author:Desmond
	跑酷场景
]]

require "game/scene/logic/battle/BattleResultView"
require "game/scene/logic/battle/BattleResultAnimationView"
require "game/scene/logic/battle/PetForSettlement"
require "game/scene/logic/battle/BattleCtrlView"
require "game/scene/logic/battle/BattleEndlessResult"
require "game/scene/logic/battle/BattleRolling"
require "game/scene/logic/battle/BattleManagement"
require "game/scene/logic/battle/EndlessLoadListener"
require "game/scene/logic/battle/BattlePauseView"	
require "game/scene/logic/battle/BattleDesmondListener"
require "game/scene/logic/battle/RollingAttribute"
require	"game/scene/logic/battle/BattleControl"
require "game/scene/logic/Sound/SoundManagement"
require "game/scene/logic/snatch/SnatchBattleResultView"
require "game/scene/logic/Ladder/LadderPromotionEndView"
require "game/scene/logic/Ladder/LadderChallengeResultView"
require "game/scene/logic/guide/BattleGuideView"
require "game/scene/logic/battle/BattleCountdownView"	
require	"game/scene/logic/Challenge/ChallengeWaitView"
require	"game/scene/logic/Challenge/ChallengeWinView"
require	"game/scene/logic/Challenge/ChallengeLoseView"
require	"game/scene/logic/AsyncPvp/AsyncPvpResultView"

BattleScene = class(BaseScene)

BattleScene.name = "BattleScene" --类名
BattleScene.player = nil --角色

BattleScene.manager = nil --数据管理器
BattleScene.uiRoot = nil --ui根节点
BattleScene.runningUI = nil --new runningui
BattleScene.objects = nil --动态物体
BattleScene.objectLoader = nil --动态加载gameObject管理器
BattleScene.previousLoader = nil --存储管理器
BattleScene.previousMemeryPool = nil --存储内存池
BattleScene.mainCamera = nil --场景摄像头
BattleScene.resultView = nil --结算界面
BattleScene.uiDialogue = nil -- 管理对话
BattleScene.uiCtrl = nil --UI 主界面
BattleScene.uiEventCtrl = nil --ui 事件监听
BattleScene.sceneTarget = nil -- 场景监听脚本obj
BattleScene.light = nil --场景平行光
BattleScene.excessView = nil -- 关卡过度界面
BattleScene.pauseView = nil -- 暂停界面
BattleScene.asyncPvpResultView = nil -- 打开世界对战结算界面
BattleScene.pause = false --游戏暂停
BattleScene.battleType = 0 -- 战斗类型

BattleScene.battleCountdownView = nil -- 倒计时界面

BattleScene.ladderPromotionEndView = nil -- 天梯升级确认界面

BattleScene.gameIsOver = false 
BattleScene.isSendMessage_Gameover = false -- 战斗是否已经结束(用于判断是否给服务器发送了命令)
BattleScene.BattleGuideView = nil -- 战斗引导
BattleScene.BattleGuideViewFinish = false -- 战斗引导结束
function BattleScene:Awake()
	if TxtFactory:isInit() ~= true then --调试时加载本地表
		TxtFactory:RegisterAll()
	end

	--创建ui
	self.uiRoot = find("UI Root")
	self.runningUI = newobject(Util.LoadPrefab("UI/battle/runningUI"))
    self.runningUI.gameObject.transform.parent = self.uiRoot.gameObject.transform
    self.runningUI.gameObject.transform.localPosition = Vector3.zero
    self.runningUI.gameObject.transform.localScale = Vector3.one
	self.sceneTarget = self:AddUIButtonCtrlOnObj(self.uiRoot,"UIBattleLua")

    self.objects = find("Objects")
	-- 添加特效
	local blood = getChildByPath(self.runningUI,"UI/UIGame/LeftUp/blood/BloodFront") --find("BloodFront")
	self.effect = newobject(Util.LoadPrefab("Effects/UI/ef_ui_articleblood"))
	self.effect.gameObject.transform.parent = blood.gameObject.transform
	self.effect.gameObject.transform.localPosition = Vector3(440,0,0)
	self.effect.gameObject.transform.localScale = Vector3.one
	SetEffectOrderInLayer(self.effect,100)

	--设置攻击按钮box的尺寸
	local atkCollider = --find("BtnAttack").gameObject:GetComponent("BoxCollider")
	getObjectComponent(self.runningUI,"BoxCollider","UI/UIGame/LeftDown/BtnAttack")
	atkCollider.center = Vector3(150,0,0)
	atkCollider.size = Vector3(500,170,0)
	--btnSpeed.depth = 100
	--find("BtnSpeedUp").gameObject:GetComponent("UIWidget").depth = 100
	--btnSpeed.transform:GetComponent("UIWidget").depth = 100
    --创建人物
    -- local player = find('player')
    -- local lua = player:AddComponent(BundleLua.GetClassType())
    -- lua.luaName = "Desmond"
    -- lua.isUpdate = false

	--创建摄像机
	local camera = find ("CameraMove")
	self.mainCamera = GameCamera.new()
	self.mainCamera:setParent(camera)
	self.mainCamera:Awake()
	--print ("-------------------function BattleScene:Awake() 1 "..tostring(self.bundleParams).." "..tostring(self.bundleParams.Length))


	--战斗新手引导
    self.BattleGuideView = BattleGuideView.new()
    self.BattleGuideView:Init(self)
    self.BattleGuideViewFinish = false
    
   	self.battleType = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE)
	    local task = TxtFactory:getTable(TxtFactory.TaskManagement)
   		 task:LevelStoryInit()
	--创建动态加载gameObject管理器 剧情模式
	if self.battleType == 1 then
		self.objectLoader = ObjectLoader.new()
	    self.objectLoader:setCamera(self.mainCamera)
	    self.objectLoader:Awake()
        

    	--初始结算view
		self.resultView = BattleResultView.new()
		self.resultView.scene = self
		self.resultView:Awake()
		--奖杯任务
		self.LevelCupTaskView = LevelCupTaskView.new()
		self.LevelCupTaskView:init(self)
		self.bStroy = false
        
        --设置场景
		local txt = TxtFactory:getTable(TxtFactory.ChapterTXT)
		local story_name = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_STORY)
		local base = txt:GetData(txt:GetLevelIDByScenesId(story_name),TxtFactory.S_CHAPTER_BASE)
		self:changeMiddleLandscape(base,0)
		self:changeFarLandscape(base,0)

	elseif self.battleType == 2 or self.battleType == 4  or self.battleType == 6 or self.battleType == 7 or self.battleType == 8 then
    --创建动态加载EndlessLoader管理器 无尽模式  
		local listener = EndlessLoadListener.new()
		listener.callback = self

		self.objectLoader = EndlessLoader.new()
		self.objectLoader.listener = listener
		self.objectLoader:setCamera(self.mainCamera)
		self.objectLoader:Awake()
		--无尽结算view
		self.resultView = BattleEndlessResult.new()
		self.resultView.scene = self
		self.resultView:Awake()
	elseif self.battleType == 3 then
	--创建动态加载EndlessLoader管理器 据点模式
		local listener = EndlessLoadListener.new()
		listener.callback = self

		self.objectLoader = EndlessLoader.new()
		self.objectLoader.listener = listener
		self.objectLoader:setCamera(self.mainCamera)
		self.objectLoader:Awake()
		self.resultView = SnatchBattleResultView.new()
		self.resultView:init(self)
	elseif self.battleType == 5 then
	--创建动态加载EndlessLoader管理器 天梯挑战
		local listener = EndlessLoadListener.new()
		listener.callback = self

		self.objectLoader = EndlessLoader.new()
		self.objectLoader.listener = listener
		self.objectLoader:setCamera(self.mainCamera)
		self.objectLoader:Awake()
		self.resultView = LadderChallengeResultView.new()
		self.resultView:init(self)
	else 
		--test 模式
		self.objectLoader = ObjectLoader.new()
	    self.objectLoader:setCamera(self.mainCamera)
	    self.objectLoader:Awake()
	end
	
	self.gameIsOver = false
	self.isSendMessage_Gameover = false
	--[[
	 --创建动态加载gameObject管理器 剧情模式
    if self.bundleParams == nil or self.bundleParams.Length == 0 then
	    self.objectLoader = ObjectLoader.new()
	    self.objectLoader:setCamera(self.mainCamera)
	    self.objectLoader:Awake()

    	--初始结算view
		self.resultView = BattleResultView.new()
		self.resultView.scene = self
		--奖杯任务
		self.LevelCupTaskView = LevelCupTaskView.new()
		self.LevelCupTaskView:init(self)
	
		self.resultView:Awake()
    end
    if self.bundleParams ~= nil and self.bundleParams.Length > 0 then
  		-- 无尽模式
		if tostring(System.Array.GetValue(self.bundleParams,0)) == "endless" then
			local listener = EndlessLoadListener.new()
			listener.callback = self

			self.objectLoader = EndlessLoader.new()
			self.objectLoader.listener = listener
			self.objectLoader:setCamera(self.mainCamera)
			self.objectLoader:Awake()
			--无尽结算view
			self.resultView = BattleEndlessResult.new()
			self.resultView.scene = self
			self.resultView:Awake()
	    	 
		end
		-- 判断当前无尽模式属于据点还是无尽  (gaofei)
		 local snatchInfo =TxtFactory:getMemDataCacheTable(TxtFactory.SnatchInfo)
   		 if snatchInfo == nil or snatchInfo.strongholdID == -1 then
			--无尽结算view
			self.resultView = BattleEndlessResult.new()
			self.resultView.scene = self
			self.resultView:Awake()
	     else
		 	   -- 据点模式
			  self.resultView = SnatchBattleResultView.new()
			  self.resultView:init(self)
		 end
	end
	]]--
    --初始化界面UI
    self.uiCtrl = BattleCtrlView.new()
    self.uiCtrl.scene = self
    self.uiCtrl:Awake()

    --数据管理器
    self.manager = BattleManagement.new()
    self.manager.scene = self
    self.manager:Awake()
    
    self:boundButtonEvents(self.uiRoot)

	--游戏内按钮控制
    self.gameControl = BattleControl.new()
    self.gameControl.scene = self
    self.gameControl:Awake()

end

--启动事件--
function BattleScene:Start()
	if self.objectLoader ~= nil then
		self.objectLoader:Start()
	end
	self.light = find("Directional Light")
	self.mainCamera:Start()

	TxtFactory:getTable(TxtFactory.SoundManagement):PlayBackGroundSound(2)
    self.uiCtrl:Start()
end
--[[
初始化player
]]
function BattleScene:initPlayer()
    local playerObj = find('player')
	playerObj:SetActive(false)
	local lua = playerObj.gameObject:AddComponent(BundleLua.GetClassType())
	lua.luaName = "Desmond"
	lua.isUpdate = false
	playerObj:SetActive(true)
	
	self.player = LuaShell.getRole(playerObj:GetInstanceID())

    --加入跑酷核心玩法回调接口
    local listener = BattleDesmondListener.new()
    listener.callback = self
	self.player.sceneListener = listener
end


function BattleScene:Update()
	if self.player == nil then
		self:initPlayer()
		return
	end
	if self.battleCountdownView ~= nil then
		self.battleCountdownView:Update()
	end
	--test 使用
	if RoleProperty.UseTestStroy and UnityEngine.Input.GetKeyDown(KeyCode.J) then
       self:sendStoryRunningRequest(true)
    end
	
	if self.bStroy and self.battleType == 1 then

		self.resultView:Update()
	end
	
	if self.pause == true then
		return
	end

	if self.objectLoader ~= nil then
		self.objectLoader:Update()
	end
	if self.gameIsOver ~= true then --判断游戏是否结束
		self.mainCamera:Update()
	end

	if self.uiCtrl~= nil then
    	self.uiCtrl:Update()
    end
    
    if self.uiEventCtrl ~= nil then
    	self.uiEventCtrl:Update()
    end
    self.player:Update()

	
end

function BattleScene:FixedUpdate()
	if self.player == nil then
		self:initPlayer()
		return
	end

	if self.pause == true then
		return
	end

	if self.objectLoader ~= nil then
		self.objectLoader:FixedUpdate()
	end
	
	if self.gameIsOver ~= true then --判断游戏是否结束
	    self.mainCamera:FixedUpdate()
    end
    
    self.player:FixedUpdate()

end

function BattleScene:LateUpdate()
	if self.player == nil then
		self:initPlayer()
		return
	end

	if self.pause == true then
		return
	end
	
	self.mainCamera:LateUpdate()
end
--结算ui 事件方法
function BattleScene:uiResultEvent( fName,... )
	self.effect.gameObject:SetActive(false)
	self.resultView[fName](self.resultView,...)
end

-- 暂停ui 事件方法
function BattleScene:uiPauseEvent( fName,... )
	self.pauseView[fName](self.pauseView,...)
end

--弹出胜利框  ＋ 结算动画 
function BattleScene:VictoryUIPanelShow(dataList)
	self.bStroy = true
	self.effect.gameObject:SetActive(false)
    TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.result_success)
    self.resultView:VictoryUIPanelShow(dataList)
end
--弹出失败面板 
function BattleScene:FailureUIPanelShow()
	self.effect.gameObject:SetActive(false)
    TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.result_falid)
    self.resultView:FailureUIPanelShow()
end

--发送无尽或者据点结算结果请求
function BattleScene:sendEndRunningRequest()
	self.isSendMessage_Gameover = true
	--GamePrint("aaaaaaaaaaaaaa")
	if self.battleType == 2 or self.battleType == 7 or self.battleType == 8 then
		-- 无尽模式
		self.manager:sendEndRunningRequest(self.player)
	elseif self.battleType == 3 then
		-- 据点模式
		--local snatchInfo =TxtFactory:getMemDataCacheTable(TxtFactory.SnatchInfo)
		self.manager:sendStrongholdRequest(self.player)
	elseif self.battleType == 4 then
		-- 天梯定位赛
		self.manager:sendLadderRaceEndRequest(self.player)
	elseif self.battleType == 5  then
		-- 天梯挑战赛
		self.manager:sendLadderChallengeRequest(self.player)
	elseif self.battleType == 6  then
		-- 天梯晋级赛
		self.manager:sendLadderUpgradeEndRequest(self.player)
	end
	
end

--发送剧情结算结果请求
function BattleScene:sendStoryRunningRequest(isTest)
	self.manager:sendStoryRunningRequest(self.player,isTest)
end

--弹出无尽结算界面
function BattleScene:showEndlessResult()
	self.uiCtrl:SetInvisible()
	self.objects:SetActive(false)
    self.resultView:showEndlessResult()
end

--弹出据点结算界面
function BattleScene:showSnatchResult()
	self.uiCtrl:SetInvisible()
	self.objects:SetActive(false)
    self.resultView:ShowView()
	self.resultView:InitData()
end

--弹出天梯挑战结算界面
function BattleScene:showLadderChallengeResultView()
	self.uiCtrl:SetInvisible()
	self.objects:SetActive(false)
    self.resultView:ShowView()
	self.resultView:InitData()
end


-- 玩家升级界面
function BattleScene:showPlayerLevelUpView(lv,OkDel,...)
	self.PlayerLevelUpView = PlayerLevelUpView.new()
	self.PlayerLevelUpView:init(self,OkDel,...)
	self.PlayerLevelUpView:InitData(lv)
end
function BattleScene:showCupListReward(data)
	self:rewardItemsShow(data)
end

--获取动态加载gameObject管理器
function BattleScene:getObjLoader()
	return self.objectLoader
end

--获取动态加载gameObject管理器
function BattleScene:getCamera()
	return self.mainCamera
end


-- 创建对话框面板
function BattleScene:DialogueUIPanelShow(tab,item)
    self.uiDialogue = UIDialogue.new()
    self.uiDialogue.infoTab = tab
    self.uiDialogue:init(self.uiRoot.gameObject,tab,item)
end

-- 对话框下一页 按钮
function BattleScene:uiDialogue_nextBtn()
	self.uiDialogue:btnOnClick()
end

--执行人物动作
function BattleScene:doPlayerAction( action )
	if self.player == nil then
		return
	end
	self.player:DoAction(action)
end

--游戏暂停
function BattleScene:doPause()
	--self.pause = not self.pause
	self:PauseTheGame()
	
	if self.pauseView == nil then
		self.pauseView = BattlePauseView.new()
		self.pauseView.scene = self
		self.pauseView:Awake()
	end
	self.pauseView:ShowPauseView()
	--print (tostring(self.pause))
end

-- 开始倒计时
function BattleScene:StarCountdownView()
	if self.battleCountdownView == nil then
		self.battleCountdownView = BattleCountdownView.new()
		self.battleCountdownView:Awake(self)
	end
	self.battleCountdownView:ShowView()
	self.battleCountdownView:StarCountdownView()
end

-- 设置暂停的状态
function BaseScene:SetPauseValue()
	--UnityEngine.Time.timeScale = UnityEngine.Time.timeScale == 1 and 0 or 1
	self.pause = not self.pause
end
--通过设置timeScale 暂停游戏
function BaseScene:PauseTheGame()
	UnityEngine.Time.timeScale = UnityEngine.Time.timeScale == 1 and 0 or 1
end
--进入挑战等待界面
function BattleScene:ShowChallengeWaitView(ChallengeInfo)
	local waitView = ChallengeWaitView.new()
	waitView:Awake(self,ChallengeInfo)
end
--进入挑战胜利界面
function BattleScene:ShowChallengeWinView(ChallengeInfo)
	local winView = ChallengeWinView.new()
	winView:Awake(self,ChallengeInfo)
end
--进入挑战失败界面
function BattleScene:ShowChallengeLoseView(ChallengeInfo)
	local loseView = ChallengeLoseView.new()
	loseView:Awake(self,ChallengeInfo)
end
-- 无尽结算界面之后的处理
function BaseScene:EndLessResultFinsh()
	--如果有保存的挑战数据,发送挑战请求
    if TxtFactory:getMemDataCacheTable(TxtFactory.ChallengeInfo) ~= nil then --挑战信息
        self.manager:SendEndRunningChallengeReq(math.floor(self.player:getScoreResult()))
    elseif TxtFactory:getMemDataCacheTable(TxtFactory.ReplyChallengeInfo) ~= nil then
        self.manager:SendEndRunningReplyChallengeReq(math.floor(self.player:getScoreResult())) --应战信息
        --删掉邮件
        local mailTab = {}
        mailTab[1] = tonumber(TxtFactory:getValue(TxtFactory.ReplyChallengeInfo,TxtFactory.REPLYCHALLENGE_MAILID) or 0)
        self.manager:SendEmailReward(mailTab)
    elseif self.battleType == 6  then
		-- 打开界面
		if self.ladderPromotionEndView == nil then
			self.ladderPromotionEndView = LadderPromotionEndView:new()
			self.ladderPromotionEndView:Awake(self)
		end
		self.ladderPromotionEndView:InitData()
	elseif self.battleType == 7 or self.battleType == 8 then
		-- 世界挑战
		self.manager:SendRankChallengeRequest(math.floor(self.player:getScoreResult()))
	else
		self:ChangScene(SceneConfig.buildingScene)
	end
end

--无尽结算界面之后的处理ui 事件方法
function BattleScene:ladderPromotionEndViewUIEvent( fName,... )
	self.ladderPromotionEndView[fName](self.ladderPromotionEndView,...)
end


--回调方法 改变主角速度
function BattleScene:changePlayerSpeed( speed )
	--print ("-------------function BattleScene:changePlayerSpeed( speed ) "..tostring(speed))
	local txt = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	txt[TxtFactory.USER_MOVE_SPEED]=speed
end

--改变中景显示 回调
--base 场景id
function BattleScene:changeMiddleLandscape(base,pos_x)
	if RoleProperty.removeBgScene == true then
		return
	end
	local root = find("middle_landscape")
    for i = 1, root.transform.childCount do
    	PoolFunc:inactiveObj(root.transform:GetChild(i - 1).gameObject)
    end
    
    local txt = TxtFactory:getTable(TxtFactory.SceneThemeTXT)
    local scene_name = txt:GetData(base,TxtFactory.S_SCENE_MID)
	local view = PoolFunc:pickObjByPrefabName('part/landscape/'..scene_name)
	view.gameObject.transform.parent = root.transform
	local old_pos = view.gameObject.transform.localPosition 
	old_pos = UnityEngine.Vector3(pos_x,0,0)
	--print ("-------------function BattleScene:changeMiddleLandscape(base,pos_x) "..tostring(old_pos))
	view.gameObject.transform.localPosition = old_pos
	--view.gameObject.transform:Translate(pos_x - old_pos.x,0,0)
end

--改变远景显示 回调
--base 场景id
function BattleScene:changeFarLandscape(base,pos_x)
	if RoleProperty.removeBgScene == true then
		return
	end
	pos_x = 0 --临时做法，远景不移动
	local root = find("far_landscape")
    for i = 1, root.transform.childCount do
    	PoolFunc:inactiveObj(root.transform:GetChild(i - 1).gameObject)
    end

    local txt = TxtFactory:getTable(TxtFactory.SceneThemeTXT)
    local scene_name = txt:GetData(base,TxtFactory.S_SCENE_FAR)
    --print ("--------------------------changeFarLandscape "..tostring(pos_x)..' '..tostring(scene_name))
	local view = PoolFunc:pickObjByPrefabName('part/landscape/'..scene_name)

	view.gameObject.transform.parent = root.transform
	local old_pos = view.gameObject.transform.localPosition 
	old_pos = UnityEngine.Vector3(0,0,pos_x)
	view.gameObject.transform.localPosition = old_pos
	--view.gameObject.transform:Translate(pos_x - old_pos.x,0,0)
end

--[[进入游戏结束界面 回调]]
function BattleScene:notifyFinish()
	--player.stateMachine:changeState(FailedState.new())

	if self.resultView == nil or self.gameIsOver then
		return
	end
	local battleType = self.resultView:getName()
	if battleType == "BattleEndlessResult" then
    	self.player.stateMachine:changeState(EndlessRunningOutState.new())
	elseif battleType == "SnatchBattleResultView" then
    	self.player.stateMachine:changeState(EndlessRunningOutState.new())
	elseif battleType == "LadderChallengeResultView" then
    	self.player.stateMachine:changeState(EndlessRunningOutState.new())
    elseif battleType == "BattleResultView" then
    	self.player.stateMachine:changeState(FailedState.new())
    end
    
end

--[[更新技能信息 回调]]
function BattleScene:notifySkillInfo(num)
	if self.player:getCaptainPetTypeID() == nil then
		self.uiCtrl:setActiveSkillBtn(false)
	else
		self.uiCtrl:setActiveSkillBtn(true)
	end
	local suitTxt = TxtFactory:getTable(TxtFactory.SuitTXT)
	local config_id =TxtFactory:getTable(TxtFactory.MemDataCache):getPlayerSuit()
    local id = suitTxt:GetData(config_id,TxtFactory.S_SUIT_TYPE)
    
	if tonumber(id) == TxtFactory.S_SUIT_DEFAULT_SUIT then --默认套装
		if num == nil then
			self.uiCtrl:setSkillView('anniu-4','')
		else
			self.uiCtrl:setSkillView(nil,num)
		end
	elseif tonumber(id) == TxtFactory.S_SUIT_CHOPPER_SUIT then --乔巴变大

    	if num == nil then
			self.uiCtrl:setSkillView('anniu-4','')
		else
			self.uiCtrl:setSkillView(nil,num)
		end

	elseif tonumber(id) == TxtFactory.S_SUIT_TEEMO_SUIT then --提莫的隐形
    	

	elseif tonumber(id) == TxtFactory.S_SUIT_FORTUNE_CAT_SUIT then --招财猫的金币雨
		

	elseif tonumber(id) == TxtFactory.S_SUIT_LION_EAR_SUIT then --狮子耳的吼
		

	elseif tonumber(id) == TxtFactory.S_SUIT_FORTUNE_COLOR_SUIT then --招财猫的金币雨

	end

end
--增加分数提示
function BattleScene:showSkillInfo(skillID,petId)
	self.uiCtrl:PlaySkillAmination(skillID,petId)
end
--增加分数提示
function BattleScene:addScore( addVal )
	if addVal >0 then
		self.uiCtrl:SetScoreAdditionValue(addVal)
	end
end

--触发队长技能
function BattleScene:triggerCaptianSkill()
	local pet = self.player:createPet(self.player:getCaptainPetTypeID())
	pet:triggerCaptainSkill()
end

--加入场景切换过渡动画
--加入动画的场景x方向坐标
function BattleScene:addCurtain(pos_x)
	if self.excessView == nil then
		self.excessView = PoolFunc:pickObjByPrefabName('part/landscape/Ui_black')
		--local camera = find ("CameraMove")
		--printf('X ===================='..camera.transform.position.x)
		local old_pos = self.excessView.transform.localPosition
		old_pos.x = pos_x
		self.excessView.transform.localPosition = old_pos
	end
end

--移除场景切换过渡动画
function BattleScene:removeCurtain()
	if self.excessView ~= nil then
		PoolFunc:inactiveObj(self.excessView)
		self.excessView = nil
	end
end
--隐藏显示场景平行光
function BattleScene:setActiveLight(flg)
	
	if self.light ~= nil then
		self.light.gameObject:SetActive(flg)
	end
	if flg == false then
		UnityEngine.RenderSettings.fog = true
		UnityEngine.RenderSettings.fogColor = Color.New(1,238/255,243/255,1)
		UnityEngine.RenderSettings.fogMode = "Linear"
		UnityEngine.RenderSettings.fogStartDistance = 20
		UnityEngine.RenderSettings.fogEndDistance = 80
		UnityEngine.RenderSettings.ambientSkyColor = Color.New(158/255,9/255,55/255,1)
		UnityEngine.RenderSettings.ambientIntensity = 1
	else
		UnityEngine.RenderSettings.fog = true
		UnityEngine.RenderSettings.ambientSkyColor = Color.New(128/255,128/255,128/255,1)
		UnityEngine.RenderSettings.ambientIntensity = 0.65
		UnityEngine.RenderSettings.fogColor = Color.New(148/255,219/255,231/255,1)
		UnityEngine.RenderSettings.fogMode = "Exponential"
		UnityEngine.RenderSettings.fogDensity = 0.0012
	end

end
--载入无尽的下一段路面
function BattleScene:loadNextRoad()
	return self.objectLoader:loadNextRoad()
end
--载入神圣模式路面
function BattleScene:LoaderHolyMap()
	
	self.previousLoader = self.objectLoader --存储原来的loader
	self.previousMemeryPool = self.objectLoader.memeryPool
	self.objectLoader = HolyLoader.new()
	self.objectLoader.memeryPool = self.previousMemeryPool
	self.objectLoader.memeryPool:init() --重新初始化内存池
	self.objectLoader.listener = self.previousLoader.listener
	self.objectLoader:setCamera(self.mainCamera)
	self.objectLoader:Awake()
end
--退出神圣模式路面
function BattleScene:QuitHolyMap()
	self.objectLoader:inactiveObj() --隐藏原来地图上的对象
	self.objectLoader = self.previousLoader --恢复loader
	self.objectLoader.listener = self.previousLoader.listener
	self.objectLoader:setCamera(self.mainCamera)
	self.objectLoader.memeryPool = self.previousMemeryPool
	self.objectLoader.memeryPool:init() --重新初始化内存池
	self.objectLoader.listener:notifySpeedChange(tonumber(self.objectLoader.currentSpeed)) --恢复无尽移动速度
	self.objectLoader.isCreateNexting = false
	--self.objectLoader:Awake()
end


-- 禁止用按钮
function BattleScene:SetCanClickBtn(btn)
    getObjectComponent(self.runningUI,"BoxCollider","UI/UIGame/RightDown/BtnJump").enabled = false
    getObjectComponent(self.runningUI,"BoxCollider","UI/UIGame/LeftDown/BtnSpeedUp").enabled = false
    getObjectComponent(self.runningUI,"BoxCollider","UI/UIGame/LeftDown/BtnAttack").enabled = false

	if btn ~= nil then
		getObjectComponent(btn,"BoxCollider").enabled = true
    	--btn:GetComponent("BoxCollider").enabled = true
    end
    
end
-- 开启按钮
function BattleScene:SetAllClickBtn()
    getObjectComponent(self.runningUI,"BoxCollider","UI/UIGame/RightDown/BtnJump").enabled = true
    getObjectComponent(self.runningUI,"BoxCollider","UI/UIGame/LeftDown/BtnSpeedUp").enabled = true
    getObjectComponent(self.runningUI,"BoxCollider","UI/UIGame/LeftDown/BtnAttack").enabled = true
 	
end
-- 播放鼠标特效
function BattleScene:PlayMouseEffect()
	local uiLua = self.uiEventCtrl
	uiLua.super.PlayMouseEffect(uiLua)
end

-- 打开世界对战结算界面
function BattleScene:OpenAsyncPvpResultView()
	if self.asyncPvpResultView == nil then
		local asyncPvpResultView = AsyncPvpResultView.new()
		asyncPvpResultView:Awake(self)
	end
	
	
end




