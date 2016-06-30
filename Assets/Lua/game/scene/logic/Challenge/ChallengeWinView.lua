--[[
author:赵名飞
挑战胜利
]]

ChallengeWinView = class()
ChallengeWinView.scene = nil --对应场景
ChallengeWinView.panel = nil -- 界面preb
ChallengeWinView.challengeInfo = nil --对战信息
ChallengeWinView.modelShow = nil -- 模型秀
function ChallengeWinView:Awake(targetScene,challengeInfo)
	self.scene = targetScene
	self.challengeInfo = challengeInfo
	self.panel = newobject(Util.LoadPrefab("UI/ChallengeUI/ChallengeWinUI"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one 
    self.modelShow = ModelShow.new()
    self.modelShow:Init(self.scene)
	self:Resrefh()
end
function ChallengeWinView:Resrefh()
	
	local charIconTxt = TxtFactory:getTable(TxtFactory.CharIconTXT)
	local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	local player = LuaShell.getRole(LuaShell.DesmondID) 
	local leftIcon = find("leftInfo")
	local iconId = UserInfo[TxtFactory.USER_ICON]
    if charIconTxt:GetLineByID(iconId) ~= nil then
        leftIcon.gameObject:GetComponent("UISprite").spriteName = charIconTxt:GetData(iconId, "ICON")
    end
    local leftScore = find("l_winerScore")
    leftScore:GetComponent("UILabel").text = self.challengeInfo["dst_score"]
    local name = leftIcon.gameObject.transform:FindChild("l_name"):GetComponent("UILabel")
    name.text = UserInfo[TxtFactory.USER_NAME]

    local RightIcon = find("rightInfo")
    RightIcon.gameObject:GetComponent("UISprite").spriteName = 
    TxtFactory:getTable(TxtFactory.CharIconTXT):GetData("101003", "ICON")
    local friendName = TxtFactory:getValue(TxtFactory.ReplyChallengeInfo,TxtFactory.REPLYCHALLENGE_FRIENDNAME)
    local name = RightIcon.gameObject.transform:FindChild("l_name"):GetComponent("UILabel")
    name.text = GetFriendNameByNick(friendName)
    local leftScore = find("l_score")
    leftScore:GetComponent("UILabel").text = self.challengeInfo["src_score"]
    self.modelShow:ChooseCharacter(UserInfo[TxtFactory.USER_SEX])
    local btn_Ok = find("ChallengeWin_btnOk")
    local uie = btn_Ok.gameObject:GetComponent('UIEventListener')
    if uie == nil then
        uie = btn_Ok.gameObject:AddComponent(UIEventListener.GetClassType())
    end
    uie.onClick = function()
    	self.scene:ChangScene(SceneConfig.buildingScene)
    end
end

