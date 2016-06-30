--[[
author:huqiuxiang
萌宠被动技能
]]

PetSkillPassiveTXT = class(TableTXT)

PetSkillPassiveTXT.tag = "PetSkillPassiveTXT"

PetSkillPassiveTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."petSkillPassive_config.txt"                  --记录文件地址和名字

local RankToNum = {
	["B"] = 1,
	["A"] = 2,
	["S"] = 3,
	["SS"] = 4,
}
-- 根据根据主宠品质获取系数
function PetSkillPassiveTXT:GetZHU_PET_MODULUS(sData,zhuRank)
	local idTabd = string.gsub(sData,'"',"")
	self.array = lua_string_split(tostring(idTabd),";")
	--GamePrintTable(self.array)
	local iid  = RankToNum[zhuRank]
	if iid == nil then 
		iid = 1
	end
	local ret = self.array[iid]
	if ret == nil then
		return 1		
	end
	return tonumber(ret)
end
-- 根据副宠星级获取系数
function PetSkillPassiveTXT:GetFu_PET_MODULUS(sData,star)
	local idTabd = string.gsub(sData,'"',"")
	self.array = lua_string_split(tostring(idTabd),";")

	if tonumber(star) > #self.array then
		star = #self.array
	end

	return tonumber(self.array[tonumber(star)])
end