--[[
author:hanli_xiong
兑换码
]]

ExchangeManagement = class()

ExchangeManagement.scene = nil
ExchangeManagement.userTable = nil -- 玩家数据表

function ExchangeManagement:Awake(targetscene)
	self.scene = targetscene
	self.userTable = TxtFactory:getTable(TxtFactory.UserTXT) 
end

-- 兑换礼品 发送
function ExchangeManagement:SendExchangeGift(code)
	-- print("code -- " .. code)
	local json = require "cjson"
	local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = { gift_key = code }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = charinfo_pb.GetGiftRequest()
        message.gift_key = code
        strr = ZZBase64.encode(message:SerializeToString())
    end
	
   -- local msg = { gift_key = code }
   -- local strr = json.encode(msg)
    local param = {
        code = MsgCode.GetGiftRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.GetGiftResponse,self)
    NetManager:SendPost(NetConfig.DEFAULT,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 兑换礼品 接收
function ExchangeManagement:GetExchangeGift(response)
	
	local json = require "cjson"
 	local tab = json.decode(response.data)
	local ret = tonumber(tab.result)
	-- 清空原来的兑换码
	self.scene.exchangeCodeInput.value = ""
	if ret == 0 then
		--warn("兑换失败")
		self.scene.scene:promptWordShow("兑换失败")
	elseif ret == 1 then
		self.scene:OnExchangeResult(tab)
		self.scene.scene:promptWordShow("激活码兑换成功")
		--邮件刷新
		self.scene.scene:GetMailList()
	elseif ret == 2 then
		self.scene.scene:promptWordShow("激活码无效")
	elseif ret == 3 then
		self.scene.scene:promptWordShow("激活码过期")
	elseif ret == 4 then
		self.scene.scene:promptWordShow("激活码已经使用")
	elseif ret == 4 then
		self.scene.scene:promptWordShow("此类型已经领取了")
	end
	
end


