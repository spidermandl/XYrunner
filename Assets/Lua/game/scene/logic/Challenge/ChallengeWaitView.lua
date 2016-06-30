--[[
author:赵名飞
挑战等待
]]

ChallengeWaitView = class()
ChallengeWaitView.scene = nil --对应场景
ChallengeWaitView.panel = nil -- 界面preb
ChallengeWaitView.challengeInfo = nil --对战信息
function ChallengeWaitView:Awake(targetScene,challengeInfo)
	self.scene = targetScene
	self.challengeInfo = challengeInfo
	self.panel = newobject(Util.LoadPrefab("UI/ChallengeUI/ChallengeWaitUI"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one 
	self:Resrefh()
end
function ChallengeWaitView:Resrefh()
	local charIconTxt = TxtFactory:getTable(TxtFactory.CharIconTXT)
	local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	local player = LuaShell.getRole(LuaShell.DesmondID) 
	local leftIcon = find("leftInfo")
	local iconId = UserInfo[TxtFactory.USER_ICON]
    if charIconTxt:GetLineByID(iconId) ~= nil then
        leftIcon.gameObject:GetComponent("UISprite").spriteName = charIconTxt:GetData(iconId, "ICON")
    end
    local leftScore = leftIcon.gameObject.transform:FindChild("l_score"):GetComponent("UILabel")
    leftScore.text = math.floor(player:getScoreResult())
    local name = leftIcon.gameObject.transform:FindChild("l_name"):GetComponent("UILabel")
    name.text = UserInfo[TxtFactory.USER_NAME]
    local RightIcon = find("rightInfo")
    RightIcon.gameObject:GetComponent("UISprite").spriteName = 
    TxtFactory:getTable(TxtFactory.CharIconTXT):GetData(self.challengeInfo.icon == 0 and 101003 or self.challengeInfo.icon, "ICON")
    local name = RightIcon.gameObject.transform:FindChild("l_name"):GetComponent("UILabel")
    name.text = GetFriendNameByNick(self.challengeInfo.nickname)


    local btn_Ok = find("ChallengeWait_btnOk")
    local uie = btn_Ok.gameObject:GetComponent('UIEventListener')
    if uie == nil then
        uie = btn_Ok.gameObject:AddComponent(UIEventListener.GetClassType())
    end
    uie.onClick = function()
    	self.scene:ChangScene(SceneConfig.buildingScene)
    end
end

