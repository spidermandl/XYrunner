--[[
author:gaofei
夺宝奇兵据点信息界面
]]

SnatchStrongholdView = class ()

SnatchStrongholdView.scene = nil --场景scene
SnatchStrongholdView.panel = nil -- 界面
SnatchStrongholdView.defendPetsObj = nil -- 存储加载的驻守宠物对象

-- 初始化
function SnatchStrongholdView:init(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Snatch/SnatchStrongholdView"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
	
	local ui = self.panel.transform:Find("Anchors/UI")
    self.maxOutputValueLabel = ui:Find("MaxOutputValue"):GetComponent("UILabel")
    self.outputValueLabel = ui:Find("OutputValue"):GetComponent("UILabel")
    self.challengeScoreLabel = ui:Find("ChallengeScore"):GetComponent("UILabel")
	self.mountTxt =  TxtFactory:getTable(TxtFactory.MountTXT)
	self.grid = self.panel.transform:Find("Anchors/UI/Scroll View/Grid")
	
	
   -- self.scene:boundButtonEvents(self.panel)
	self:HiddenView()
end

-- 初始化数据
function SnatchStrongholdView:InitData()

	local snatchData = TxtFactory:getTable(TxtFactory.SnatchConfigTXT)
	local outputValue = tonumber(snatchData:GetData(self.explorer_info.tid,"TERRITORY_GOLD_BASIS_SPEED"))
	local maxTime = tonumber(snatchData:GetData(self.explorer_info.tid,"TERRITORY_GOLD_TIME_MAX"))
	local maxOutputValue = outputValue * maxTime
    if self.addSnatchCoinCount == 0 or self.addSnatchCoinCount == nil  then
        self.outputValueLabel.text = "[824614]"..outputValue..'/分[-]'
    else
        self.outputValueLabel.text = "[824614]"..outputValue..'/分[-]'.."[f6524c]+"..math.ceil((outputValue*self.addSnatchCoinCount)).."[-]"
    end
	
	self.maxOutputValueLabel.text = self.explorer_info.gold.."/"..maxOutputValue
	self.challengeScoreLabel.text = self.explorer_info.score

end


-- 刷新驻守的宠物
function SnatchStrongholdView:RefreshDefendPet()
	local defendpets = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_DEFENGPETS)
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]
    self:ClearDefendPets()
    local petObj = nil
    self.addSnatchCoinCount = 0
	for i = 1 , #defendpets do
		-- 已经召唤的
        printf("petid ==="..defendpets[i])
       if defendpets[i] == 0 then
               petObj = newobject(Util.LoadPrefab("UI/Snatch/AddPetDefend"))
               petObj.gameObject.transform.parent = self.grid.gameObject.transform
               petObj.gameObject.transform.localScale = Vector3(1,1,1)
               petObj.name = "AddPetDefend"
       else
            petObj = self:GetDefendPet(defendpets[i])
       end
	   self.defendPetsObj[i] = petObj
       
    end
    local itemGrid = self.grid:GetComponent("UIGrid")
	itemGrid:Reposition()
	itemGrid.repositionNow = true
    self.scene:boundButtonEvents(self.panel)
    -- 刷新数据
    self:InitData()
end

-- 清除驻守萌宠对象
function SnatchStrongholdView:ClearDefendPets()
    if self.defendPetsObj ~= nil then
       
       for i = 1 , #self.defendPetsObj do
           if self.defendPetsObj[i] ~= nil then
				GameObject.Destroy(self.defendPetsObj[i])
			end
       end
        
    end
    self.defendPetsObj = {}
end


-- 获取萌宠对象
function SnatchStrongholdView:GetDefendPet(pet_id)
    local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]
    for i = 1, #petTab do 
        if petTab[i].id == pet_id then
            -- 计算加成
            self.addSnatchCoinCount = self.addSnatchCoinCount + self:AddSnatchCoinByPet(petTab[i].tid)
            return self:creatPetIcon(petTab[i].tid,self.grid,self.panel)
        end
    end
end
-- 创建萌宠小icon
function SnatchStrongholdView:creatPetIcon(tid,grid,target)
    local petTable = TxtFactory:getTable("MountTypeTXT")
   
    local ctid = self.mountTxt:GetData(tid, TxtFactory.S_MOUNT_TYPE) -- 种类
    local starNum = self.mountTxt:GetData(tid, TxtFactory.S_MOUNT_STAR) -- 星级
    local level =  self.mountTxt:GetData(tid, TxtFactory.S_MOUNT_LVL) -- 等级

    local icon = newobject(Util.LoadPrefab("UI/Pet/MypetIcon"))
    icon.gameObject.transform.parent = grid.gameObject.transform
    icon.gameObject.transform.localScale = Vector3(1,1,1)
     -- 添加按钮监听脚本
    local  seletePetIcon = icon.gameObject.transform:FindChild("SeletePetIcon")
	seletePetIcon.name = "AddPetDefend"
    local  bm = seletePetIcon.gameObject:AddComponent(UIButtonMessage.GetClassType())
  --  bm.target = self.sceneTarget -- target.gameObject
    bm.functionName = "OnClick"
    bm.trigger = 0

    local starGrid = icon.gameObject.transform:FindChild("starGrid")
    local starGridCo = starGrid.gameObject.transform:GetComponent("UIGrid")
    for i=0, starGrid.childCount-1 do
        starGrid:GetChild(i).gameObject:SetActive(i < starNum)
    end
    starGridCo:Reposition() -- 自动排列

    -- 品质更改外框
    local rankData = petTable:GetData(ctid,"RANK_ICON")
    local rankIcon = icon.gameObject.transform:FindChild("iconback"):GetComponent("UISprite")
    rankIcon.spriteName = rankData
    -- GetComponent<UISprite>().spriteName

    -- 名字更改
    local nameData = petTable:GetData(ctid,"NAME")
    local nameLabel = icon.gameObject.transform:FindChild("name").gameObject.transform:GetComponent("UILabel")
    nameLabel.text = nameData

    -- 信息按钮
    local infoBtn = icon.gameObject.transform:FindChild("petIconInfoBtn")
    local infoBtnMes = infoBtn.gameObject.transform:GetComponent("UIButtonMessage")
    infoBtnMes.target = self.sceneTarget --target.gameObject

    -- 碎片
    local pieceNum = icon.gameObject.transform:FindChild("pieceNum")
    pieceNum.gameObject:SetActive(false)

    -- icon设置
    local iconPic = icon.gameObject.transform:FindChild("icon"):GetComponent("UISprite")
    iconPic.spriteName = petTable:GetData(ctid,"PET_ICON")
    
    local levelLabel = icon.transform:FindChild("levelLabel")-- 更新等级信息
    levelLabel.gameObject:SetActive(true)
    local plabel = levelLabel:GetChild(0):GetComponent("UILabel")
	plabel.text = "lv." .. tostring(level)

    return icon
end

-- 获取宠物对夺宝币加成
function SnatchStrongholdView:AddSnatchCoinByPet(pet_tid)
    printf("pet_tid ==="..pet_tid)
    
    local starNum = self.mountTxt:GetData(pet_tid, TxtFactory.S_MOUNT_STAR) -- 星级
    local level = self.mountTxt:GetData(pet_tid, TxtFactory.S_MOUNT_LVL) -- 等级
    
    local color = 1.8  -- 暂时默认
    
    return ((level * 2 + starNum * 3) * color)/1548
end

-- 设置防守阵容
function SnatchStrongholdView:AddPetDefendOnClick()
	printf("设置防守阵容")
	self.scene:OpenSnatchPetDefeng()
end

-- 收获按钮
function SnatchStrongholdView:GainBtnOnClick()
	printf("收获按钮")
	self:SendExplorerGainMessage()
end

--激活暂停界面
function SnatchStrongholdView:ShowView()
	self.panel:SetActive(true)
end

-- 关闭按钮
function SnatchStrongholdView:SnatchStrongholdViewCloseBtnOnClick()
	
	self:SendExplorerDenfenseMessage()
	
	self:HiddenView()
end

-- 冷藏界面
function SnatchStrongholdView:HiddenView()
	self.panel:SetActive(false)
end

--[[ 

发送获取自己的据点信息
]]--
function SnatchStrongholdView:sendExplorerInfoRequest()
     printf("发送获取自己的据点信息")
	local json = require "cjson"
    
     local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = explorer_pb.ExplorerInfoRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    --[[
    local msg = {
       
	}
    local strr = json.encode(msg)
    ]]--
    local param = {
              code = MsgCode.ExplorerInfoRequest,
              data = strr, -- strr
             }
	if self.userTable == nil then
		self.userTable = TxtFactory:getTable("UserTXT")
	end
    MsgFactory:createMsg(MsgCode.ExplorerInfoResponse, self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

--[[ 

获取自己的据点信息
]]--
function SnatchStrongholdView:getExplorerInfoRequest(response)
    local json = require "cjson"
    local data = json.decode(response.data)
	
	if data.explorer_info ~= nil then
		self:ShowView()
		-- 保存自己的据点信息
		TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_STRONGHOLDINFO,data.explorer_info)
		-- 保存驻守的萌宠
		TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_DEFENGPETS,data.explorer_info.pets)
		self.explorer_info = data.explorer_info
		self:InitData()
        self:RefreshDefendPet()
		return
	end
	-- 没有据点
	local word = "您还没有据点,赶紧去抢夺吧"
	self.scene:promptWordShow(word)
 
end

-- 据点收获消息发送
function SnatchStrongholdView:SendExplorerGainMessage()
    local json = require "cjson"
    
     local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = explorer_pb.ExplorerGainRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
	--local msg = {}
  --  local strr = json.encode(msg)
    local param = {
              code = MsgCode.ExplorerGainRequest,
              data = strr, -- strr
             }
    if  self.userTable == nil then
		 self.userTable = TxtFactory:getTable("UserTXT")
	end
	printf(tostring(param))
    MsgFactory:createMsg(MsgCode.ExplorerGainResponse,self)
    NetManager:SendPost(NetConfig.SURVEY,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

--  据点收获消息接收
function SnatchStrongholdView:ExplorerGainMessageListen(info)
	local json = require "cjson"
  	local tab = json.decode(info.data)
	if tab.result == 1 then
		printf("收获成功   gold ==="..tab.gold)
        local snatch_gold =  TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_GOLD)+tab.gold
        TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_GOLD,snatch_gold)
        -- 刷新
        self.scene.snatchMianView:InitTopData()
        self.explorer_info.gold = 0
        self:InitData()
	end
end

-- 设置守卫消息发送
function SnatchStrongholdView:SendExplorerDenfenseMessage()
	local curDefendPets  = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_DEFENGPETS)
    local json = require "cjson"
	
     local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {pets = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_DEFENGPETS)}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = explorer_pb.ExplorerDenfenseRequest()
		for i = 1 , #curDefendPets do
		      --printf("petid ==="..curDefendPets[i])
             message.pets:append(curDefendPets[i])
	    end
        strr = ZZBase64.encode(message:SerializeToString())
    end
   
	--local msg = {pets = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_DEFENGPETS)}
    --local strr = json.encode(msg)
	
    local param = {
              code = MsgCode.ExplorerDenfenseRequest,
              data = strr, -- strr
             }
    if  self.userTable == nil then
		 self.userTable = TxtFactory:getTable("UserTXT")
	end
	printf(tostring(param))
    MsgFactory:createMsg(MsgCode.ExplorerDenfenseResponse,self)
    NetManager:SendPost(NetConfig.SURVEY,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 设置守卫消息接收
function SnatchStrongholdView:ExplorerDenfenseMessageListen(info)
	local json = require "cjson"
  	local tab = json.decode(info.data)
	if tab.result == 1 then
		printf("设置守卫消息接收成功")
	end
end