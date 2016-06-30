--[[
	author:Desmond
	城建配置表
]]
BuildingTXT = class(TableTXT)

BuildingTXT.tag = "BuildingTXT"

BuildingTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."building_config.txt"                  --记录文件地址和名字
BuildingTXT.MaxLvl = nil --城建最大等级
--建筑类型对应操作
--1           1           1         1
--建筑产出  建筑升级   scene跳转   是否开放
BuildingTXT.TypeAttribute = --nil
{
	[11001] = 10, --建筑可升级
	[11002] = 110, --可升级，可产出
	[11003] = 10, --建筑可升级
	[11004] = 1, --调入任务
	[11005] = 10, --建筑可升级
	[11006] = 1, --跳入炼金所
	[11007] = 1, --跳入礼品界面
	[11008] = 1, --跳入购买材料界面
	[11009] = 1, --跳入坐骑界面
	[11010] = 1,--跳入套装界面
	[11011] = 1,--跳入天梯功能
	[11012] = 1,--夺宝奇兵界面
	[11013] = 1,--跳入装备界面
}
BuildingTXT.TypeName = --城建的详细类型
{
	[11001] = 1, --娃娃机枢纽
	[11002] = 2, --游戏币小屋
	[11003] = 3, --仓库
	[11004] = 4, --萌宠驿站
	[11005] = 5, --萌宠小屋
	[11006] = 6, --萌宠炼金所
	[11007] = 7, --礼品小卖部
	[11008] = 8, --泡泡小酒吧
	[11009] = 9, --萌宠公交站
	[11010] = 10,--萌萌服装店
	[11011] = 11,--天梯竞技场
	[11012] = 12,--夺宝奇兵营地
	[11013] = 13,--萌宠装备屋
}

function BuildingTXT:Init()

	self.super.Init(self)
    self.MaxLvl = {}

    local lase_config_id = 0 --上一次 config ID 纪录
    local temp_id = 0  --上一次 ID 纪录
    local lvMax = 1 -- id 对应等级 纪录
    for i =1, self.super.GetLineNum(self) do
    	local config_id = self:GetData(i,'ID')
    	local typeId= tostring(math.floor(tonumber(config_id)/1000))
    	if typeId ~=  temp_id then
    		lvMax = 1
            self.MaxLvl[lase_config_id] = true
            --print("该城建ID是最大等级"..lase_config_id)
    	else
    		lvMax = lvMax + 1
    	end
    	temp_id = typeId
    	lase_config_id = config_id
    end
end

-- --[[
-- 获取table一行,一列数据
-- id:主键 or 行号 or typeid
-- column:列名
-- ]]
function BuildingTXT:GetData(id,column)
    if column == TxtFactory.S_BUILDING_TYPE then --建筑类型
		return self.TypeAttribute[math.floor(tonumber(id)/1000)]
	elseif column == TxtFactory.S_BUILDING_TYPENAME then
		return self.TypeName[math.floor(tonumber(id)/1000)]
	elseif column == TxtFactory.S_BUILDING_FIRST_LVL then
		return tostring(id).."001"
	elseif column == TxtFactory.S_BUILDING_MAX_LVL then
		return self.MaxLvl[tostring(id)]
    end

	return self.super.GetData(self,id,column)

end
--  根据建筑ID获取当前的建筑等级
function BuildingTXT:GetBulidLevelById(buildId)
	return tonumber(tonumber(buildId) % 1000)
end

-- 获取建筑transform配置
function BuildingTXT:GetTransform(id)
	local p_v3 = Vector3.zero
	local r_v3 = Quaternion.identity
	local s_v3 = Vector3.one
	if id == nil then
		return p_v3, r_v3, s_v3
	end
	local p_str = self:GetData(id, "POSITION")
	local r_str = self:GetData(id, "ROTATION")
	local s_str = self:GetData(id, "SCALE")
	local v3_array = nil -- 三维向量数组
	v3_array = lua_string_split(p_str, ";")
	if #v3_array == 3 then
		p_v3:Set(tonumber(v3_array[1]),tonumber(v3_array[2]),tonumber(v3_array[3]))
	end
	v3_array = lua_string_split(r_str, ";")
	if #v3_array == 3 then
		r_v3 = Quaternion.Euler(tonumber(v3_array[1]),tonumber(v3_array[2]),tonumber(v3_array[3]))
	end
	if s_str ~= nil then
		v3_array = lua_string_split(s_str, ";")
		if #v3_array == 3 then
			s_v3:Set(tonumber(v3_array[1]),tonumber(v3_array[2]),tonumber(v3_array[3]))
		end
	end
	
	return p_v3, r_v3, s_v3
end


