--RoleInfoMsg
--[[
author:huqiuxiang
角色信息获取
]]
RoleInfoMsg =class(BaseMsg)

function RoleInfoMsg:Excute(response)
	local txt = TxtFactory:getTable("UserTXT")
	-- txt:setID(response.access_token,response.uid)
	
    --AppConst.SocketPort = 9000
end
