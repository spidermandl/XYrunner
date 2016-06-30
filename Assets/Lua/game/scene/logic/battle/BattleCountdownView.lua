--[[
author:Gaofei
倒计时
]]
BattleCountdownView = class()
BattleCountdownView.scene = nil

BattleCountdownView.panel = nil -- 面板

BattleCountdownView.count = 1 -- 计时器
BattleCountdownView.lastTime = 0 --上一帧时间
BattleCountdownView.startTime = 0 --开始时间
BattleCountdownView.isEnable = false
function BattleCountdownView:Awake(scene)
    self.scene = scene
	self.panel = newobject(Util.LoadPrefab("UI/battle/CountdownCiew"))
    self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
	self.timeSprite =  self.panel.transform:Find("Anchors/UI/Num"):GetComponent("UISprite")
	

end

function BattleCountdownView:StarCountdownView()
    self.isEnable = true
	self.count = 3
	self:StarCountdown()
end

-- 开始在线活动时间倒计时
function BattleCountdownView:StarCountdown()
    --GamePrint("BattleCountdownView:StarCountdown   "..self.count)
    self.startTime = 0
    self.lastTime = UnityEngine.Time.realtimeSinceStartup
    -- 设置时间
    self.timeSprite.spriteName = "daoji"..self.count
    self.count = self.count - 1
    --coroutine.start(self.SetCountdownValue, self)
end
function BattleCountdownView:Update()
    if self.isEnable == false then
        return
    end
    local daltaTime = UnityEngine.Time.realtimeSinceStartup - self.lastTime --取得一帧的时长
    self.lastTime = UnityEngine.Time.realtimeSinceStartup
    self.startTime = self.startTime + daltaTime
    if self.startTime >= 1 then --  一秒
        self:SetCountdownValue()
    end
end
-- 每一秒调用一次 刷新时间
function BattleCountdownView:SetCountdownValue()
    if self.count == 0 then
        -- 结束
        self:HiddenView()
        self.scene.effect.gameObject:SetActive(true)
        self.scene:PauseTheGame()
        return
    end
    --coroutine.wait(1)
    self:StarCountdown()
end

--激活暂停界面
function BattleCountdownView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function BattleCountdownView:HiddenView()
    self.isEnable = false
	self.panel:SetActive(false)
end