--[[
author:赵名飞
挑战VS
]]

ChallengeVsView = class()
ChallengeVsView.curretView = nil --上级界面
ChallengeVsView.panel = nil -- 界面preb
ChallengeVsView.friendInfo = nil --对战信息
ChallengeVsView.startTime = nil --界面打开时间
ChallengeVsView.modelShow = nil
function ChallengeVsView:Awake(CurretView,friendInfo)
	self.curretView = CurretView
	self.friendInfo = friendInfo
	self.panel = newobject(Util.LoadPrefab("UI/ChallengeUI/ChallengeVSUI"))
	self.panel.transform.parent = self.curretView.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one 
    self.startTime=UnityEngine.Time.time
    self.modelShow = find("ChallengeModelShow")
	self:Resrefh()

end
function ChallengeVsView:Resrefh()
	local charIconTxt = TxtFactory:getTable(TxtFactory.CharIconTXT)
	local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	local player = LuaShell.getRole(LuaShell.DesmondID) 
	local leftIcon = find("leftInfo")
	local iconId = UserInfo[TxtFactory.USER_ICON]
    if charIconTxt:GetLineByID(iconId) ~= nil then
        leftIcon.gameObject:GetComponent("UISprite").spriteName = charIconTxt:GetData(iconId, "ICON")
    end
    local name = leftIcon.gameObject.transform:FindChild("l_name"):GetComponent("UILabel")
    name.text = UserInfo[TxtFactory.USER_NAME]

    local RightIcon = find("rightInfo")
    RightIcon.gameObject:GetComponent("UISprite").spriteName = 
    TxtFactory:getTable(TxtFactory.CharIconTXT):GetData(self.friendInfo["icon"] == 0 and 101003 or self.friendInfo["icon"], "ICON")
    local name = RightIcon.gameObject.transform:FindChild("l_name"):GetComponent("UILabel")
    name.text = GetFriendNameByNick(self.friendInfo["name"])
    self:showModels()
    --[[
    local btn_Ok = find("ChallengeWait_btnOk")
    local uie = btn_Ok.gameObject:GetComponent('UIEventListener')
    if uie == nil then
        uie = btn_Ok.gameObject:AddComponent(UIEventListener.GetClassType())
    end
    uie.onClick = function()
    	self.scene:ChangScene(SceneConfig.buildingScene)
    end
    ]]
end
function ChallengeVsView:showModels()
    for i=0, self.modelShow.transform.childCount-1 do
            self.modelShow.transform:GetChild(i).gameObject:SetActive(false)
    end
    --自己的信息
    local userTable = TxtFactory:getTable(TxtFactory.UserTXT)
    local mountTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local suitTable = TxtFactory:getTable(TxtFactory.SuitTXT)
    local pName = "Player/"
    local suit_id = TxtFactory:getTable(TxtFactory.MemDataCache):getPlayerSuit()
    local charId = suitTable:GetData(suit_id, TxtFactory.S_SUIT_TYPE)
    if charId ~= nil then
        local uInfo = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
        local modelName = suitTable:GetModelName(uInfo[TxtFactory.USER_SEX], charId)
        pName = pName .. modelName .."_generic"
    end
    self:createModel(pName,Vector3(-3,-0.9,200),Vector3(1.5,1.5,1.5),Quaternion.Euler(0,130,0))
    local  petTab = TxtFactory:getTable(TxtFactory.MemDataCache):getCurPetTab()
    local petPosition = {Vector3(-1.6,1.66,200),Vector3(-4.33,-0.7,200),Vector3(-1.56,-0.7,200)}
    local petScale = {Vector3(1.5,1.5,1.5),Vector3(1.5,1.5,1.5),Vector3(1.2,1.2,1.2)}
    local petRotation = {Quaternion.Euler(0,176,0),Quaternion.Euler(0,130,0),Quaternion.Euler(0,175,0)}
    for i =1, #petTab do
        local ctid = tonumber(string.sub(tostring(petTab[i]),1,-5)) 
        if ctid ~= nil then
            pName = "Pet/"
            pName = pName .. mountTable:GetData(ctid, "MODEL")
            self:createModel(pName,petPosition[i],petScale[i],petRotation[i])
        end
    end
    --对方的信息
    pName = "Player/"
    --套装ID，性别
    local suit_id = TxtFactory:getTable(TxtFactory.MemDataCache):getPlayerSuit()
    local charId = suitTable:GetData(suit_id, TxtFactory.S_SUIT_TYPE)
    if charId ~= nil then
        local uInfo = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
        local modelName = suitTable:GetModelName(uInfo[TxtFactory.USER_SEX], charId)
        pName = pName .. modelName .."_generic"
    end
    self:createModel(pName,Vector3(3,-0.9,200),Vector3(1.5,1.5,1.5),Quaternion.Euler(0,130,0))
    --飞行宠物、
    local petTab = {}--TxtFactory:getTable(TxtFactory.MemDataCache):getCurPetTab()
    petPosition = {Vector3(4.5,1.66,200),Vector3(1.75,-0.7,200),Vector3(4.48,-0.7,200)}
    for i =1, #petTab do
        local ctid = tonumber(string.sub(tostring(petTab[i]),1,-5)) 
        if ctid ~= nil then
            pName = "Pet/"
            pName = pName .. mountTable:GetData(ctid, "MODEL")
            self:createModel(pName,petPosition[i],petScale[i],petRotation[i])
        end
    end
end
--用于创建模型
function ChallengeVsView:createModel(pName,p,s,r)
    local model = newobject(Util.LoadPrefab(pName))
    SetGameObjectLayer(model,self.modelShow)
    model.transform.parent = self.modelShow.transform
    model.transform.localPosition = p
    model.transform.localScale = s
    model.transform.localRotation = r
end
function ChallengeVsView:Update()
    if UnityEngine.Time.time - self.startTime > 4 then
        --self.curretView:join()
        coroutine.start(self.curretView.join,self.curretView)
        self.curretView.scene.VsView = nil
    end
end

