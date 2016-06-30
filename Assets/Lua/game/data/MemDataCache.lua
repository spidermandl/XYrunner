--[[
author:Desmond
内存动态数据表：
如玩家信息，玩家材料表，玩家道具表等
]]

MemDataCache = class (TableTXT)
MemDataCache.tag = "MemDataCache"
MemDataCache.memTable = nil --内存数据表

--[[
  {
	玩家信息表
	memberid = 1  玩家id
	username = 2  玩家姓名
	sex = 3  玩家性别
	gold = 4  玩家金币
	diamond = 5  玩家钻石
	exp = 6  玩家经验
	exp_max = 7  玩家升级经验
	level = 8  玩家等级
	strength = 14 体力值
	icon   = 15 头像索引
	guide  = 16 新手引导进度
	battle_type = 1 核心战斗类型

	bloodBottleExtra = 1 --血瓶增益 吃到血瓶才加血
	hpSlowDown = 2 --延缓体力 跑酷体力减少减缓
	secondJumpScore = 4 --二段跳额外得分
	multiJumpScore = 5  --多段跳额外得分
	minusDamage = 6 --受击减伤
	inmuneFalldown = 1 --掉坑免伤
	inmuneAktCount = 4 --免疫攻击，不掉血次数(暂时不做)
	hpKillSuck = 2  --吸血每击杀以下个数怪物获得2点体力
	magnetTimeExtra = 4  --磁铁时间延长
	invincibleTimeExtra = 4 --无敌延长
	holyKillSuck = 4 --击杀怪物额外能量 神圣模式能量
	-- TxtFactory.S_EQUIP_ENERGYJUMP = "ENERGYJUMP"--跳跃产生极限碎片 弹跳加神圣模式能量
	jumpCap = 9 --跳跃次数增加
	suitSkillCD = 9 --减少CD时间 套装cd时间
	speedExtra = 4 --增加速度 跑酷速度
	diveScore = 5 --滑翔得分
	onDuckFlyTime = 100 --大黄鸭飞行时间
	story = 1000101 --当前选中关卡


  }
]]
--[[ 玩家装备表
	{
		maxnum    = 1;//可解锁的最大数量
		unlocknum = 2;//已经解锁的数量
		slotnum   = 3;//最大的装备位数量
		unlockslot= 4;//当前已经解锁的装备位
	    bin_equips =[
	      	id 		= 1;//这里为在背包中的位置
		    tid      = 2;//配置表中的id
		    slot     = 3;//0 未装备 非0 装备位置
	    ]
	    upgrade_selected = 1 --升级选中序号
	    merge_selected = 1 --融合选中序号
	}
]]

--[[ 玩家关卡表
    {
	   cur_battle_id    = 2;//当前解锁的id
	   bin_battles =[  战斗历史成绩
           	battle_id = 1;
	        star   = 2; 小关卡星数
	   ]


	   selected_battle_id = 1 前段当前选中关卡id
	   chapter_info = { 
	        纪录关卡大章id   已经解锁
            chapter_id   =  true,
            ...
	   }
    }

]]

--[[ 玩家套装表
  {
    suit_selected_index = 1 界面选中套装index cur_suits中序号
    suit_left_index = 1 界面滑动最左边套装index cur_suits中序号
	cur_suits = [
	    suit_id = 100 套装id
	    suit_config_id = 101004 套装材质表id (未解锁时为第一个等级)
	    lvl = 0 套装等级 （等级 0 未解锁  大于0 等级数）
	]
  }
]]

--[[ 玩家萌宠表
		cur_pets = [0,0,0] // 上场的宠物
		bin_pet = 
		[
			id = 1 // 背包位置
			tid = 2 // 配置表的id
			slot = 3 // 装备位置 
			exp = 4 // 经验
			skill1 = 5 // 主动技能id
			skill2 = 6 //  被动技能id
			skill2_val = 7 // 被动技能当前值
			skills  // 被动技能对应的属性    0  1            2         4           8 
			                                  额外增加体力  收集物得分  击杀额外得分 得分加成
		]

		piece_pets =  [
			material = 1 ,  // 碎片材料信息
			tid = 2 ,  // 萌宠tpyeid
			maxNum = 3 // 碎片最大数量
		]

]]

--[[ 玩家坐骑表
		cur_mount = 0 // 上场的坐骑ID
		bin_mount = 
		[
			id = 1 // 
			tid = 2 // 配置表的id
			slot = 3 // 
		]

]]

--[[ 玩家材料表
		bin_items = 
		[
			tid = 1 // 配置表id
			num = 2 // 数量
			id = 3 //背包位置
		]

]]

--[[ 玩家邮件列表
	bin_mails =
	[
		type_id=0
		diamond=100
		time=1449131158
		pet_id=0
		id=1
		text=开启困难模式
		strength=0
		coins=0	
	]
]]
--[[ 任务信息
message bin_tasks = [
	id = 1;
	tid = 2;
	status = 3; -- 0 是未完成 1 为完成
] 
TaskDialyInfo 每日任务 数组
TaskGuideInfo 新手任务 单个
]]
--初始化数据
function MemDataCache:Init()
	self.memTable = {}
end

--插入数据表
function MemDataCache:setTable(name,t)
	self.memTable[name] = t
end

--获取数值
function MemDataCache:getTable(name)
	return self.memTable[name]
end

--[[
初始化玩家信息
]]
function  MemDataCache:initAccount(info)
	local account = {}

	account[TxtFactory.USER_MEMBERID] = info.memberid
	account[TxtFactory.USER_NAME] = info.username
	account[TxtFactory.USER_SEX] = info.sex
	account[TxtFactory.USER_GOLD] = info.gold
	account[TxtFactory.USER_DIAMOND] = info.diamond
	account[TxtFactory.USER_EXP] = info.exp
	account[TxtFactory.USER_EXP_MAX] = info.exp_max
	account[TxtFactory.USER_LEVEL] = info.level
	account[TxtFactory.USER_STRENGTH] = info.strength
	account[TxtFactory.USER_ICON]   = info.icon
	account[TxtFactory.USER_GUIDE]  = info.guide
	account[TxtFactory.USER_STORY] = 0
	account[TxtFactory.USER_STATUS] = info.status
	account[TxtFactory.USER_GET_LOGIN_GIFT] = info.get_login_gift
	account[TxtFactory.USER_LOGIN_NUM] = info.login_num
	account[TxtFactory.USER_ALIVE_TIME] = info.alive_time
	account[TxtFactory.USER_STRENGTH_TIME] = info.strength_time
	
	account[TxtFactory.USER_GAME_STAR_TIME] = os.time()
	account[TxtFactory.USER_ALIVE_REWARD] = info.alive_reward
	if info.lott_gold ~=nil and info.lott_diamond then
		account[TxtFactory.USER_LOTT_GOLD] = info.lott_gold + os.time()
		account[TxtFactory.USER_LOTT_DIAMOND] = info.lott_diamond + os.time()
	end
	
	account[TxtFactory.USER_BLOOD_BOTTLE_EXTRA] = RoleProperty.StaminaAdd --血瓶增益 吃到血瓶才加血
	account[TxtFactory.USER_HP_RATE] = RoleProperty.hpLostByTime --体力 消耗速率
	account[TxtFactory.USER_HP_SLOWDOWN] = 0--延缓体力 跑酷体力减少减缓
	account[TxtFactory.USER_SECOND_JUMP_SCORE] = 0--二段跳额外得分
	account[TxtFactory.USER_MULTI_JUMP_SCORE] = 0--多段跳额外得分
	account[TxtFactory.USER_MINUS_DAMAGE] = 0--受击减伤
	account[TxtFactory.USER_INMUNE_FALLDOWN] = 0--掉坑免伤 免伤数
	account[TxtFactory.USER_INMUNE_ATK_COUNT] = 0--免疫攻击，不掉血次数(暂时不做)
	account[TxtFactory.USER_HP_KILL_SUCK] = 0 --吸血每击杀以下个数怪物获得2点体力
	account[TxtFactory.USER_MAGNET_TIME] = RoleProperty.MagnetStateTime  --磁铁时长
	account[TxtFactory.USER_INVINCIBLE_TIME] = RoleProperty.InvincibleTime --无敌时长
	account[TxtFactory.USER_HOLY_KILL_SUCK]= 1--击杀怪物额外能量 神圣模式能量
	-- TxtFactory.S_EQUIP_ENERGYJUMP = "ENERGYJUMP"--跳跃产生极限碎片 弹跳加神圣模式能量
	account[TxtFactory.USER_JUMP_CAP] = RoleProperty.jumpAllow --跳跃次数增加
	account[TxtFactory.USER_SUIT_SKILL_CD] = 0 --减少CD时间 套装cd时间
	account[TxtFactory.USER_SPEED_EXTRA] = 0--增加速度 跑酷速度
	account[TxtFactory.USER_DIVE_SCORE] = 0 --滑翔得分
	account[TxtFactory.USER_ON_DUCK_FLY_TIME] = RoleProperty.RhubarbDuckFlyTime--在大黄鸭上飞行时间

	if account[TxtFactory.USER_SEX] == nil then
		account[TxtFactory.USER_SEX] = RoleProperty.defaultSex
	end
	TxtFactory:setMemDataCacheTable(TxtFactory.UserInfo,account)
end

--获得玩家信息
--column 列名
function MemDataCache:getAccountValue(column)
	local txt = self:getTable(TxtFactory.UserInfo)
	return txt[column]
end

--[[
初始化玩家套装表
	cur_suits [
		id = 1;
		level =2;
	]
]]
function MemDataCache:initSuitInfo(cur_suits, cur_avator)
	local mSuit = {}
	mSuit[TxtFactory.SUIT_LEFT_INDEX] = 1
	mSuit[TxtFactory.SUIT_SELECTED_INDEX] = 1
	mSuit[TxtFactory.CUR_SUITS] = {}
	local suit_array = mSuit[TxtFactory.CUR_SUITS]
    local sSuit = TxtFactory:getTable(TxtFactory.SuitTXT)
    --[[
    判断id 是否在cur_suits中
    ]]
    local isInSuit = function (id) 
    	for i=1,#cur_suits do
    		if id == sSuit:GetData(cur_suits[i].id,TxtFactory.S_SUIT_TYPE) then
    			return i
    		end
		end
		return 0
    end
    
    --根据主键解析套装id
    local length = sSuit:GetLineNum()
	local temp = {}
	for i=1,length do
		local id = sSuit:GetData(i,'ID')
		local suit_id = sSuit:GetData(id,TxtFactory.S_SUIT_TYPE)
		if temp[suit_id] == nil then --装入内存表里
			local index = isInSuit(suit_id)
			--print (tostring(suit_id).." "..tostring(index))
			local meta = {}
			--print (id.." "..tostring(index))
			if index > 0 then --已经解锁
				meta[TxtFactory.SUIT_ID] = suit_id
				meta[TxtFactory.SUIT_CONFIG_ID] = cur_suits[index].id
				meta[TxtFactory.SUIT_LVL] = sSuit:GetData(cur_suits[index].id,TxtFactory.S_SUIT_LVL)--cur_suits[index].level
				--print ("----------function MemDataCache:initSuitInfo(cur_suits) "..tostring(meta[TxtFactory.SUIT_LVL]))
			else
				meta[TxtFactory.SUIT_ID] = suit_id
				meta[TxtFactory.SUIT_CONFIG_ID] = sSuit:GetData(suit_id,TxtFactory.S_SUIT_INIT)
				meta[TxtFactory.SUIT_LVL] = 0
				--print (tostring(meta[TxtFactory.SUIT_CONFIG_ID]))
			end
			--print ("-----initSuitInfo "..tostring(meta[TxtFactory.SUIT_ID])..","..tostring(meta[TxtFactory.SUIT_CONFIG_ID]))
			temp[suit_id] = true
			table.insert(suit_array, meta)
		end
	end

	--设置选中序号
	for j=1,#suit_array do
		--print ("function MemDataCache:initSuitInfo(cur_suits) "..tostring(j))
		if suit_array[j][TxtFactory.SUIT_CONFIG_ID] == cur_avator then
			mSuit[TxtFactory.SUIT_SELECTED_INDEX] = j
			break
		end
	end
    --print ("----------function MemDataCache:initSuitInfo(cur_suits) "..tostring(#suit_array))
	TxtFactory:setMemDataCacheTable(TxtFactory.SuitInfo,mSuit)
end

--获取玩家suit id
function MemDataCache:getPlayerSuit()
	local suitInfo = TxtFactory:getMemDataCacheTable(TxtFactory.SuitInfo)
	local index = suitInfo[TxtFactory.SUIT_SELECTED_INDEX]
	if index == nil then --没有得到服务器信息
		return RoleProperty.defaultSuit
	end

	local suitData = suitInfo[TxtFactory.CUR_SUITS][index]
	local config_id =suitData[TxtFactory.SUIT_CONFIG_ID]

	return config_id
end


--添加物品，装备，宠物到本地数据 items为list
function MemDataCache:AddUserInfoItemForType(type,items)
    if type == TxtFactory.BagItemsInfo then
        self:AddUserInfoItems(items)
     elseif type == TxtFactory.EquipInfo then
        self:AddUserInfoEquips(items)
     elseif type == TxtFactory.PetInfo then
        self:AddUserInfoPets(items)
     end
end


--添加物品到 items 是 list
function MemDataCache:AddUserInfoItems(items)
    if items == nil then
        print("AddUserInfoItems items is nil ")
        return
    end
     local BagItemsInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo)  
     local isHave = false      
    for i = 1,#items do
        if  items[i]~= nil then
            for j = 1,#BagItemsInfo.bin_items do 
                if BagItemsInfo.bin_items[j].tid == items[i].tid then
                     BagItemsInfo.bin_items[j] = items[i]
                     isHave = true
                end
            end
            if not isHave then
                table.insert(BagItemsInfo.bin_items,items[i])
                isHave = false
            end
         
        end
    end
end

function MemDataCache:AddUserInfoEquips(equips)
    if equips == nil then
        print("AddUserInfoEquips equips is nil ")
        return
    end
     local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    for i = 1,#equips do
        if equips[i] ~=nil then
            table.insert(EquipInfoTab.bin_equips,equips[i])     
         end
    end
end

function MemDataCache:AddUserInfoPets(pets)
    if pets == nil then
        print("AddUserInfoPets pets is nil ")
        return
    end
    local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
    for i = 1,#pets do
    	pets[i].slot = 0
        table.insert(petInfo[TxtFactory.BIN_PETS],pets[i])
    end
end

-- 增加或扣除金币钻石
function MemDataCache:AddUserInfo(coins, diamond,strength)
   
    self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    if coins~=nil then
        self.UserInfo[TxtFactory.USER_GOLD] = self.UserInfo[TxtFactory.USER_GOLD] + coins
        DataCollector.OnUse("金币", math.abs(coins))
    end
     if diamond ~= nil then
        self.UserInfo[TxtFactory.USER_DIAMOND] = self.UserInfo[TxtFactory.USER_DIAMOND] + diamond
        DataCollector.OnUse("钻石", math.abs(diamond))
    end
    if strength~=nil then
        self.UserInfo[TxtFactory.USER_STRENGTH] = self.UserInfo[TxtFactory.USER_STRENGTH] + strength
        DataCollector.OnUse("体力", math.abs(strength))
    end
 
end

-- 获取萌宠信息
function MemDataCache:initPetInfo(bin_pets,cur_pets)
	local petTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
	local mountTxt = TxtFactory:getTable(TxtFactory.MountTXT)
	-- print(self:TableToString(bin_pets))
	-- print(self:TableToString(cur_pets))
    local bin_pet = {}
    if bin_pets == nil then
        bin_pets = {}
    end
    for i = 1, #bin_pets do
        local  id  = bin_pets[i].id

        local tid = bin_pets[i].tid
        local exp = bin_pets[i].exp
        local skills = bin_pets[i].skills
        local ctid = tonumber(mountTxt:GetData(bin_pets[i].tid,TxtFactory.S_MOUNT_TYPE))
        local petType = petTable:GetData(ctid,"TYPE")
        if petType == "1" or petType == "2" then
			bin_pets[i].slot = 0

            for u =1, #cur_pets do
                if id == cur_pets[u] then
                    bin_pets[i].slot = u
                end
            end
            bin_pet[#bin_pet + 1] = bin_pets[i]
        end
    end
    table.sort(bin_pet, function(p1,p2) return p1.id < p2.id end)
    -- local memCache = TxtFactory:getTable("MemDataCache")
    local t = {}
    t[TxtFactory.BIN_PETS] = bin_pet
    t[TxtFactory.CUR_PETS] = cur_pets
    TxtFactory:setMemDataCacheTable(TxtFactory.PetInfo,t)

end


-- 初始化坐骑信息
function MemDataCache:initMountInfo(bin_pets, cur_horse)
	-- print(self:TableToString(bin_pets))
	local mountTxt = TxtFactory:getTable(TxtFactory.MountTXT)
	local _tb = {}
	for k, v in pairs(bin_pets) do
		local type_id = tonumber(mountTxt:GetData(v.tid, TxtFactory.S_MOUNT_TYPE))
		_tb[type_id] = v
	end

	local mountTypeT = TxtFactory:getTable(TxtFactory.MountTypeTXT)
	local mountTypeId = mountTypeT:GetMountIdList()
	local mountCache = {}
    mountCache.bin_mount = {}
    mountCache.cur_mount = cur_horse
    if mountCache.cur_mount == 0 then
    	mountCache.cur_mount = -1
    end
    for k,v in pairs(mountTypeId) do
    	if _tb[tonumber(v)] ~= nil then
    		mountCache.bin_mount[v] = _tb[tonumber(v)]
    	end
    	-- print(v .. "=" .. tostring(mountCache.bin_mount[k]))
    end

    TxtFactory:setMemDataCacheTable(TxtFactory.MountInfo, mountCache)
end

--获取玩家材料个数
function MemDataCache:getMaterialCount(materialId)
	local txt = self:getTable(TxtFactory.BagItemsInfo)
	for i = 1,#txt do
		if(tonumber(txt[i].tid) == tonumber(materialId))then
			return tonumber(txt[i].num)
		end
	end
	--print("BagItemsInfo not have :"..materialId)
	return 0
end

-- 表 => 字符串(递归)
function MemDataCache:TableToString(t)
	local str = ""
	for k,v in pairs(t) do
		str = str .. k .. "=" .. tostring(v) .. "\t"
		if type(v) == "table" then
			str = str .. "\n"
			str = str .. self:TableToString(v)
			str = str .. "\n"
		end
	end
	return str
end

-- 初始化新手引导信息
function MemDataCache:initGuideInfo(guide)
	local t = {}
	t[TxtFactory.ACCOUNT_GUIDE] = guide
    TxtFactory:setMemDataCacheTable(TxtFactory.AccountInfo,t)
end

-- 获取上场萌宠tab
-- 返回萌宠id
function MemDataCache:getCurPetTab()
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]

    if petTab == nil then --未获取服务器数据
    	local t = RoleProperty.defaultPet
    	return t
    end

	local tab = {}
	for i = 1, #petTab do
		--print ("-----------------------function MemDataCache:getCurPetTab() ")
		if petTab[i].slot ~= 0 then
			table.insert(tab,petTab[i].tid)
		end
	end

	----------test code------------
	--[[
	if #tab == 0 then
		table.insert(tab,1010011)
	end
	]]--
	-------------------------------

	return tab
end

--获取当前选择座骑id
function MemDataCache:getCurMountID()
	local mountInfo = TxtFactory:getMemDataCacheTable(TxtFactory.MountInfo)
	local id = mountInfo[TxtFactory.CUR_MOUNT]
	if id == -1 then 
		return nil
	end
	local tb = mountInfo[TxtFactory.BIN_MOUNT]

	if tb == nil then --没有获取服务器数据
		return nil --RoleProperty.defaultSuit
	end

	for k,v in pairs(tb) do
		if v.id == id then
			return v.tid
		end
	end
	return nil
end

--获取当前装备的装备表
function MemDataCache:getCurEquipTab()
	local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local tab = {}

    if EquipInfoTab.bin_equips == nil then--没有获取服务器数据
    	return tab
    end

    for i , v in ipairs(EquipInfoTab.bin_equips) do
        if v.slot ~= 0 then
            tab[#tab+1] = v.tid
        end
    end

    return tab
end

--跑酷吸收分数增加
--返回所加分数
function MemDataCache:absorbItemScore(s_mID)
    local s_material = TxtFactory:getTable(TxtFactory.MaterialTXT) --材料表
    local basicScore = s_material:GetData(s_mID,TxtFactory.S_MATERIAL_BASICSCORE)--基本加成得分
    if basicScore==nil or tonumber(basicScore) == nil then
    	basicScore=0
    end
    basicScore = tonumber(basicScore)
    --print ("基本加成得分==================="..tostring(basicScore))
    local extraScore = 0

    if tonumber(s_material:GetData(s_mID,TxtFactory.S_MATERIAL_TYPE)) == 3  then --材料类型为3的才会有加成

    	basicScore = basicScore + self:addExtraPoints(
    						   TxtFactory.S_EQUIP_ELFSOCRE,
    						   TxtFactory.S_SUIT_COLLECTIONS_SCORE,
    						   TxtFactory.S_MOUNT_COLLECTIONS_SCORE,
    						   TxtFactory.S_MAIN_SKILL_ADD_COLLECTIONS_SCORE,
    						   2)
    end
    
    return basicScore

end

--跑酷吸收金币增加
--返回所加分数
function MemDataCache:absorbCoinMoney(s_mID)
	local s_material = TxtFactory:getTable(TxtFactory.MaterialTXT) --材料表

    --print ("基本加成金币==================="..tostring(basicScore))
    local basicScore = s_material:GetData(s_mID,TxtFactory.S_MATERIAL_GOLD_VALUE)--基本加成得分
    if basicScore==nil or tonumber(basicScore) == nil then
    	basicScore=0
    end
    basicScore = tonumber(basicScore)

    return basicScore
end



--跑酷击杀分数增加
--返回所加分数
function MemDataCache:attackScore(s_mID)
    local s_material = TxtFactory:getTable(TxtFactory.MaterialTXT) --材料表
    --print ("基本加成得分==================="..tostring(basicScore))
    local basicScore = s_material:GetData(s_mID,TxtFactory.S_MATERIAL_BASICSCORE)--基本加成得分
    if basicScore==nil or tonumber(basicScore) == nil then
    	basicScore=0
    end
    basicScore = tonumber(basicScore)

    if tonumber(s_material:GetData(s_mID,TxtFactory.S_MATERIAL_TYPE)) == 4  then --材料类型为4的才会有加成

	    basicScore = basicScore + self:addExtraPoints(TxtFactory.S_EQUIP_ADDATKSC,
	    						   TxtFactory.S_SUIT_ADD_KILLSCORE,
	    						   TxtFactory.S_MOUNT_ADDATKSC,
	    						   TxtFactory.S_MAIN_SKILL_ADD_KILL_SCORE,
	    						   4)
	end

	return basicScore
end

--跑酷结算分数增加
--返回所加分数
function MemDataCache:budgetScore()
    return self:addExtraPoints(TxtFactory.S_EQUIP_ADDSC,
    						   TxtFactory.S_SUIT_SCORE_PEN,
    						   TxtFactory.S_MOUNT_ADDSC,
    						   TxtFactory.S_MAIN_SKILL_ADD_SCORE_PEN,
    						   8)
end


--跑酷结算金钱增加
--返回所加分数
function MemDataCache:budgetMoney()
    return self:addExtraPoints(TxtFactory.S_EQUIP_ADDGOLD,
    						   nil,
    						   nil,
    						   nil,
    						   8)
end

--跑酷结算经验增加
--返回所加分数
function MemDataCache:budgetExp()
    return self:addExtraPoints(TxtFactory.S_EQUIP_ADDEXP,
    						   nil,
    						   nil,
    						   nil,
    						   8)
end


--跑酷初始体力计算
--返回体力
function MemDataCache:getFullHP()
    return self:addExtraPoints(TxtFactory.ADDHP,
						   TxtFactory.S_SUIT_BASE_HP,
						   TxtFactory.S_MOUNT_ADDHP,
						   TxtFactory.S_MAIN_SKILL_ADD_HP,
						   1)
end
--[[
   收集，击杀,体力加成计算
   装备加成，套装加成,萌宠基础加成（坐骑加成），主动技能加成，被动技能加成
]]
function MemDataCache:addExtraPoints(EQUIP_ADD,SUIT_ADD,MOUNT_ADD,SKILL_ADD,PASSIVE_SKILL_ADD)
    local s_equip = TxtFactory:getTable(TxtFactory.EquipTXT) --装备表
    local s_suit= TxtFactory:getTable(TxtFactory.SuitTXT) --套装表
    local s_pet_subject = TxtFactory:getTable(TxtFactory.PetSkillMainTXT) --宠物主动技能表
    local s_pet_passive = TxtFactory:getTable(TxtFactory.PetSkillPassiveTXT) --宠物被动技能表
    local s_mount = TxtFactory:getTable(TxtFactory.MountTXT) --宠物坐骑配置表
    
    local m_equip = self:getTable(TxtFactory.EquipInfo) --玩家装备表
    local m_suit = self:getTable(TxtFactory.SuitInfo) --玩家套装表
    local m_pet = self:getTable(TxtFactory.PetInfo) --玩家萌宠表
    local m_mount = self:getTable(TxtFactory.MountInfo) --玩家坐骑表

    local basicScore = 0 --基本加成得分
    local extraScore = 0

	local addExtraScore = function ( extraScore ) --增加额外得分
    	if extraScore==nil or tonumber(extraScore) ==nil then
    		extraScore = 0
    	end
    	basicScore = basicScore + extraScore
	end
    --[[装备配置加成===============================================================
    ==============================================================================]]
    if EQUIP_ADD ~= nil then
	    local getOnEquipment = function () --获得已经装上的装备id
	    	local onEquip = {}
	    	for i=1,#m_equip.bin_equips do
	    		if m_equip.bin_equips[i].slot > 0 then--装备已经装上
	    			table.insert(onEquip,m_equip.bin_equips[i].tid)
	    		end
	    	end
	    	return onEquip
	    end
	    local onEquip = self:getCurEquipTab()--getOnEquipment()
	    for i=1,#onEquip do
	    	extraScore = s_equip:GetData(onEquip[i],EQUIP_ADD)
	    	--print ("装备配置加成==================="..tostring(extraScore))
	    	addExtraScore(extraScore)
	    end
	end
	--[[套装配置加成===================================================================
	==============================================================================]]
	if SUIT_ADD ~= nil then
		local suit_id = RoleProperty.defaultSuit
		if m_suit.cur_suits ~=nil then
			suit_id = m_suit.cur_suits[m_suit.suit_selected_index].suit_config_id
		end
		local extraScore = s_suit:GetData(suit_id,SUIT_ADD)
		--print ("套装配置加成==================="..tostring(extraScore))
		addExtraScore(extraScore)
	end
	--[[宠物配置 宠物主动技能 宠物被动技能================================================================
	==============================================================================]]
	local pets = self:getCurPetTab()--getPetBins()--获取上场萌宠
	for i=1,#pets do 
		if type(pets[i]) =="table" then
			if MOUNT_ADD ~= nil then
				--萌宠基本加成
				extraScore = s_mount:GetData(pets[i].tid,MOUNT_ADD)
				--print ("萌宠基本加成==================="..tostring(extraScore))
	    		addExtraScore(extraScore)
	    	end

	    	if SKILL_ADD ~= nil then
	    		--宠物主动技能加成
	    		local subjectSkill = pets[i].skill1
	    		extraScore = s_pet_subject:GetData(subjectSkill,SKILL_ADD)
	    		--print ("宠物主动技能加成==================="..tostring(extraScore))
	    		addExtraScore(extraScore)
	    	end

	    	if PASSIVE_SKILL_ADD ~= nil then
		    	--宠物被动技能加成
		    	local passiveSkill = pets[i].skill2
		    	local passiveSkillType = pets[i].skills
		    	local passvieSkillNum = pets[i].skill2_val
		    	if passiveSkill == PASSIVE_SKILL_ADD then --收集物加成
		    		--print ("宠物被动技能加成==================="..tostring(passvieSkillNum))
					addExtraScore(passvieSkillNum)
		    	end
	    	end
    	end
	end

	--[[坐骑配置加成 ================================================================
	==============================================================================]]
	if MOUNT_ADD ~= nil then
		extraScore = s_mount:GetData(m_mount.cur_mount,MOUNT_ADD)
		--print ("当前坐骑=================="..tostring(extraScore))
		addExtraScore(extraScore)
	end
    
    return basicScore
end

--装上/卸下装备 数据改变
--equip_id 装备id
--on true：装上 false：卸下
function MemDataCache:exchangeEquip(equip_id,on)
	local s_equip = TxtFactory:getTable(TxtFactory.EquipTXT) --装备表
	local info = self:getTable(TxtFactory.UserInfo)
	local meta = 1
	if on == false then
		meta = -1
	end
	local value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_ADDITEMR)--血瓶增益 吃到血瓶才加血
	if value~=nil and tonumber(value)~=nil then
		info[TxtFactory.USER_BLOOD_BOTTLE_EXTRA] = info[TxtFactory.USER_BLOOD_BOTTLE_EXTRA] + meta * tonumber(value)
	end

	value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_SLOWHP)--延缓体力 跑酷体力减少减缓
	if value~=nil and tonumber(value)~=nil then
		info[TxtFactory.USER_HP_SLOWDOWN] = info[TxtFactory.USER_HP_SLOWDOWN] + meta * tonumber(value)
	end

	value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_TWOJUMPSOCRE)--二段跳额外得分
	if value ~= nil and tonumber(value) ~= nil then
		info[TxtFactory.USER_SECOND_JUMP_SCORE] = info[TxtFactory.USER_SECOND_JUMP_SCORE] + meta * tonumber(value)
	end

	value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_MOREJUMPSOCRE)--多段跳额外得分
	if value ~= nil and tonumber(value) ~= nil then
		info[TxtFactory.USER_MULTI_JUMP_SCORE] = info[TxtFactory.USER_MULTI_JUMP_SCORE] + meta * tonumber(value)
	end

	value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_SUBATKDMG)--受击减伤
	if value ~= nil and tonumber(value) ~= nil then
		info[TxtFactory.USER_MINUS_DAMAGE] = info[TxtFactory.USER_MINUS_DAMAGE] + meta * tonumber(value)
	end

	value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_SUBDROPDMG)--掉坑免伤
	if value ~= nil and tonumber(value) ~= nil then
		info[TxtFactory.USER_INMUNE_FALLDOWN] = info[TxtFactory.USER_INMUNE_FALLDOWN] + meta * tonumber(value)
	end

	value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_MISATKDMG)--免疫攻击，不掉血次数(暂时不做)
	if value ~= nil and tonumber(value) ~= nil then
		info[TxtFactory.USER_INMUNE_ATK_COUNT] = info[TxtFactory.USER_INMUNE_ATK_COUNT] + meta * tonumber(value)
	end

	value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_ADDSUCKHP)--吸血每击杀以下个数怪物获得2点体力
	if value ~= nil and tonumber(value) ~= nil then
		info[TxtFactory.USER_HP_KILL_SUCK] = info[TxtFactory.USER_HP_KILL_SUCK] + meta * tonumber(value)
	end

	value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_ADDSUCKTIME)--磁铁时间延长
	if value ~= nil and tonumber(value) ~= nil then
		info[TxtFactory.USER_MAGNET_TIME_EXTRA] = info[TxtFactory.USER_MAGNET_TIME_EXTRA] + meta * tonumber(value)
	end

	value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_ADDGODTIME)--无敌延长
	if value ~= nil and tonumber(value) ~= nil then
		info[TxtFactory.USER_INVINCIBLE_TIME_EXTRA] = info[TxtFactory.USER_INVINCIBLE_TIME_EXTRA] + meta * tonumber(value)
	end

	value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_ENERGY)--击杀怪物额外能量 神圣模式能量
	if value ~= nil and tonumber(value) ~= nil then
		info[TxtFactory.USER_HOLY_KILL_SUCK] = info[TxtFactory.USER_HOLY_KILL_SUCK] + meta * tonumber(value)
	end

	-- value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_ENERGYJUMP)--跳跃产生极限碎片 弹跳加神圣模式能量
	-- if value ~= nil and tonumber(value) ~= nil then
	-- 	info[TxtFactory.USER_SECOND_JUMP_SCORE] = info[TxtFactory.USER_SECOND_JUMP_SCORE] + meta * tonumber(value)
	-- end

	value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_ADDJUMP)--跳跃次数增加
	if value ~= nil and tonumber(value) ~= nil then
		info[TxtFactory.USER_JUMP_CAP] = info[TxtFactory.USER_JUMP_CAP] + meta * tonumber(value)
	end

	value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_CDDOWM)--减少CD时间 套装cd时间
	if value ~= nil and tonumber(value) ~= nil then
		if meta == 1 then
			info[TxtFactory.USER_SUIT_SKILL_CD] = info[TxtFactory.USER_SUIT_SKILL_CD] * (1 + tonumber(value))
		else
			info[TxtFactory.USER_SUIT_SKILL_CD] = info[TxtFactory.USER_SUIT_SKILL_CD] / (1 + tonumber(value))
		end
	end

	value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_SPEED)--增加速度 跑酷速度
	if value ~= nil and tonumber(value) ~= nil then
		if meta == 1 then
			info[TxtFactory.USER_SPEED_EXTRA] = info[TxtFactory.USER_SPEED_EXTRA] * (1 + tonumber(value))
		else
			info[TxtFactory.USER_SPEED_EXTRA] = info[TxtFactory.USER_SPEED_EXTRA] / (1 + tonumber(value))
		end
	end

	value = s_equip:GetData(equip_id,TxtFactory.S_EQUIP_VOLPLANE)--滑翔得分
	if value ~= nil and tonumber(value) ~= nil then
		info[TxtFactory.USER_DIVE_SCORE] = info[TxtFactory.USER_DIVE_SCORE] + meta * tonumber(value)
	end

 	value = s_equip:GetData(equip_id, TxtFactory.S_EQUIP_SPRINT) --冲刺时间
	if value ~= nil and tonumber(value) ~= nil then
		if meta == 1 then
			info[TxtFactory.USER_ON_DUCK_FLY_TIME] = info[TxtFactory.USER_ON_DUCK_FLY_TIME] * (1 + tonumber(value))
		else
			info[TxtFactory.USER_ON_DUCK_FLY_TIME] = info[TxtFactory.USER_ON_DUCK_FLY_TIME] / (1 + tonumber(value))
		end
	end
end

--装上/卸下萌宠 数据改变
--equip_id 装备id
--on true：装上 false：卸下
function MemDataCache:exchangePet(petInfo,on)

end
