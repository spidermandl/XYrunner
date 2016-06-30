--[[
author:huqiuxiang
每日任务系统
]]

require "game/scene/logic/task/TaskDialyManagement"
require "game/scene/logic/task/TaskManagement"
TaskDialySystemView = class()

TaskDialySystemView.scene = nil -- 依附的场景对象
TaskDialySystemView.panel = nil -- 面板
TaskDialySystemView.management = nil -- 数据管理器
TaskDialySystemView.itemsScrollView = nil 
TaskDialySystemView.itemsGrid = nil 
TaskDialySystemView.taskTable = nil
TaskDialySystemView.sceneTarget = nil 

TaskDialySystemView.infoPanel = nil -- 描述面板
TaskDialySystemView.rewardPanel = nil -- 奖励面板

TaskDialySystemView.guideMes = nil -- 新手引导

TaskDialySystemView.cutTaskId = nil -- 当前选中id
TaskDialySystemView.curTaskUid = nil -- 当前选中uid
TaskDialySystemView.isGetGuideReward = nil
TaskDialySystemView.taskNumLabel = nil -- 任务数量label
TaskDialySystemView.taskOkNumLabel = nil -- 完成任务数量label

-- 初始化UI
function TaskDialySystemView:Init(targetscene)
	self.scene = targetscene
	self.management = TaskDialyManagement.new()
	self.management:Awake(self.scene)
	self.sceneTarget = targetscene.sceneTarget

	 local TaskInfo = TxtFactory:getMemDataCacheTable(TxtFactory.TaskInfo)
	 if TaskInfo == nil then
		self.management:SendSystemTask()
	 end

	self.taskTable = TxtFactory:getTable(TxtFactory.TaskTXT)
end

-- 创建面板
function TaskDialySystemView:creatPanel()
	self.panel = self.scene:LoadUI("Task/TaskSystemUI")
	self.panel.gameObject.transform.localPosition = Vector3.zero
    self.panel.gameObject.transform.localScale = Vector3.one

    local trans = self.panel.transform:Find("Wnd")
    self.itemsScrollView = trans:Find("ScrollView"):GetComponent("UIScrollView")
    self.itemsGrid = trans:Find("ScrollView/Grid")
	self.taskNumLabel = trans:Find("TaskSystemUI_progress/rightLabel"):GetComponent("UILabel")
	self.taskOkNumLabel = trans:Find("TaskSystemUI_progress/leftLabel"):GetComponent("UILabel")
	self.scene:boundButtonEvents(self.panel)
   self:listUpdate()
   self:updateTaskUINum()
  	-- 请求任务数据
	--self.management:SendSystemTask()
end



-- 刷新任务ui右上角数值
function TaskDialySystemView:updateTaskUINum()
	local TaskInfo = TxtFactory:getMemDataCacheTable(TxtFactory.TaskInfo)
	if  TaskInfo == nil or TaskInfo.bin_tasks == nil  then
		return
	end
	local TaskDialyInfo = TaskInfo[TxtFactory.TASK_DIALYINFOTAB] -- 每日任务 status
	--local TaskGuideInfo = TaskInfo[TxtFactory.TASK_GUIDEINFOTAB] -- 新手任务

	local taskNum = #TaskDialyInfo -- 任务数量
	local taskOkNum = 0

	--  判读是否完成
	for i = 1, #TaskDialyInfo do 
		if TaskDialyInfo[i].status ~= 0 then
			taskOkNum = taskOkNum + 1 
		end
	end 

	-- 判断新手任务是否完成
	--[[
	if TaskGuideInfo ~= nil then
		if TaskGuideInfo.status ~= 0 then
			taskOkNum = taskOkNum + 1 
		end
	end
]]--
	self.taskNumLabel.text = taskNum
	self.taskOkNumLabel.text = taskOkNum
end

-- 更新list
function TaskDialySystemView:listUpdate()

	local TaskInfo = TxtFactory:getMemDataCacheTable(TxtFactory.TaskInfo)
	if  TaskInfo == nil or TaskInfo.bin_tasks == nil  then
		return
	end
	local TaskDialyInfo = TaskInfo[TxtFactory.TASK_DIALYINFOTAB] --  
	--local TaskGuideInfo = TaskInfo[TxtFactory.TASK_GUIDEINFOTAB] -- 新手任务

	-- 刷新grid 
	destroy(self.itemsGrid.gameObject)
    self.itemsGrid = GameObject.New()

    local  ms = self.itemsGrid:AddComponent(UIGrid.GetClassType())
	ms.cellHeight = 110
	ms.maxPerLine = 1
    self.itemsGrid.name =  "Grid"
    local trans = self.panel.transform:Find("Wnd")
    self.itemsGrid.gameObject.transform.parent = trans:Find("ScrollView").gameObject.transform
    self.itemsGrid.gameObject.transform.localPosition = Vector3(0,130,0)
    self.itemsGrid.gameObject.transform.localScale = Vector3(1,1,1)
--[[
    if TaskGuideInfo ~= nil then
    	local guideTaskIcon = self:creatItem(TaskGuideInfo)
		self:guideTaskIconSet(guideTaskIcon)
    end
]]--
	if TaskDialyInfo~=nil then
		for i = 1, #TaskDialyInfo do 
			if 	TaskDialyInfo[i].status >0 then
				local icon = self:creatItem(TaskDialyInfo[i])
			end
		end
	end
	
	-- guideTaskIcon.name = "UITaskItem_guideTaskIcon"
	if TaskDialyInfo~=nil then
		for i = 1, #TaskDialyInfo do 	
			if TaskDialyInfo[i].status == 0 then
				local icon = self:creatItem(TaskDialyInfo[i])
			end
		end
	end

	local grid = self.itemsGrid.gameObject.transform:GetComponent("UIGrid")
    grid:Reposition() -- 自动排列
end

-- 每日任务关闭
function TaskDialySystemView:closePanel()
	self.scene.TaskSystemPanel = nil
	destroy(self.panel)
end

-- 创建单个任务itme
function TaskDialySystemView:creatItem(data)
	local icon = newobject(Util.LoadPrefab("UI/Task/TaskItemPre"))
	
	icon.gameObject.transform.parent = self.itemsGrid.gameObject.transform
	icon.gameObject.transform.localScale = Vector3.one
	icon.name = data.id

	local startstate = icon.gameObject.transform:FindChild("startstate")
	local getState = icon.gameObject.transform:FindChild("getState")
	local overState = icon.gameObject.transform:FindChild("overState")
	local stateLabel = startstate.gameObject.transform:FindChild("Label"):GetComponent("UILabel")
	local stateIcon = startstate.gameObject.transform:FindChild("icon"):GetComponent("UISprite")
	
	local descLabel =  icon.gameObject.transform:FindChild("Desc"):GetComponent("UILabel")

	--local senderIcon = icon.gameObject.transform:FindChild("senderIcon")
	--local tasknameLabel = senderIcon.gameObject.transform:FindChild("senderName"):GetComponent("UILabel")
	-- local senderIconTarget = senderIcon.gameObject.transform:GetComponent("UIButtonMessage")
	-- senderIconTarget.target = self.panel
	self.scene:boundButtonEvents(icon)
	--senderIcon.name = "UITaskItem_senderName"
	local descData = self.taskTable:GetData(data.tid,"TASK_DESC")
	descLabel.text = descData
	
	
	-- 进度条
	local progress = icon.transform:Find("TaskProgress "):GetComponent("UISlider")
	
	local progressLabel =  icon.transform:Find("TaskProgress /Label"):GetComponent("UILabel")
	
	if data.param_data1 >= data.param_data2 then
		data.param_data1 = data.param_data2
	end
	
	if data.param_data2 == 0 then -- 新手礼包强制为1
		data.param_data1 = 1
		data.param_data2 = 1
	end
	
	progress.value = tonumber(data.param_data1)/tonumber(data.param_data2)
	
	progressLabel.text = data.param_data1.."/"..data.param_data2
	
	
	--GamePrint("state is ===="..data.status)
	
	-- 状态检查 
	if data.status ~= 2 then
		if data.status == 1 then
			--领取
			--GamePrint("111111111111")
			startstate.gameObject:SetActive(false)
			getState.gameObject:SetActive(true)
			overState.gameObject:SetActive(false)
		else				
			-- 未完成
			if data.status == 0 then
				--GamePrint("0000000000000000000000")
				startstate.gameObject:SetActive(true)
				getState.gameObject:SetActive(false)
				overState.gameObject:SetActive(false)
				
				stateIcon.spriteName = "jinxingzhongtb"
				stateLabel.text = "未完成"
			end
			
		end
	else
		--GamePrint("2222222222222222")
		startstate.gameObject:SetActive(false)
		getState.gameObject:SetActive(false)
		overState.gameObject:SetActive(true)
	end

	local mode = self.taskTable:GetData(data.tid,"TASK_GAME_MODE")
	if mode~="" and tonumber(mode)>15 then
		startstate.gameObject:SetActive(false)
	end
	-- 奖励道具生成
	local grid = icon.gameObject.transform:FindChild("Grid")
	self:creatRewardItems(grid,data.tid)
	-- local gridItems = self.management:getTaskRewardData(data.tid)
	-- local spriteIconName = {["REWARD_EXP"] = "exp",["REWARD_GOLD"] = "jinbi",["REWARD_DIAMOND"] = "zuanshi"}
	-- for k,v in pairs(gridItems) do
	-- 	local taskRewardIcon = newobject(Util.LoadPrefab("UI/Task/taskRewardPre"))
	-- 	taskRewardIcon.gameObject.transform.parent = grid.gameObject.transform
	-- 	taskRewardIcon.gameObject.transform.localScale = Vector3.one

	-- 	local taskRewardIcon_label = taskRewardIcon.gameObject.transform:FindChild("Label"):GetComponent("UILabel")
	-- 	taskRewardIcon_label.text = v
	-- 	local taskRewardIcon_sprite = taskRewardIcon.gameObject.transform:GetComponent("UISprite")
	-- 	taskRewardIcon_sprite.spriteName =spriteIconName[k]

	-- end

	-- local gridt = grid.gameObject.transform:GetComponent("UIGrid")
	-- gridt:Reposition() -- 自动排列
	return icon 
end





function TaskDialySystemView:GotoBtn(btn)
	local uid = tonumber(btn.gameObject.transform.parent.name)
	local tid = self.management:taskuidFindTid(uid)
	local status = self.management:taskuidFindStatus(uid)
	local mode = self.taskTable:GetData(tid,"TASK_GAME_MODE")
	print ("mode : "..mode)
	if mode ~=""then
		if tonumber(mode) == 1 then
		--普通关卡
		--self.scene:ChangScene(SceneConfig.storyScene)
			self:SetActive(false)
			self.scene:OpenChapterScene()
		elseif tonumber(mode )== 2 then
		--无尽
		TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,2)
    			--self.scene:ChangScene(SceneConfig.endlessScene)
				self:SetActive(false)
				self.scene:OpenEndlessScene()
		elseif tonumber(mode )== 3 then
		--夺宝
			   --self.scene:ChangScene(SceneConfig.snathScene)
			   self:SetActive(false)
			   self.scene:OpenSnatchScene()
		end
	end
	
end


-- 任务单个items点击
function TaskDialySystemView:itemsOnClick(btn)
	-- print("任务id"..btn.gameObject.transform.parent.name)
	
	local uid = tonumber(btn.gameObject.transform.parent.name)
	local tid = self.management:taskuidFindTid(uid)

	local status = self.management:taskuidFindStatus(uid)
	self.cutTaskId = tid
	self.curTaskUid = uid

	if status == 2 then -- 完成任务不用显示
		return
	end
	
	-- 直接领取奖励
	
	self:stateBtn()
	
	--self:creatInfoPanel(tid,status)
	
end

-- 创建奖励物品
function TaskDialySystemView:creatRewardItems(grid,tid,isReturnList)
	local gridItems = self.management:getTaskRewardData(tid)
	--local spriteIconName = {["REWARD_EXP"] = "exp",["REWARD_GOLD"] = "jinbi",["REWARD_DIAMOND"] = "zuanshi"}
	local itemList = {}
	
	for i =1 ,#gridItems do
		local rewardItem = gridItems[i]
		local taskRewardIcon = newobject(Util.LoadPrefab("UI/Task/taskRewardPre"))
		if grid ~=nil then 
			taskRewardIcon.gameObject.transform.parent = grid.gameObject.transform
			taskRewardIcon.gameObject.transform.localScale = Vector3.one
		end

		local taskRewardIcon_label = taskRewardIcon.gameObject.transform:FindChild("Label"):GetComponent("UILabel")
		taskRewardIcon_label.text = "x"..rewardItem.value
		local taskRewardIcon_sprite = taskRewardIcon.gameObject.transform:GetComponent("UISprite")
		
		--atlasName = "UI/Picture/"..atlasName
		taskRewardIcon_sprite.atlas =  Util.PreLoadAtlas("UI/Picture/"..rewardItem.atlasName)
		--taskRewardIcon_sprite.spriteName =spriteIconName[k]
		taskRewardIcon_sprite.spriteName = rewardItem.iconName
		table.insert(itemList,taskRewardIcon)
	
	end
	
	for k,v in pairs(gridItems) do
		
	end
	
	if isReturnList then
		return itemList
	end

	local gridt = grid.gameObject.transform:GetComponent("UIGrid")
	gridt:Reposition() -- 自动排列
end

-- 引导任务set
function TaskDialySystemView:guideTaskIconSet(icon)
	--local senderIcon = icon.gameObject.transform:FindChild("UITaskItem_senderName")
	--senderIcon.name = "UITaskGuideItem_senderName"
end

---------------------------------------------- 描述面板相关 -----------------------------
function TaskDialySystemView:creatInfoPanel(taskId,status)

	destroy(self.infoPanel)
	self.infoPanel = self.scene:LoadUI("Task/TaskInfoUI")
	local ui = self.infoPanel.gameObject.transform:FindChild("UI")

	local btn = ui.gameObject.transform:FindChild("TaskInfoUI_stateBtn")
	self.scene:SetButtonTarget(btn,self.sceneTarget)

	local taskingBtn = ui.gameObject.transform:FindChild("TaskInfoUI_getRewardBtn")
	self.scene:SetButtonTarget(taskingBtn,self.sceneTarget)

	-- print("status"..status)
	if status == 1 then
		btn.gameObject:SetActive(true)
		taskingBtn.gameObject:SetActive(false)
	elseif status == 0 then
		btn.gameObject:SetActive(false)
		taskingBtn.gameObject:SetActive(true)
	end

	self:rewardListUpdate(taskId,ui)

end

-- 完成任务 发送请求
function TaskDialySystemView:stateBtn()
	-- 新手任务 先行
	-- if self.cutTaskId == 114001 then
	-- 	self.isGetGuideReward = false
		self:creatRewardPanel(self.cutTaskId)
		-- self.isGetGuideReward = true
		self.management:SendCommitTask(self.curTaskUid,0)
		destroy(self.infoPanel)
	-- 	return
	-- end
	-- self.management:SendCommitTask(self.curTaskUid,0)
	-- destroy(self.infoPanel)
end

--  未完成任务 进行中 按钮
function TaskDialySystemView:taskingBtn()
	destroy(self.infoPanel)
end

function TaskDialySystemView:rewardListUpdate(taskId,ui)
	local titleLabel = ui.gameObject.transform:FindChild("titlebg/Label"):GetComponent("UILabel")
	local taskDescriptLabel = ui.gameObject.transform:FindChild("TaskInfoUI_itemInfo/TaskDescriptLabel"):GetComponent("UILabel")

	local nameData = self.taskTable:GetData(taskId,"TASK_NAME")
	titleLabel.text = nameData

	local taskDesData = self.taskTable:GetData(taskId,"TASK_DESC")
	taskDescriptLabel.text = taskDesData

	local grid = ui.gameObject.transform:FindChild("TaskInfoUI_itemInfo/Grid")
	self:creatRewardItems(grid,taskId)

end

---------------------------------------------- 奖励面板相关 -----------------------------
function TaskDialySystemView:creatRewardPanel(taskId)
	--destroy(self.infoPanel)

	-- 新手任务特例
	-- if taskId == 114001 and self.isGetGuideReward == true then
	-- 	return
	-- end

end

-- 设置当前界面的状态
function TaskDialySystemView:SetActive(active)
	self.panel:SetActive(active)
end
