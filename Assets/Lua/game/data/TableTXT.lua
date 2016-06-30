--[[
txt表管理类
控制本地文件的写入读出
author:Desmond
]]

TableTXT = class()

TableTXT.tag = "TableTXT"

TableTXT.TxtName=nil					--记录文件地址和名字
TableTXT.TxtTitle=nil					--记录文件各列标题
										--[[
										    {
										      columnName1 : 1,
										      columnName2 : 2,
										      columnName3 : 3,
										    }
										]]
TableTXT.TxtLines = nil                 --按行号记录文件第四行之后的数据
TableTXT.TxtArray = nil					--按照主键记录文件第四行之后的数据


--初始化数据
function TableTXT:Init()
	self.TxtTitle = {}
	self.TxtLines = {}
	self.TxtArray = {}
	local array= SimpleFramework.TXTReader.ReadTxt(self.TxtName)--读取数据
	--print("读取txt行数："..self.TxtName)
	--初始化column name
	for i=0,array[0].Length-1 do
		self.TxtTitle[array[0][i]] = i+1
		--print(i.."标题："..array[0][i])
	end
	--初始化table item
	for i=1,array.Length-1 do
		if array[i][0]=="\t"then
			break
		end
		if self.TxtTitle.ID == nil then
			GameWarnPrint("文件="..self.TxtName.."找不到ID")
			break
		end
		self.TxtArray[array[i][self.TxtTitle.ID-1]]=array[i]
		self.TxtLines[i]=array[i]
	end
end

-- deprecated 读取数据
function TableTXT:ReadTxt()
	local txtArray=DoLocalData.ReadTxt(self.TxtName)
	return txtArray
end

-- deprecated 写入数据
function TableTXT:WriteTxt(txtName,value)
	DoLocalData.WriteTxt(self.TxtName,value)
end

--获取表列长度
function TableTXT:GetColumnLength()
	return self:GetLine(1).Length
end

--[[
获取table一行数据
index: 行索引
]]
function TableTXT:GetLine(index)
	return self.TxtLines[index]
end

--[[
获取table一行数据
index: 行id号
]]
function TableTXT:GetLineByID(id)
	return self.TxtArray[tostring(id)]
end

--获取table共几行数据
function TableTXT:GetLineNum()
	return #self.TxtLines
end

--[[
获取table一行,一列数据
id:主键或者行号
column:列名
]]
function TableTXT:GetData(id,column)
	if column ==nil or self.TxtTitle[column] ==nil then
		return
	end
	local line = nil
	line = self.TxtLines[id]
	if line == nil then
		line = self.TxtArray[tostring(id)]
	end
    
    if line == nil then
    	return nil
    end
	return line[self.TxtTitle[column]-1]
end

--[[
获取table一行,一列数据
id:主键主键或者行号
index:列索引
]]
function TableTXT:GetDataByColumnIndex(id,index)
	if index == nil or index<=0 then
		return
	end

    local line = nil
	line = self.TxtLines[id]
	if line == nil then
		line = self.TxtArray[tostring(id)]
	end
    
    if line == nil then
    	return nil
    end

	return line[index-1]
end


--查找相应所在列
function TableTXT:FindIndex(valueKey)
	for i=0,self.TxtTitle.Length-1 do 
		if self.TxtTitle[i]==valueKey then
			return i
		end
	end
	return -1
end

function TableTXT:PrintTxt()
	for k, v in pairs(self.TxtArray) do
		local str = k .. "\n"
		for i=0, v.Length-1 do
			str = str .. i .. "=" .. v[i] .. "&"
		end
		print(str)
	end
end

-- 根据id获取icon(并返回图集名)
function TableTXT:GetItemIconById(tid)
	local item_type = tonumber(string.sub(tostring(tid),1,2))
	--GamePrint("--"..item_type)
	if item_type == 11 then
		-- 城建
	elseif item_type == 12 then
		-- 套装
	elseif item_type == 13 then
		-- 宠物
		--GamePrint("1111111111111")
		local petData = TxtFactory:getTable(TxtFactory.MountTypeTXT)
		return petData:GetItemIcon(string.sub(tostring(tid),1,5)),"PetIcon"
	elseif item_type == 14 then
		-- 装备
		local equipData = TxtFactory:getTable(TxtFactory.EquipTXT)
		return equipData:GetItemIcon(tid),"EquipIcon"
	elseif item_type == 15 then
		-- 材料
		local materialData  = TxtFactory:getTable(TxtFactory.MaterialTXT)
		return materialData:GetItemIcon(tid),"GiftIcon"
	elseif item_type == 16 then
		-- 礼包
	elseif item_type == 17 then
		-- 奖池
	elseif item_type == 18 then
		-- 抽奖
	end

end

