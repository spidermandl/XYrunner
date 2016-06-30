--[[
author:Desmond
套装技能表
]]
SuitSkillTXT = class(TableTXT)

SuitSkillTXT.tag = "SuitSkillTXT"

SuitSkillTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."suitSkill_config.txt"                  --记录文件地址和名字

SuitSkillTXT.luaClass = {
	[101] = "SprintState",
	[102] = "ChangeBigState",
	[103] = "StealthState",
	[104] = "FortuneCatSuitState",
	[105] = "LionEarSuitState",
	[106] = "FortuneCatSuitState"
}

-- function SuitSkillTXT:Init()
-- 	self.super.Init(self)

-- 	for i =1, self.super.GetLineNum(self) do
-- 		print (TxtFactory.S_SUIT_SKILL_CD_TIME)
-- 		print (self:GetData(i,'ID')..':'..self:GetData(i,TxtFactory.S_SUIT_SKILL_CD_TIME))
-- 	end
-- end
-- --[[
-- 获取table一行,一列数据
-- id:主键或者行号
-- column:列名
-- ]]
function SuitSkillTXT:GetData(id,column)
    if column ==TxtFactory.S_SUIT_SKILL_TYPE  then
        return math.floor(tonumber(id)/1000)
    elseif column == TxtFactory.S_SUIT_SKILL_LUA_CLASS then
    	return self.luaClass[math.floor(tonumber(id)/1000)]
    end

	return self.super.GetData(self,id,column)

end
