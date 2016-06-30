--[[
author:Gaofei
无尽关卡暂停
]]
BattlePauseView = class()
BattlePauseView.scene = nil

BattlePauseView.panel = nil -- 面板

function BattlePauseView:Awake()
	  self.panel = newobject(Util.LoadPrefab("UI/battle/PauseUI"))
    self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
    --self.scene:boundButtonEvents(self.panel)
    
    self.restart = getChildByPath(self.panel,"UI/UIGame/Center/PauseUIResstart")
    self.continue = getChildByPath(self.panel,"UI/UIGame/Center/PauseUIGoOn")
    self.quit = getChildByPath(self.panel,"UI/UIGame/Center/PauseUIGotoMenu")

    AddonClick(self.restart,function ()
        self:RestartGame()
    end)

    AddonClick(self.continue,function ()
        self:GoOn()
    end)

    AddonClick(self.quit,function ()
        self:GotoMenu()
    end)

    self.panel:SetActive(false)
end

--激活暂停界面
function BattlePauseView:ShowPauseView()
    self.scene.effect.gameObject:SetActive(false)
	self.panel:SetActive(true)
end

-- 重新开始游戏
function BattlePauseView:RestartGame()
    local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    --刷新 新手引导进度
    --local battleScene = GetCurrentSceneUI()
    if self.scene.BattleGuideView.isGuideLevel == true  then
        --self.scene:ChangScene(SceneConfig.buildingScene) --新手引导不进入下面步骤
        --TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,-1)
        TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_STORY,'Level_T_1')        
        self.scene:ChangScene(SceneConfig.levelStory)
        return
    end

    self.scene:PauseTheGame()
    self.panel:SetActive(false)
    TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_IS_RESTART,true)
    
    if RoleProperty.corePlayOnly == true then
        self.scene:ChangScene(SceneConfig.testScene)
        return
    end
    --剧情
    self.scene:ChangScene(SceneConfig.buildingScene)
     
end

-- 继续游戏
function BattlePauseView:GoOn()
    self.scene.effect.gameObject:SetActive(true)
    self.panel:SetActive(false)
    -- 开始倒计时
    self.scene:StarCountdownView()
end

-- 返回游戏大厅
function BattlePauseView:GotoMenu()
    self.scene:PauseTheGame()
    self.panel:SetActive(false)

    if RoleProperty.corePlayOnly == true then
        self.scene:ChangScene(SceneConfig.testScene)
        return
    end
    
    self.scene:ChangScene(SceneConfig.buildingScene)
end