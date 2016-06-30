--JieSuoTiaoJianTXT.lua
--[[
功能开启
作者：吴高文
XT]]

JieSuoTiaoJianTXT=class(TableTXT)

JieSuoTiaoJianTXT.tag= "JieSuoTiaoJianTXT"

JieSuoTiaoJianTXT.TxtName = Util.DataPath..AppConst.luaRootPath.."game/export/".."JieSuo_Tiao_Jian.txt"

--装备2-3格子解锁ID
JieSuoTiaoJianTXT.EquipID = {
	[2]= 1001,
	[3]= 1002,
}