--[[
author: hanli_xiong
sunkai 修改
选子关卡场景UI控制类
]]

UISelectChapterCtrl = class(BaseUILua)

UISelectChapterCtrl.scene = nil -- 场景对象
UISelectChapterCtrl.uiName = nil -- 脚本对应UI名

-- 外部数据表
UISelectChapterCtrl.localTxt = nil
UISelectChapterCtrl.cacheTxt = nil
UISelectChapterCtrl.levelManagement = nil -- 开始酷跑信息

-- 关卡信息面板
UISelectChapterCtrl.cupPic = "jiangbei"
UISelectChapterCtrl.gcupPic = "jiangbeihui"
UISelectChapterCtrl.levelTitle = nil -- 关卡标题
UISelectChapterCtrl.levelDesc = nil -- 关卡描述
UISelectChapterCtrl.levelSuggest = nil -- 关卡建议
UISelectChapterCtrl.levelCupTask = nil -- 关卡奖杯任务
UISelectChapterCtrl.levelRewardList = nil -- 关卡奖励列表

-- 材料信息面板
UISelectChapterCtrl.materialInfo = nil


function UISelectChapterCtrl:Awake()
    self.super.Awake(self)
    local sceneUI = find(ConfigParam.SceneOjbName)
    local mainscene = LuaShell.getRole(sceneUI.gameObject:GetInstanceID())
    self.scene = mainscene:GetUIChild(SceneConfig.selectChapterScene)
end
--[[
function UISelectChapterCtrl:Awake()

      self.scene = LuaShell.getRole(find(ConfigParam.SceneOjbName):GetInstanceID())
    if self.scene == nil then
        warn("self.sceneUI == nil")
    end
end
]]--
--外部调用接口
function UISelectChapterCtrl:DoUIButton(buttonType,button)

    
     print("按钮名字"..button.name.."::Type::"..buttonType)
     
    if buttonType=="OnClick" then
        self:OnClick(button)
    elseif buttonType=="OnPress" then
        -- self:OnPress(button)
    elseif buttonType=="OnRelease" then
        -- self:OnRelease(button)
    elseif buttonType=="OnDoubleClick" then
        -- self:OnDoubleClick(button)
    end
end

--点击事件
function UISelectChapterCtrl:OnClick(button)
    --GamePrint("11111111111111111")
    local flag = self.super.UIPanelControl(self,button)
    if flag == true then
        return
    end
    --GamePrint("33333333333333")
    if button.name == "ChapterUI_start" then -- 开始游戏
        self.scene.LevelStartView:ChapterUI_start()
    elseif button.name == "BtnCups" then -- 奖杯界面
       self.scene.LevelCupCenterView:SetShowView(true)
    elseif button.name == "BtnMaterial" then -- 材料界面
        self.scene.LevelBagView:SetShowView(true)
    elseif button.name == "ChapterUI_role" then -- 角色
            self.scene:UIBuilding_SuitBtn()
    elseif button.name == "ChapterUI_pet" then -- 宠物
             self.scene:UIBuilding_PetBtn()
    elseif button.name == "ChapterUI_equip" then -- 装备
             self.scene:UIBuilding_EquipBtn()
    elseif button.name == "ChapterUI_mount" then -- 坐骑
             self.scene:UIBuilding_MountBtn()
    elseif button.name == "CupCentreUI_Close" then
        self.scene.LevelCupCenterView:SetShowView(false)
    elseif button.name == "MaterialUI_Close" then
       self.scene.LevelBagView:SetShowView(false)   
    elseif button.name == "MaterialPopupUI1_close" then
         self.scene.LevelBagInfoView:SetShowView(false)
    elseif button.name == "CupTaskUI_close" then
        self.scene.LevelCupTaskView:SetShowView(false)
    elseif string.find(button.name, "ItemLevelCup") then
        self.scene.LevelStartView:ItemLevelCupClick(button)
     elseif string.find(button.name,"ItemForBag") then
         self.scene.LevelBagView:ItemClick(button)
     elseif button.name == "MaterialPopupUI1_get" then
        self.scene.LevelBagInfoView:GetMaterialClick(button)
     elseif string.find(button.name, "MaterialPopupUI1_composite") then
        self.scene.LevelBagInfoView:CompositeMaterial(button)
     elseif string.find(button.name,"ItemCupCenter") then
        self.scene.LevelCupCenterView:ItemClick(button)
      elseif button.name == "LevelCupCenterInfoView_close" then
        self.scene.LevelCupCenterInfoView:SetShowView(false)
       elseif button.name == "LevelCupCenterInfoView_get" then
        self.scene.LevelCupCenterInfoView:GetClick(button)
      elseif button.name == "LevelCupCenterInfoView_bugou" then
        self.scene.LevelCupCenterInfoView:GetShortOfClick(button)
      elseif button.name == "DialogueUI_next" then  -- 剧情对话
		self.scene:uiDialogue_nextBtn()
      elseif button.name == "LevelSelectView_CloseBtn" then
        -- GamePrint("44444444444444")
            self.scene:LevelSceneBackBtnOnClick()
     end 
     self:PlayButEffectSound()
end



