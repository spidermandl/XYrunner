--[[
author:Desmond
游客注册返回信息
]]
GuestMsg = class(BaseMsg)

function GuestMsg:Excute(response)
	local txt = TxtFactory:getTable("UserTXT")
	txt:setUser(response.username,response.password)
    txt:addRole("0")
    --AppConst.SocketPort = 80
    -- print ("------------->>>>>>>>>> "..response.username.." "..response.password)
    -- NetManager:SendGet(NetConfig.USER_LOGIN_API,'username=' ..txt:getValue('Username')..'&password='..txt:getValue('Password')) --
end