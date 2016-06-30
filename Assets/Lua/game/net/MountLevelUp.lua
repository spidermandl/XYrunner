--[[
author:hanli_xiong
坐骑升级返回消息
]]

MountLevelUp = class(BaseMsg)

function MountLevelUp:Excute(response)
	-- local txt = TxtFactory:getTable("UserTXT")
	-- txt:setUser(response.username,response.password)
 --    txt:addRole("0")
 --    AppConst.SocketPort = 80
 -- request result :{"code":18003,"data":"{\"result\":4}","extra":"","username":"","memberid":0}
 	-- self.callback:getPetUpgrade(response)
	
    self.callback:GetUpgradeMount(response) -- 通知升级信息回调
end