--[[
    城建ui逻辑
    author:Huqiuxiang
]]
require "game/scene/logic/farm/FarmManagement"
require "game/scene/logic/building/BuildingManagement"
require "game/scene/logic/farm/BaseBuilding"
require "game/scene/logic/farm/BaseBlock"
require "game/scene/logic/farm/LandMap"
require "game/scene/logic/farm/FunctionBuilding"
require "game/scene/logic/building/PlayerSettingView"
require "game/scene/logic/building/PlayerInfoView"
require "game/scene/logic/building/EmailSystemView"
require "game/scene/logic/task/TaskDialySystemView"
require "game/scene/logic/building/BroadCastView"
require "game/scene/logic/building/BuildingInfo"
require "game/scene/logic/building/BuildingUpgrade"
require "game/scene/logic/pet/PetinfoView"
require "game/scene/logic/guide/GuideManagement"
require "game/scene/logic/guide/GuideBuildingScene"
require "game/scene/logic/guide/GuidieuiViewNew"
require "game/scene/logic/building/SurveyUI"
require "game/scene/UISceneFactory"
require "game/scene/logic/store/StoreView"
require "game/scene/logic/Ladder/LadderMainView"
require "game/scene/logic/friend/FriendView"
require "game/scene/logic/building/SelectModeView"
require "game/scene/logic/Activity/ActivityView"
require "game/scene/logic/building/FunctionOpenView"
require "game/scene/logic/Activity/SveneDayActivityView"
require "game/scene/logic/AsyncPvp/AsyncPvpView"
require "game/scene/logic/farm/BasePetWalk"
require "game/scene/logic/farm/PetWalkManagement"
UIbuildingScene = class (BaseScene)
UIbuildingScene.farmManager = nil --城建功能逻辑类
UIbuildingScene.uiRoot = nil --城建界面父级
UIbuildingScene.sceneTarget = nil -- 城建按钮绑定对象
UIbuildingScene.buildingManager = nil --城建数据管理类
UIbuildingScene.item = nil   --关卡点击物品
UIbuildingScene.itemParent = nil --关卡点击物品父级
UIbuildingScene.BuildingBtnAPanel = nil 
UIbuildingScene.BtnTurnOn = nil  --右下角展开按钮
UIbuildingScene.Building = nil --当前选中建筑的baseBuilding
UIbuildingScene.buildingSelectInfo = nil --建筑选中UI
UIbuildingScene.buildingUpgradeInfo = nil --升级信息按钮
UIbuildingScene.buildingHarvestInfo = nil --收获信息按钮
UIbuildingScene.buildingEnterInfo = nil --建筑进入按钮
UIbuildingScene.buildingInfoLabel = nil --建筑信息label
UIbuildingScene.BtnTurnOff = nil --左下角收起按钮
UIbuildingScene.UIRankingPanel = nil --排行榜面板profeb
UIbuildingScene.BtnTurnOn_Ranking = nil  --排行榜展开按钮
UIbuildingScene.BtnTurnOff_Ranking = nil --排行榜收起按钮
UIbuildingScene.buildBtnActive = false --左下角所有按钮状态
UIbuildingScene.buildBtns = nil  --左下角需要隐藏的所有按钮
UIbuildingScene.mainCamera = nil --主摄像机
UIbuildingScene.UICamera = nil --UI摄像机


UIbuildingScene.playerTopInfoPanel = nil -- 顶部 金币钻石
UIbuildingScene.FunctionOpen = nil -- 功能开启
-- 城建界面其他UI(xhl)
UIbuildingScene.PlayerSettingPanel = nil -- 玩家信息－游戏设置－兑换码界面
UIbuildingScene.PlayerInfoPanel = nil -- 玩家信息面板
UIbuildingScene.EmailSystemPanel = nil -- 邮件系统面板
UIbuildingScene.TaskSystemPanel = nil -- 任务系统面板
UIbuildingScene.BroadCastPanel = nil -- 公告系统面板fjc
UIbuildingScene.cameraView = nil --fjc
UIbuildingScene.UICameraView = nil
UIbuildingScene.surveyUI = nil -- 问卷调查
UIbuildingScene.buildingInfo = nil --建筑信息面板
UIbuildingScene.buildingUpgrade = nil --建筑升级面板
UIbuildingScene.storeView = nil -- 商城界面
UIbuildingScene.friendView = nil --好友界面
UIbuildingScene.sveneDayActivityView = nil --七天活动界面
UIbuildingScene.ladderMainView = nil  -- 天梯界面
UIbuildingScene.activityView = nil  -- 天梯界面
UIbuildingScene.landMapObj = nil -- 地面
UIbuildingScene.asyncPvpView = nil --异步PVP
UIbuildingScene.petWalkManagement = nil -- 宠物行走数据管理类

UIbuildingScene.GuideSystem = nil -- 新手引导
UIbuildingScene.uiDialogue = nil -- 新手对话类
UIbuildingScene.UIChild = nil -- 副场景UI工厂
UIbuildingScene.modelShow = nil -- 共用模型展

UIbuildingScene.ScreenUIParent = nil --场景UI的父类
UIbuildingScene.ScreenUITabel = {} --3D场景中UI的tabel
UIbuildingScene.ScreenNeedDestroyTabel = {} --3D场景中需要删除的tabel
UIbuildingScene.CheckTime = 2 --2秒后删除
UIbuildingScene.FetchId = 0 --收获城建的实例ID
UIbuildingScene.NeedRefresh = false --是否需要刷新城建场景UI

UIbuildingScene.BuildNameParent = nil --城建名字的父类
UIbuildingScene.BuildNameTable = {} --城建名字Table

UIbuildingScene.isBuildScene = true -- 是否是主城界面
UIbuildingScene.buildingZheZhaoView = nil -- 遮罩

function UIbuildingScene:Awake()
    -- 判断是否需要打卡天梯界面
    local battleType = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE)
    if battleType== 4 or battleType== 5 or battleType == 6 then
        self:UIBuilding_LadderBtn()
    end
    self:SetIsBuildScene(true)
    self:initGameObject()
    self.modelShow = ModelShow.new()
    self.modelShow:Init(self)
	self:initUIObject()
    self.UIChild = UISceneFactory.new()
    self.UIChild:Init()
    self.buildingManager = BuildingManagement.new()
    self.buildingManager:Awake(self)
    local hasBuildingData = TxtFactory:getValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_HASDATA)
    --如果没有城建服务器数据发送请求
    mainCamera = find("Camera"):GetComponent(UnityEngine.Camera.GetClassType())     --查找主摄像头
    UICamera = find("CameraUI"):GetComponent(UnityEngine.Camera.GetClassType())     --查找UI摄像头
    self.BuildNameTable = {}
    self:initBuilding()
    self:initWalkPetInBuilding()
    if hasBuildingData == nil then
        self.buildingManager:SendSystemBuilding() --获取城建信息
    else 
        self:CreateBuildings()
    end
      TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_IS_RESTART,false)
       -- 是否放回关卡界面
  --  local battleType = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE)
    if battleType== 1 then
        self:OpenLevelScene()
    elseif battleType == -2 then
       -- self:OpenChapterScene()
    end
end

--启动事件--
function UIbuildingScene:Start()
    --print("-----------------BaseBehaviour Start--->>>-----------------")
    
end

function UIbuildingScene:Update()
    --print("-----------------Desmond Update-->>>-----------------")
    if self.farmManager~= nil then
        self.farmManager:Update()
    end
    if self.UIChild ~= nil then
        self.UIChild:Update()
    end
    if self.petWalk ~= nil and #self.petWalk > 0 then
        for i = 1 , #self.petWalk do
            self.petWalk[i]:Update()
        end
    end
    if self.NeedRefresh then    --需要刷新时候才刷新场景UI
        if #self.ScreenNeedDestroyTabel >0 then --当有需要删除的UI时开始计时
            self.CheckTime = self.CheckTime-UnityEngine.Time.deltaTime
            if self.CheckTime <=0 then--计时功能 当飘字到位置后 在self.CheckTime时间后删除城建场景UI
                self:DestroyUITabel()
            end
        end
    end
end

function UIbuildingScene:FixedUpdate()
	-- body
end



function UIbuildingScene:initGameObject()
    self.uiRoot = newobject(Util.LoadPrefab("UI/battle/UI Root"))
	self.uiRoot.name = 'UI Root'
    -- self.sceneTarget = find("sceneBtnTarget")
    --self.cameraView = self.farmManager.cameraView
    self.sceneTarget = self:AddUIButtonCtrlOnObj(self.uiRoot,"UICtrlBuildingLua")

    -- self:boundButtonEvents()
    TxtFactory:getTable(TxtFactory.SoundManagement):PlayBackGroundSound(SoundType.main)

end

-- 创建在主城中行走的宠物
function UIbuildingScene:initWalkPetInBuilding()
    --local walkPetTab ={13001,13002,13005,13008,13011}
    local walkPetTab ={13001,13002}
    local bornPoints = {4,8}
    -- 初始化宠物行走的数据
    if  self.petWalkManagement == nil then
        self.petWalkManagement = PetWalkManagement.new()
	    self.petWalkManagement:Awake()
    end
    
  --  local  pName = nil
    --local mountTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local walkPetParent = GameObject.New()
    walkPetParent.transform.rotation = Quaternion.Euler(0,90,0)
    walkPetParent.name = "walkPet"
    self.petWalk = {}
    for i = 1 ,#walkPetTab do
        self.petWalk[i]  = BasePetWalk.new()
        
        self.petWalk[i]:Awake(walkPetTab[i],walkPetParent,self.petWalkManagement,bornPoints[i])
       -- petWalk[i] = basePetWalk
       -- pName = "Pet/"
        --print("----------"..walkPetTab[i])
      --  pName = pName .. mountTable:GetData(walkPetTab[i], "MODEL")
       -- local model = newobject(Util.LoadPrefab(pName))
        
       -- model:SetActive(false)
        --local sub = model:AddComponent(BundleLua.GetClassType())
       -- sub.luaName = "BasePetWalk"
       -- LuaShell.setPreParams(model:GetInstanceID(),self.petWalkManagement)--预置构造参数
        
       
       
    
       -- model.transform.localPosition = Vector3(-12.6,0,0)
      --  model.transform.localScale = Vector3.one*5
      --  model.transform.parent = walkPetParent.transform
      --  model:SetActive(true)
        --[[
         -- 修改宠物的材质
        GamePrint(model.name)
        local renders = model:GetComponentsInChildren(UnityEngine.SkinnedMeshRenderer.GetClassType())
        GamePrint("renders  count ==="..renders.Length)
	    for i = 1 , renders.Length do
		     renders[i-1].material.shader = UnityEngine.Shader.Find("Unlit/Depth")
	    end
        ]]--
    end
    
end

function UIbuildingScene:initBuilding()
    if RoleProperty.buildingOpen == true then
        local bg = find("Texture")--self.BuildingBtnAPanel.transform:FindChild("Texture")
        --print ("-------------------function UIbuildingScene:initBuilding() "..tostring(bg))
        bg:SetActive(false)

        self.farmManager = FarmManagement.new() --创建城建逻辑
        self.farmManager.scene = self
        self.farmManager:Awake()
        self.cameraView = self.farmManager.cameraView
        self.landMapObj = find("land")
    else
    end
end
--创建城建建筑，刷新建筑信息，刷新城建名字
function UIbuildingScene:CreateBuildings()
    if self.farmManager ~= nil then
        self.farmManager.farmLand:initBuilding()
    end
    self.buildingManager:UpdateBuildingObjs()
    self:RefreshBuildingNames()
    -- body
    -- 功能开启
    -- self.FunctionOpen = FunctionOpenView.new()
    -- self.FunctionOpen:Init(self)
end

function UIbuildingScene:initUIObject()

    self.BuildingBtnAPanel = self:LoadUI("Building/Building-UI")
    self:boundButtonEvents(self.BuildingBtnAPanel)
   

    -- 玩家信息
    self.PlayerInfoPanel = PlayerInfoView.new()
    self.PlayerInfoPanel:Init(self)
    
    -- 加载遮罩
    self.buildingZheZhaoView =  self:LoadUI("Building/BuildingZheZhaoView")
    
    -- 玩家配置
    --self.PlayerSettingPanel = PlayerSettingView.new()
   -- self.PlayerSettingPanel:Init(self)
    -- 邮件系统
   -- self.EmailSystemPanel = EmailSystemView.new()
   -- self.EmailSystemPanel:Init(self)

    -- 任务系统
   -- self.TaskSystemPanel = TaskDialySystemView.new()
   -- self.TaskSystemPanel:Init(self)

   
    self:SetSurveyBtn()
    --公告板
    -- self.BroadCastPanel = BroadCastView.new()
    -- self.BroadCastPanel:Init(self)

    --self.BtnTurnOn = find("BtnTurnOn_BuildingUI")
    --self.BtnTurnOff = find("BtnTurnOff_BuildingUI")
    self.buildBtns = find("buildBtns")
    self.buildingSelectInfo = find("building_operation_info")
    self.buildingUpgradeInfo = find("building_upgrade")
    self.buildingHarvestInfo = find("building_harvest")
    self.buildingEnterInfo = find("building_enter")
    self.buildingInfoLabel = find("building_infoLabel")
    --self.buildingSelectInfo.gameObject:SetActive(false)
    self:UIBuilding_ShowBuildInfo(false)
    self.BtnTurnOff_Ranking = find("RankingSystem_Close")
    self.ScreenUIParent = find("screenUIParent")
    self.BuildNameParent = find("buildNameParent")
    self:ShowAllBtns(true)
    

    
    -- self.BtnTurnOn_Ranking = find("IstOpen_RankingUI")
    -- self.BtnTurnOff.gameObject:SetActive(false)
    -- self.BtnTurnOff_Ranking.gameObject:SetActive(false)
    -- self.BtnIsTurnOn = 0

    -- 新手引导
    --[[self.GuideSystem = GuideBuildingScene.new()
    self.GuideSystem:init(self)]]

    self.GuideSystem = GuidieuiViewNew.new()
    self.GuideSystem:init(self)
    
end

function UIbuildingScene:SetRedPoint(type,active)
   self.PlayerInfoPanel:SetRedPoint(type,active)
end

function UIbuildingScene:GetMailList()
        --email
     local emailManagement= EmailManagement.new()
    emailManagement:Awake(self)
    emailManagement:SendSystemEmail()
end

function UIbuildingScene:RankingSystem_Close( hide )

    -- 判断是否需要加载对象
    if self.UIRankingPanel == nil then
        self.UIRankingPanel = self:LoadUI("RankingUI")
        self:boundButtonEvents(self.UIRankingPanel)
    end
    
    if self.UIRankingPanel.activeSelf == false then
        self.UIRankingPanel.gameObject:SetActive(true)
    end

    if self.UIRankingPanel.activeSelf == false then
        self.UIRankingPanel.gameObject:SetActive(false)
    end

end

function UIbuildingScene:GetSurveySuccess()
      local userInfo = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    local active = userInfo[TxtFactory.USER_STATUS] ~=1
    return active
end

function UIbuildingScene:SetSurveyBtn()
    local btn = find("Building_Survey")
    btn.gameObject:SetActive(self:GetSurveySuccess())
    local leftGrid = getUIComponent(  self.PlayerInfoPanel,"UI/LeftUp/Waves","UIGrid")     
    leftGrid:Reposition()
	leftGrid.repositionNow = true
end
-- 加载界面
function UIbuildingScene:LoadUI(name)
    local path = "UI/"..name
    local obj = newobject(Util.LoadPrefab(path))
    obj.gameObject.transform.parent = self.uiRoot.gameObject.transform
    obj.gameObject.transform.localPosition = Vector3.zero
    obj.gameObject.transform.localScale = Vector3.one
    return obj
end

-- 界面及场景对象显隐
function UIbuildingScene:SetActive(enable)
    -- self.sceneTarget:SetActive(enable)
    self:SetIsBuildScene(enable)
    self.BuildingBtnAPanel:SetActive(enable)
    self:SetFarmActive(enable)
    self.PlayerInfoPanel:SetActive(enable)
    self.landMapObj.gameObject:SetActive(enable)
    self.buildingZheZhaoView:SetActive(enable)

end
-- 隐藏城建地图以及建筑
function UIbuildingScene:SetFarmActive(enable)
    if self.farmManager ~= nil then
        self.farmManager:SetActive(enable)
    end
end

------------------------------------------------------ 按钮事件 -----------------------------------------------------------
-- 点击建筑事件
function UIbuildingScene:ClickBuild()
    if Input.GetMouseButtonUp(0) then
        self:ClickFunctionBuild()
    end
end

-- 点击功能建筑
function UIbuildingScene:ClickFunctionBuild()
    local ray = self.farmManager.cameraView:ScreenPointToRay (Input.mousePosition)
    local flag,hitinfo = UnityEngine.Physics.Raycast (ray, nil,UnityEngine.Mathf.Infinity,2^UnityEngine.LayerMask.NameToLayer("Default"))    
    if flag == false then
        return
    end   

    if flag == true then
        local obj = LuaShell.getRole(hitinfo.collider.gameObject:GetInstanceID())

        if obj == nil then
            return
        end
        
    end
end


--城建跑酷按钮
function UIbuildingScene:UIBuilding_RunningBtn()
	
    if self.selectModeView ==nil then
        self.selectModeView = SelectModeView.new()
    end
    self.selectModeView:init(self)
    self.selectModeView:SetData(SelectModeType.OneMode)
end
--展开城建按钮时关闭其他次要按钮
function UIbuildingScene:UIBuilding_CloseInfo()
       -- self.UIRankingPanel.gameObject:SetActive(false)
        self:UIBuilding_ShowBuildInfo(false)
end
--点击左下角按钮
function UIbuildingScene:UIBuilding_BtnTurn()
    --print("点击坐下角按钮")
    if self.buildBtnActive == true then
        self:ShowAllBtns(false)
    else
        self:ShowAllBtns(true)
    end
end
--设置左下角所有按钮的状态
function UIbuildingScene:ShowAllBtns(flg)
    --print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~flg:   "..tostring(flg))
    self.buildBtnActive = flg
    self.buildBtns:SetActive(flg)
    if flg == true then
        self:UIBuilding_CloseInfo() --关闭其他按钮
    end
end
--排行榜张开按钮
function UIbuildingScene:UIRanking_BtnTurnOn()
    self.BtnTurnOn_Ranking.gameObject:SetActive(false)
    -- self.BtnTurnOff_Ranking.gameObject:SetActive(true)
end

--排行榜收起按钮
function UIbuildingScene:UIRanking_BtnTurnOff()
    -- self.BtnTurnOff_Ranking.gameObject:SetActive(false)
    --self.BtnTurnOn_Ranking.gameObject:SetActive(true)
    self.UIRankingPanel:SetActive(false)
end

--选中building 显示ui
function UIbuildingScene:showBuildingOperation(building)
    self:ShowAllBtns(false)
    self.Building = building
    self.Building:ShakeObject()
    local build_txt = TxtFactory:getTable(TxtFactory.BuildingTXT) --获取建筑表
    local buildId = building:getBuildingId()
    local name = build_txt:GetData(buildId,TxtFactory.S_BUILDING_NAME)
    local lvl = build_txt:GetBulidLevelById(buildId)
    local t = building:getBuildingOperationType()
    --print ("--------------------function UIbuildingScene:showBuildingOperation() "..tostring(t))
    --self.buildingSelectInfo.gameObject:SetActive(true)
    self:UIBuilding_ShowBuildInfo(true)
    
    if t == nil then --建筑没有开放
        --self.buildingEnterInfo
        self.buildingEnterInfo.gameObject:SetActive(false)
        self.buildingUpgradeInfo.gameObject:SetActive(false)
        self.buildingHarvestInfo.gameObject:SetActive(false)
        return
    end
    self.buildingInfoLabel:GetComponent("UILabel").text = name.."   Lv:"..lvl
    if t == 110 then
        self.buildingInfoLabel.gameObject.transform.localPosition = Vector3(-215,79,0)
    else
        self.buildingInfoLabel.gameObject.transform.localPosition = Vector3(-275,79,0)
    end

    if t%10 == 1 then --取第一位 进入
        self.buildingEnterInfo.gameObject:SetActive(true)
    else
        self.buildingEnterInfo.gameObject:SetActive(false)
    end

    t = math.floor(t/10) --取第二位 升级
    if t%10 == 1 then
        self.buildingUpgradeInfo.gameObject:SetActive(true)
    else
        self.buildingUpgradeInfo.gameObject:SetActive(false)
    end 

    t = math.floor(t/10) --取第二位 收获
    if t%10 == 1 then
        self.buildingHarvestInfo.gameObject:SetActive(true)
    else
        self.buildingHarvestInfo.gameObject:SetActive(false)
    end 

end
--按钮动画
function UIbuildingScene:UIBuilding_ShowBuildInfo(flg)  
    local tween = nil
    tween = self.buildingSelectInfo:GetComponent("TweenPosition")
    if tween ~= nil then
        if flg == false then
            tween:PlayReverse()     --false 收起UI
        else
            tween:PlayForward()     --true 弹出UI
            --[[
            if self.buildingSelectInfo.gameObject.activeSelf then
                tween:PlayReverse()
                tween:PlayForward()
            else
                tween:PlayForward()
            end]]
        end
    end
end
--显示建筑信息
function UIbuildingScene:showBuildingInfo()
     --建筑信息面板
    if self.buildingInfo == nil then
        self.buildingInfo = BuildingInfo.new()
        self.buildingInfo:Init(self)
    end
    

    self.buildingInfo:SetActive(true)
    self.buildingInfo:setInfo(self.Building)
    --self.buildingSelectInfo.gameObject:SetActive(false)
    self:UIBuilding_ShowBuildInfo(false)
end
--关闭建筑信息
function UIbuildingScene:closeBuildingInfo()
    self.buildingInfo:SetActive(false)
    --self.buildingSelectInfo.gameObject:SetActive(true)
    self:UIBuilding_ShowBuildInfo(true)
end
--显示升级建筑面板
function UIbuildingScene:showUpgradeBuilding()
    if self.buildingUpgrade == nil then
        self.buildingUpgrade = BuildingUpgrade.new()
        self.buildingUpgrade:Init(self)
    end
    self.buildingUpgrade:SetActive(true)
    self.buildingUpgrade:setInfo(self.Building)
    --self.buildingSelectInfo.gameObject:SetActive(false)
    self:UIBuilding_ShowBuildInfo(false)
end
--进入建筑按钮
function UIbuildingScene:joinBuilding(mType)

--[[

[11001] = 1, --娃娃机枢纽
	[11002] = 2, --游戏币小屋
	[11003] = 3, --仓库
	[11004] = 4, --萌宠驿站
	[11005] = 5, --萌宠小屋
	[11006] = 6, --萌宠炼金所
	[11007] = 7, --礼品小卖部
	[11008] = 8, --泡泡小酒吧
	[11009] = 9, --萌宠公交站
	[11010] = 10,--萌萌服装店
	[11011] = 11,--天梯竞技场
	[11012] = 12,--夺宝奇兵营地
	[11013] = 13,--萌宠装备屋
    
    ]]--
    if mType == nil then
    local txt = TxtFactory:getTable(TxtFactory.BuildingTXT)
        mType = txt:GetData(self.Building:getBuildingId(),TxtFactory.S_BUILDING_TYPENAME)
    end
    if mType == 12 then --夺宝奇兵
        --self:ChangScene(SceneConfig.snathScene)
        self:OpenSnatchScene()
       
    elseif mType == 13 then -- 萌宠装备屋
        self:UIBuilding_EquipBtn()
    elseif mType == 7 then -- 礼品小卖部
        self:UIBuilding_PetBtn("petMainView_giftBtn")
    elseif mType == 4 then -- 萌宠驿站
        self:UIBuilding_PetBtn("petMainView_myGiftCloseBtn")
    elseif mType == 8 then -- 泡泡小酒吧(无尽)
        --self:UIBuilding_EndlessBtn()
        TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,2)
        --self:ChangScene(SceneConfig.endlessScene)
        self:OpenEndlessScene()
    elseif mType == 9 then -- 萌宠公交站(坐骑)
        self:UIBuilding_MountBtn()
    elseif mType == 10 then -- 萌萌服装店
        self:UIBuilding_SuitBtn()
    elseif mType == 11 then  -- 天梯竞技场
        self:UIBuilding_LadderBtn()
    else
        local word = "该功能暂未开放,敬请期待!!!"
        self:promptWordShow(word)
    end

end
--关闭升级建筑面板
function UIbuildingScene:closeBuildingUpgrade()
    self.buildingUpgrade:SetActive(false)
    --self.buildingSelectInfo.gameObject:SetActive(true)
    self:UIBuilding_ShowBuildInfo(true)
end
--隐藏城建名字
function UIbuildingScene:HideBuildingNames()
    --[[
    local uitween = self.BuildNameParent:GetComponent("UIPlayTween")
    uitween:Play(false)
    self.BuildNameParent:SetActive(false)
    ]]
end
--刷新城建建筑名字位置
--通过城建服务器数据获取城建ID 从城建表获取城建信息 生成城建名字prefab ，根据配表位置 3D转2D
function UIbuildingScene:RefreshBuildingNames()
    
    local buildTab = --TxtFactory:getMemDataCacheTable(TxtFactory.BuildingInfo)
    TxtFactory:getValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_IDTABLE)
    local buildTxt = TxtFactory:getTable(TxtFactory.BuildingTXT) --获取建筑表
    if buildTab == nil then return end
    for k,v in pairs(buildTab) do
        if v == nil or v.tid == nil then
            break
        end
        local pos = self.buildingManager:GetBuildingObj(v.tid):GetNamePointWorldPos() --获取该城建下名字点的时间坐标
        if pos == nil then
            print("pos == nil")
            break
        end
        if self.BuildNameTable[k] == nil then --名字tab没有这对象，需要重新生成
            local nameObj = newobject(Util.LoadPrefab("UI/Building/buildNamePer"))
            nameObj.transform.parent = self.BuildNameParent.transform
            nameObj.gameObject.transform.localScale = Vector3.one
            nameObj.name = v.tid
            local name = nameObj.transform:Find("name")
            name:GetComponent("UILabel").text = buildTxt:GetData(v.tid,TxtFactory.S_BUILDING_NAME)--设置名字
            self.BuildNameTable[k] = nameObj --根据实例ID存放名字对象
        end
        --转换位置
        pos = mainCamera:WorldToScreenPoint(pos) --世界坐标转屏幕坐标
        pos = UICamera:ScreenToWorldPoint(pos) --屏幕坐标转UI坐标
        pos.z = 0;
        self.BuildNameTable[k].transform.position = pos   
    end
    --[[
    self.BuildNameParent:SetActive(true)
    local uitween = self.BuildNameParent:GetComponent("UIPlayTween")
    uitween:Play(true)
    ]]
end

--收获资源
function UIbuildingScene:claimHarvest()
    print("收获资源"..self.Building:getBuildingInstanceId())
    self.buildingManager:BuildingFetch_Req(self.Building:getBuildingInstanceId())
    self.FetchId = self.Building:getBuildingInstanceId()
end
--点击场景UI收获奖励
function UIbuildingScene:FecthHarvest(fecthId)
    self.buildingManager:BuildingFetch_Req(tonumber(fecthId))
    self.FetchId = tonumber(fecthId)
end
--展示收获数字label
function UIbuildingScene:ShowFetchNumLabel(num)
    local numObject = newobject(Util.LoadPrefab("UI/Building/buildingFetchNum"))
    numObject.gameObject.transform.parent = self.ScreenUIParent.transform
    numObject.gameObject.transform.localScale = Vector3.one
    local goldLabel = numObject.gameObject.transform:FindChild("goldLabel")
    goldLabel.gameObject:SetActive(true)
    goldLabel.gameObject:GetComponent("UILabel").text = "X "..num
    local info = self.buildingManager:GetBuildingTabelById(tonumber(self.FetchId)) 
    if info == nil then
        return
    end
    local pos = self.buildingManager:GetBuildingObj(info.tid):getBuildingObjPosition()
    if pos == nil then
        return
    end
    pos = mainCamera:WorldToScreenPoint(pos)
    pos = UICamera:ScreenToWorldPoint(pos)
    pos.z = 0;
    pos.y = pos.y+0.2
    numObject.gameObject.transform.position = pos
    table.insert(self.ScreenNeedDestroyTabel,numObject) 
    self.CheckTime = 2
    self.NeedRefresh = true
end
--检测需要删除的objTabel
function UIbuildingScene:DestroyUITabel() 
    for i=1,#self.ScreenNeedDestroyTabel do
        GameObject.Destroy(self.ScreenNeedDestroyTabel[i].gameObject)
        table.remove(self.ScreenNeedDestroyTabel,i)
    end
    if self.ScreenUIParent.transform.childCount < 1 then
        self.NeedRefresh = false
    end
end
--建筑升级按钮
function UIbuildingScene:buildLevelUp()

    local status,model = self.buildingUpgrade:checkUpgrade()
    --print("城建升级状态："..status,"model"..tostring(model))
    if status == 1 then
        self:promptWordShow("升级条件不满足",model)
        return
    elseif status == 2 then
        self:promptWordShow("最大等级",model)
        return
    end
    self.buildingManager:BuildingUpLv_Req(self.Building:getBuildingInstanceId())
    self:closeBuildingUpgrade()
end


------------------------------------ 玩家信息设置相关 ---------------------------------------
-- 打开角色信息界面
function UIbuildingScene:ShowPlayerSetting(enable)

    if self.PlayerSettingPanel == nil then
         self.PlayerSettingPanel = PlayerSettingView.new()
         self.PlayerSettingPanel:Init(self)
    end
    
    self.PlayerSettingPanel:SetActive(enable)
    
end

-- 切换角色信息界面选项页
function UIbuildingScene:SwitchTable(buttonName)
    self.PlayerSettingPanel:OnBtnClick(buttonName)
end

-- 兑换礼包按钮
function UIbuildingScene:OnExchangeGift()
    self.PlayerSettingPanel:OnExchangeGift()
end

-- 确认礼包按钮
function UIbuildingScene:OnGetGiftOk()
    self.PlayerSettingPanel:OnGetGiftOk()
end

-- 渠道主页按钮
function UIbuildingScene:OnThirdHomePage()
    local fun = function(self, str)
        print("我处理了回调 - " .. str)
    end
    PlatformAction.CallAction(PlatformAction.ActionLogin, "1", self, fun)
end

-- 客服按钮
function UIbuildingScene:OnGMService()
    
end

-- 退出按钮
function UIbuildingScene:OnExit()
    -- 通知服务器下线
    self:SendGameEndNotify()
    Application.Quit()
    
end

-- 游戏音量设置按钮
function UIbuildingScene:OnGameSetSoundBtn()
    self.PlayerSettingPanel:OnSetSound()
end

-- 游戏其他开关设置按钮
function UIbuildingScene:OnGameSetSwitchBtn(buttonName)
    self.PlayerSettingPanel:OnSwitchBtn(buttonName)
end

------------------------------------ 邮件系统相关 ---------------------------------------
-- 显示／隐藏邮件UI
function UIbuildingScene:ShowEmailSystem()
    self.EmailSystemPanel = EmailSystemView.new()
    self.EmailSystemPanel:Init(self)
    self.EmailSystemPanel:SetActive(true)
end


-- 邮件界面按钮
function UIbuildingScene:OnEmailBtnDown(buttonName)
    self.EmailSystemPanel:OnSwitchBtn(buttonName)
end

-- 邮件界面按钮
function UIbuildingScene:GetEmailReward(btn)
    self.EmailSystemPanel:GetReward(btn)
end

------------------------------------ 右下角按钮列表 ---------------------------------------
-- 通过子UI的名字返回子UI的lua对象
function UIbuildingScene:GetUIChild(name)
    return self.UIChild:Get(name)
end

--套装按钮
function UIbuildingScene:UIBuilding_SuitBtn()
    -- UpgradeType.Upgrade = UpgradeType.suit
    -- self:ChangScene(SceneConfig.suitScene)
    self:SetActive(false)
    self:GetUIChild(SceneConfig.suitScene):SetActive(true)
    self:GetUIChild(SceneConfig.suitScene):SetOpenViewClass(self)
end

--萌宠按钮
function UIbuildingScene:UIBuilding_PetBtn(funName)
    -- self:ChangScene(SceneConfig.petScene)
    self:SetActive(false)
    local petScene = self:GetUIChild(SceneConfig.petScene)
    petScene:SetOpenViewClass(self)
    petScene:SetActive(true)
    if funName then
        petScene[funName](petScene)
    end
end

--装备按钮
function UIbuildingScene:UIBuilding_EquipBtn()
    -- self:ChangScene(SceneConfig.equipScene)
    self:SetActive(false)
    self:GetUIChild(SceneConfig.equipScene):SetActive(true)
    self:GetUIChild(SceneConfig.equipScene):SetOpenViewClass(self)
end

--坐骑按钮
function UIbuildingScene:UIBuilding_MountBtn()
    -- self:ChangScene(SceneConfig.mountScene)
     --  测试代码
    local word = "该功能暂未开放,敬请期待!!!"
    self:promptWordShow(word)
    
    return
    --self:SetActive(false)
    --self:GetUIChild(SceneConfig.mountScene):SetActive(true)
end

--无尽按钮
function UIbuildingScene:UIBuilding_EndlessBtn()
    --TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,2)
    --self:ChangScene(SceneConfig.endlessScene)
    if self.selectModeView ==nil then
        self.selectModeView = SelectModeView.new()
    end
    self.selectModeView:init(self)
    self.selectModeView:SetData(SelectModeType.TwoMode)
end

--好友按钮
function UIbuildingScene:UIBuilding_Ranking()
    self.UIRankingPanel:SetActive(true)
end

------------------------------------ 任务系统相关 ---------------------------------------
function UIbuildingScene:ShowTaskSystem()
    -- print("显示任务系统")
     -- 任务系统
    if self.TaskSystemPanel == nil then
        self.TaskSystemPanel = TaskDialySystemView.new()
        self.TaskSystemPanel:Init(self)
    end
    
    self.TaskSystemPanel:creatPanel()
end

function UIbuildingScene:UIBuilding_taskSystemView_backBtn()
    self.TaskSystemPanel:closePanel()
  
end

function UIbuildingScene:UIBuilding_taskSystemView_itemsOnClick(btn)
    self.TaskSystemPanel:itemsOnClick(btn)
end

-- 任务描述面板里的按钮
function UIbuildingScene:UIBuilding_taskSystemView_stateBtn()
    self.TaskSystemPanel:stateBtn()
end
function UIbuildingScene:UIBuilding_taskSystemView_taskingBtn()
    self.TaskSystemPanel:taskingBtn()
end
function UIbuildingScene:UIBuilding_taskSystemView_rewardOkBtn()
    self.TaskSystemPanel:rewardPanel_okBtn()
end

------------------------------------ 新手引导相关 ---------------------------------------
-- 对话结束回调
UIbuildingScene.dialogIsOver = function()
    -- body
end

function UIbuildingScene:DialogueUIPanelShow(tab,item)
    -- local root = find("Camera")
    self.uiDialogue = UIDialogue.new()
    self.uiDialogue.infoTab = tab
    self.uiDialogue:init(self.uiRoot,tab,item)
end

-- 对话框下一页 按钮
function UIbuildingScene:uiDialogue_nextBtn()
    self.uiDialogue:btnOnClick()
end


------------------------------------ 公告系统相关 --------------------------------------- 
function UIbuildingScene:BroadCastSceneClose()
    --self.BroadCastPanel.gameObject:SetActive(false)
    --self.BroadCastPanel:closePanel()
    -- Destroy(self.BroadCastPanel)
end 

-------------------------------------  问卷调查  -------------------------------------------
function UIbuildingScene:OpenSurveyView()
     -- 问卷调查
    if self.surveyUI == nil then
        self.surveyUI = SurveyUI.new()
        self.surveyUI:Init(self)
    end
    if self:GetSurveySuccess() then
        self.surveyUI:ShowSurveyView()
    end 
    
end

-- 问卷调查ui 事件方法
function UIbuildingScene:surveyUIEvent( fName,... )
    --printf('fName=='..fName)
	self.surveyUI[fName](self.surveyUI,...)
end


-------------------------------------   商城界面 ---------------------------------------------
function UIbuildingScene:StoreBtnOnClick()
    --printf("商城功能")
    
	if self.storeView == nil then
		self.storeView = StoreView.new()
		self.storeView:init(self)
	end
    self.storeView:ShowView()
    self.storeView:InitData(1)
end

function UIbuildingScene:storeUIEvent( fName,... )
    self.storeView[fName](self.storeView,...)
end
-------------------------------------   好友界面 ---------------------------------------------
function UIbuildingScene:UIBuilding_FriendBtn()
    --printf("好友界面")
    
    if self.friendView == nil then
        self.friendView = FriendView.new()
        self.friendView:init(self)
    end
    self.friendView:ShowView()
    self.friendView:InitData(1)
end

function UIbuildingScene:FriendUIEvent( fName,... )
    self.friendView[fName](self.friendView,...)
end

-----------------------------------------  天梯功能 --------------------------------------------

function UIbuildingScene:UIBuilding_LadderBtn()
    printf("天梯界面")
    if self.ladderMainView == nil then
        self.ladderMainView = LadderMainView.new()
        self.ladderMainView:Awake(self)
    end
    
    -- 请求天梯信息数据
    self.ladderMainView:SendLadderBaseInfoMsg()
end

function UIbuildingScene:LadderUIEvent(fName,...)
    self.ladderMainView[fName](self.ladderMainView,...)
end

-- ui 事件方法
function UIbuildingScene:LadderStoreUIEvent( fName,... )
	self.ladderMainView.ladderStoreView[fName](self.ladderMainView.ladderStoreView,...)
end

function UIbuildingScene:selectModeViewEvent( fName,... )
	self.selectModeView[fName](self.selectModeView,...)
end

----------------------------------------   七日活动功能  ---------------------------------------------------
function UIbuildingScene:UIBuilding_SveneDayActivityBtn()
    
    if self.sveneDayActivityView == nil then
        self.sveneDayActivityView = SveneDayActivityView.new()
        self.sveneDayActivityView:init(self)
        --self.sveneDayActivityView:InitRewardList()
    end
    
    self.sveneDayActivityView:ShowView()
    
end

function UIbuildingScene:sveneDayActivityViewUIEvent(fName,...)
    self.sveneDayActivityView[fName](self.sveneDayActivityView,...)
end

----------------------------------------  异步PVP界面  ---------------------------------------------------
function UIbuildingScene:OpenAsyncPvpView()
    if self.asyncPvpView == nil then
        self.asyncPvpView = AsyncPvpView.new()
        self.asyncPvpView:init(self)
    end
    self.asyncPvpView:ShowView()
end

----------------------------------------  在线奖励界面 ----------------------------------------------------
function UIbuildingScene:UIBuilding_OnlineActivityBtn()
   -- GamePrint("----------------------------"..tostring(self.PlayerInfoPanel.IsGetOnlineRewad))
    if self.PlayerInfoPanel.IsGetOnlineRewad then
         -- 领取奖励
        --self.PlayerInfoPanel:InitOnlineData()
        self.PlayerInfoPanel:SendSevenLoginRequest()
    end
   
end
-----------------------------------------  活动功能介绍(暂时用) --------------------------------------------

function UIbuildingScene:UIBuilding_ActivityBtn()
    GamePrint("活动按钮")
    if self.activityView == nil then
        self.activityView = ActivityView.new()
        self.activityView:init(self)
    end
    
    self.activityView:ShowView()
    self.activityView:SetActivityIndex(1)
    
end

function UIbuildingScene:ActivityUIEvent(fName,...)
    self.activityView[fName](self.activityView,...)
end

function UIbuildingScene:OpenFunctionGoOK(fName,...)
    --GamePrint("OpenFunctionGoOK")
    self.FunctionOpen:Close()
    local showList = self.FunctionOpen:GetShowList()
    GamePrintTable(showList[1][3])
    if showList ~= nil and #showList >= 1 then
        for _, btnlist in ipairs(showList) do
            for _, btnBox in ipairs(btnlist[3]) do
                btnBox:GetComponent('BoxCollider').enabled = true
                local  uibtn = btnBox:GetComponent('UIButton')
                --GameWarnPrint("btnBox =="..btnBox.name)
                if uibtn ~= nil then
                    uibtn.defaultColor = Color.New(1,1,1,1)--Color.new()
                    uibtn:SetState(0,false)
                end
            end
        end
    end
end
function UIbuildingScene:OpenFunctionGoTo(tarLua,fun)
    --GamePrint("OpenFunctionGoTo="..tostring(self.FunctionOpen:GetGotoBtn()))

    self.FunctionOpen:Close()
    if self.uiDialogue ~= nil and self.uiDialogue.panel.activeSelf == true then
        destroy(self.uiDialogue.panel)
    end
    local showList = self.FunctionOpen:GetShowList()
    if showList ~= nil and #showList >= 1 then

        for _, btnlist in ipairs(showList) do
            for _, btnBox in ipairs(btnlist[3]) do
                btnBox:GetComponent('BoxCollider').enabled = true
                local  uibtn = btnBox:GetComponent('UIButton')
                --GameWarnPrint("btnBox =="..btnBox.name)
                if uibtn ~= nil then
                    uibtn.defaultColor = Color.New(1,1,1,1)--Color.new()
                    uibtn:SetState(0,false)
                end
            end
        end

        local oldfun = self.dialogIsOver
        self.dialogIsOver = function()
            local btn,ty = self.FunctionOpen:GetGotoInfo(showList[1][1])
            if btn ~= nil then
                tarLua[fun](tarLua,btn)
            elseif ty ~= nil then
                self:joinBuilding(ty)
            end
            self.dialogIsOver = oldfun
        end

        local tabSs = string.split(showList[1][2], ",")
        self:DialogueUIPanelShow(tabSs,self)
    end
    
end

-- 设置当前场景的状态
function UIbuildingScene:SetIsBuildScene(isBuildScene)
    self.isBuildScene = isBuildScene
end

-- 打开夺宝奇兵界面
function UIbuildingScene:OpenSnatchScene()
      self:SetActive(false)
      -- 隐藏顶部资源
      self.playerTopInfoPanel:SetActive(false)
      self:GetUIChild(SceneConfig.snathScene):SetActive(true)
      self:GetUIChild(SceneConfig.snathScene):SetSceneTarget(self)
      --self:SetIsBuildScene(false)
end

-- 打开无尽界面
function UIbuildingScene:OpenEndlessScene()
      self:SetActive(false)
      self:GetUIChild(SceneConfig.endlessScene):SetActive(true)
      self:GetUIChild(SceneConfig.endlessScene):SetSceneTarget(self)
end

-- 打开剧情界面(大关卡)
function UIbuildingScene:OpenChapterScene()
    self:SetActive(false)
    self:GetUIChild(SceneConfig.storyScene):SetActive(true)
    self:GetUIChild(SceneConfig.storyScene):SetSceneTarget(self)
    --self:SetIsBuildScene(false)
end

-- 打开剧情界面(小关卡)
function UIbuildingScene:OpenLevelScene()
    self:SetActive(false)
    self:GetUIChild(SceneConfig.selectChapterScene):SetActive(true)
    self:GetUIChild(SceneConfig.selectChapterScene):SetSceneTarget(self)
    self:GetUIChild(SceneConfig.selectChapterScene):SetSceneTargetCameraId(1006)
    --self:SetIsBuildScene(false)
end

-- 通知服务器下线
function UIbuildingScene:SendGameEndNotify()
	local json = require "cjson"
    local userTable = TxtFactory:getTable(TxtFactory.UserTXT)
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = charinfo_pb.GameEndNotify()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.GameEndNotify,
              data = strr, -- strr
             }
   -- MsgFactory:createMsg(MsgCode.SevenLoginResponse,self)
    NetManager:SendPost(NetConfig.STORE_BUYITEM,json.encode(param)..'|'..userTable:getValue('Username')..':'..userTable:getValue('access_token'))
end
