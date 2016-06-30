--[[
author:hanli_xiong
玩家随机昵称
]]

CharNamesTXT = class(TableTXT)

CharNamesTXT.tag = "CharNamesTXT"

CharNamesTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."charNames_config.txt"                  --记录文件地址和名字

CharNamesTXT.P_names = {} -- 前名字
CharNamesTXT.E_names = {} -- 后名字


function CharNamesTXT:Init()
	self.TxtTitle = {}
	self.TxtLines = {}
	self.TxtArray = {}
	local array = SimpleFramework.TXTReader.ReadTxt(self.TxtName)--读取数据
	--print("读取txt行数："..self.TxtName)
	--初始化column name
	for i=0,array[0].Length-1 do
		self.TxtTitle[array[0][i]] = i+1
		--print(i.."标题："..array[0][i])
	end
	--初始化table item
	print("Length:" .. array.Length)
	for i=1,array.Length-1 do
		if tonumber(array[i][0]) == 1 then
			self.P_names[#self.P_names + 1] = array[i][1]
		elseif tonumber(array[i][0]) == 2 then
			self.E_names[#self.E_names + 1] = array[i][1]
		end
	end
	for i=1,array.Length-1 do
		if array[i][0]=="\t"then
			break
		end
		self.TxtArray[i]=array[i]
		self.TxtLines[i]=array[i]
	end
	local time = os.time()--设置随机种子
	math.randomseed(time)
end

function CharNamesTXT:RandomName()
 	local nub = math.random(1,#self.P_names)
	local name = self.P_names[nub]
	nub = math.random(1,#self.E_names)
	name = name .. self.E_names[nub]

 	return name
 end