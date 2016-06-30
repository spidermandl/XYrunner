--RoleInfoGetMsg
--[[
author:Huqiuxiang
获得角色反馈
]]
RoleInfoGetMsg = class(BaseMsg)

RoleInfoGetMsg.E_FAILED = 0  --获取失败
RoleInfoGetMsg.E_SUCCESS = 1 --角色信息获取成功
RoleInfoGetMsg.E_USER_NOT_EXIST = 2 --玩家角色未创建

function RoleInfoGetMsg:Excute(response)
    if response == nil then
    	return
    end

    local json = require "cjson"
    local data = json.decode(response.data)
	print ("-----function RoleInfoGetMsg:Excute(response) "..tostring(data.result))
	local result = data.result
    if result == self.E_FAILED then

	elseif result == self.E_SUCCESS then
		self.callback:getRoleInfo(response)
	elseif result == self.E_USER_NOT_EXIST then
		self.callback:getRoleFail()
	end

end



