--[[
功能开启
作者：吴高文
XT]]

FunctionOpenTXT=class(TableTXT)

FunctionOpenTXT.tag= "FunctionOpenTXT"

FunctionOpenTXT.TxtName = Util.DataPath..AppConst.luaRootPath.."game/export/".."function_open.txt"                  --记录文件地址和名字

FunctionOpenTXT.NameToID = nil
function FunctionOpenTXT:Init()
	self.super.Init(self)
	self.NameToID = {}
	--初始化table item
	for i=1,#self.TxtLines do
		self.NameToID[self.TxtLines[i][self.TxtTitle.MODULE-1]] = i
	end
end

function FunctionOpenTXT:GetLineByName(name)
	return self.super.GetLine(self,self.NameToID[name])
end
