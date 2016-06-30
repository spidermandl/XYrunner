--[[
账号配置表
author:sunkai
]]
PlayerLevelUpTXT = class (TableTXT)

PlayerLevelUpTXT.tag = "PlayerLevelUpTXT"

PlayerLevelUpTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."player_levelup_config.txt"                  --记录文件地址和名字

function PlayerLevelUpTXT:getTotalExpByLevel(level)
	local retExp = 0
	for i = 1,level do 
		local exp = self:GetData(i,"Accounts_Exp")
		retExp = retExp+ tonumber(exp)
	end
	return retExp
end
