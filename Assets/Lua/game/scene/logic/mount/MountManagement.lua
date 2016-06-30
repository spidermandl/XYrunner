--[[
author:hanli_xiong
坐骑数据管理
]]

MountManagement = class()

MountManagement.scene = nil -- 附属场景
MountManagement.userTable = nil -- 玩家数据表
MountManagement.mountTable = nil -- 本地坐骑表
MountManagement.mountInfoCache = nil -- 坐骑信息缓存

function MountManagement:Awake(targetscene)
	self.scene = targetscene
	self.userTable = TxtFactory:getTable(TxtFactory.UserTXT)
	self.mountTable = TxtFactory:getTable(TxtFactory.MountTXT)
	self.mountInfoCache = TxtFactory:getMemDataCacheTable(TxtFactory.MountInfo)
	--print(TxtFactory:getTable(TxtFactory.MemDataCache):TableToString(self.mountInfoCache))
end

-- 设置当前选择的坐骑
function MountManagement:SetCurMount(mountId)
	local info = self.mountInfoCache[TxtFactory.BIN_MOUNT][mountId]
	if info == nil then
		self.mountInfoCache[TxtFactory.CUR_MOUNT] = mountId
	else
		self.mountInfoCache[TxtFactory.CUR_MOUNT] = info.id
	end
end

-- 坐骑升级消息发送
function MountManagement:SendUpgradeMount(mountId)
    -- 向服务器发送升级请求
    local json = require "cjson"
    local info = self.mountInfoCache[TxtFactory.BIN_MOUNT][mountId]
    if info == nil then
    	warn("坐骑未解锁")
    	return
    end
    local uid = info.id
    local tid = self:GetTidById(uid)
    if self.mountTable:GetLineByID(tonumber(tid)+10) == nil then
    	warn("找不到这个坐骑 或 等级已经升满:" .. tid)
    	return
    end
    local coinsNum, diamondNum = self:GetUpgradeNeed(tid)
   -- local msg = { pet_uid = uid, use_coins = coinsNum, use_diamond = diamondNum }
   -- local strr = json.encode(msg)
	
	 local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = { pet_uid = uid, use_coins = coinsNum, use_diamond = diamondNum }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = pet_pb.UpgradePetRequest()
        message.pet_uid = uid
        message.use_coins = coinsNum
		message.use_diamond = diamondNum
        strr = ZZBase64.encode(message:SerializeToString())
    end
	
    -- print(strr)
    local param = {
        code = MsgCode.UpgradePetRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.UpgradePetResponse,self)
    NetManager:SendPost(NetConfig.MOUNT_LVUP,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 坐骑升级消息返回 
function MountManagement:GetUpgradeMount(info)
	local json = require "cjson"
 	local tab = json.decode(info.data)
	local re = tonumber(tab.result) -- 反馈结果
	if re == 0 then
	    print("反馈服务器错误")
	elseif re == 1 then  -- 反馈成功结果 升级
		if tab.pet_info --[[and tab.use_coins and tab.use_diamond]] then
			local tid = tab.pet_info.tid
			print("升级之后的tid:" .. tid)
			local coins, diamond = self:GetUpgradeNeed(tid)
			local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
			memData:AddUserInfo(-coins, -diamond)
			self.scene:UpdatePlayerInfo()
			local mountId = tostring(math.floor(tonumber(tid)/10000))
			self.mountInfoCache[TxtFactory.BIN_MOUNT][mountId].tid = tid
			self.scene:UpgradeMount(mountId)
		end
		print("升级坐骑成功!")
	elseif re == 2 then
	    print("错误的坐骑ID")
	end
end

-- 选择坐骑信息发送
function MountManagement:SendSelectMount()
    -- 向服务器发送升级请求
    local json = require "cjson"
    local id = self.mountInfoCache[TxtFactory.CUR_MOUNT]
    if id == 0 then
    	warn("没有选择任何坐骑")
    	return
    end
   -- local msg = { pet_id = id }
   --local strr = json.encode(msg)
   local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = { pet_id = id }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = pet_pb.SelectHorseRequest()
        message.pet_id = id
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
        code = MsgCode.SelectHorseRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.SelectHorseResponse,self)
    NetManager:SendPost(NetConfig.MOUNT_LVUP,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 选择坐骑消息返回 
function MountManagement:GetSelectMount(info)
	local json = require "cjson"
 	local tab = json.decode(info.data)
	local re = tonumber(tab.result) -- 反馈结果
	if re == 0 then
	    print("反馈服务器错误")
	elseif re == 1 then  -- 反馈成功结果 升级
		-- self.scene:()
		print("选择坐骑成功!")
	elseif re == 2 then
	    print("错误的坐骑ID")
	end
end

-- 通过id得到tid    -- id = 27 tid = 130230010
function MountManagement:GetTidById(id)
	local tb = self.mountInfoCache[TxtFactory.BIN_MOUNT]
	for k,v in pairs(tb) do
		if v.id == id then
			return v.tid
		end
	end
	warn("找不到这个坐骑id:" .. id)
	return id
end

function MountManagement:GetUpgradeNeed(tid)
	local coins = tonumber(self.mountTable:GetData(tid, "UPGOLD"))
    local diamond = tonumber(self.mountTable:GetData(tid, "UPDIAMOND"))
    if coins == nil then coins = 0 end
    if diamond == nil then diamond = 0 end

    return coins, diamond
end
