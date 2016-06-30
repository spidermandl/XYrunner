--[[
	赵名飞
	城建升级协议
]]
 
BuildingUpLvMsg = class(BaseMsg)

function BuildingUpLvMsg:Excute(response)

    local json = require "cjson"
 	local tab = json.decode(response.data)
    --print ("------------->>>>>>>>>> BuildingUpLvMsg Res -----------------"..tostring(tab.n_avator))
    -- NetManager:SendGet(NetConfig.USER_LOGIN_API,'username=' ..txt:getValue('Username')..'&password='..txt:getValue('Password')) --
    self.callback:BuildingUpLv_Resp(tab) -- 通知升级信息回调
end