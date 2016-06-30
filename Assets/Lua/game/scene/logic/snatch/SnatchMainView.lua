--[[
author:gaofei
夺宝奇兵主界面
]]

SnatchMainView = class ()

SnatchMainView.scene = nil --场景scene
SnatchMainView.panel = nil -- 界面

SnatchMainView.rivalInfos = nil -- 存储五个据点信息

SnatchMainView.rivalInfoItems = nil -- 用于存放可以攻打的据点的对象

SnatchMainView.rivalHeadInfo = nil -- 用于存储每个据点的head信息

SnatchMainView.effectObjs = nil   -- 用于存储特效

SnatchMainView.rivalInfoObjectPatent = nil -- 用于存放可攻打据点对象的父节点

-- 初始化
function SnatchMainView:init(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Snatch/SnatchMainView"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
	
	
	self.rivalInfoObjectPatent =  self.scene.rivalInfoObjectPatent
	
	
	-- 可以夺宝的次数
	self.snatchCountLabel = self.panel.transform:Find("Anchors/TopLeft/TopInfo/UI/tili/Label"):GetComponent("UILabel")
	-- 夺宝币
	self.snatchCoinLabel = self.panel.transform:Find("Anchors/TopLeft/TopInfo/UI/tili 1/Label"):GetComponent("UILabel")
	-- 钻石
	self.diamondLabel = self.panel.transform:Find("Anchors/TopLeft/TopInfo/UI/tili 2/Label"):GetComponent("UILabel")
	-- 刷新消耗的金币
	self.refreshCoin = self.panel.transform:Find("Anchors/BottomLeft/RefreshRivalBtn/Label"):GetComponent("UILabel")
	self.gameConfigTXT = TxtFactory:getTable(TxtFactory.GameConfigTXT)
	
	self:SendExplorerListMessage()
	
    self.scene:boundButtonEvents(self.panel)
	
end

-- 初始化数据
function SnatchMainView:InitData()
	self:InitTopData()
	-- 设置刷新需要的金币
	self.refreshCoin.text = self:GetRefreshCoinCount()
	-- 加载5个模型
	local indenx = 1
	self:ClearRivalInfoItems()
	local  strongholdPostionTable = TxtFactory:getTable(TxtFactory.StrongholdPostionConfigTXT)
	local  snatchConfigTXT = TxtFactory:getTable(TxtFactory.SnatchConfigTXT)
	for i = 1,#self.rivalInfos do
		local prebName = snatchConfigTXT:GetData(self.rivalInfos[i].tid,"PREFAB_NAME")
		local obj = newobject(Util.LoadPrefab("Level/Stronghold/"..prebName))
		obj.name = "SnatchStrongholdObject;"..i
		self.rivalInfoItems[i] = obj
		obj.transform.parent = self.rivalInfoObjectPatent.transform
		local postion_3d = lua_string_split(strongholdPostionTable:GetData(i,"POSITION_3D"), ";")
		local postion_2d = lua_string_split(strongholdPostionTable:GetData(i,"POSITION_2D"), ";")
		local rotation = lua_string_split(strongholdPostionTable:GetData(i,"ROTATION"), ";")
		local scale = tonumber(strongholdPostionTable:GetData(i,"SCALING"))
		obj.transform.position = UnityEngine.Vector3(tonumber(postion_3d[1]),tonumber(postion_3d[2]),tonumber(postion_3d[3]))
		obj.transform.localScale = UnityEngine.Vector3(scale,scale,scale)
		obj.transform.localRotation =Quaternion.Euler(tonumber(rotation[1]),tonumber(rotation[2]),tonumber(rotation[3]))
		-- 加载5个模型的拥有者
		local headObj = newobject(Util.LoadPrefab("UI/Snatch/StrongHoldHead"))
		headObj.transform.parent = self.panel.transform
		headObj.transform.localPosition = UnityEngine.Vector3(tonumber(postion_2d[1]),tonumber(postion_2d[2]),tonumber(postion_2d[3]))
		headObj.transform.localScale = Vector3.one
		self.rivalHeadInfo[i] = headObj
		--printf("self.rivalInfos[i].memberid==="..self.rivalInfos[i].memberid)
		if tonumber(self.rivalInfos[i].memberid) == 0 then
			-- 无主之地
			headObj.transform:Find("RoleInfo").gameObject:SetActive(false)
			-- 添加特效
			local effectName = snatchConfigTXT:GetData(self.rivalInfos[i].tid,"EFFECT_NAME")
			local effectObj =  newobject(Util.LoadPrefab("Effects/Scenes/"..effectName))
			effectObj.transform.parent = obj.transform
			effectObj.transform.localPosition =  Vector3.zero
			effectObj.transform.localScale =  Vector3.one
			effectObj.transform.localRotation =  Vector3.zero
			self.effectObjs[indenx] = effectObj
			indenx = indenx +1
		else
			-- 属于某个玩家
			headObj.transform:Find("State").gameObject:SetActive(false)
			local err, ret = pcall(ZZBase64.decode, self.rivalInfos[i].name)
    		if err then
				headObj.transform:Find("RoleInfo/Sprite/Name"):GetComponent("UILabel").text = ret
    		end
		end
		-- 判断是否是自己
		if tonumber(self.UserInfo[TxtFactory.USER_MEMBERID]) == tonumber(self.rivalInfos[i].memberid) then
			headObj.transform:Find("RoleInfo/Sprite"):GetComponent("UISprite").spriteName = "renwubiaolan2"
		else
			headObj.transform:Find("RoleInfo/Sprite"):GetComponent("UISprite").spriteName = "renwubiaolan"
		end	
	end
	
end

-- 获取刷新需要的金币
function SnatchMainView:GetRefreshCoinCount()
	local refresh_num = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_REFER_NUM)
	local refresh_needCoin = lua_string_split(self.gameConfigTXT:GetData(1002,"CONFIG2"), ";")
	if refresh_num >= #refresh_needCoin then
		return tonumber(refresh_needCoin[#refresh_needCoin])
	else
		return tonumber(refresh_needCoin[refresh_num+1])
	end
	
end

-- 判断刷新金币是否足够刷新据点信息
function SnatchMainView:IsRefreshStrongholdInfo()
	local txt = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	if txt[TxtFactory.USER_GOLD] >=  self:GetRefreshCoinCount() then
		return true
	end
	return false
end

-- 清除数据
function SnatchMainView:ClearRivalInfoItems()
	if self.rivalInfoItems ~= nil then
		for i = 1 , # self.rivalInfoItems do
			if self.rivalInfoItems[i] ~= nil then
				GameObject.Destroy(self.rivalInfoItems[i])
			end
		end
	end
	
	self.rivalInfoItems = {}
	
	if self.rivalHeadInfo ~= nil then
		for i = 1 , # self.rivalHeadInfo do
			if self.rivalHeadInfo[i] ~= nil then
				GameObject.Destroy(self.rivalHeadInfo[i])
			end
		end
	end
	
	self.rivalHeadInfo = {}
	
	if self.effectObjs ~= nil then
		for i = 1 , # self.effectObjs do
			if self.effectObjs[i] ~= nil then
				GameObject.Destroy(self.effectObjs[i])
			end
		end
	end
	
	self.effectObjs = {}
	
	
end

-- 初始化顶部信息
function SnatchMainView:InitTopData()
	--local count = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_REFER_MAXNUM) - TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_NUM)
	self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    self.snatchCountLabel.text = self.scene:GetSnatchCount()
   	self.snatchCoinLabel.text = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_GOLD)
	self.diamondLabel.text = tonumber(self.UserInfo[TxtFactory.USER_DIAMOND])
end

--激活暂停界面
function SnatchMainView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function SnatchMainView:HiddenView()
	self.panel:SetActive(false)
end

function SnatchMainView:SetActive(active)
	self.panel:SetActive(active)
end

-- 请求五个据点信息
function SnatchMainView:SendExplorerListMessage()
    local json = require "cjson"
	--printf(tostring(is_refresh))
   -- local msg = {refresh=is_refresh}
	--local msg = {}
  --  local strr = json.encode(msg)
   local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = explorer_pb.ExplorerListRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
	
    local param = {
              code = MsgCode.ExplorerListRequest,
              data = strr, -- strr
             }
    if  self.userTable == nil then
		 self.userTable = TxtFactory:getTable("UserTXT")
	end
	printf(tostring(param))
    MsgFactory:createMsg(MsgCode.ExplorerListResponse,self)
    NetManager:SendPost(NetConfig.SURVEY,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 接受五个玩家信息
function SnatchMainView:ExplorerListMessageListen(info)
	local json = require "cjson"
  	local tab = json.decode(info.data)
	self.rivalInfos = tab.bin_explorers
	
	self:InitData()
end

-- 换一批 (请求)
function SnatchMainView:SendExplorerStartRequestMessage()
    local json = require "cjson"
	--printf(tostring(is_refresh))
   -- local msg = {refresh=is_refresh}
	--local msg = {}
   -- local strr = json.encode(msg)
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = explorer_pb.ExplorerReferRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.ExplorerReferRequest,
              data = strr, -- strr
             }
    if  self.userTable == nil then
		 self.userTable = TxtFactory:getTable("UserTXT")
	end
	printf(tostring(param))
    MsgFactory:createMsg(MsgCode.ExplorerReferResponse,self)
    NetManager:SendPost(NetConfig.SURVEY,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 换一批 (回复)
function SnatchMainView:ExplorerReferMsgResponseMessageListen(info)
	local json = require "cjson"
  	local tab = json.decode(info.data)
	if tab.result == 1 then
		self.rivalInfos = tab.bin_explorers
		-- 设置数据
		TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_REFER_NUM,tab.refer_num)
		local txt = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
		txt[TxtFactory.USER_GOLD] = txt[TxtFactory.USER_GOLD] - tab.use_gold
		
		self:InitData()
	end
	
	
end

