--RoleCreatMsg
--[[
author:Huqiuxiang
创建角色反馈
]]

RoleCreatMsg = class(BaseMsg)

function RoleCreatMsg:Excute(response)

	self.callback:CharacterCreatFromSer()
	-- local txt = TxtFactory:getTable("UserTXT")
 --    AppConst.SocketPort = 80
 --    print ("------------->>>>>>>>>> Enter RoleCreatMsg")
 --    txt:addRole("1")
end