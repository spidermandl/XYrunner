--[[
坐骑数据
作者：秦仕超
]]

MountTXT=class(TableTXT)

MountTXT.tag = "MountTXT"

MountTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."mount_config.txt"                  --记录文件地址和名字
MountTXT.Attribute = {
    ADDSC = "得分加成",
    ADDATKSC = "击杀得分",
    GOLD_SCORE = "收集得分",
    ADDHP = "额外体力",
}
                                        
MountTXT.AttributeNew = {
    ["GOODOPINION"] = "需要好感度",
    ["UPGOLD"] = "强化金币",
    ["MATERIAL"] = "强化钻石",
    ["MATERIAL"] = "需要素材",
    ["ADDSC"] = "表现加成",
    ["ADDATKSC"] = "杀怪得分",
    ["COLLECTIONS_SCORE"] = "收集得分",
    ["ADDHP"] = "额外体力",
    ["SLOWHP"] = "延缓体力",
}
MountTXT.lvlPairs = nil -- id ==> 等级
MountTXT.maxLvl = nil --id种类 ==> 顶级
MountTXT.initLvl = nil --id种类  ==> 每种坐骑/萌宠第一个等级
MountTXT.nextLvl = nil -- id  ==> 下一个等级id
MountTXT.expPairs = nil -- id ==> 满当前等级的总经验值

function MountTXT:Init()
	self.super.Init(self)
    
    --初始化lvlPairs和maxLvl
    self.lvlPairs ={}
    self.maxLvl = {}
    self.initLvl = {}
    self.nextLvl = {}
    self.expPairs = {}

    local last_mount_id = 0 --上一次mount ID 纪录
    local temp_mount_type_id = 0  --上一次mount ID 种类纪录
    local lvMax = 1 -- id对应等级 纪录
    local lvExp = 0 -- id对应经验
    for i =1, self.super.GetLineNum(self) do
    	local mount_id = self:GetData(i,'ID')
    	local mount_type_id = tostring(math.floor(tonumber(mount_id)/10000))
        local exp = tonumber(self:GetData(i, 'GOODOPINION'))
        if not exp then exp = 0 end
    	if mount_type_id ~=  temp_mount_type_id then
            lvExp = 0
    		lvMax = 1
            self.maxLvl[temp_mount_type_id] = last_mount_id
            self.initLvl[mount_type_id] = mount_id
    	else
    		lvMax = lvMax + 1
    	end
        lvExp = lvExp + exp
        self.expPairs[mount_id] = lvExp
        -- warn("id="..mount_id.."/exp="..lvExp)
    	self.lvlPairs[mount_id] = lvMax
    	temp_mount_type_id = mount_type_id
        if last_mount_id ~= 0 then
            self.nextLvl[last_mount_id] = mount_id
            -- 如果类型ID不同则保留自己为下一等级ID 约定为最高等级
            if math.floor(tonumber(last_mount_id)/10000) ~= math.floor(tonumber(mount_id)/10000) then
                self.nextLvl[last_mount_id] = last_mount_id
            end
            -- warn(type(last_mount_id).."-last_mount_id:"..last_mount_id.."nextLvl->"..self.nextLvl[last_mount_id])
        end
    	last_mount_id = mount_id
    end
    self.maxLvl[temp_mount_type_id] = last_mount_id
    self.nextLvl[last_mount_id] = last_mount_id
end

-- --[[
-- 获取table一行,一列数据
-- id:主键 or 行号 or typeid
-- column:列名
-- ]]
function MountTXT:GetData(id,column)

    if column == TxtFactory.S_MOUNT_LVL then --等级
    	return self.lvlPairs[tostring(id)]
	elseif column == TxtFactory.S_MOUNT_MAX then --顶级id
		local t = self.maxLvl[tostring(id)]
		if t==nil then
			t=self.maxLvl[math.floor(tonumber(id)/10000)]
		end
		return t
	elseif column == TxtFactory.S_MOUNT_STAR then --星级
		local star = tonumber(id) - math.floor(tonumber(id)/10)*10
		return star
	elseif column == TxtFactory.S_MOUNT_INIT_ID then --初始等级id
		--print (tostring(id))
		local t = self.initLvl[tostring(id)]
		if t==nil then
			t=self.initLvl[math.floor(tonumber(id)/10000)]
		end
		return t
	elseif column == TxtFactory.S_MOUNT_TYPE then --萌宠种类id
		return math.floor(tonumber(id)/10000)
    elseif column == TxtFactory.S_MOUNT_EXP then --满当前等级的总经验值
        return self.expPairs[tostring(id)]
    end

	return self.super.GetData(self,id,column)

end

-- 通过当前ID得到下一等级ID
function MountTXT:GetNextLevel(id)
    return tonumber(self.nextLvl[tostring(id)])
end

-- 通过ID得到该宠物或坐骑的类型ID
function MountTXT:GetTypeID(id)
    return math.floor(tonumber(id)/10000)
end



