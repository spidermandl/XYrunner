--[[
author:huqiuxiang
萌宠主动技能
]]

PetSkillMainTXT = class(TableTXT)

PetSkillMainTXT.tag = "PetSkillMainTXT"

PetSkillMainTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."petSkillMain_config.txt"                  --记录文件地址和名字

-- 根据技能ID获得技能等级
function PetSkillMainTXT:GetSkillLevel(skill_id)
	local level
	if tonumber(skill_id) then
		level = tonumber(skill_id)%10
	end
	return level
end