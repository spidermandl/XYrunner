--[[
author:gaofei
异步pvp vs界面
]]

AsyncPvpVsView = class()
AsyncPvpVsView.curretView = nil --上级界面
AsyncPvpVsView.panel = nil -- 界面preb
AsyncPvpVsView.startTime = nil --界面打开时间
AsyncPvpVsView.waitObj = nil -- 请稍等对象
AsyncPvpVsView.modelShow = nil
function AsyncPvpVsView:Awake(CurretView)
	self.curretView = CurretView
	self.panel = newobject(Util.LoadPrefab("UI/AsyncPvp/AsyncPvpVsView"))
	self.panel.transform.parent = self.curretView.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one 
    self.startTime=UnityEngine.Time.time
    self.waitObj = self.panel.transform:Find("Anchors/bottomInfo/Wait").gameObject
   -- self.modelShow = find("ChallengeModelShow")
    self.modelShow =  self.panel.transform:Find("Anchors/ChallengeModelShow")
	--self:Resrefh()
    for i=0, self.modelShow.transform.childCount-1 do
         self.modelShow.transform:GetChild(i).gameObject:SetActive(false)
    end

    self:ResrefhMyInfo()
    -- 播放特效
    self.sousuo = self.panel.transform:Find("Anchors/sousuo").gameObject
    self.sousuo.transform.localPosition = UnityEngine.Vector3(180,-130,0)
    self.sousuo.transform.localScale = UnityEngine.Vector3(30,30,30)
    SetEffectOrderInLayer(self.sousuo,100)
end

-- 刷新自己的信息
function AsyncPvpVsView:ResrefhMyInfo()
	local charIconTxt = TxtFactory:getTable(TxtFactory.CharIconTXT)
	local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	local player = LuaShell.getRole(LuaShell.DesmondID) 
	--local leftIcon = find("leftInfo")
    local leftIcon =  self.panel.transform:Find("Anchors/bottomInfo/leftInfo")
	local iconId = UserInfo[TxtFactory.USER_ICON]
    if charIconTxt:GetLineByID(iconId) ~= nil then
        leftIcon.transform:GetComponent("UISprite").spriteName = charIconTxt:GetData(iconId, "ICON")
    end
    local name = leftIcon.gameObject.transform:FindChild("l_name"):GetComponent("UILabel")
    name.text = UserInfo[TxtFactory.USER_NAME]
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
   -- self:showModels()
   coroutine.start(self.ResrefhRivalInfo,self)
end

-- 添加对手信息

function AsyncPvpVsView:ResrefhRivalInfo()

    
	local rival_name= TxtFactory:getValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_NICKNAME)
	local rival_icon=TxtFactory:getValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_ICON)
	local rival_actor=TxtFactory:getValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_ACATOR)
	local rival_actors=TxtFactory:getValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_ACATORS)
	local rival_curpets=TxtFactory:getValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_CURPETS)
	local rival_pets=TxtFactory:getValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_BINPETS)
    
    local gameConfigTXT = TxtFactory:getTable(TxtFactory.GameConfigTXT)
    local minTime = tonumber(gameConfigTXT:GetData(1011,"CONFIG1"))
    local maxTime = tonumber(gameConfigTXT:GetData(1011,"CONFIG2"))
    math.randomseed(os.time())   
    local waitTime = math.random(minTime,maxTime)
    coroutine.wait(waitTime)
    --对方的信息
    self.waitObj:SetActive(false)
    self.sousuo:SetActive(false)
   -- local RightIcon = find("rightInfo")
    local RightIcon =  self.panel.transform:Find("Anchors/bottomInfo/rightInfo")
    RightIcon.gameObject:GetComponent("UISprite").spriteName = TxtFactory:getTable(TxtFactory.CharIconTXT):GetData(rival_icon, "ICON")
    local name = RightIcon.gameObject.transform:FindChild("l_name"):GetComponent("UILabel")
    name.text = GetFriendNameByNick(rival_name)
    
    local mountTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local suitTable = TxtFactory:getTable(TxtFactory.SuitTXT)
        --对方的信息
    pName = "Player/"
    --套装ID，性别
    --local suit_id = TxtFactory:getTable(TxtFactory.MemDataCache):getPlayerSuit()
    local charId = suitTable:GetData(rival_actor, TxtFactory.S_SUIT_TYPE)
    if charId ~= nil then
        local uInfo = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
        local modelName = suitTable:GetModelName(uInfo[TxtFactory.USER_SEX], charId)
        pName = pName .. modelName .."_generic"
    end
    self:createModel(pName,Vector3(3,-0.9,200),Vector3(1.5,1.5,1.5),Quaternion.Euler(0,130,0))
    
    local petTab = {}--TxtFactory:getTable(TxtFactory.MemDataCache):getCurPetTab()
    for i = 1,#rival_curpets do
        if rival_curpets[i] ~= 0 then
            table.insert(petTab,rival_pets[rival_curpets[i]].tid)
        end
    end
    local petPosition = {Vector3(4.5,1.66,200),Vector3(1.75,-0.7,200),Vector3(4.48,-0.7,200)}
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
    -- 等待一秒钟 进入跑酷
    coroutine.wait(1)
    coroutine.start(self.curretView.join,self.curretView)
    self.curretView.scene.VsView = nil
end
--用于创建模型
function AsyncPvpVsView:createModel(pName,p,s,r)
    local model = newobject(Util.LoadPrefab(pName))
    SetGameObjectLayer(model,self.modelShow)
    model.transform.parent = self.modelShow.transform
    model.transform.localPosition = p
    model.transform.localScale = s
    model.transform.localRotation = r
end

function AsyncPvpVsView:Update()
  
end

