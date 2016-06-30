--[[
游戏里用的文字表
作者：gaofei
]]

TextsConfigTXT = class(TableTXT)

TextsConfigTXT.tag = "TextsConfigTXT"

TextsConfigTXT.TxtName = Util.DataPath..AppConst.luaRootPath.."game/export/".."texts_config.txt"                  --记录文件地址和名字

TextsConfigTXT.TextType = "TEXT_CHS" --语言字段名

function TextsConfigTXT:GetText(id)
	return string.gsub(self.GetData(self,id,"TEXT_CHS"), "###", "\n")
end



