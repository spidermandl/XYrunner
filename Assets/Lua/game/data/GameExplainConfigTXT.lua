--[[
游戏功能说明界面
作者：gaofei
]]

GameExplainConfigTXT = class(TableTXT)

GameExplainConfigTXT.tag = "GameExplainConfigTXT"

GameExplainConfigTXT.TxtName = Util.DataPath..AppConst.luaRootPath.."game/export/".."gameExplain_config.txt"                  --记录文件地址和名字


function GameExplainConfigTXT:GetLineByID(id)
	return self.TxtArray[id]
end



