--[[
author:Desmond
套装数据表
]]
SuitTXT= class (TableTXT)

SuitTXT.tag = "SuitTXT"

SuitTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."suit_config.txt"                  --记录文件地址和名字

SuitTXT.suitMaleModel = {
    [12001] = "desmond",
    [12002] = "desmond",
    [12003] = "dmale_qb",
    [12004] = "desmond",
    [12005] = "desmond",
    [12006] = "desmond"
}

SuitTXT.suitFemaleModel = {
    [12001] = "dgirl",
    [12002] = "dgirl",
    [12003] = "dgirl_qb",
    [12004] = "dgirl",
    [12005] = "dgirl",
    [12006] = "dgirl"
}


SuitTXT.lvlPairs = nil -- id ==> 等级
SuitTXT.maxLvl = nil --id ==> 顶级
SuitTXT.initLvl = nil -- 种类id  ==> 每种套装第一个等级


function SuitTXT:Init()
	self.super.Init(self)
    
    --初始化lvlPairs和maxLvl
    self.lvlPairs ={}
    self.maxLvl = {}
    self.initLvl = {}

    local last_config_suit_id = 0 --上一次suit config ID 纪录
    local temp_suit_id = 0  --上一次suit ID 纪录
    local lvMax = 1 -- id对应等级 纪录
    for i =1, self.super.GetLineNum(self) do
    	local suit_config_id = self:GetData(i,'ID')
    	local suit_id = tostring(math.floor(tonumber(suit_config_id)/1000))
        lvMax = math.floor(tonumber(suit_config_id)%1000)
    	if suit_id ~= temp_suit_id then
            self.maxLvl[last_config_suit_id] = true
            self.initLvl[suit_id] = suit_config_id
    	end
    	self.lvlPairs[suit_config_id] = lvMax
    	temp_suit_id = suit_id
    	last_config_suit_id = suit_config_id
    end
    self.maxLvl[last_config_suit_id] = true
end

-- --[[
-- 获取table一行,一列数据
-- id:主键或者行号
-- column:列名
-- ]]
function SuitTXT:GetData(id,column)
    if column == TxtFactory.S_SUIT_LVL then
    	return self.lvlPairs[tostring(id)]
	elseif column == TxtFactory.S_SUIT_MAX then
		return self.maxLvl[tostring(id)]
	elseif column == TxtFactory.S_SUIT_INIT then --获取一个套装的第一个等级
		return self.initLvl[tostring(id)]
    elseif column ==TxtFactory.S_SUIT_TYPE  then
        return math.floor(tonumber(id)/1000)
    elseif column == TxtFactory.S_SUIT_MALE_MODEL then
        return self.suitMaleModel[math.floor(tonumber(id)/1000)]
    elseif column == TxtFactory.S_SUIT_FEMALE_MODEL then
        return self.suitFemaleModel[math.floor(tonumber(id)/1000)]
    end

	return self.super.GetData(self,id,column)

end

--[[

]]
function SuitTXT:GetFisrtLvlID( suit_id )
	return self.initLvl[suit_id]
end

-- 获取套装transform配置
function SuitTXT:GetTransform(suit_type_id)
    local id = self:GetData(suit_type_id, TxtFactory.S_SUIT_INIT)
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
    v3_array = lua_string_split(s_str, ";")
    if #v3_array == 3 then
        s_v3:Set(tonumber(v3_array[1]),tonumber(v3_array[2]),tonumber(v3_array[3]))
    end
    return p_v3, r_v3, s_v3
end

-- 根据性别和套装ID获得对应模型
function SuitTXT:GetModelName(sex, suit_id)
    local tb = {[0]=self.suitMaleModel, [1]=self.suitFemaleModel}
    if not tb[sex] then
        warn("sex error")
        return nil
    end
    return tb[sex][suit_id]
end

-- 获取所有套装（key为套装id，value为对应模型）
function SuitTXT:GetSuitTable(sex, suit_id)
    local tb = {[0]=self.suitMaleModel, [1]=self.suitFemaleModel}
    if not tb[sex] then
        warn("sex error")
        return nil
    end
    return tb[sex]
end

-- 获取套装名字
function SuitTXT:GetSuitName(suit_type_id)
    local id = self:GetData(suit_type_id, TxtFactory.S_SUIT_INIT)
    return self:GetData(id,"NAME")
end
