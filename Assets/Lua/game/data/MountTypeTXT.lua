--[[ 
坐骑数据
作者：huqiuxiang
]]

MountTypeTXT = class(TableTXT)

MountTypeTXT.tag = "MountTypeTXT"

MountTypeTXT.TxtName = Util.DataPath..AppConst.luaRootPath.."game/export/".."mountType_config.txt"                  --记录文件地址和名字

MountTypeTXT.petIdList = nil
MountTypeTXT.mountIdList = nil

function MountTypeTXT:GetLineByID(id)
	return self.TxtArray[id]
end

-- 单独获取坐骑列表(hanli_xiong)
function MountTypeTXT:GetMountIdList()
	if self.mountIdList == nil then
		self.mountIdList = {}
		for k,v in pairs(self.TxtArray) do
			if tonumber(k) > 100 and self:GetData(k, "TYPE") == "3" then
				self.mountIdList[#self.mountIdList+1] = k
			end
		end
		table.sort(self.mountIdList)
	end
	return self.mountIdList
end

-- 单独获取宠物列表(hanli_xiong)
function MountTypeTXT:GetPetIdList()
	if self.petIdList == nil then
		self.petIdList = {}
		for k,v in pairs(self.TxtArray) do
			local type_str = self:GetData(k, "TYPE")
			if tonumber(k) > 100 and (type_str == "1" or type_str == "2") then
				self.petIdList[#self.petIdList+1] = k
			end
		end
		table.sort(self.petIdList)
	end
	return self.petIdList
end

-- 获取宠物/坐骑transform配置
function MountTypeTXT:GetTransform(id)
	local p_v3 = Vector3.zero
	local r_v3 = Quaternion.identity
	local s_v3 = Vector3.one
	if id == nil then
		return p_v3, r_v3, s_v3
	end
	local p_str = self:GetData(id, "POSITION")
	local r_str = self:GetData(id, "ROTATION")
	local s_str = self:GetData(id, "SCALE")
	local v3_array = nil -- 三维向量数组
	v3_array = lua_string_split(p_str, ";")
	if #v3_array == 3 then
		p_v3:Set(tonumber(v3_array[1]),tonumber(v3_array[2]),tonumber(v3_array[3]))
	end
	v3_array = lua_string_split(r_str, ";")
	if #v3_array == 3 then
		r_v3 = Quaternion.Euler(tonumber(v3_array[1]),tonumber(v3_array[2]),tonumber(v3_array[3]))
	end
	v3_array = lua_string_split(s_str, ";")
	if #v3_array == 3 then
		s_v3:Set(tonumber(v3_array[1]),tonumber(v3_array[2]),tonumber(v3_array[3]))
	end
	return p_v3, r_v3, s_v3
end

-- 获取坐骑种类icon
function MountTypeTXT:GetItemIcon(id)
   -- GamePrint("id ==="..id)
	return self:GetData(id,"PET_ICON_LIST")
end



