--[[
author:sunkai
跑酷声音
]]
TaskManagement = class()

TaskManagement.tag = "TaskManagement"
TaskManagement.memTable = nil --内存数据表


--by sunkai 关卡任务
--收集了什么道具有几个
TaskType ={}
TaskType.TASK_COLLECT = "TASK_COLLECT"
--使用了什么道具有几个 
TaskType.USE_PROPS = "USE_PROPS"
--累计分数
TaskType.ALTOGETHER_SCORE = "ALTOGETHER_SCORE"

--单局获得得分
TaskType.ALONE_SCORE = "ALONE_SCORE"
-- 使用技能数量
TaskType.SKILL_COUNT = "SKILL_COUNT"
--击杀怪物数量
TaskType.ENEMY_COUNT = "ENEMY_COUNT"
--无伤通过
TaskType.NO_HURT = "NO_HURT"
--不是用攻击过关
TaskType.NO_ATK = "NO_ATK"

--"收集超过50%的收集物"
TaskType.COLLECT_PROPORTION = "COLLECT_PROPORTION"
-- 攻击次数上限
TaskType.ATK_COUNT_MAX = "ATK_COUNT_MAX"
--"跳跃次数"
TaskType.JUMP_COUNT_MAX = "JUMP_COUNT_MAX"
--是否击杀所有怪物
TaskType.KILL_COUNT = "KILL_COUNT"
--by sunkai 关卡任务
TaskType.LEVEL_NOW = "LEVEL_NOW"

--战斗之外的数据
--购买道具数量
TaskType.BUY_COUNT ="BUY_COUNT"
--天梯
TaskType.LADDER_COUNT="LADDER_COUNT"
--向好友赠送体力
TaskType.LIGHT_COUNT = "LIGHT_COUNT"
--关卡过关
TaskType.LEVEL = "LEVEL"
--默认套装达到多少等级
TaskType.DRESS_GETTO_LV = "DRESS_GETTO_LV"
--将宠物升级到多少等级
TaskType.PET_GETTP_LV = "PET_GETTP_LV"
--任意套装达到多少等级
TaskType.ANY_DRESS_GETTO_LV = "ANY_DRESS_GETTO_LV"
--任意宠物达到多少等级
TaskType.ANY_PET_GETTO_LV = "ANY_PET_GETTO_LV"
--使用某个套装进行一局游戏
TaskType.USE_THE_DRESS = "USE_THE_DRESS"
--使用宠物进行一局游戏
TaskType.USE_THE_PET = "USE_THE_PET"
--赢得多少次据点比赛
TaskType.TERRITORY_WIN = "TERRITORY_WIN"
--赢得多少次神圣模式比赛
TaskType.SUPER_LEVEL = "SUPER_LEVEL"



-- 初始化
function TaskManagement:Init()
    --累计分数
    self.ALTOGETHER_SCORE = 0
	self:LevelStoryInit()
    self.isTestTask = false
    
end

--关卡任务初始化
function TaskManagement:LevelStoryInit()
   --by sunkai 关卡任务
	--收集了什么道具有几个

	self.TASK_COLLECT = {}
	--使用了什么道具有几个 
	self.USE_PROPS = {}
	--累计分数
	self.ALTOGETHER_SCORE = 0
    
	--单局获得得分
	self.ALONE_SCORE = 0
	-- 使用技能数量
	self.SKILL_COUNT = {}
	--击杀怪物数量
	self.ENEMY_COUNT = {}
	
	--无伤通过
	self.NO_HURT = 0	
	
	--不是用攻击过关
	self.NO_ATK = 0
	
	--"收集超过50%的收集物 0-1"
	self.COLLECT_PROPORTION = 0
	-- 攻击次数上限
	self.ATK_COUNT_MAX = 0
	--"跳跃次数"
	self.JUMP_COUNT_MAX = 0

    
    -- 通关当前关卡
    self.LEVEL_NOW = false
    
    self.BUY_COUNT ={}
    
    --天梯
    self.LADDER_COUNT={}
    --向好友赠送体力
    self.LIGHT_COUNT = 0
    --关卡过关
    self.LEVEL = {}
    --默认套装达到多少等级
    self.DRESS_GETTO_LV ={}
    --将宠物升级到多少等级
    self.PET_GETTP_LV = {}
    --任意套装达到多少等级
    self.ANY_DRESS_GETTO_LV = {}
    --任意宠物达到多少等级
    self.ANY_PET_GETTO_LV = {}
    --使用某个套装进行一局游戏
    self.USE_THE_DRESS = {}
    --使用宠物进行一局游戏
    self.USE_THE_PET = {}
    --赢得多少次据点比赛
    self.TERRITORY_WIN = 0
    --赢得多少次神圣模式比赛
    self.SUPER_LEVEL = 0
    --test
    --self:TestData() 
	--by sunkai 关卡任务
end

--模拟假数据跑
function TaskManagement:TestData()   
    --怪物
     self:SetTaskData(TaskType.ENEMY_COUNT,15028000,300)
     self:SetTaskData(TaskType.ENEMY_COUNT,15033000,300)
     self:SetTaskData(TaskType.ENEMY_COUNT,15029000,300)
   
    self:SetTaskData(TaskType.ENEMY_COUNT,15030000,300)
    --收集
    --金币
    self:SetTaskData(TaskType.TASK_COLLECT,15001000,900)
    
    self:SetTaskData(TaskType.TASK_COLLECT,15036000,900)
    self:SetTaskData(TaskType.TASK_COLLECT,15034000,900)
    self:SetTaskData(TaskType.TASK_COLLECT,15036000,900)
    
    --未添加的接口
    self:SetTaskData(TaskType.JUMP_COUNT_MAX ,10)
    self:SetTaskData(TaskType.NO_ATK ,10)
    self:SetTaskData(TaskType.NO_HURT ,10)
end

--收集了什么道具有几个
--[[
	id 道具id
	num 需要加的数量
--]]

function TaskManagement:SetTaskData(...)
    local arg = {...}
    local taskType = arg[1]
    local id = arg[2]
    local num = arg[3]
     if type(self[taskType])=="table" then
         self:AddTable(self[taskType],id,num)
     elseif type(self[taskType]) == "number" then
           self[taskType] =  self[taskType] +id
     elseif type(self[taskType]) == "boolean" then
         self[taskType] =  id
     end
    -- --收集了什么道具有几个
    -- if type == TaskType.TASK_COLLECT then
    --     self:AddTable(self[type],id,num)
    -- elseif type == TaskType.USE_PROPS then
    --     self:AddTable(self[type],id,num)
    -- --累计分数
    -- elseif  type == TaskType.ALTOGETHER_SCORE then
    --     self[type] = self[type] +id
    -- --单局获得得分
    -- elseif type == TaskType.ALONE_SCORE then
    --     self[type] =  self[type] +id
    -- -- 使用技能数量
    -- elseif type == TaskType.SKILL_COUNT then
    --     self:AddTable(self[type],id,num)
    -- --击杀怪物数量 
    -- elseif type == TaskType.ENEMY_COUNT then
    --     self:AddTable(self[type],id,num)
    -- --无伤通过
    -- elseif type == TaskType.NO_HURT then
    --     self[type] =  self[type] +id
    -- --不是用攻击过关
    -- elseif type == TaskType.NO_ATK then
    --     self[type] =  self[type] +id
    -- -- 攻击次数上限
    -- elseif type == TaskType.ATK_COUNT_MAX then
    --     self[type] =  self[type] +id
    -- --"跳跃次数"
    -- elseif type == TaskType.JUMP_COUNT_MAX then
    --     self[type] =  self[type] +id
    -- elseif type == TaskType.LEVEL_NOW then
    --     self[type] =  id
    -- end
end

function TaskManagement:AddTable(tab,id,num)
	local myId = tonumber(id)
	local myNum = tonumber(num)
	if tab[myId] == nil then
		tab[myId] = myNum
	else
		tab[myId] = tab[myId] + myNum
	end
end

function TaskManagement:GetTaskCompleteList(taskList)

    local taskTxt = TxtFactory:getTable(TxtFactory.TaskTXT)
    local taskSonTxt = TxtFactory:getTable(TxtFactory.TaskSonTXT)
    local cupList = {}
    for i = 1 ,#taskList do 
        local taskid = taskList[i]
        cupList[i] =  self:GetTaskCompleteOne(taskid) 
    end
    return cupList
end
--单个任务是否完成
function TaskManagement:GetTaskCompleteOne(taskid,bin_status) 
		local taskTxt = TxtFactory:getTable(TxtFactory.TaskTXT)
		local taskSonTxt = TxtFactory:getTable(TxtFactory.TaskSonTXT)
		local sonTaskList=  taskTxt:GetSplitArray(taskid,"TASK_TASK_ID")
		local sonTaskCountList = taskTxt:GetSplitArray(taskid,"OBJ_COUNT")
		local sonTaskObjList = taskTxt:GetSplitArray(taskid,"OBJ")
        local sonTaskGameMode= taskTxt:GetSplitArray(taskid,"TASK_GAME_MODE")
		local cupCompleteList = {}
			
		for i = 1,#sonTaskList do 
			local sonTaskId = sonTaskList[i] 
			local taskCout = sonTaskCountList[i]
			local obj = sonTaskObjList[i]
			cupCompleteList[i] =  self:completeSonOneTask(sonTaskId,taskCout,obj,sonTaskGameMode,bin_status)   
		end
		--如果只有一个任务
        GamePrint("sonTaskList ===="..#sonTaskList)
        GamePrint("cupCompleteList ===="..#cupCompleteList)
		if #sonTaskList == 1 then
			return cupCompleteList[1]
		end
		--多个任务的情况
		return cupCompleteList
end

--刷新最新的任务获得的进度
function TaskManagement:RefreshTaskStateInfo()
    local TaskInfo = TxtFactory:getMemDataCacheTable(TxtFactory.TaskInfo)
	if  TaskInfo == nil or TaskInfo.bin_tasks == nil  then
		return
	end
    for i = 1,#TaskInfo.bin_tasks do
         self:GetTaskCompleteOne(TaskInfo.bin_tasks[i],TaskInfo.bin_status[i])
         TaskInfo.bin_status[i].param_id = TaskInfo[i].id
    end
end


function TaskManagement:completeSonOneTask(sonTaskId,taskCout,obj,sonTaskGameMode)
    local complete = 0
 
    local taskSonTxt = TxtFactory:getTable(TxtFactory.TaskSonTXT)
    local TASK_TYPE = taskSonTxt:GetData(sonTaskId,"TASK_TYPE")
    local SON_TYPE = taskSonTxt:GetData(sonTaskId,"SON_TYPE")

     
    if TASK_TYPE == "TASK_COLLECT" then --			收集类任务
       
        if tonumber(SON_TYPE) ==  1 then	
            --收集指定物品
			if self.TASK_COLLECT[tonumber(obj)]~= nil and 
                self.TASK_COLLECT[tonumber(obj)] >= tonumber (taskCout) then
				complete  = 1
			end
        elseif tonumber(SON_TYPE) == 2 then
            --关卡中吃到几个道具
            local count = 0
            local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
            for k,v  in pairs(self.TASK_COLLECT) do
                if tonumber (txt:GetData(k,"MATERIAL_TYPE")) == tonumber (obj) then
                    count = count + v
                end
            end
            --收集任务完成
            if count >= tonumber(taskCout) then
                complete  = 1
            end
        end	
    
    elseif	TASK_TYPE == "USE_PROPS" then  --	使用道具	
            
    elseif TASK_TYPE == "BUY_COUNT" then  -----------------			游戏开始前购买多少个指定道具		
            
    elseif TASK_TYPE == "SKILL_COUNT" then---------------			使用技能

        local skill_count = 0 
        for k,v in pairs(self.SKILL_COUNT) do
            skill_count = skill_count+1
        end
        if skill_count >= tonumber(taskCout) then
            complete  = 1
        end
        
    elseif TASK_TYPE == "ALTOGETHER_SCORE" then----------			累计获得得分	
         
    --累计获得多少分数   
    elseif TASK_TYPE == "GET_GOLD" then	
        --收集指定物品
        if self:GetTabGameMode() ~= tonumber(sonTaskGameMode) then
            return complete
        end
        if self.TASK_COLLECT[tonumber(obj)]~= nil and 
            self.TASK_COLLECT[tonumber(obj)] > tonumber (taskCout) then
            complete  = 1
        end
        
    elseif TASK_TYPE == "TERRITORY_WIN" then
    
        if self.TERRITORY_WIN >= 1 then
            complete  = 1
        end
    --使用某个宠物
    elseif TASK_TYPE == "USE_THE_PET" then
        --如果不是这个模式的话就不用判断了
        if self:GetTabGameMode() ~= tonumber(sonTaskGameMode) then
            return complete
        end
        for i = 1,#self.USE_THE_PET do
            if tonumber(self.USE_THE_PET[i]) == tonumber(obj) then
                complete = 1
            end
        end

    elseif TASK_TYPE == "ALONE_SCORE" then---------------			单局获得得分
        print("ALONE_SCORE : "..self.ALONE_SCORE)
        if tonumber(self.ALONE_SCORE) >= tonumber(taskCout) then
            complete = 1
        end			
    elseif TASK_TYPE == "LIGHT_COUNT" then---------------			向好友赠送体力	
        if self.LIGHT_COUNT>= tonumber(taskCout) then
            complete = 1
        end
    elseif TASK_TYPE == "LEVEL" then---------------------			完成指定关卡
        if self.LEVEL == tonumber(obj) then
            complete = 1 
        end
    elseif TASK_TYPE =="LEVEL_NOW"then
        if self.LEVEL_NOW then
             complete = 1
        end
    elseif TASK_TYPE == "ENEMY_COUNT" then---------------			击杀怪物			
        local count = 0
        
        for k,v in pairs(self.ENEMY_COUNT) do
         if obj =="" or k == tonumber (obj) then
                count = count+v
            end
        end
        print (count)
        if count>= tonumber (taskCout) then
            complete  = 1
        end
    elseif TASK_TYPE == "NO_ATK" then
       for k,v in pairs(self.ENEMY_COUNT) do
              count = count+v
        end
        print (count)
        if count== 0 then
            complete  = 1
        end
        --是否无伤通过
    elseif TASK_TYPE == "NO_HURT" then
        if self.NO_HURT ==0 then
            complete  = 1
        end
        --收集超过多少的收集物
    elseif TASK_TYPE == "COLLECT_PROPORTION" then
        local count = 0
        for k,v  in pairs(self.TASK_COLLECT) do
            count = count + v
        end
        --收集任务完成
        if count >= tonumber(taskCout) then
            complete  = 1
        end
        
    elseif TASK_TYPE == "ATK_COUNT_MAX" then
        for k,v in pairs(self.ENEMY_COUNT) do
            count = count+v
        end
        print (count)
        if count <= tonumber(taskCout) then
            complete  = 1
        end
    elseif TASK_TYPE == "JUMP_COUNT_MAX" then
        if self.JUMP_COUNT_MAX <= tonumber(taskCout) then
            complete  = 1
        end
    elseif TASK_TYPE == "KILL_COUNT_ALL" then
        local  kill_count = 0
        local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
        for k,v in pairs(self.ENEMY_COUNT) do
            if tonumber (txt:GetData(k,"MATERIAL_TYPE")) == tonumber (obj) then
                kill_count = kill_count+1
            end
        end	
        
        if taskCout ~= nil and kill_count >= tonumber(taskCout) then
            complete  = 1
        end
    end
    return complete
end

function TaskManagement:GetTabGameMode()
    local battleType = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE)
    return battleType
end
