--[[
author:Desmond
无尽关卡配置表
]]
EndlessTXT = class (TableTXT)

EndlessTXT.tag = "EndlessTXT"

EndlessTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."endless_config.txt"                  --记录文件地址和名字

EndlessTXT.baseNum = 1 --base数量
EndlessTXT.maxSpeed = 1 --最大速度

function EndlessTXT:Init()
	self.super.Init(self)
    
    local last_base = 1
    for i =1, self.super.GetLineNum(self) do
    	local base = self:GetData(i,TxtFactory.S_ENDLESS_BASE)--获取base数量
    	if tonumber(base) ~= last_base then
    		self.baseNum = self.baseNum + 1
    		last_base = tonumber(base)
    	end

    	local speed = self:GetData(i,TxtFactory.S_ENDLESS_SPEED) --获取最大速度
    	if tonumber(speed) > self.maxSpeed then
    		self.maxSpeed = tonumber(speed)
    	end
    end

end

--[[
  表 列名
  id 主键
  name 场景元素prefab 名字
  base 场景id
  speed 速度难度
  type 场景类型 1 头 2 中 3尾
]]

--[[
获取满足条件的id号 
]]
function EndlessTXT:getIDbyCondition(conditions)
	--print ("base: "..conditions['BASE'].." speed:"..conditions['SPEED'].." type:"..conditions['TYPE'])
	local ids = {}
	for i=1,self.super.GetLineNum(self) do --遍历表
		local line = self.super.GetLine(self,i)
		local  flag = true
		for k,v in pairs(conditions) do --遍历条件
			--print ("k:"..k.." v:"..v)
			if self.TxtTitle[k] == nil then --key不存在
				flag = false
				break
			end

			if line[self.TxtTitle[k]-1] ~= v then --数值不一样
				flag = false
				break
			end 
		end

		if flag == true then
			--print ("getIDbyCondition "..tostring(line[self.TxtTitle['ID']-1]))
			table.insert(ids,line[self.TxtTitle['ID']-1])
		end

	end
    -- for i=1,#ids do
    -- 	print ('id: '..tostring(ids[i]))
    -- end
	return ids
end

-- --[[
-- 获取table一行,一列数据
-- id:主键或者行号
-- column:列名
-- ]]
function EndlessTXT:GetData(id,column)
    if column == TxtFactory.S_ENDLESS_BASE_NUM then
    	return self.baseNum
    elseif column == TxtFactory.S_ENDLESS_MAX_SPEED then
    	return self.maxSpeed
    end

	return self.super.GetData(self,id,column)

end
