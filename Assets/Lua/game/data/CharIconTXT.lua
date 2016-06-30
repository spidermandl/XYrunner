--[[
author:hanli_xiong
玩家／系统icon
]]

CharIconTXT = class(TableTXT)

CharIconTXT.tag = "CharIconTXT"

CharIconTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."charIcon_config.txt"                  --记录文件地址和名字

CharIconTXT.OtherIcon = {
	gold = "jinbi",
	diamond = "zuanshi",
	strength = "tili",
	explorer_gold = "duobaobi",
	suit = "xing",
	pet = "xing",
	suit = "xing",
}
