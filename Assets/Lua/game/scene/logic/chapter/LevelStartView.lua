require "game/scene/logic/chapter/ItemLevelCup"
require "game/scene/logic/chapter/ItemLevelReward"

--[[
	author : sunkai
]]
LevelStartView = class()
LevelStartView.panel = nil
LevelStartView.scene = nil 


function LevelStartView:init(targetScene)
	self.scene = targetScene
	self.uiRoot = targetScene.uiRoot
    
	self.localTxt = TxtFactory:getTable(TxtFactory.ChapterTXT)
    self.cacheTxt = TxtFactory:getMemDataCacheTable(TxtFactory.ChapterInfo)
    
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/Chapter/LevelStartView"))
    	self.panel.gameObject.transform.parent = self.uiRoot.gameObject.transform
    	self.panel.gameObject.transform.localPosition = Vector3.zero
    	self.panel.gameObject.transform.localScale = Vector3.one
	end
	
	self.levelTitleLab = getUIComponent(self.panel,"UI/facePlate/titlebg/ChapterUI_levelId","UILabel")
	self.levelDescLab = getUIComponent(self.panel,"UI/facePlate/chapterDes/desLabel","UILabel")
	self.levelSuggest = getUIGameObject(self.panel,"UI/facePlate/chapterDes/comat")
    self.levelNeedPowerLab = getUIComponent(self.panel,"UI/facePlate/chapterDes/comat/Label","UILabel")
    self.levelCurrentPowerLab = getUIComponent(self.panel,"UI/facePlate/chapterDes/comat/Label","UILabel")
    --心
    self.needHeartNumLab = getUIComponent(self.panel,"UI/ChapterUI_start/physicalPower/valueLabel","UILabel")
    self.ItemLevelCupGrid = getUIGameObject(self.panel,"UI/facePlate/cups")

    self.ItemLevelRewardGrid = getUIGameObject(self.panel,"UI/facePlate/reward")
    self.ItemDataList = {}
    self.ItemObjList = {}
    
    self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
   
    self.CupList = {}
    self.CupObjList = {}
    self.scene:boundButtonEvents(self.panel)
	  self:SetShowView(false)
	
end

-- 设置关卡标题
function LevelStartView:SetLevelInfo(levelId)
    local levelName = self.localTxt:GetData(levelId,"Name")
    local desc = self.localTxt:GetData(levelId,"Level_Desc")
    local NEED_POWER_ATK = self.localTxt:GetData(levelId,"NEED_POWER_ATK")
     self.LIGHT_USE = self.localTxt:GetData(levelId,"LIGHT_USE")
     self.scene.curState = self.scene.ShowLevelInfo
    self.levelTitleLab.text = levelName
    self.levelDescLab.text = desc
    self.levelNeedPowerLab.text = NEED_POWER_ATK
    self.needHeartNumLab.text = self.LIGHT_USE
    --获取当前关卡的奖杯链表
    self.serverCupList = self.cacheTxt.cupList[tonumber(levelId)]
    self:InitCupItem(levelId,self.serverCupList)
    self:InitItem(levelId)
    print(" levelN2me  : "..levelName )
    --local rewardInfo = self.localTxt:GetLevelReward(levelId)
    --for i = 0, self.levelRewardList.childCount-1 do
       -- self.levelRewardList:GetChild(i).gameObject:SetActive(i < #rewardInfo)
   -- end
      -- print(" levelNamsdde  : "..levelName )
end



--奖杯逻辑
function LevelStartView:InitCupItem(levelId,cupInfoList)
    self.CupList = {}
    local cupTaskTxt = self.localTxt:GetLevelCupTask(levelId)
    local index = 1
    
    local hasCup = {}
    --先显示服务器上的奖杯任务
    if cupInfoList ~=nil then
        for i = 1,#cupInfoList do 
            --服务器里面保存的都是index 索引值
              if cupInfoList[i] ~=0 then
                local cupTaskIndex = i
                local item = ItemLevelCup.new()
            
                local itemObj
                if self.CupObjList[index] == nil then
                    itemObj = newobject(Util.LoadPrefab("UI/Chapter/ItemLevelCup"))
                    self.CupObjList[index] = itemObj
                end
                
                item:init(self.scene, self.CupObjList[index],self.ItemLevelCupGrid)
                item:SetData(cupTaskIndex,cupTaskTxt[cupTaskIndex])
                item:Refresh(true)
                self.CupList[cupTaskIndex] = item
                --已经完成的任务标记一下
                hasCup[cupTaskIndex] = true
                index = index + 1
            end
        end
    end
    --没有完成的奖杯任务
    for i = 1,#cupTaskTxt  do
        if hasCup[i] ~= true then
            local item = ItemLevelCup.new()
            local itemObj
            if self.CupObjList[index] == nil then
              itemObj = newobject(Util.LoadPrefab("UI/Chapter/ItemLevelCup"))
              self.CupObjList[index] = itemObj
            end
            item:init(self.scene, self.CupObjList[index],self.ItemLevelCupGrid)
            item:SetData(i,cupTaskTxt[i])
            item:Refresh(false)
            self.CupList[i] = item
            index = index + 1
        end
    end
        	--多了的就删掉
	for i = index,#self.CupObjList do
		GameObject.Destroy(self.CupObjList[i])
	end
    

    self.ItemLevelCupGrid:GetComponent("UIGrid"):Reposition()
	  self.ItemLevelCupGrid:GetComponent("UIGrid").repositionNow = true
end


--掉落物品
function LevelStartView:InitItem(levelId)
     local StarsTaskID = self.localTxt:GetData(levelId,"StarsTaskID")
     local taskData = TxtFactory:getTable(TxtFactory.TaskTXT)
     
    --道具材料类奖励 格式 ： 材料ID=材料数量;材料ID=材料数量 兼 关卡任务中的二星奖励
     local REWARD_PROPS = taskData:GetData(StarsTaskID,"REWARD_PROPS")
     local REWARD_THREE_PROPS = taskData:GetData(StarsTaskID,"REWARD_THREE_PROPS")
     local Str = REWARD_PROPS..";"..REWARD_THREE_PROPS
     print(rewardIDListStr)
     local rewardIDList  = string.split(Str,";")
     
    local index = 1
	self.ItemDataList = {}
    for i = 1 ,#rewardIDList do 
        local item = ItemLevelReward.new()
		local itemObj
		if self.ItemObjList[index] == nil then
			itemObj = newobject(Util.LoadPrefab("UI/Chapter/ItemLevelReward"))
			self.ItemObjList[index] = itemObj
		end
		
        item:init(self.scene, self.ItemObjList[index] ,self.ItemLevelRewardGrid)
        print(rewardIDList[i])
        
        local myStr = string.split(rewardIDList[i],"=")
        item:SetData(myStr[1],1)
		
        self.ItemDataList[myStr[1]] = item
		index = index + 1
    end
    
    	--多了的就删掉
	for i = index,#self.ItemObjList do
		GameObject.Destroy(self.ItemObjList[i])
	end
    
    self.ItemLevelRewardGrid:GetComponent("UIGrid"):Reposition()
	self.ItemLevelRewardGrid:GetComponent("UIGrid").repositionNow = true
	
     
end


--奖杯点击事件
function LevelStartView:ItemLevelCupClick(button)
   print("button.name : "..button.name)
   local str = string.split(button.name,"_")
   print("str[2] : "..str[2])
   local index = tonumber(str[2])
   local taskId =  self.CupList[index].taskId
   
   self.scene.LevelCupTaskView:SetShowView(true)
   self.scene.LevelCupTaskView:RefreshData(taskId)
    
end



function LevelStartView:SetShowView(active)
    self.scene:SetModelShow(active)
	 self.panel.gameObject:SetActive(active)

   if active == true then
      -- 夺宝奇兵,等级开启
      if self.scene.FunctionOpen == nil then
        -- self.scene.FunctionOpen = FunctionOpenView.new()
        --   self.scene.FunctionOpen:Init(self.scene,true)
      end
      local bbtn = self.panel.transform:FindChild("UI/btn")
      self.scene.FunctionOpen:UpdataOtherBtn("套装",bbtn:FindChild("ChapterUI_role"))
      self.scene.FunctionOpen:UpdataOtherBtn("萌宠",bbtn:FindChild("ChapterUI_pet"))
      self.scene.FunctionOpen:UpdataOtherBtn("装备",bbtn:FindChild("ChapterUI_equip"))
      self.scene.FunctionOpen:UpdataOtherBtn("坐骑",bbtn:FindChild("ChapterUI_mount"))
   end
end


-- 关卡选择 开始按钮
function LevelStartView:ChapterUI_start()
  
    if   tonumber(self.UserInfo[TxtFactory.USER_STRENGTH]) >= tonumber(self.LIGHT_USE) then
        self.scene.levelManagement:sendStartRunning()
    else
        self.scene:promptWordShow("体力不够")
    end
end



