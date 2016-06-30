--[[
author:gaofei
异步pvp 战斗结束界面
]]

AsyncPvpResultView = class()
AsyncPvpResultView.scene = nil -- 父级场景
AsyncPvpResultView.panel = nil -- 界面preb

function AsyncPvpResultView:Awake(targetScene)
    self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/AsyncPvp/AsyncPvpResultView"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one 
    
    local okBtn = self.panel.transform:Find("Anchors/UI/OkBtn")
	local okBtn_Listener= okBtn:GetComponent("UIEventListener")
	if okBtn_Listener == nil then
		okBtn_Listener = okBtn.gameObject:AddComponent(UIEventListener.GetClassType())
	end
	okBtn_Listener.onClick = function( ... )
		self.scene:ChangScene(SceneConfig.buildingScene)
	end
    
    -- 根据结果初始化界面
    self:ChallengeSuccess()
end

-- 挑战胜利
function AsyncPvpResultView:ChallengeSuccess()
    -- 自己的信息
    local rival_name= TxtFactory:getValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_NICKNAME)
	local rival_icon=TxtFactory:getValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_ICON)
	--local rival_actor=TxtFactory:getValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_ACATOR)
	--local rival_actors=TxtFactory:getValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_ACATORS)
	--local rival_curpets=TxtFactory:getValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_CURPETS)
	--local rival_pets=TxtFactory:getValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_BINPETS)
    
    local successObj = self.panel.transform:Find("Anchors/UI/Success")
    successObj.gameObject:SetActive(true)
    local myinfo_icon = successObj:Find("MyInfo"):GetComponent("UISprite")
    local myinfo_name = successObj:Find("MyInfo/l_name"):GetComponent("UILabel")
    local myinfo_score = successObj:Find("BattleInfo/Score"):GetComponent("UILabel")
    
    local charIconTxt = TxtFactory:getTable(TxtFactory.CharIconTXT)
    local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	local iconId = UserInfo[TxtFactory.USER_ICON]
    if charIconTxt:GetLineByID(iconId) ~= nil then
        myinfo_icon.spriteName = charIconTxt:GetData(iconId, "ICON")
    end
    myinfo_name.text = UserInfo[TxtFactory.USER_NAME]
    myinfo_score.text = "1638000"
    
    -- 对手的信息
    local rivalInfo_icon = successObj:Find("RivalInfo"):GetComponent("UISprite")
    local rivalInfo_name = successObj:Find("RivalInfo/l_name"):GetComponent("UILabel")
    local rivalInfo_score = successObj:Find("RivalInfo/Score"):GetComponent("UILabel")
    rivalInfo_icon.spriteName = charIconTxt:GetData(rival_icon, "ICON")
    rivalInfo_name.text = GetFriendNameByNick(rival_name)
    rivalInfo_score.text = "965000"
end

-- 挑战失败
function AsyncPvpResultView:ChallengeFail()
    local failObj = self.panel.transform:Find("Anchors/UI/Fail")
    failObj.gameObject:SetActive(true)
    local myinfo_icon = failObj:Find("MyInfo"):GetComponent("UISprite")
    local myinfo_name = failObj:Find("MyInfo/l_name"):GetComponent("UILabel")
    local myinfo_score = failObj:Find("BattleInfo/Score"):GetComponent("UILabel")
    -- 对手的信息
    local rivalInfo_icon = failObj:Find("RivalInfo"):GetComponent("UISprite")
    local rivalInfo_name = failObj:Find("RivalInfo/l_name"):GetComponent("UILabel")
    local rivalInfo_score = failObj:Find("RivalInfo/Score"):GetComponent("UILabel")
end

-- 挑战未结束
function  AsyncPvpResultView:ChallengeUnfinished()
    local unfinishedObj = self.panel.transform:Find("Anchors/UI/Unfinished")
    unfinishedObj.gameObject:SetActive(true)
    local myinfo_icon = unfinishedObj:Find("MyInfo"):GetComponent("UISprite")
    local myinfo_name = unfinishedObj:Find("MyInfo/l_name"):GetComponent("UILabel")
    local myinfo_score = unfinishedObj:Find("BattleInfo/Score"):GetComponent("UILabel")
    -- 对手的信息
    local rivalInfo_icon = unfinishedObj:Find("RivalInfo"):GetComponent("UISprite")
    local rivalInfo_name = unfinishedObj:Find("RivalInfo/l_name"):GetComponent("UILabel")
    local rivalInfo_score = unfinishedObj:Find("RivalInfo/Score"):GetComponent("UILabel")
end


