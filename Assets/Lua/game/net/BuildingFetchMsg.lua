--[[
	赵名飞
	领取城建产出
]]

BuildingFetchMsg = class(BaseMsg)

function BuildingFetchMsg:Excute(response)

    local json = require "cjson"
 	local tab = json.decode(response.data)
    --print ("------------->>>>>>>>>> BuildingFetchMsg Res -----------------"..tostring(tab.n_avator))
    -- NetManager:SendGet(NetConfig.USER_LOGIN_API,'username=' ..txt:getValue('Username')..'&password='..txt:getValue('Password')) --
    self.callback:BuildingFetch_Resp(tab) -- 通知升级信息回调
end