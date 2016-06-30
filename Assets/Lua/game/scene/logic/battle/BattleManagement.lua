--[[
author:Desmond
跑酷数据管理
]]
BattleManagement = class()

BattleManagement.scene = nil --对应登录场景
BattleManagement.userTable = nil  --用户表

--初始化
function BattleManagement:Awake()
	self.userTable = TxtFactory:getTable("UserTXT")
end

--[[
无尽发送结算成绩
]]
function BattleManagement:sendEndRunningRequest(role)
	local json = require "cjson"
	local user = TxtFactory:getTable("UserTXT")
    --[[
    local msg = {
    	score	= math.floor(role:getScoreResult()),
		coins    = math.floor(role:getMoneyResult()),
		exp      = math.floor(role:getExpResult()),
	}
    local strr = json.encode(msg)
    ]]--
     local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
         local msg = {
    	score	= math.floor(role:getScoreResult()),
		coins    = math.floor(role:getMoneyResult()),
		exp      = math.floor(role:getExpResult()),
	   }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = battle_pb.EndBattleEndRequest()
        message.score = math.floor(role:getScoreResult())
        message.coins = math.floor(role:getMoneyResult())
        message.exp = math.floor(role:getExpResult())
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    
    local param = {
              code = MsgCode.EndBattleEndRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.EndBattleEndResponse, self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

--[[
无尽获取结算成绩
]]
function BattleManagement:getEndRunningResponse(response)

    
    --print (response.data)
    local json = require "cjson"
    local data = json.decode(response.data)
    local txt = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    if data.coins ~= nil then
    	txt[TxtFactory.USER_GOLD] = txt[TxtFactory.USER_GOLD] + data.coins
	end

	if data.exp ~= nil then
       
    	txt[TxtFactory.USER_EXP] = txt[TxtFactory.USER_EXP] + data.exp
        print("txt[TxtFactory.USER_EXP]  : "..txt[TxtFactory.USER_EXP] )
	end
    
    -- 扣除体力
    if data.strength ~= nil then
        txt[TxtFactory.USER_STRENGTH] = data.strength
    end
    
    if data.strength_time ~= nil then
        txt[TxtFactory.USER_STRENGTH_TIME] = data.strength_time
    end
    
    
    	
    if data.level>txt[TxtFactory.USER_LEVEL]  then
        self.scene:showPlayerLevelUpView(data.level ,function (scene) 
            scene:showEndlessResult()
        end)
        
        txt[TxtFactory.USER_LEVEL] = data.level 
    else
        self.scene:showEndlessResult()
    end
end

--[[ 

争夺据点发送结算成绩
]]--
function BattleManagement:sendStrongholdRequest(role)
     printf("争夺据点获取结算成绩")
	local json = require "cjson"
	local user = TxtFactory:getTable("UserTXT")
    
     local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {
        id = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_STRONGHOLDID),
        score	= math.floor(role:getScoreResult()),
		gold    = math.floor(role:getMoneyResult()),
        exp      = math.floor(role:getExpResult()),
	   }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = explorer_pb.ExplorerListRequest()
		message.id = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_STRONGHOLDID)
        message.score =  math.floor(role:getScoreResult())
        message.gold =  math.floor(role:getMoneyResult())
        message.exp =  math.floor(role:getExpResult())
        strr = ZZBase64.encode(message:SerializeToString())
    end
    --[[
    local msg = {
        id = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_STRONGHOLDID),
        score	= math.floor(role:getScoreResult()),
		gold    = math.floor(role:getMoneyResult()),
        exp      = math.floor(role:getExpResult()),
	}
    local strr = json.encode(msg)
    ]]--
    local param = {
              code = MsgCode.ExplorerEndRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.ExplorerEndResponse, self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

--[[ 

争夺据点获取结算成绩
]]--
function BattleManagement:getStrongholdRequest(response)
    local json = require "cjson"
    local data = json.decode(response.data)
    local txt = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
 
    if data.coins ~= nil then
    	txt[TxtFactory.USER_GOLD] = txt[TxtFactory.USER_GOLD] + data.coins
	end
    -- 保存抢到的夺宝币
    if data.sgold ~= nil then
        local snatch_gold =  TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_GOLD)+data.sgold
        TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_GOLD,snatch_gold)
	end
    
    local task = TxtFactory:getTable(TxtFactory.TaskManagement)
    task:SetTaskData(TaskType.TERRITORY_WIN,1)
    -- 保存据点战斗结束信息
    TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_BATTLERESULT,data)
 
	if data.exp ~= nil then
       
    	txt[TxtFactory.USER_EXP] = txt[TxtFactory.USER_EXP] + data.exp
        --print("txt[TxtFactory.USER_EXP]  : "..txt[TxtFactory.USER_EXP] )
	end
   
      if data.upgrade>txt[TxtFactory.USER_LEVEL]  then
            self.scene:showPlayerLevelUpView(data.upgrade ,function (scene) 
               scene:showSnatchResult()
            end)
            
            txt[TxtFactory.USER_LEVEL] = data.upgrade 
        else
             self.scene:showSnatchResult()
        end
    
end

--[[



//汇报关卡成绩
message EndBattleRequest{
	enum MSGTYPE { ID=17004;}
	optional int32 battle_id	= 1;
	optional int32 star 		= 2;
	repeated int32 cup_task     = 3;//给索引id给我
}



]]--
--[[
剧情发送结算成绩
]]
function BattleManagement:sendStoryRunningRequest(role,isTest)

	local json = require "cjson"
	local user = TxtFactory:getTable("UserTXT")
    
     self.RoleScore = math.floor(role:getScoreResult())
    local taskManagement = TxtFactory:getTable(TxtFactory.TaskManagement)
    taskManagement:SetTaskData(TaskType.ALONE_SCORE, self.RoleScore)
    taskManagement:SetTaskData(TaskType.LEVEL_NOW,true)

   
    self.chapterTable =TxtFactory:getMemDataCacheTable(TxtFactory.ChapterInfo)
    if  self.chapterTable == nil then
        return
    end
    print(self.chapterTable[TxtFactory.SELECTED_BATTLE_ID])
    --任务奖杯
   -- local cupList= {}
    --先使用假数据
   --cupList = {1,1,1,1,1,0}
    
   --奖杯任务
   local cupList = {0,0,0,0,0,0}
   local battleId = tonumber(self.chapterTable[TxtFactory.SELECTED_BATTLE_ID])
   local chapterTXT = TxtFactory:getTable(TxtFactory.ChapterTXT)
   local cupTaskList = chapterTXT:GetLevelCupTask(battleId)
    cupList = taskManagement:GetTaskCompleteList(cupTaskList)
    taskManagement:SetTaskData(TaskType.LEVEL,battleId)
    local memdata = TxtFactory:getTable(TxtFactory.MemDataCache)
    local petTab = memdata:getCurPetTab()
    --穿哪个宠物
    for i = 1,#petTab do
        taskManagement:SetTaskData(TaskType.USE_THE_PET,petTab[i],petTab[i])
    end
    --完成某一关
    taskManagement:SetTaskData(TaskType.USE_THE_PET,battleId)
   local targetList = {}
   local currentTotolCupList = {}
   local currentList = self.chapterTable.cupList[battleId]
   
   if currentList ~= nil then
       for i = 1,#currentList do
            currentTotolCupList[i] = currentList[i]
       end
        --当前没有关卡新获得的奖杯
        for i = 1,#cupList do
            if currentList[i] == 0  and cupList[i] == 1 then
                targetList[i] = 1
                currentTotolCupList[i] = 1
                
            else
                targetList[i] = 0
            end 
        end
   else
      targetList = cupList  
      currentTotolCupList =cupList
   end
 
   self.CurrentBattleCupList =  currentTotolCupList
     
   --战斗星级
   local starList = {0,0,0}
   local starsTaskID = chapterTXT:GetData(battleId,"StarsTaskID")
   starList  = taskManagement:GetTaskCompleteOne(starsTaskID)    
        
   local starNum= 0
   for i = 1,#starList do
       if starList[i] == 1 then
            starNum = starNum+1
       end
   end
    if RoleProperty.UseTestStroy and isTest== true then
        --starNum = 3
        --targetList = {1,1,1,1,1,1}
        --self.CurrentBattleCupList  = {1,1,1,1,1,1}
    end
   --[[
    local msg = {
    	battle_id =battleId,
		star    = starNum ,
        cup_task = targetList
       
	}
    --test
   
     
    local strr = json.encode(msg)
    ]]--
     local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
         local msg = {
    	   battle_id =battleId,
		   star    = starNum ,
           cup_task = targetList
	       }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = battle_pb.EndBattleRequest()
        message.battle_id =battleId
        message.star =starNum
        for i = 1 , #targetList do
             message.cup_task:append(targetList[i])
	    end
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    
    local param = {
              code = MsgCode.EndBattleRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.EndBattleResponse, self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end






--[[
    
    
    //根据成绩得到结算的奖励
message EndBattleResponse{
	enum MSGTYPE { ID=17005;}
	optional int32 battle_id    = 1;
	optional int32 star         = 2;
	//optional int32 money        = 3;
	//optional int32 exp          = 4;
	//optional int32 diamond      = 5;
	//optional int32 upgrade      = 6;//0为没有升级 非0为升级到的级数
	//repeated ItemInfo bin_items = 7;//物品列表
	repeated BattleTaskReward normal_reward = 8;//关卡任务奖励
	repeated BattleTaskReward cup_reward = 9;//奖杯任务奖励
}

//关卡任务奖励
message BattleTaskReward {
	optional int32 id 			= 1;    //所在的索引id
	optional int32 gold 		= 2;
	optional int32 diamond 		= 3;
	optional int32 exp  		= 4;
	repeated ItemInfo bin_items = 5;
	optional PetInfo pet_info 	= 6;
	optional EquipInfo equip_info = 7;
	optional int32 upgrade      = 8;//0为没有升级 非0为升级到的级数
}

剧情获取结算成绩
]]
function BattleManagement:getStoryRunningResponse(response)    
    
    --print (response.data)
    local json = require "cjson"
    local data = json.decode(response.data)
    local txt = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    local chapterTXT = TxtFactory:getTable(TxtFactory.ChapterTXT)
    --战斗星级
    --保存之前的奖杯用于显示效果
    local onceCupList = {}
    if data.battle_id ~=nil then
            
        if string.find(tostring(data.cur_battle_id ),"001") and self.chapterTable.chapter_star[data.battle_id]  == nil then 
            local chapterID = chapterTXT:GetData(data.cur_battle_id,TxtFactory.S_CHAPTER_TYPE)
            self.chapterTable.chapter_info[chapterID] = true  
            --print("chapterTable ;"..chapterID)  
            --当前开启的章节
            Util.SetString("CurrentChapterID",tostring(chapterID)) 
                        
        end
        
        --记录最多的星级
        if self.chapterTable.chapter_star[data.battle_id] == nil then
             self.chapterTable.chapter_star[data.battle_id] = data.star
        else
            if  self.chapterTable.chapter_star[data.battle_id] < data.star then
                self.chapterTable.chapter_star[data.battle_id] = data.star
            end
        end

    
        if self.chapterTable.cupList[data.battle_id] ~= nil then
            for i = 1,#self.chapterTable.cupList[data.battle_id] do
                onceCupList[i] =self.chapterTable.cupList[data.battle_id][i]
               -- print("self.chapterTable.cupList[data.battle_id][i] : "..self.chapterTable.cupList[data.battle_id][i])
            end
        end
        self.chapterTable.cupList[data.battle_id] = self.CurrentBattleCupList
        
    
        local CurrentchapterId = chapterTXT:GetData(data.battle_id,TxtFactory.S_CHAPTER_TYPE)
         --当前玩的哪个章节
        self.chapterTable.selected_battle_id = data.battle_id
        local battle_index = chapterTXT:GetCurrentLevelIndex(data.battle_id)
        self.chapterTable.cur_battle_id =  tonumber(data.cur_battle_id)
        self.chapterTable.chapter_info[data.cur_battle_id] = true
        --下一关必须小于总的关卡数
    end
    
    
    --关卡任务奖励
      local normal_rewardList = nil
     if data.normal_reward~=nil then
        local list = data.normal_reward 
         normal_rewardList = self:GetTaskRewardList(list)
     end
     
     --奖杯任务奖励
     local cup_rewardList = nil 
     if data.cup_reward~= nil then
        local list = data.cup_reward 
        cup_rewardList = self:GetTaskRewardList(list)
        --奖杯任务奖励界面显示
        --  self.scene:showCupListReward(cup_rewardList) -- 创建奖励界面
     end
     --两个奖励合并起来
    local totalRewardList = nil 
    local totalRewardTable = nil
     if data.normal_reward ~=nil then
       totalRewardList = data.normal_reward
       if data.cup_reward ~=nil then
            for i = 1,#data.cup_reward do
                table.insert(totalRewardList,data.cup_reward[i])
            end
       end 
       
     else
        if data.cup_reward ~=nil then
            totalRewardList = data.cup_reward
         end
     end
     
    --添加到本地数据里面
    totalRewardTable = self:GetTaskRewardList(totalRewardList)
    txt[TxtFactory.USER_GOLD] = txt[TxtFactory.USER_GOLD]+totalRewardTable.gold
    txt[TxtFactory.USER_EXP] = txt[TxtFactory.USER_EXP]+totalRewardTable.exp
    txt[TxtFactory.USER_DIAMOND] = txt[TxtFactory.USER_DIAMOND]+totalRewardTable.diamond
    -- 扣除体力
    if data.strength ~= nil then
        txt[TxtFactory.USER_STRENGTH] = data.strength
    end
    if data.strength_time ~= nil then
        txt[TxtFactory.USER_STRENGTH_TIME] = data.strength_time
    end
    
      --结算物品
     local memDataCache = TxtFactory:getTable(TxtFactory.MemDataCache)
     memDataCache:AddUserInfoItemForType(TxtFactory.BagItemsInfo,totalRewardTable.bin_items)
     --结算装备
     memDataCache:AddUserInfoItemForType(TxtFactory.EquipInfo ,totalRewardTable.equip_info)
     --结算宠物
     memDataCache:AddUserInfoItemForType(TxtFactory.PetInfo,totalRewardTable.pet_info)
        --test 
            --结算升级
            GamePrint("totalRewardTable.upgrade : "..totalRewardTable.upgrade)
    if totalRewardTable.upgrade ~= 0 then
        txt[TxtFactory.USER_LEVEL] = totalRewardTable.upgrade
        --展示升级界面
        local OkDel = function (scene,Datalist) 
              scene:VictoryUIPanelShow(Datalist)
        end
        self.scene:showPlayerLevelUpView(txt[TxtFactory.USER_LEVEL],OkDel,normal_rewardList,cup_rewardList,self.CurrentBattleCupList,onceCupList, self.RoleScore,totalRewardTable.gold,totalRewardTable.exp,data.star)            
    else
        local dataList = {}
        dataList[1] = normal_rewardList
        dataList[2] = cup_rewardList
        dataList[3] = self.CurrentBattleCupList
        dataList[4] = onceCupList
        dataList[5] =  self.RoleScore
        dataList[6] = totalRewardTable.gold
        dataList[7] = totalRewardTable.exp
        dataList[8] = data.star
        self.scene:VictoryUIPanelShow(dataList)
    end
        -- self.RoleScore = 100000
	 --self.scene:VictoryUIPanelShow(normal_rewardList,cup_rewardList,self.CurrentBattleCupList,onceCupList, self.RoleScore,totalRewardTable.gold,totalRewardTable.exp,data.star)
end

-- 萌宠动态表里添加
function EmailManagement:petMemDataCacheTableAdd(petData)
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]
	petTab[#petTab +1] = petData
	self:setValue(TxtFactory.PetInfo,TxtFactory.BIN_PETS,petTab)
end

function EmailManagement:EquipMemDataCacheTableAdd(EquipList)
	    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)

        if EquipList ~= nil then
            for i =1 ,#EquipList do
                local t = EquipList[i]
                EquipInfoTab.bin_equips[#EquipInfoTab.bin_equips + 1] = t
            end
        end
end



--获得一个一窜任务的奖励获得的物品和其他奖励
function BattleManagement:GetTaskRewardList(taskRewardList)
    local retList = {}
    
    
     retList.gold = 0
     retList.diamond = 0
     retList.exp = 0
     retList.upgrade = 0
     retList.bin_items ={}
     retList.pet_info = {}
     retList.equip_info = {}
     
     
    if taskRewardList~=nil then
        for i = 1,#taskRewardList do 
            local data = taskRewardList[i]
            if data ~=nil then
                if data.gold~=nil then
                    retList.gold = data.gold+retList.gold
                end
                if data.diamond ~= nil then
                    retList.diamond = data.diamond+retList.diamond
                end
                if data.exp ~=nil then
                    retList.exp =data.exp+retList.exp
                end
                if data.upgrade ~=nil then
                     retList.upgrade = data.upgrade
                end
                if data.bin_items ~= nil then
                    for i = 1,#data.bin_items do
                        table.insert(retList.bin_items,data.bin_items[i])
                    end
                end
                if data.pet_info ~= nil then
                     table.insert(retList.pet_info,data.pet_info)
                end
                if data.equip_info ~= nil then
                      table.insert(retList.equip_info,data.equip_info)
                end
            end 
        end 
    end
    
    return retList 
end


----------------------------------------------------  天梯 无尽模式结算  ----------------------------------

-- 定位赛结算 (请求)
function BattleManagement:sendLadderRaceEndRequest(role)
    
	local json = require "cjson"
	local user = TxtFactory:getTable("UserTXT")
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
       local msg = {
    	 score	= math.floor(role:getScoreResult()),
         gold    = math.floor(role:getMoneyResult()),
         exp      = math.floor(role:getExpResult()),
	   }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = ladder_pb.LadderRaceEndRequest()
        message.score = math.floor(role:getScoreResult())
        message.gold = math.floor(role:getMoneyResult())
        message.exp = math.floor(role:getExpResult())
        strr = ZZBase64.encode(message:SerializeToString())
    end
    --[[
    local msg = {
    	 score	= math.floor(role:getScoreResult()),
         gold    = math.floor(role:getMoneyResult()),
         exp      = math.floor(role:getExpResult()),
	}
    local strr = json.encode(msg)
    ]]--
    local param = {
              code = MsgCode.LadderRaceEndRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.LadderRaceEndResponse, self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 定位赛结算 (回复)

function BattleManagement:getLadderRaceEndResponse(response)
    local json = require "cjson"
    local data = json.decode(response.data)
    local txt = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    
    if data.result ~= 1 then
        self.scene:showEndlessResult()
        return
    end
    
    if data.gold ~= nil then
    	txt[TxtFactory.USER_GOLD] = txt[TxtFactory.USER_GOLD] + data.gold
	end
    -- 扣除体力
    if data.strength ~= nil then
        txt[TxtFactory.USER_STRENGTH] = data.strength
    end
    if data.strength_time ~= nil then
        txt[TxtFactory.USER_STRENGTH_TIME] = data.strength_time
    end
    -- 更新天梯积分信息
    local ladderInfo = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO)
   -- GamePrint("----"..ladderInfo.max_score)
    --GamePrint("----"..data.score)
    if ladderInfo.max_score == nil or ladderInfo.max_score < data.score then
        ladderInfo.max_score = data.score
    end
    -- 更新玩家信息
    local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
  	memData:AddUserInfo(-data.use_gold,-data.use_diamond) -- 刷新面板
  	--self.scene:UpdatePlayerInfo()
    -- 定位赛结算还是走无尽的结算
   -- self.scene:showEndlessResult()
    if data.exp ~= nil then
       
    	txt[TxtFactory.USER_EXP] = txt[TxtFactory.USER_EXP] + data.exp
        GamePrint("txt[TxtFactory.USER_EXP]  : "..txt[TxtFactory.USER_EXP] )
	end
   
      if data.upgrade>txt[TxtFactory.USER_LEVEL]  then
            self.scene:showPlayerLevelUpView(data.upgrade ,function (scene) 
               scene:showEndlessResult()
            end)
            
            txt[TxtFactory.USER_LEVEL] = data.upgrade 
        else
             self.scene:showEndlessResult()
        end
   
end
   
-- 晋级挑战汇报 (请求)
function BattleManagement:sendLadderUpgradeEndRequest(role)
    
	local json = require "cjson"
	local user = TxtFactory:getTable("UserTXT")
    
     local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
       local msg = {
    	 score	= math.floor(role:getScoreResult()),
         gold    = math.floor(role:getMoneyResult()),
         exp      = math.floor(role:getExpResult()),
	   }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = ladder_pb.LadderUpgradeEndRequest()
        message.score = math.floor(role:getScoreResult())
        message.gold = math.floor(role:getMoneyResult())
        message.exp = math.floor(role:getExpResult())
        strr = ZZBase64.encode(message:SerializeToString())
    end
    --[[
    local msg = {
    	 score	= math.floor(role:getScoreResult()),
         gold    = math.floor(role:getMoneyResult()),
         exp      = math.floor(role:getExpResult()),
	}
    local strr = json.encode(msg)
    ]]--
    local param = {
              code = MsgCode.LadderUpgradeEndRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.LadderUpgradeEndResponse, self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 晋级挑战汇报 (回复)

function BattleManagement:getLadderUpgradeEndResponse(response)
    local json = require "cjson"
    local data = json.decode(response.data)
    local txt = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    if data.gold ~= nil then
    	txt[TxtFactory.USER_GOLD] = txt[TxtFactory.USER_GOLD] + data.gold
	end
     -- 扣除体力
    if data.strength ~= nil then
        txt[TxtFactory.USER_STRENGTH] = data.strength
    end
    if data.strength_time ~= nil then
        txt[TxtFactory.USER_STRENGTH_TIME] = data.strength_time
    end
    --[[
    if data.result == 0 then
    
    elseif data.result == 3 then
    
    else
        -- 更新天梯信息
        TxtFactory:setValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO,data.ladder_info)
        TxtFactory:setValue(TxtFactory.LadderInfo,TxtFactory.LADDER_UPGRADE_RESULT,data.result)
        --  晋级赛结算还是走无尽的结算
        self.scene:showEndlessResult()
    end
   ]]--
     -- 更新天梯信息
    TxtFactory:setValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO,data.ladder_info)
    TxtFactory:setValue(TxtFactory.LadderInfo,TxtFactory.LADDER_UPGRADE_RESULT,data.result)
    --  晋级赛结算还是走无尽的结算
  --  self.scene:showEndlessResult()
    if data.exp ~= nil then
       
    	txt[TxtFactory.USER_EXP] = txt[TxtFactory.USER_EXP] + data.exp
        GamePrint("txt[TxtFactory.USER_EXP]  : "..txt[TxtFactory.USER_EXP] )
	end
   
      if data.upgrade>txt[TxtFactory.USER_LEVEL]  then
            self.scene:showPlayerLevelUpView(data.upgrade ,function (scene) 
               scene:showEndlessResult()
            end)
            
            txt[TxtFactory.USER_LEVEL] = data.upgrade 
        else
             self.scene:showEndlessResult()
        end
   
end

-- 向其他玩家发起晋级挑战 (请求)
function BattleManagement:sendLadderChallengeRequest(role)
    
	local json = require "cjson"
	local user = TxtFactory:getTable("UserTXT")
    
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
       local msg = {
    	 score	= math.floor(role:getScoreResult()),
         gold    = math.floor(role:getMoneyResult()),
         exp      = math.floor(role:getExpResult()),
         memberid = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_RIVAL_MEMBERID),
	   }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = ladder_pb.LadderChallengeRequest()
        message.score = math.floor(role:getScoreResult())
        message.gold = math.floor(role:getMoneyResult())
        message.exp = math.floor(role:getExpResult())
        message.memberid = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_RIVAL_MEMBERID)
        strr = ZZBase64.encode(message:SerializeToString())
    end
    --[[
    local msg = {
    	 score	= math.floor(role:getScoreResult()),
         gold   = math.floor(role:getMoneyResult()),
         memberid = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_RIVAL_MEMBERID),
         exp      = math.floor(role:getExpResult()),
	}
    local strr = json.encode(msg)
    ]]--
    local param = {
              code = MsgCode.LadderChallengeRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.LadderChallengeResponse, self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 向其他玩家发起晋级挑战 (回复)

function BattleManagement:getLadderChallengeResponse(response)
    local json = require "cjson"
    local data = json.decode(response.data)
    local txt = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    if data.gold ~= nil then
    	txt[TxtFactory.USER_GOLD] = txt[TxtFactory.USER_GOLD] + data.gold
	end
     -- 扣除体力
    if data.strength ~= nil then
        txt[TxtFactory.USER_STRENGTH] = data.strength
    end
    if data.strength_time ~= nil then
        txt[TxtFactory.USER_STRENGTH_TIME] = data.strength_time
    end
    
    -- 保存天梯挑战数据
    TxtFactory:setValue(TxtFactory.LadderInfo,TxtFactory.LADDER_CHALLENGE_RESULT,data)
    
    -- 挑战赛结算还是走无尽的结算
    --self.scene:showLadderChallengeResultView()
    
    if data.exp ~= nil then
       
    	txt[TxtFactory.USER_EXP] = txt[TxtFactory.USER_EXP] + data.exp
        GamePrint("txt[TxtFactory.USER_EXP]  : "..txt[TxtFactory.USER_EXP] )
	end
   
      if data.upgrade>txt[TxtFactory.USER_LEVEL]  then
            self.scene:showPlayerLevelUpView(data.upgrade ,function (scene) 
               scene:showLadderChallengeResultView()
            end)
            
            txt[TxtFactory.USER_LEVEL] = data.upgrade 
        else
             self.scene:showLadderChallengeResultView()
        end
    
   
end
--向其他好友发送无尽挑战 请求
function BattleManagement:SendEndRunningChallengeReq(score) 
    local json = require "cjson"
     local strr = nil
     local friendId = TxtFactory:getValue(TxtFactory.ChallengeInfo,TxtFactory.CHALLENGE_FRIENDID)
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {memberid = tonumber(friendId or 1),score = tonumber(score)}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = mail_pb.FriendChallengeRequest()
        message.memberid = tonumber(friendId or 1)
        message.score = tonumber(score)
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    local param = {
        code = MsgCode.FriendChallengeRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.FriendChallengeResponse,self)
    NetManager:SendPost(NetConfig.FRIENDCHALLENGE,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    GamePrint("发送挑战信息，挑战了:"..tonumber(friendId or 1).."   我的得分为："..tonumber(score))
end
--向其他好友发起无尽挑战 回复
function BattleManagement:GetEndRunningChallengeResp(resp)

    local json = require "cjson"
    local infos = json.decode(resp.data)
    if infos.result == 1 then
        GamePrint("向其他好友发起挑战成功"..infos.memberid)
        local friendInfo = TxtFactory:getValue(TxtFactory.ChallengeInfo,TxtFactory.CHALLENGE_FRIENDINFO)
        self.scene:ShowChallengeWaitView(friendInfo)
        self:ClearChallangeInfo(TxtFactory.ChallengeInfo)
    else
        GamePrint("发起挑战失败"..infos.result)
        --self.scene.scene:promptWordShow("发起挑战失败！")
    end
end
--应战 请求
function BattleManagement:SendEndRunningReplyChallengeReq(score) 
    local json = require "cjson"
     local strr = nil
     local friendId = TxtFactory:getValue(TxtFactory.ReplyChallengeInfo,TxtFactory.REPLYCHALLENGE_FRIENDID)
     local mailId = TxtFactory:getValue(TxtFactory.ReplyChallengeInfo,TxtFactory.REPLYCHALLENGE_MAILID)
     if AppConst.isPBencrypted == false then --pb不加密
        local msg = {memberid = tonumber(friendId or 1),mail_id = tonumber(mailId or 0),score = tonumber(score or 0)}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = mail_pb.FriendAckChallengeRequest()
        message.memberid = tonumber(friendId or 1)
        message.mail_id = tonumber(mailId or 0)
        message.score = tonumber(score or 0)
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
        code = MsgCode.FriendAckChallengeRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.FriendAckChallengeResponse,self)
    NetManager:SendPost(NetConfig.FRIENDCHALLENGE,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    GamePrint("发送应战信息，回应了:"..tonumber(friendId or 1).."  邮件ID："..tonumber(mailId or 0).."   我的得分为："..tonumber(score or 0))
end
--应战 回复
function BattleManagement:GetEndRunningReplyChallengeResp(resp)

    local json = require "cjson"
    local infos = json.decode(resp.data)
    if infos.result == 1 then
        GamePrint("应战胜利，挑战者的得分："..infos.src_score.."   我的得分："..infos.dst_score)
        local tab = {}
        tab["dst_score"] = infos.dst_score
        tab["src_score"] = infos.src_score
        self.scene:ShowChallengeWinView(tab)
    elseif infos.result == 2 then
        GamePrint("应战失败，挑战者的得分："..infos.src_score.."   我的得分："..infos.dst_score)
        local tab = {}
        tab["dst_score"] = infos.dst_score
        tab["src_score"] = infos.src_score
        self.scene:ShowChallengeLoseView(tab)
    else
        GamePrint("无效的邮件")
    end
end
--应战或挑战成功后清空本地保存的挑战数据  TxtFactory.ChallengeInfo  TxtFactory.ReplyChallengeInfo
function BattleManagement:ClearChallangeInfo(column)
    TxtFactory:setMemDataCacheTable(column,nil)
end
--领取应战邮件
function BattleManagement:SendEmailReward(tab)
    if #tab == 0 then
        print ("have not  email reward")
        return
    end
    local json = require "cjson"
       local strr = nil
     if AppConst.isPBencrypted == false then --pb不加密
       local msg = { bin_mails =tab }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = charinfo_pb.GetMailItemRequest()
        for i = 1 , #tab do
              --printf("petid ==="..curDefendPets[i])
             message.bin_mails:append(tab[i])
        end
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
        code = MsgCode.GetMailItemRequest,
        data = strr,
    }
    --MsgFactory:createMsg(MsgCode.GetMailItemResponse,self)
    NetManager:SendPost(NetConfig.DEFAULT,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end
--关卡消耗道具 请求
function BattleManagement:SendUseItemReq(items) 
    local json = require "cjson"
     local strr = nil
     local itemTab = {}
     for i=1,#items do
        GamePrint("BattleManagement:SendUseItemReq   tid:"..items[i])
        local itemInfo = {}
        itemInfo.tid = tonumber(items[i])
        itemInfo.num = 1
        itemInfo.id = 0
        itemInfo.add_num = 0
        table.insert(itemTab,itemInfo)
     end
     if AppConst.isPBencrypted == false then --pb不加密
        local msg = {
            bin_items = itemTab
        }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.UseItemRequest()
        bin_items = itemTab
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
        code = MsgCode.UseItemRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.UseItemResponse,self)
    NetManager:SendPost(NetConfig.STORYUSEITEM,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end
--关卡消耗道具 回复
function BattleManagement:GetUseItemResp(resp)
    GamePrint("BattleManagement:GetUseItemResp")
    local json = require "cjson"
    local infos = json.decode(resp.data)
    if infos.result == 1 then
        local memData = TxtFactory:getTable(TxtFactory.MemDataCache)  --扣除道具
        memData:AddUserInfoItemForType(TxtFactory.BagItemsInfo,infos.bin_items)
    else
    end
end

--向匹配的玩家发起挑战 请求
function BattleManagement:SendRankChallengeRequest(score) 
    local json = require "cjson"
     local strr = nil
    local memberid  = TxtFactory:getValue(TxtFactory.AsyncPvpInfo,TxtFactory.ASYNCPVPVINFO_MEMBERID)
     if AppConst.isPBencrypted == false then --pb不加密
        local msg = {memberid = memberid,score = tonumber(score or 0),mi =0}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = rank_pb.RankChallengeRequest()
       -- message.memberid = tonumber(memberid)
       -- message.mi = 0
      --  message.score = tonumber(score or 0)
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
        code = MsgCode.RankChallengeRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.RankChallengeResponse,self)
    NetManager:SendPost(NetConfig.FRIENDCHALLENGE,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    
end
--应战 回复
function BattleManagement:GetRankChallengeResponse(resp)

    local json = require "cjson"
    local infos = json.decode(resp.data)
    
    -- 保存数据
   -- print("I Come on")
    
    self.scene:OpenAsyncPvpResultView()
    
end