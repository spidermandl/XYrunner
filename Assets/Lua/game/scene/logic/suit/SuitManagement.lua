--[[
author:Desmond
套装逻辑管理
]]
SuitManagement = class()

SuitManagement.scene = nil --对应场景
SuitManagement.userTable = nil  --用户表
SuitManagement.suitTable = nil --用户套装表
SuitManagement.materialTable = nil --材料表

function SuitManagement:Awake()
	-- 角色套装
    self.userTable = TxtFactory:getTable(TxtFactory.UserTXT)
    self.suitTable = TxtFactory:getMemDataCacheTable(TxtFactory.SuitInfo)
    self.materialTable = TxtFactory:getTable(TxtFactory.MaterialTXT)
end

--选择套装消息发送
function SuitManagement:sendSuitSelection()
	-- 套装
	local selected_index = self.suitTable[TxtFactory.SUIT_SELECTED_INDEX]
	local suitData = self.suitTable[TxtFactory.CUR_SUITS][selected_index]
	local config_id = suitData[TxtFactory.SUIT_CONFIG_ID]

	local json = require "cjson"
	--local msg = { avator_tid   = config_id }
	--local strr = json.encode(msg)
	
	local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = { avator_tid   = config_id }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = avator_pb.SelectAvatorRequest()
        message.avator_tid = config_id
        strr = ZZBase64.encode(message:SerializeToString())
    end
	
	local param = {
		code = MsgCode.SelectAvatorRequest,
		data = strr,
	}
	MsgFactory:createMsg(MsgCode.SelectAvatorResponse,self)
	NetManager:SendPost(NetConfig.SUIT_SELECT,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end

--选择套装消息回复
function SuitManagement:getSuitSelection(response)
	local json = require "cjson"
    local tab = json.decode(response.data)
    local re = tab.result
    if re == 0 then
     	print("反馈服务器错误")
    elseif re == 1 then  -- 反馈成功结果 升级
    	print("套装选择成功")
    elseif re == 2 then
     	print("id错误")
    end
end

--升级功能消息发送
function SuitManagement:sendSuitUpgrade(selected_index)
	local json = require "cjson"
	if not selected_index then
		return
	end
	local config_id  = self.suitTable[TxtFactory.CUR_SUITS][selected_index][TxtFactory.SUIT_CONFIG_ID]
	-- 向服务器发送升级请求
	--local msg = { avator_tid = tonumber(config_id) }
	--local strr = json.encode(msg)
	
	local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = { avator_tid = tonumber(config_id) }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = avator_pb.SelectAvatorRequest()
        message.avator_tid = tonumber(config_id)
        strr = ZZBase64.encode(message:SerializeToString())
    end
	
	
	local param = {
		code = MsgCode.UpgradeAvatorRequest,
		data = strr,
	}

	MsgFactory:createMsg(MsgCode.UpgradeAvatorResponse,self)
	NetManager:SendPost(NetConfig.SUIT_LVUP,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end

--升级功能消息回复
function SuitManagement:getSuitUpgrade(response)

	local json = require "cjson"
    local re = tonumber(response.result) -- 反馈结果
    if re == 0 then
     	print("反馈服务器错误")
    elseif re == 1 then  -- 反馈成功结果 升级
    	local tid = response.n_avator
    	self.scene:updateSuccess(tid)
    elseif re == 2 then
     	print("等级到顶 。。。。。")
    elseif re == 3 then
     	print("缺少金币")
    elseif re == 4 then
     	print("缺少钻石")
    end
end




