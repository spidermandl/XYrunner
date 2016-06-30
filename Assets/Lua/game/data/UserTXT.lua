--[[
用户配置表
author:Desmond
]]
UserTXT = class (TableTXT)

UserTXT.tag = "UserTXT"

UserTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."user_config.txt"                  --记录文件地址和名字

-- "Username": "xy0000039",
-- "Password": "04080d",
-- "access_token": "XYEd2ADGRwOWihFxlp40xg",
-- "uid": "xy0000001"

--[[
初始化数据
]]
function UserTXT:Init()
	local json = require "cjson"
	local util = require "3rd/cjson.util"
	local text = util.file_load(self.TxtName)

	if text ~= nil then
		self.TxtArray = json.decode(text)
	end

	if self.TxtArray == nil then
		self.TxtArray = {}
	end

end

--[[
设置用户名密码
]]
function UserTXT:setUser(name,passwd)
	self.TxtArray.Username = name
	self.TxtArray.Password = passwd
	local json = require "cjson"
	local util = require "3rd/cjson.util"
	util.file_save(self.TxtName, json.encode(self.TxtArray))
end

--[[
创建角色
]]
function UserTXT:addRole(ro)
	self.TxtArray.roleCount = ro
	local json = require "cjson"
	local util = require "3rd/cjson.util"
	util.file_save(self.TxtName, json.encode(self.TxtArray))
end

--[[
设置用户id和token
]]
function UserTXT:setID(token,authkey)
	self.TxtArray.access_token = token
	self.TxtArray.authkey = authkey
	-- self.TxtArray.uid = uid
	local json = require "cjson"
	local util = require "3rd/cjson.util"
	util.file_save(self.TxtName, json.encode(self.TxtArray))
end

--[[
设置用户昵称和性别
]]
function UserTXT:setSexName(Name,Sex)
	self.TxtArray.sex = Sex
	self.TxtArray.nickName = Name
	-- self.TxtArray.uid = uid
	local json = require "cjson"
	local util = require "3rd/cjson.util"
	util.file_save(self.TxtName, json.encode(self.TxtArray))
end

--[[
设置 角色是否被创建
]]
function UserTXT:setRoleForAccont(info)
	self.TxtArray.RoleForAccont = info
	-- self.TxtArray.uid = uid
	local json = require "cjson"
	local util = require "3rd/cjson.util"
	util.file_save(self.TxtName, json.encode(self.TxtArray))
end


--[[
获取table项
]]
function UserTXT:getValue( key )
	return self.TxtArray[key]
end

--[[
是否注册过
]]
function UserTXT:isActive( )
	if self.TxtArray.Username ~= nil then
		return true
	else
		return false
	end
end
