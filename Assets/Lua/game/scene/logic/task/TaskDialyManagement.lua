--[[
author:huqiuxiang
每日任务系统数据管理
]]

TaskDialyManagement = class()

TaskDialyManagement.scene = nil -- 每日任务view TaskDialySystemView
TaskDialyManagement.targetscene = nil -- 城建场景scene
TaskDialyManagement.taskManagement = nil -- 城建新手进度管理器
TaskDialyManagement.userTable = nil -- 玩家数据表
TaskDialyManagement.taskTable = nil -- 任务数据表

function TaskDialyManagement:Awake(targetscene)
	self.scene = targetscene
    self.targetscene = targetscene.scene
	self.userTable = TxtFactory:getTable(TxtFactory.UserTXT) 
    self.taskTable = TxtFactory:getTable(TxtFactory.TaskTXT)
end

-- 获取任务列表 发送
function TaskDialyManagement:SendSystemTask()
    --GamePrint("TaskManagement:SendSystemTask")
	local json = require "cjson"
   -- local msg = {}
   -- local strr = json.encode(msg)
     local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
      	local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = task_pb.TaskListRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
        code = MsgCode.TaskListRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.TaskListResponse,self)
    NetManager:SendPost(NetConfig.TASK_INFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end

-- 获取任务列表 接收 
function TaskDialyManagement:GetSystemTask(response)
	local json = require "cjson"
 	local tab = json.decode(response.data)
	-- self.scene:SetEmailList(tab.bin_mails)
    local memCache = TxtFactory:getTable(TxtFactory.MemDataCache)
    memCache:setTable(TxtFactory.TaskInfo,tab)
    
    -- 根据type过滤出每日任务
    local dialyTaskTable = {}
   -- local guideTask = {}
   -- local taskTable = TxtFactory:getTable(TxtFactory.TaskTXT)
    for i = 1, #tab.bin_tasks do
      --  GamePrint("gaofei id come")
        local taskType = self.taskTable:GetData(tab.bin_tasks[i].tid,"TASK_TYPE")
      --  GamePrint("tid ==="..tab.bin_tasks[i].tid)
       -- print("taskType : " ..taskType)
        if  taskType == "1" or taskType == "7" then
           -- GamePrint("@@@@@@@@@@@@@@@")
            --print("tab.bin_tasks[i].tid : "..tab.bin_tasks[i].tid)
            --GamePrint("state ===="..tab.bin_tasks[i].status)
            dialyTaskTable[#dialyTaskTable+1] = tab.bin_tasks[i]
            self:setValue(TxtFactory.TaskInfo,TxtFactory.TASK_DIALYINFOTAB,dialyTaskTable)
        end
        --[[   
        elseif taskType == "7" then
            guideTask = tab.bin_tasks[i]
            self:setValue(TxtFactory.TaskInfo,TxtFactory.TASK_GUIDEINFOTAB,guideTask)
        end
        ]]--
    end
   -- self:SetTaskInfoListStates()
    self:SetTaskRedPoint()
     if self.scene.TaskSystemPanel ~= nil then
        self.scene.TaskSystemPanel:listUpdate()
        self.scene.TaskSystemPanel:updateTaskUINum()
    end
end

function TaskDialyManagement:SetTaskRedPoint()
    local GetReward = 0
    local TaskInfo = TxtFactory:getMemDataCacheTable(TxtFactory.TaskInfo)
    for i = 1, #TaskInfo.bin_tasks do
        --可以奖励 显示红点
        --GetReward = self:taskStatusCheck(TaskInfo.bin_tasks[i].tid,TaskInfo.bin_tasks[i])
        if TaskInfo.bin_tasks[i].status == 1 then
            self.scene:SetRedPoint("task",true)
            return
        end
    end
    self.scene:SetRedPoint("task",false)
end


-- 提交任务 发送
function TaskDialyManagement:SendCommitTask(tid,param)
    local json = require "cjson"
   -- print("SendCommitTask : "..tid)
   -- local msg = {task_id = tid,param1 = param}
   -- local strr = json.encode(msg)
     local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
      	local msg = {task_id = tid,param1 = param}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = task_pb.TaskCommitRequest()
        message.task_id = tid
        message.param1 = param
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
        code = MsgCode.TaskCommitRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.TaskCommitResponse,self)
    NetManager:SendPost(NetConfig.TASK_INFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 提交任务 接收
function TaskDialyManagement:GetCommitTask(response)
    local json = require "cjson"
    local tab = json.decode(response.data)
    -- self.scene:SetEmailList(tab.bin_mails)
    if tab.result == 1 then 
        -- self.scene:creatRewardPanel(tab.task_id)

        local TaskInfo = TxtFactory:getMemDataCacheTable(TxtFactory.TaskInfo)
       -- local TaskGuideInfo = TaskInfo[TxtFactory.TASK_GUIDEINFOTAB]
        --TaskGuideInfo.status = 2
      
        local CurtaskInfo =  self:FindInfoForid( tab.task_id)
        CurtaskInfo.status = 2
        --self:setValue(TxtFactory.TaskInfo,TxtFactory.TASK_GUIDEINFOTAB,TaskGuideInfo)

        self.scene.TaskSystemPanel:listUpdate()

        local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
        
        --[[
        if  tab.exp~=nil then
            local exp = user[TxtFactory.USER_EXP] + tab.exp
            -- local diamondPrice = user[TxtFactory.USER_DIAMOND] + tab.diamond
            -- local coinPrice = user[TxtFactory.USER_GOLD] + tab.gold
            -- TxtFactory:setMemDataCacheTable(TxtFactory.BagItemsInfo,BagItemsInfo)
            -- self:setValue(TxtFactory.UserInfo,TxtFactory.USER_DIAMOND,diamondPrice)
            -- self:setValue(TxtFactory.UserInfo,TxtFactory.USER_GOLD,coinPrice)
            self:setValue(TxtFactory.UserInfo,TxtFactory.USER_EXP,exp)
        end
        ]]--
        
        if not tab.gold then
			tab.gold = 0
		end
		if not tab.diamond then
			tab.diamond = 0
		end
        
        
        local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
        memData:AddUserInfo(tab.gold,tab.diamond)
        
       
       
       memData:AddUserInfoItemForType(TxtFactory.BagItemsInfo,tab.bin_items)
		--结算装备
		memData:AddUserInfoItemForType(TxtFactory.EquipInfo ,tab.bin_equips)
		--结算宠物
		memData:AddUserInfoItemForType(TxtFactory.PetInfo,tab.bin_pets)
       
        local serverData = {}
        
        serverData.gold = tab.gold
        serverData.diamond = tab.diamond
       -- serverData.exp = tab.exp
        --GamePrint("~~~"..#tab.bin_pets)
        serverData.itemInfoList = tab.bin_items
		serverData.equipInfoList = tab.bin_equips
		serverData.petInfoList = tab.bin_pets
        
       local itemObjList=  self.scene:CreatItemList(serverData)
       self.scene:rewardItemsShow(itemObjList)
       --[[
        -- 新手任务 保存进度
        local taskid = nil
        if taskid == 114001 then
            local guide = user[TxtFactory.USER_GUIDE] -- 获取进度
            self:setValue(TxtFactory.UserInfo,TxtFactory.USER_GUIDE,guide)
        end
      ]]--
        self:SetTaskRedPoint()
        
        if tab.gold ~= 0 or tab.diamond ~= 0 then
            self.scene:UpdatePlayerInfo()
        end
        
    end
end


-- 根据任务id获取奖励物品 获取任务的icon和数量
function TaskDialyManagement:getTaskRewardData(tid)
    local tab = {}
    local tabData = {"REWARD_EXP","REWARD_GOLD","REWARD_DIAMOND"}
    local spriteIconName = {"exp","jinbi","zuanshi"}
    local index = 1 
    for i = 1, #tabData do
        local value = self.taskTable:GetData(tid,tabData[i])
        if value ~= "" then
            local rewardItem = {}
            GamePrint("--"..value)
            rewardItem.iconName = spriteIconName[i]
            rewardItem.value = value
            rewardItem.atlasName = "GiftIcon"
            tab[index] = rewardItem
            index = index + 1
        end
    end
    
    -- 判断是否奖励宠物
    
    local petid = self.taskTable:GetData(tid,"REWARD_PET")
    
    if petid ~= "" then
        local rewardItem = {}
        rewardItem.iconName,rewardItem.atlasName = self.taskTable:GetItemIconById(petid)
        rewardItem.value = 1
        --rewardItem.atlasName = "GiftIcon"
        tab[index] = rewardItem
    end
    
    return tab
end

--为数据表赋值
function TaskDialyManagement:setValue( tName,column,value)
    TxtFactory:setValue(tName,column,value)
end

-- 根据任务id获取任务信息
function TaskDialyManagement:taskIdFindInfo(tid)
    local TaskInfo = TxtFactory:getMemDataCacheTable(TxtFactory.TaskInfo)
    local TaskDialyInfo = TaskInfo[TxtFactory.TASK_DIALYINFOTAB]

    local tab = {}
    for i = 1, #TaskDialyInfo do
        local dataTid = TaskDialyInfo[i].tid
        if tid == dataTid then
            tab = TaskDialyInfo[i]
        end
    end

    return tab
end

-- 根据任务id获取任务信息
function TaskDialyManagement:FindInfoForid(id)
    local TaskInfo = TxtFactory:getMemDataCacheTable(TxtFactory.TaskInfo)
    local TaskDialyInfo = TaskInfo[TxtFactory.TASK_DIALYINFOTAB]

    local tab = {}
    for i = 1, #TaskDialyInfo do
        local dataId = TaskDialyInfo[i].id
        if id == dataId then
            tab = TaskDialyInfo[i]
        end
    end

    return tab
end

-- 根据任务uid取任务tid
function TaskDialyManagement:taskuidFindTid(id)
    local tid = nil

    local TaskInfo = TxtFactory:getMemDataCacheTable(TxtFactory.TaskInfo)
    for i = 1, #TaskInfo.bin_tasks do
        if id == TaskInfo.bin_tasks[i].id then
            tid = TaskInfo.bin_tasks[i].tid
        end
    end

    return tid
end

 -- 根据任务uid取任务状态
function TaskDialyManagement:taskuidFindStatus(id)
    local status = nil

    local TaskInfo = TxtFactory:getMemDataCacheTable(TxtFactory.TaskInfo)
    for i = 1, #TaskInfo.bin_tasks do
        if id == TaskInfo.bin_tasks[i].id then
            status = TaskInfo.bin_tasks[i].status
        end
    end

    return status
end

--[[
-- 获取任务列表 发送
function TaskDialyManagement:SendTaskStatusRequest(bin_status)
    -- print("TaskManagement:SendSystemTask")
	local json = require "cjson"
     local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
      local msg = {
        bin_status = bin_status
        }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = task_pb.TaskStatusRequest()
        for i = 1 , #bin_status do
		      --printf("petid ==="..curDefendPets[i])
             message.bin_status:append(bin_status[i])
	    end
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
        code = MsgCode.TaskStatusRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.TaskStatusResponse,self)
    NetManager:SendPost(NetConfig.TASK_INFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end

-- 获取任务列表 接收 
function TaskDialyManagement:GetTaskStatusResponse(response)
	local json = require "cjson"
 	local tab = json.decode(response.data)
    print("任务数据提交成功")
end
]]--

function TaskDialyManagement:SetTaskInfoListStates()
  local TaskInfo = TxtFactory:getMemDataCacheTable(TxtFactory.TaskInfo)
    for i = 1, #TaskInfo.bin_tasks do
         local status,curValue,maxValue = self:taskStatusCheck(TaskInfo.bin_tasks[i].tid,TaskInfo.bin_tasks[i])
         TaskInfo.bin_tasks[i].param_data1 = curValue
         TaskInfo.bin_tasks[i].param_data2 = maxValue
         if status == 1 then
            TaskInfo.bin_tasks[i].status = 1
         end
    end
end

-- 任务状态检查
function TaskDialyManagement:taskStatusCheck(tid,data)
	local num = 0
	-- print("tid"..tid)
    local taskType = self.taskTable:GetData(tid,"TASK_TYPE")
	if taskType == '7' then
        --[[
		local TaskInfo = TxtFactory:getMemDataCacheTable(TxtFactory.TaskInfo)
        local TaskGuideInfo = TaskInfo[TxtFactory.TASK_GUIDEINFOTAB]
        if TaskGuideInfo.status == 2 then
        	num	= 0
        else
        	num	= 1
        end
		
		return num
        ]]--
        
        if data.status == 2 then
            return 2,1,1
        end
        return 1,1,1
	else
		local TaskInfo = TxtFactory:getMemDataCacheTable(TxtFactory.TaskInfo)
         local curValue = 0 -- 当前值
        local maxValue = self.taskTable:GetData(tid,"OBJ_COUNT") -- 目标值
        if data~= nil then
            if data.status == 2 then
                curValue = maxValue
                return num,curValue,maxValue
            end
        end
        
		if TaskInfo.bin_status == nil then
			return num,curValue,maxValue
		end
		--print("--tid : "..tid)	
	   
		for i = 1,#TaskInfo.bin_status do
			-- print("TASK_TASK_ID "..self.taskTable:GetData(tid,"TASK_TASK_ID"))
			-- print ("param_id : "..TaskInfo.bin_status[i].param_id)
			 --	print ("param_val :"..TaskInfo.bin_status[i].param_val )
			-- 	print("OBJ_COUNT : "..self.taskTable:GetData(tid,"OBJ_COUNT"))
			if tonumber(self.taskTable:GetData(tid,"TASK_TASK_ID")) == TaskInfo.bin_status[i].param_id then
				if tonumber(self.taskTable:GetData(tid,"TASK_TASK_ID")) == 109001 then
					if  TaskInfo.bin_status[i].param_val  == tonumber (self.taskTable:GetData(tid,"OBJ")) then
						curValue = 1
                        return 1,curValue,maxValue
					end
				elseif  TaskInfo.bin_status[i].param_val  >= tonumber (self.taskTable:GetData(tid,"OBJ_COUNT")) then
					curValue = maxValue
                    num = 1,curValue,maxValue
                else
                    curValue = TaskInfo.bin_status[i].param_val
				end
			end
		end
		return num,curValue,maxValue
	end

end