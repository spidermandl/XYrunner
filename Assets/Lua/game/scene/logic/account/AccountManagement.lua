--[[
author:Desmond
玩家账号管理类
]]



AccountManagement = class ()

AccountManagement.scene = nil --对应登录场景
AccountManagement.userTable = nil  --用户表
AccountManagement.suitTable = nil --套装表
AccountManagement.materialTable = nil --材料表
AccountManagement.petTable = nil -- 萌宠表

--初始化
function AccountManagement:Awake()
	self.userTable = TxtFactory:getTable("UserTXT")
    self.suitTable = TxtFactory:getTable("SuitTXT")
    self.petTable = TxtFactory:getTable("MountTypeTXT")
end

--发送注册
function AccountManagement:sendRegister( name,passwd )
	local json = require "cjson"
    local param = {
        ---- device = "111116",e25081f3
        username = name,
        password = passwd,
    }

    MsgFactory:createMsg(MsgCode.RegisterMsg,self)
    NetManager:SendPost(NetConfig.USER_REG_API,json.encode(param))
end

-- 注册按钮事件（返回）
function  AccountManagement:RegisterBtnFromSer(response)
    -- print("注册按钮事件（返回) 成功")
    self.userTable:setUser(response.username,response.password)
    --self.scene:LogInBtnAction() -- 注册成功直接登录
    self:sendLogin(response.username,response.password)

end

--发送登录
function AccountManagement:sendLogin( name,passwd )
	local json = require "cjson"
    self.userTable:setUser(name,passwd)
	local param = {
		-- -- device = "111116",e25081f3
		username = name,
		password = passwd,
	}
	MsgFactory:createMsg(MsgCode.LoginMsg,self)
	NetManager:SendPost(NetConfig.USER_LOGIN_API,json.encode(param))
end

-- 登陆按钮事件（返回）
function  AccountManagement:LogInBtnFromSer(response)
    -- print("登陆按钮事件（返回) 成功")
    self.userTable:setID(response.token,response.authkey)

    MsgFactory:createMsg(MsgCode.ServerListMsg,self)
    NetManager:SendPost(NetConfig.SER_LISTGET_API,'a'..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))  -- 发送获取服务器消息请求

end

--发送xy渠道用户登录
function AccountManagement:sendXYLogin(name, passwd, deviceId)
    local json = require "cjson"
    self.userTable:setUser(name,passwd)
    local param = {
        device_id = deviceId,
        username = name,
        password = passwd,
    }
    MsgFactory:createMsg(MsgCode.XYLoginMsg,self)
    NetManager:SendPost(NetConfig.USERXY_LOGIN_API, json.encode(param))
end
--发送渠道用户登录
function AccountManagement:sendSDKLogin( name,passwd,deviceId,providerId )
    local json = require "cjson"
    self.userTable:setUser(name,passwd)
    local param = {
        device_id = deviceId,
        username = name,
        password = passwd,
        provider = providerId
    }
    MsgFactory:createMsg(MsgCode.SDKLoginMsg,self)
    NetManager:SendPost(NetConfig.USER_SDK_LOGIN_API, json.encode(param))
end

-- 获取服务器消息（返回）
function AccountManagement:ServerListFromSer(response)
	self.scene:ServerListFromSer(response)
end

--创建角色
function AccountManagement:sendCreateRole(dataSex,dataName)
    dataName = ZZBase64.encode(dataName)
	local json = require "cjson"
    --[[
	local msg = { authkey = self.userTable:getValue('authkey') ,name = dataName,sex = dataSex}
    local str = json.encode(msg)
    ]]--
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = { authkey = self.userTable:getValue('authkey') ,name = dataName,sex = dataSex}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = charinfo_pb.RegisterRequest()
        message.authkey = self.userTable:getValue('authkey')
        message.name = dataName
        message.sex = dataSex
        strr = ZZBase64.encode(message:SerializeToString())
    end

   -- print("创建角色:" .. str)
    local param = {  --创建角色
              code = MsgCode.RegisterRequest,
              data = strr,
             }

    MsgFactory:createMsg(MsgCode.RegisterResponse,self)
    NetManager:SendPost(NetConfig.ROLE_CREAT_API,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- （创建角色 返回) 
function AccountManagement:CharacterCreatFromSer()
	self.scene:CharacterCreatFromSer()
end

--发送请求角色信息
function AccountManagement:sendRoleInfo()
    local json = require "cjson"
    local strr = nil --data部分数据
    
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = { authkey = self.userTable:getValue('authkey') }
        GamePrint(tostring(msg))
        strr = json.encode(msg)
    else
        --设置pb data
        
        local message = charinfo_pb.GetCharInfoRequest()
        message.authkey = self.userTable:getValue('authkey')
       -- strr = ZZBase64.encode(message:SerializeTostring())
        strr = ZZBase64.encode(message:SerializeToString())
    end

    local param = { 
              code = MsgCode.GetCharInfoRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.GetCharInfoResponse,self)
    NetManager:SendPost(NetConfig.ROLE_INFOGET_API,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end


--（获取角色成功 返回）
function AccountManagement:getRoleInfo(response)
	local json = require "cjson"
    if response == nil then
        print("角色信息为空 开始创建")
        self:creatCharacterPanel()
        return
    end
    local tab = json.decode(response.data)
    local err, ret = pcall(ZZBase64.decode, tab.charinfo.username)
    if err then
        tab.charinfo.username = ret
    end
    -- tab.charinfo.username = ZZBase64.decode(tab.charinfo.username)
    local bin_avators = tab.charinfo.bin_avators
    local bin_pets =  tab.charinfo.bin_pets
    -- print("Enter 获得角色信息  "..tostring(bin_avators))
    -- print("url"..AppConst.SocketAddress)
    -- -- 保存服务器 金币 钻石 等数据
    -- self.userTable:setInfo(tab.charinfo.gold,tab.charinfo.diamond,tab.charinfo.level,tab.charinfo.icon,tab.charinfo.cur_avator,bin_avators,tab.charinfo.cur_pets
    --             ,bin_pets,tab.charinfo.cur_horse,tab.charinfo.sex
    --     )

    TxtFactory:getTable(TxtFactory.MemDataCache):initAccount(tab.charinfo) --初始化玩家信息
    TxtFactory:getTable(TxtFactory.MemDataCache):initSuitInfo(bin_avators,tab.charinfo.cur_avator) --初始化套装表
    TxtFactory:getTable(TxtFactory.MemDataCache):initPetInfo(bin_pets,tab.charinfo.cur_pets) -- 初始化萌宠表
    TxtFactory:getTable(TxtFactory.MemDataCache):initMountInfo(bin_pets,tab.charinfo.cur_horse) -- 初始化坐骑表
    TxtFactory:getTable(TxtFactory.MemDataCache):initGuideInfo(tab.charinfo.guide) -- 初始化人物信息
    self:sendEquipInfo() --获取装备信息
    self:sendMaterialList()--获取材料背包
    self:sendPetListRequest() -- 萌宠列表
    self.scene:StartGameBtnBack()
    if RoleProperty.corePlayOnly == true then
        self.scene:ChangScene(SceneConfig.testScene)
    else
        self.scene:ChangScene(SceneConfig.buildingScene)
    end

end
--获取获得萌宠列表 (发送)
function AccountManagement:sendPetListRequest()
    local json = require "cjson"

    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = pet_pb.PetListRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.PetListRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.PetListResponse,self,"getPetListResponse",PetListMsg.new())
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    -- print("获取玩家装备信息 发送")
end

--获取获得萌宠列表 (返回)
function AccountManagement:getPetListResponse(info)
    local json = require "cjson"
    --GamePrintTable("萌宠列表")
    --GamePrintTable(info)
    local tab = json.decode(info.data)
    local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo) -- 萌宠数据表
    petInfo[TxtFactory.DUI_ZHANG] = tonumber(tab.master_uid)
    petInfo[TxtFactory.Limit_NUM] = tonumber(tab.limit_num)

    local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    UserInfo[TxtFactory.USER_LOTT_GOLD] = tonumber(tab.lottGoldTime) + os.time()
    UserInfo[TxtFactory.USER_LOTT_DIAMOND] = tonumber(tab.lottDiamTime) + os.time()

end
--获取玩家装备信息 (发送)
function AccountManagement:sendEquipInfo()
    local json = require "cjson"
    --[[
    local msg = {}
    local strr = json.encode(msg)
    ]]--
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.EquipsListRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.EquipsListRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.EquipsListResponse,self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    -- print("获取玩家装备信息 发送")
end

-- 获取玩家装备信息（返回）
function AccountManagement:getEquipInfo(info)
    local json = require "cjson"
    local tab = json.decode(info.data)
    GamePrintTable("获取玩家装备信息（返回）")
    GamePrintTable(tab)
    print("-------------function AccountManagement:getEquipInfo(info) "..tostring(tab))
    if not tab then
        tab = {}
    end
    local memCache = TxtFactory:getTable("MemDataCache")
    if tab.bin_equips == nil then
        tab.bin_equips = {}
    end
    memCache:setTable(TxtFactory.EquipInfo,tab)
    
    -- 给装备赋值
    for i = 1, #tab.bin_equips do 
        if tab.bin_equips[i].slot ~= 0 then
            TxtFactory:getTable(TxtFactory.MemDataCache):exchangeEquip(tab.bin_equips[i].tid,on)
        end
    end
end

-- 获取背包信息(发送)
function AccountManagement:sendMaterialList()
    local json = require "cjson"
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.ItemListRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.ItemListRequest,
              data = strr, -- strr
            }

    MsgFactory:createMsg(MsgCode.ItemListResponse,self)
    NetManager:SendPost(NetConfig.ITEMINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end

-- 获取背包信息（返回）
function AccountManagement:getMaterialList(info)
    local json = require "cjson"
    local tab = json.decode(info.data)
    local memCache = TxtFactory:getTable("MemDataCache")
    if tab.bin_items == nil then
        tab.bin_items = {}
    end

    memCache:setTable(TxtFactory.BagItemsInfo,tab)

end

--（获取角色失败 返回）
function AccountManagement:getRoleFail()
	self.scene:creatCharacterPanel()
end

-- 激活账号 发送
function AccountManagement:sendActiveAccount()
    -- body
end

-- 激活账号 接收
function AccountManagement:getActiveAccount(response)
    -- body
end
