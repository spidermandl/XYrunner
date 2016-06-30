--[[
用户配置表
author:Desmond  
]]
EquipTXT = class (TableTXT)

EquipTXT.tag = "EquipTXT"

EquipTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."equip_config.txt"                  --记录文件地址和名字
 
EquipTXT.Attribute = {
	"ADDHP",
	"ADDITEMR",
	"SLOWHP",
	"ELFSOCRE",
	"ADDATKSC",
	"ADDSC",
	"ADDEXP",
	"ADDGOLD",
	"TWOJUMPSOCRE",
	"MOREJUMPSOCRE",
	"SUBATKDMG",
	"SUBDROPDMG",
	"MISATKDMG",
	"ADDSUCKHP",
	"ADDSUCKTIME",
	"ADDGODTIME",
	"LIGHT_PE",
	"TASK_PE",
	"ENERGY",
	"ENERGYJUMP",
	"DIAMOND_PE",
	"ADDJUMP",
	"MATERIAL",
	"ATK",
	"CDDOWM",
	"SPEED",
	"NOTE",
	"SPTINT",
	"VOLPLANE",
	"NEVER",
	"JUMPTIME",
	"SKILLBUFF",
}


EquipTXT.lvlPairs = nil -- id ==> 等级
EquipTXT.maxLvl = nil --id ==> 顶级
EquipTXT.initLvl = nil -- 种类id  ==> 每种套装第一个等级


function EquipTXT:Init()
	self.super.Init(self)
    --初始化lvlPairs和maxLvl
    self.lvlPairs ={}
    self.maxLvl = {}
    self.initLvl = {}

    local last_config_equip_id = 0 --上一次suit config ID 纪录
    local temp_equip_id = 0  --上一次suit ID 纪录
    local lvMax = 1 -- id对应等级 纪录
    for i =1, self.super.GetLineNum(self) do
    	local equip_config_id = self:GetData(i,'ID')
    	local equip_id= tostring(math.floor(tonumber(equip_config_id)/1000))
    	if equip_id ~=  temp_equip_id then
    		lvMax = 1
            self.maxLvl[temp_equip_id] = last_config_equip_id
            self.initLvl[equip_id] = equip_config_id
    	else
    		lvMax = lvMax + 1
    	end
    	self.lvlPairs[equip_config_id] = lvMax
    	temp_equip_id = equip_id
    	last_config_equip_id = equip_config_id
    end
    self.maxLvl[temp_equip_id] = last_config_equip_id
end

-- --[[
-- 获取table一行,一列数据
-- id:主键或者行号
-- column:列名
-- ]]
function EquipTXT:GetData(id,column)
    if column == TxtFactory.S_EQUIP_LVL then
    	return self.lvlPairs[tostring(id)]
	elseif column == TxtFactory.S_EQUIP_MAX then
		local max = self.maxLvl[tostring(id)]
		if not max then
			max = self.maxLvl[tostring(self:GetData(id,TxtFactory.S_EQUIP_TYPE))]
		end
		return max
	elseif column == TxtFactory.S_EQUIP_INIT then --获取一个套装的第一个等级
		return self.initLvl[tostring(id)]
    elseif column ==TxtFactory.S_EQUIP_TYPE  then
        return math.floor(tonumber(id)/1000)
    end

	return self.super.GetData(self,id,column)

end

-- 获取装备附加属性
function EquipTXT:GetAttribute(id)
	local key,value
	for i=1, #self.Attribute do
		value = self:GetData(id, self.Attribute[i])
		if value and value ~= "" then
			key = self.Attribute[i]
			break
		end
	end
	return key,value
end

-- 获取装备icon
function EquipTXT:GetItemIcon(id)
	return self:GetData(id,"EQUIPMENT_ICON")
end
