--[[
author:Desmond
跑酷胜利、失败结算界面
]]

BattleResultView = class()

BattleResultView.txt = nil    --配置表读取
BattleResultView.FailureUIPanel = nil
BattleResultView.VictoryUIPanel = nil 
BattleResultView.PetCtr = nil  --管理萌宠
BattleResultView.scene = nil --场景scene
BattleResultView.name = "BattleResultView" --类名
BattleResultView.buttonIsDoing = false -- 按钮行为
--BattleResultView.efXingxing = nil -- 星星特效
function BattleResultView:Awake(target)

  if self.scene.BattleGuideView.isGuideLevel == true then
    --战斗引导
    self.VictoryUIPanel = newobject(Util.LoadPrefab("UI/battle/GuideOverUI"))
    self.VictoryUIPanel.gameObject.transform.position = Vector3.zero
    self:setPlayerIcon()
  else
    self.VictoryUIPanel = newobject(Util.LoadPrefab("UI/battle/VictoryUI"))
    self.VictoryUIPanel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.VictoryUIPanel.transform.localPosition = Vector3.zero
    self.VictoryUIPanel.transform.localScale = Vector3.one
    self.CoinsLab= getUIComponent(self.VictoryUIPanel,"UI/showdata/coins/Label","UILabel")
    self.ExpLab = getUIComponent(self.VictoryUIPanel,"UI/showdata/exp/Label","UILabel")
    self.resultUI = getUIGameObject(self.VictoryUIPanel,"UI")
    self.TemplateItemList = {}
    self.TemplateItemSpriteList = {}
    self.ResultAnimationView = {}
    for i = 1,3 do
        self.ResultAnimationView[i] = getUIGameObject(self.VictoryUIPanel,"Container/effect/ui_zhanghaoshengji@ani0"..i)          
        SetEffectOrderInLayer(self.ResultAnimationView[i],1)
    end
      --for i = 1, 5 do
         -- local str = "UI/item/Grid/TemplateItem"..i
          ---self.TemplateItemList[i] = getUIGameObject(self.VictoryUIPanel,str)
         -- self.TemplateItemSpriteList[i] = getUIComponent(self.VictoryUIPanel ,str.."Sprite","UISprite")
      --end
      self.ItemLevelRewardGrid =  getUIGameObject(self.VictoryUIPanel,"UI/showdata/item/Grid")
      --奖杯任务
      
      self.ItemLevelCupGrid = getUIGameObject(self.VictoryUIPanel,"UI/showdata/reward/grid")
   
      --奖杯任务
     self.CupObjList = {}
     self.StarList = { [1] = {},[2]= {},[3]= {} }
      self.ItemObjList = {}
     for i = 1,3 do
        for j = 1,3 do
            local str = "Container/effect/ui_zhanghaoshengji@ani0"..i.."/xing0"..(j-1)
            if j == 3 then
              str = "Container/effect/ui_zhanghaoshengji@ani0"..i.."/xing00"..(j-1)
            end
            self.StarList[i][j] = getUIGameObject(self.VictoryUIPanel,str)
        end
    end
    --转动的分数
    self.ScoreAnimationLab = getUIComponent(self.VictoryUIPanel,"Container/effect/ui_zhanghaoshengji@ani02/fentiaofu/panel/Label","UILabel")
    self.AddScore = 0
     self.CurrentScore = 1000000
     self.DeltaTime = 0
     self.AddOneTimeScroll = 0
     self.IsOpenScoreAnimation = false
     
     --结算是否做奖杯动画
     self.IsOpenCupAnimation = false
     --没有判断开始动作前是不可以按放回键的
     self.IsStartCupAnimation = false
     local efAni01 = find("ef_ui_js_ani01"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
     SetEffectOrderInLayer(efAni01,1)
     efAni01 = find("ef_ui_js_bg"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
     SetEffectOrderInLayer(efAni01,2)
    -- self.efXingxing = find("ef_ui_js_xingxing"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
   --  SetEffectOrderInLayer(efXingxing,10)
     --local efBg = find("ef_ui_js_bg"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
    -- SetEffectOrderInLayer(efBg,1)

   end
    --print ("--------------------------function BattleResultView:Awake() ")
    self.FailureUIPanel = newobject(Util.LoadPrefab("UI/battle/FailureUI"))
    self.FailureUIPanel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.FailureUIPanel.transform.localPosition = Vector3.zero
    self.FailureUIPanel.transform.localScale = Vector3.one
    

   
    self.PetCtr = PetForSettlement.new()
    self.scene:boundButtonEvents(self.VictoryUIPanel)
    self.scene:boundButtonEvents(self.FailureUIPanel)
    self.VictoryUIPanel.gameObject:SetActive(false)
    self.FailureUIPanel.gameObject:SetActive(false)
end

function BattleResultView:InitItem(data,ItemDataList,ItemObjList,parent)
    if data == nil then
      return
    end
    local itemInfoList = data.bin_items;
    local petInfoList = data.pet_info
    local equipInfoList = data.equip_info
    ItemDataList = {}
     self.index = 0
    for i = 1,#itemInfoList do 
        self:CreateItem(ItemDataList,ItemObjList,parent,itemInfoList[i],1)
    end
    for i = 1,#equipInfoList do 
       self:CreateItem(ItemDataList,ItemObjList,parent,equipInfoList[i],2)
    end
    
    for i = 1,#petInfoList do 
         self:CreateItem(ItemDataList,ItemObjList,parent,petInfoList[i],3)
    end
    
    if parent ~=nil then
      parent:GetComponent("UIGrid"):Reposition()
      parent:GetComponent("UIGrid").repositionNow = true
    end
end

function BattleResultView:CreateItem(ItemDataList,ItemObjList,parent,data,type)
     
     self.index = self.index + 1
    local item = ItemLevelReward.new()
    local id = data.tid
    local num = data.add_num
    local itemObj
    if ItemObjList[self.index] == nil then
      itemObj = newobject(Util.LoadPrefab("UI/Chapter/ItemLevelReward"))
      ItemObjList[self.index] = itemObj
    end
    
    item:init(self.scene, ItemObjList[self.index] ,parent)
    
    item:SetData(id,type)
    item:SetCount(num)
    item:SetBg(true)
    ItemDataList[id] = item
 
end


--分数跳动
function BattleResultView:Update()
     if not self.IsOpenScoreAnimation then
        return
     end
     self.DeltaTime = self.DeltaTime + UnityEngine.Time.deltaTime  
     self.AddScore = self.AddScore+self.AddOneTimeScroll   
     if self.AddScore<=self.CurrentScore then
        --if self.DeltaTime>0.001 then
            self.DeltaTime = 0
            self.ScoreAnimationLab.text = self.AddScore
        --end
     else
          self:OverSroll()
     end
end

--结束跳动字体显示最终的分数
function BattleResultView:OverSroll()
      self.IsOpenScoreAnimation = false
      self.AddScore = self.CurrentScore
      self.ScoreAnimationLab.text = self.AddScore
       coroutine.start(FinishSrcollLabel,self)
end
--字跳动结束协程函数
function FinishSrcollLabel(self)
    print("FinishSrcollLabel")
     coroutine.wait(0.5)
    self:SetStarListActive(3, self.starNum)
    
    self:SetAnimation(3)
    coroutine.wait(1.2)
    -- self.ResultAnimationView[3].gameObject:SetActive(false)
    self.resultUI.gameObject:SetActive(true)

    
    local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    local step = user[TxtFactory.USER_GUIDE] -- 获取进度
    --if step >= 5 then
    self:SetVictoryUIData(self.normal_rewardList,self.cupList, self.onceInfoList)
    
    self.PetCtr:searchPet() -- 结算萌宠显示
   -- end
end

--关闭分数跳动
function BattleResultView:CloseSrcoll()
      if self.IsOpenScoreAnimation then
          self:OverSroll()
      end
end
--设置成功界面的数据信息
function BattleResultView:SetVictoryUIData(data,cupList,onceInfoList)
    self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    self.CoinsLab.text =  self.Gold
    self.ExpLab.text = self.Exp
    local chapterTable =TxtFactory:getMemDataCacheTable(TxtFactory.ChapterInfo)
    local battleId = chapterTable[TxtFactory.SELECTED_BATTLE_ID]
    print("battleId  :" ..battleId)
    local starNum = chapterTable.chapter_star[tonumber(battleId)]
    print(" Star :"..starNum)
    self:InitCupItem(battleId,cupList,onceInfoList)
    self:InitItem(data,self.ItemDataList,self.ItemObjList,self.ItemLevelRewardGrid)
    
end

--再来一句按钮
function BattleResultView:FailureUI_Restart()
	  -- print("再来一局")

   TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_IS_RESTART,true)
   self.scene:ChangScene(SceneConfig.buildingScene)
end

--失败返回按钮
function BattleResultView:FailureUI_Back()
	--print("返回")
    -- 设置进入大关卡
    TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,-2)
    self.scene:ChangScene(SceneConfig.buildingScene)
end

--弹出胜利框  ＋ 结算动画 
function BattleResultView:VictoryUIPanelShow(args)
    self.VictoryUIPanel.gameObject:SetActive(true)
    
    if args == nil then
        return
    end
    self.normal_rewardList = args[1]
    self.cup_rewardListData = args[2]  
    self.cupList = args[3]
    self.onceInfoList = args[4]
    self.CurrentScore = args[5]
    self.Gold = args[6]
    self.Exp = args[7]
    self.starNum = args[8]
    self.AddOneTimeScroll =  math.floor(self.CurrentScore /99)
    if self.AddOneTimeScroll <= 0 then
        self.AddOneTimeScroll = 1
    end
      self.resultUI.gameObject:SetActive(false)
    coroutine.start(VictoryPlayAnimation,self)

end

function VictoryPlayAnimation(self)
    local chapterTable =TxtFactory:getMemDataCacheTable(TxtFactory.ChapterInfo)

    
    self:SetStarListActive(1, self.starNum)
    self:SetAnimation(1)
    
    coroutine.wait(3)
    self:SetStarListActive(2, self.starNum)
    self:SetAnimation(2) 
    self.IsOpenScoreAnimation = true
  
end

function BattleResultView:SetStarListActive(effectNum,starNum)
    for  i = 1,3 do 
        if i<=starNum then
            self.StarList[effectNum][i].gameObject:SetActive(true)
            --添加特效
            --self.efXingxing.transform.parent =  self.StarList[effectNum][i].transform
        else
            self.StarList[effectNum][i].gameObject:SetActive(false)
        end
    end
end

function BattleResultView:SetAnimation(index)
    for i = 1,3 do
      if index== i then
        self.ResultAnimationView[i].gameObject:SetActive(true)
        local animator = self.ResultAnimationView[i].gameObject:GetComponent("Animator")
        animator:Play("ani0"..index)
      else
         self.ResultAnimationView[i].gameObject:SetActive(false)
      end
         
    end
end

--点击胜利框
function BattleResultView:VictoryUIPanelClick()
   --在播放奖杯特效时候不可以返回
  if  self.IsOpenCupAnimation then
      return
  end
    
  local info  = TxtFactory:getMemDataCacheTable(TxtFactory.ChapterInfo)
  local chapterTXT =  TxtFactory:getTable(TxtFactory.ChapterTXT) 
  local chapterId = chapterTXT:GetData(info.cur_battle_id,TxtFactory.S_CHAPTER_TYPE)
  self.ResultAnimationView[3].gameObject:SetActive(false)
    self.resultUI.gameObject:SetActive(false)
  if Util.HasKey("CurrentChapterID") and chapterId == tonumber(Util.GetString("CurrentChapterID")) then
      self.scene:ChangScene(SceneConfig.buildingScene)
   else
      self.scene:ChangScene(SceneConfig.buildingScene)
   end
end

--弹出失败面板 
function BattleResultView:FailureUIPanelShow()
   self.FailureUIPanel.gameObject:SetActive(true)
   
end

-- 新手指导面板 再来按钮
function BattleResultView:GuideUI_Restart()
    if self.buttonIsDoing == true then
      return
    end
    self.buttonIsDoing = true
   --self.scene:ChangScene(SceneConfig.buildingScene)
   --TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,-1)
  TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_STORY,'Level_T_1')        
  self.scene:ChangScene(SceneConfig.levelStory)
end

-- 新手指导面板 继续按钮
function BattleResultView:GuideUI_Back()
    if self.buttonIsDoing == true then
      return
    end
    self.buttonIsDoing = true
    self.scene:ChangScene(SceneConfig.buildingScene)
    TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,-1)

    --刷新 新手引导进度
    local battleScene = GetCurrentSceneUI()
    if battleScene.BattleGuideView.isGuideLevel == true  then
        battleScene.BattleGuideView:GuideIsFinish()
    end

--[[    local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    local step = user[TxtFactory.USER_GUIDE] -- 获取进度
    local newStep = step+1
    GameWarnPrint("新手指导面板 继续按钮 = "..tostring(newStep))
    local taskM = GuideManagement.new()
    local scene = nil
    taskM:init(scene)
    taskM:sendGuideProgress(newStep)]]

end

-- 新手结束男女icon
function BattleResultView:setPlayerIcon()
    local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    local sex = user[TxtFactory.USER_SEX]
    local sexSpriteName = nil
    if sex == 0 then -- 男
      sexSpriteName = "Player_male_talk"
    elseif sex == 1 then -- 女
      sexSpriteName = "Player_girl_talk"
    end
    local Actor = self.VictoryUIPanel.gameObject.transform:FindChild("Camera/UI/UIGame/Actor"):GetComponent("UISprite")
    Actor.spriteName = sexSpriteName

end

-- 获取类名
function BattleResultView:getName()
    return self.name 
end

--奖杯逻辑
function BattleResultView:InitCupItem(levelId,cupInfoList,onceInfoList)
    self.CupList = {}
   local chapterTxt = TxtFactory:getTable(TxtFactory.ChapterTXT)
    local cupTaskTxt = chapterTxt:GetLevelCupTask(levelId)
    local index = 1
    local hasCup = {}
    
    --没有打关卡前有几个奖杯
    local onceNum = 0
   -- if onceInfoList ~= nil then
      for i = 1,#onceInfoList do
        if onceInfoList[i] == 1 then
          onceNum = onceNum +1
        end
      end
     --end
    
    local currentNum = 0
    for i = 1,#cupInfoList do
      if cupInfoList[i] ==  1 then
          currentNum = currentNum + 1
      end
    end
    
    --奖杯完成之后就开始显示奖杯获得奖励的物品了
    local finishDel = function (scene)
          local itemObjList = {}
          local dataList = {}
          scene.resultView:InitItem(scene.resultView.cup_rewardListData,dataList,itemObjList)
          --可以返回了
        
          if #itemObjList>0 then
              scene:rewardItemsShow(itemObjList)
          end
          scene.resultView.IsOpenCupAnimation = false
    end

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
              --print("onceNum : "..onceNum)
              --print ("currentNum : "..currentNum)
              item:Refresh(true,onceNum,finishDel,index,currentNum)
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
    
    self.ItemLevelCupGrid:GetComponent("UIGrid"):Reposition()
	  self.ItemLevelCupGrid:GetComponent("UIGrid").repositionNow = true
end

--奖杯点击事件
function BattleResultView:ItemLevelCupClick(button)
   --print("button.name : "..button.name)
   local str = string.split(button.name,"_")
   --print("str[2] : "..str[2])
   local index = tonumber(str[2])
   local taskId =  self.CupList[index].taskId
   
   self.scene.LevelCupTaskView:SetShowView(true)
   self.scene.LevelCupTaskView:RefreshData(taskId)
    
end