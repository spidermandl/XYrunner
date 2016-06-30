--[[
author:sunkai
奖杯获取奖励
]]

CupGetMsg = class(BaseMsg)

CupGetMsg.FAILED = 0  --获取失败
CupGetMsg.SUCCESS = 1 --获取成功

function CupGetMsg:Excute(response)

     if response == nil then
    	return
    end

    local json = require "cjson"
    local data = json.decode(response.data)
	print ("function CupGetMsg:Excute(response) "..tostring(data.result))
	local result = data.result
    if result == self.FAILED then
		
	elseif result == self.SUCCESS then
		self.callback:respondGetCupMsg(data)
	end
	
end