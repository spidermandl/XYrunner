--[[ 
奖池表
作者：huqiuxiang
]]

LotteryPondTXT = class(TableTXT)

LotteryPondTXT.tag = "LotteryPondTXT"

LotteryPondTXT.TxtName = Util.DataPath..AppConst.luaRootPath.."game/export/".."LotteryPond_config.txt"                  --记录文件地址和名字

LotteryPondTXT.mountIdList = {}
