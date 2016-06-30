--[[
商城配置表
作者：gaofei
]]

StoreConfigTXT = class(TableTXT)

StoreConfigTXT.tag = "StoreConfigTXT"

StoreConfigTXT.TxtName = Util.DataPath..AppConst.luaRootPath.."game/export/".."store_config.txt"                  --记录文件地址和名字

StoreConfigTXT.type_table = nil -- 商城类型->商品id表

function StoreConfigTXT:Init()
	self.super.Init(self)
	self.type_table = {}
	for i =1, self.super.GetLineNum(self) do
		local id = self:GetData(i, "ID")
		local type_id = self:GetData(i, "SHOP_TYPE")
		local type_n = tonumber(type_id)
		if not type_n then break end
		if self.type_table[type_n] == nil then
			self.type_table[type_n] = {}
		end
		self.type_table[type_n][#self.type_table[type_n]+1] = id
	end
end

-- 根据商品类型获得商品ID列表
function StoreConfigTXT:GetTableByType(type_id)
	local type_n = tonumber(type_id)
	if not type_n or not self.type_table[type_n] then
		warn("StoreConfigTXT:GetTableByType:can not find this type of" .. tostring(type_id))
		return nil
	end
	return self.type_table[type_n]
end


