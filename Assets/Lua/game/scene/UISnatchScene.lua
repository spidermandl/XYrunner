--UISnatchScene
--[[
夺宝奇兵
gaofei
]]

require "game/scene/logic/snatch/SnatchMainView"
require "game/scene/logic/snatch/SnatchExplainView"
require "game/scene/logic/snatch/SnatchRivalInfoView"
require "game/scene/logic/snatch/SnatchStoreView"
require "game/scene/logic/snatch/SnatchStrongholdView"
require "game/scene/logic/snatch/SnatchIntegralView"
require "game/scene/logic/snatch/SnatchPetDefendView"
require "game/scene/logic/store/StoreManagement"	--商城数据类

UISnatchScene = class (BaseScene)
UISnatchScene.uiRoot = nil -- ui的父类
UISnatchScene.uiCamera = nil --ui camera
UISnatchScene.mainCamera = nil
UISnatchScene.sceneTarget = nil -- 界面监听
UISnatchScene.snatchMianView = nil -- 夺宝主界面
UISnatchScene.snatchRivalInfoView = nil -- 夺宝对手的信息
UISnatchScene.snatchExplainView = nil -- 夺宝说明界面
UISnatchScene.snatchStoreView = nil -- 夺宝商城界面
UISnatchScene.snatchStrongholdView = nil -- 据点信息
UISnatchScene.snatchIntegralView = nil -- 积分信息
UISnatchScene.snatchPetDefendView = nil -- 设置萌宠防守界面
UISnatchScene.storeManager = nil --商城数据类
UISnatchScene.rivalInfoObjectPatent = nil -- 用于存放可以攻打的据点
UISnatchScene.snatchScene = nil -- 夺宝的3d场景
UISnatchScene.sceneParent = nil -- 打开这个界面的场景

function UISnatchScene:Awake()
	--self.uiRoot = newobject(Util.LoadPrefab("UI/battle/UI Root"))
	--self.uiRoot.name = 'UI Root'
	self.mainCamera = find("Camera"):GetComponent(UnityEngine.Camera.GetClassType())
	SetCameraParam(1005,self.mainCamera)
	
	self.uiRoot = find("UI Root")
	self.sceneTarget = self:AddUIButtonCtrlOnObj(self.uiRoot,"UICtrlSnatchLua")
	--self.sceneTarget:Awake()
	self.uiCamera = find("CameraUI"):GetComponent(UnityEngine.Camera.GetClassType())
	self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	
	-- 加载3d场景
	self.snatchScene = newobject(Util.LoadPrefab("Level/screenshot_cave"))
	
	self.rivalInfoObjectPatent =  GameObject.New() -- 用于存放可以攻打的据点
	self.rivalInfoObjectPatent.name = "StrongholdObject"
	
	-- 存储动态的tabel
	if TxtFactory:getMemDataCacheTable(TxtFactory.SnatchInfo) == nil then
		local snatch_info = {}
		local memCache = TxtFactory:getTable("MemDataCache")
  		memCache:setTable(TxtFactory.SnatchInfo,snatch_info)
	end
	-- 请求夺宝信息
	self:SendExplorerDataRequestMessage()
	
	self.storeManager = StoreManagement.new()
    self.storeManager:Awake(self)
	self:boundButtonEvents(self.uiRoot)
end



-- 返回按钮
function UISnatchScene:BackBtnOnClick()
	--printf('返回主界面')
	--self:ChangScene(SceneConfig.buildingScene)
	self:SetActive(false)
	--self.sceneParent:SetIsBuildScene(true)
	self.sceneParent:SetActive(true)
	self.sceneParent.playerTopInfoPanel:SetActive(true)
	-- 将摄像机参数还原
	SetCameraParam(1006,self.mainCamera)
end

-- 刷新对手
function UISnatchScene:RefreshRivalBtnOnClick()
	--printf("刷新对手")
	if not(self.snatchMianView:IsRefreshStrongholdInfo()) then
		self:promptWordShow("金币不足,不可以刷新")
		return
	end
	
	self.snatchMianView:SendExplorerStartRequestMessage()
end

-- 套装
function UISnatchScene:SuitBtnOnClick()
	--printf("套装")
end

-- 萌宠
function UISnatchScene:PetBtnOnClick()
	--printf("萌宠")
end

-- 坐骑
function UISnatchScene:MountBtnOnClick()
	--printf("坐骑")
	
end

-- 装备
function UISnatchScene:EquipBtnOnClick()
	--printf("装备")
end

function UISnatchScene:Update()
	
	if self:uiSelected() == true then --选中ui
        return
    end
	if (Input.GetMouseButtonDown(0)) then
		self:RivalInfoOnClick()
	end
end

-- 请求夺宝奇兵信息 (请求)
function UISnatchScene:SendExplorerDataRequestMessage()
    local json = require "cjson"
	--local msg = {}
    --local strr = json.encode(msg)
	 local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = explorer_pb.ExplorerDataRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.ExplorerDataRequest,
              data = strr, -- strr
             }
    if  self.userTable == nil then
		 self.userTable = TxtFactory:getTable("UserTXT")
	end
    MsgFactory:createMsg(MsgCode.ExplorerDataResponse,self)
    NetManager:SendPost(NetConfig.SURVEY,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 请求夺宝奇兵信息 (回复)
function UISnatchScene:ExplorerDataResponseMessageListen(info)
	local json = require "cjson"
  	local tab = json.decode(info.data)
	  
	TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_SCORE,tab.explorer_score)
	TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_GOLD,tab.explorer_gold)
	TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_NUM,tab.explorer_num)
	TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_REFER_NUM,tab.refer_num)
	TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_REFER_MAXNUM,tab.explorer_maxnum)
	TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_BUY_NUM,tab.buy_num)
	
	self:OpenSnatchMainView()
end

--------------------------------------   主UI模块    -----------------------------------
-- 判断点击的是哪一个据点
function UISnatchScene:RivalInfoOnClick()
	
	local ray = self.mainCamera:ScreenPointToRay(Input.mousePosition)
	local flag,hitinfo = UnityEngine.Physics.Raycast(ray,nil,500)

	if flag  then
		--printf(hitinfo.collider.gameObject.name)
		local objName = lua_string_split(hitinfo.collider.gameObject.name, ";")
		
		if(objName[1]=="SnatchStrongholdObject") then
			self:RivalInfoBtnOnClick(self.snatchMianView.rivalInfos[tonumber(objName[2])])
		end
	end
end

--是否选中ui
--true:选中 false:未选中
function UISnatchScene:uiSelected()
    local ray = self.uiCamera:ScreenPointToRay (Input.mousePosition)
    local flag,hitinfo = UnityEngine.Physics.Raycast (ray, nil,UnityEngine.Mathf.Infinity,2^UnityEngine.LayerMask.NameToLayer("UI"))
    if flag == true then --判断是否点中ui
        --print ("---------------function FarmManagement:buildingSelected() ")
        return true
    end
    return false
end

-- 打开夺宝主界面
function UISnatchScene:OpenSnatchMainView()
	-- 初始化主界面
	if self.snatchMianView == nil then
		self.snatchMianView = SnatchMainView.new()
		self.snatchMianView:init(self)
	end
end


------------------------------------------  对手信息模块 -------------------------------------
function UISnatchScene:RivalInfoBtnOnClick(rivalInfo)
	--printf("对手信息模块 ")
	
	-- 如果点击的是自己
	if tonumber(self.UserInfo[TxtFactory.USER_MEMBERID]) == tonumber(rivalInfo.memberid) then
		self:StrongholdBtnOnClick()
		return
	end
	
	self.snatchMianView:HiddenView()
	if self.snatchRivalInfoView == nil then
		self.snatchRivalInfoView = SnatchRivalInfoView.new()
		self.snatchRivalInfoView:init(self)
	end
	self.snatchRivalInfoView:InitData(rivalInfo)
	self.snatchRivalInfoView:ShowView()
end

-- 获得剩余夺宝次数
function UISnatchScene:GetSnatchCount()
	return TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_REFER_MAXNUM) - TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_NUM)
end

-- 对手信息界面ui 事件方法
function UISnatchScene:snatchRivalInfoViewEvent( fName,... )
	self.snatchRivalInfoView[fName](self.snatchRivalInfoView,...)
end

------------------------------------------   据点模块  ------------------------------------------ 
function UISnatchScene:StrongholdBtnOnClick()
	--printf("据点")
	--self.snatchMianView:HiddenView()
	if self.snatchStrongholdView == nil then
		self.snatchStrongholdView = SnatchStrongholdView.new()
		self.snatchStrongholdView:init(self)
	end
	--self.snatchStrongholdView:ShowView()
	self.snatchStrongholdView:sendExplorerInfoRequest()
	
end

-- 刷新驻守信息
function UISnatchScene:StrongholdRefreshDefendPet()
	self.snatchStrongholdView:RefreshDefendPet()
end

-- 据点信息ui 事件方法
function UISnatchScene:snatchStrongholdViewEvent( fName,... )
	self.snatchStrongholdView[fName](self.snatchStrongholdView,...)
end

------------------------------------------   说明界面模块  ------------------------------------------ 
function UISnatchScene:ExplainBtnOnClick()
	--printf("说明按钮")
	if self.snatchExplainView == nil then
		self.snatchExplainView = SnatchExplainView.new()
		self.snatchExplainView:init(self)
		self.snatchExplainView:InitData("1001003")
	end
	self.snatchExplainView:ShowView()
	-- 请求自己的数据
end

-- 说明ui 事件方法
function UISnatchScene:snatchExplainViewEvent( fName,... )
	self.snatchExplainView[fName](self.snatchExplainView,...)
end

------------------------------------------   商城界面模块 ------------------------------------------ 
function UISnatchScene:StoreBtnOnClick()
	--printf("商城按钮")
	if self.snatchStoreView == nil then
		self.snatchStoreView = SnatchStoreView.new()
		self.snatchStoreView:init(self)
		--self.snatchStoreView:InitData()
		self.snatchStoreView:SetStoreType(2)
		self.snatchStoreView:SetStoreMangement(self.storeManager)
		self.snatchStoreView:checkSend()
		self.snatchStoreView:BoundButtonEvents(self.uiRoot)
	end
	
	self.snatchStoreView:ShowView()
end

-- ui 事件方法
function UISnatchScene:snatchStoreViewEvent( fName,... )
	self.snatchStoreView[fName](self.snatchStoreView,...)
end

-----------------------------------------  积分信息模块 ------------------------------------------------
function UISnatchScene:IntegralBtnOnClick()
	--printf("积分按钮")
	if self.snatchIntegralView == nil then
		self.snatchIntegralView = SnatchIntegralView.new()
		self.snatchIntegralView:init(self)
		self.snatchIntegralView:InitData()
	end
	self.snatchIntegralView:ShowView()
end

-- 说明ui 事件方法
function UISnatchScene:snatchIntegralViewEvent( fName,... )
	self.snatchIntegralView[fName](self.snatchIntegralView,...)
end

----------------------------------------  萌宠防守界面  ------------------------------------------------
function UISnatchScene:OpenSnatchPetDefeng()
	--printf("萌宠防守界面")
	if self.snatchPetDefendView == nil then	
		self.snatchPetDefendView = SnatchPetDefendView.new()
		self.snatchPetDefendView:init(self)
		--self.snatchPetDefendView:InitData()
	end
	
	self.snatchPetDefendView:ShowView()
	self.snatchPetDefendView:InitData()
end

-- 说明ui 事件方法
function UISnatchScene:snatchPetDefendViewEvent( fName,... )
	self.snatchPetDefendView[fName](self.snatchPetDefendView,...)
end

------------------------------------------  界面的隐藏和显示 -------------------------------------------
function UISnatchScene:SetActive(active)
	-- 设置摄像机参数
	SetCameraParam(1005,self.mainCamera)
	self.rivalInfoObjectPatent:SetActive(active)
	self.snatchScene:SetActive(active)
	if self.snatchMianView ~= nil then
		self.snatchMianView:SetActive(active)
	end
end

function UISnatchScene:SetSceneTarget(sceneParent)
	
	self.sceneParent = sceneParent
end