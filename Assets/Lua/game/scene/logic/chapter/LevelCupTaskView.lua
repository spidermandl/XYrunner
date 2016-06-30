
--[[
	ui提示类
	sunkai
]]
LevelCupTaskView = class()
LevelCupTaskView.panel = nil
LevelCupTaskView.scene = nil 

function LevelCupTaskView:init(targetScene)
	self.scene = targetScene
	self.uiRoot = targetScene.uiRoot
	self.TaskTxt = TxtFactory:getTable(TxtFactory.TaskTXT)
	self.LotteryPondTxt= TxtFactory:getTable(TxtFactory.LotteryPondTXT)
	
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/Chapter/LevelCupTaskView"))
    	self.panel.gameObject.transform.parent = self.uiRoot.gameObject.transform
    	self.panel.gameObject.transform.localPosition = Vector3.zero
    	self.panel.gameObject.transform.localScale = Vector3.one
	end
	self.ItemObjList = {}
	self.ItemDataList = {}
	
	self.ItemLevelRewardGrid = getUIGameObject(self.panel,"UI/title/reward")
	self.TaskDesc = getUIComponent(self.panel,"UI/title/desc","UILabel")
	self.scene:boundButtonEvents(self.panel)
	self:SetShowView(false)
	if self.scene.name ~= "BattleScene" then
		self.scene:SetModelShow(false)
	end
end

--刷新数据
function LevelCupTaskView:RefreshData(TaskId)
	self.TaskId = TaskId
	print("TaskId : "..TaskId )
	local LotteryId =  self.TaskTxt:GetData(TaskId,"CUP_GAIN_MAP")
	print("LotteryId : "..LotteryId)
	local PRIZEPOOL = self.LotteryPondTxt:GetData(LotteryId,"PRIZEPOOL")
	print("PRIZEPOOL : "..PRIZEPOOL)
	local type = self.LotteryPondTxt:GetData(LotteryId,"FOR_OBJECT_TYPE")
	local desc = self.TaskTxt:GetData(tonumber(TaskId),"TASK_DESC")
    self.TaskDesc.text = desc

	
	local itemIdList = {}
	local array= string.split(PRIZEPOOL,";")
	for i = 1,#array do 	
		local str = string.split(array[i],"=")
		local itemstr = string.split(str[1],",")
		for j = 1,#itemstr do 
			itemIdList[itemstr[j]] = str[2]..str[3]
		end
	end
	self:InitItem(itemIdList,type)
	
	
	--奖杯描述
	--self.TaskDesc.text = 
end


function LevelCupTaskView:InitItem(itemIdList,type)
    
    --最多只有六个奖杯
	local index = 1
	self.ItemDataList = {}
    for k, v in pairs(itemIdList) do 
		
        local item = ItemLevelReward.new()
		local itemObj
		if self.ItemObjList[index] == nil then
			itemObj = newobject(Util.LoadPrefab("UI/Chapter/ItemLevelReward"))
			self.ItemObjList[index] = itemObj
		end
		
        item:init(self.scene, self.ItemObjList[index] ,self.ItemLevelRewardGrid)
        item:SetData(k,type)
		
        self.ItemDataList[k] = item
		index = index + 1
    end
	--多了的就删掉
	for i = index,#self.ItemObjList do
		GameObject.Destroy(self.ItemObjList[i])
	end
    
    self.ItemLevelRewardGrid:GetComponent("UIGrid"):Reposition()
	self.ItemLevelRewardGrid:GetComponent("UIGrid").repositionNow = true
	
end

function LevelCupTaskView:SetShowView(active)
	if self.scene.name ~= "BattleScene" then
		self.scene:SetModelShow(not active)
	end
	self.panel.gameObject:SetActive(active)
end


