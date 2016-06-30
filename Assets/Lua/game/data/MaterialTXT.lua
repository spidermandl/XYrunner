--[[
材料数据
作者：秦仕超
]]
MaterialTXT=class(TableTXT)

MaterialTXT.tag = "MaterialTXT"

MaterialTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."material_config.txt"                  --记录文件地址和名字

-- 获取材料icon
function MaterialTXT:GetItemIcon(id)
	return self:GetData(id,"MATERIAL_ICON")
end
