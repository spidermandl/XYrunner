--[[装备UI逻辑]]
UICtrlEquipLua = class (BaseUILua)

function UICtrlEquipLua:Awake()
    self.super.Awake(self)
    local sceneUI = find(ConfigParam.SceneOjbName)
    local mainscene = LuaShell.getRole(sceneUI.gameObject:GetInstanceID())
    self.scene = mainscene:GetUIChild(SceneConfig.equipScene)
end
--外部调用接口
function UICtrlEquipLua:DoUIButton(buttonType,button)
    if buttonType=="OnClick" then
        self:OnClick(button)
    elseif buttonType=="OnPress" then
        self:OnPress(button)
    elseif buttonType=="OnRelease" then
        self:OnRelease(button)
    elseif buttonType=="OnDoubleClick" then
        self:OnDoubleClick(button)
    end
end

--点击事件
function UICtrlEquipLua:OnClick(button)
    local flag = self.super.UIPanelControl(self,button)
    if flag == true then
        return
    end
    self:UIPanelControl(button)
    self:PlayButEffectSound()
end

--按下事件
function UICtrlEquipLua:OnPress(button)
    self:UIPanelControlOnPress(button)
end

--释放事件
function UICtrlEquipLua:OnRelease(button)
end

--双击事件
function UICtrlEquipLua:OnDoubleClick(button)
end


--长按事件
function UICtrlEquipLua:LongPress(button)
end

--长按要执行的事件
function UICtrlEquipLua:LongFunction(buttonName)
end

--查找名字在列表中的位置
function UICtrlEquipLua:FindButton(buttonName)
end

function UICtrlEquipLua:UIPanelControl(button)


    local objectID = self.scene
    local action = button.name
    if action == "EquipUI_close" then -- 后退
        objectID:BackBtn()
    elseif action == "EquipUI_extract" then -- 装备抽取
        objectID:EquipPanel_EquipExtractBtn()
    elseif action == "EquipUI_smelt" then -- 装备熔炼
        objectID:EquipPanel_mergeEquipBtn()
    elseif action == "EquipUIt_addVolume" then -- 添加装备位置
        objectID.mainView:EquipPanel_extendSlotPost()
    elseif action == "EquipeBuyVolumeUI_close" then -- 
        objectID.mainView:volumeBuyPanel_closeBtn()
    elseif action == "EquipeBuyVolumeUI_get" then -- 
        objectID.mainView:volumeBuyPanel_buyBtn()
    elseif action == "EquipUI_handBook" then -- 装备图鉴
        objectID:EquipPanel_handbookEquipBtn()
    elseif action == "EquipUI_forward" then -- 人物向前按钮
        objectID:DoChooseEquip(-1)
    elseif action == "EquipUI_next" then -- 人物向后按钮
        objectID:DoChooseEquip(1)
    elseif action == "EquipUI_dropEquip" then -- 放弃装备

    elseif action == "EquipUI_leftBtn1" then -- 左下一按钮
        -- objectID:EquipPanel_extendSlotPost()
    elseif action == "EquipUI_leftBtn2" then -- 左下二按钮
        -- objectID:EquipPanel_extendSlotPost()
    elseif action == "EquipUI_leftBtn3" then -- 左下三按钮
        -- objectID:EquipPanel_extendSlotPost()

    -- elseif action == "EquipeLevelUpUI_close" then -- 关闭按钮
    --     objectID:UpgradeEquipPanel_closeBtn()
    elseif action == "EquipePopupUI_equip" then 
        objectID.mainView:EquipmentUpgradePanel_equipBtn()
    elseif action == "EquipePopupUI_levelUp" then 
        objectID.mainView:EquipmentUpgradePanel_upgradeEquipBtn()
    elseif action == "EquipePopupUI_close" then 
        -- print("fjc-----EquipePopupUI_close---")
        objectID.mainView:EquipmentUpgradePanel_closeBtn()

    elseif action == "MaterialPopupUI_get" then 
        objectID.mainView:UnequipmentUpgradePanel_equipBtn()
    elseif action == "MaterialPopupUI_composite" then 
        objectID.mainView:UnequipmentUpgradePanel_upgradeEquipBtn()
    elseif action == "MaterialPopupUI_close" then 
        objectID.mainView:UnequipmentUpgradePanel_closeBtn()
    elseif string.find(action, "EquipUI_leftBtn") then
        objectID.mainView:OnLeftBagItem(action)

    elseif action == "EquipeLevelUpUI_Gold" then 
        objectID.upgradeView:UpgradeEquipPanel_coinBtn()
    elseif action == "EquipeLevelUpUI_Diamond" then 
        objectID.upgradeView:UpgradeEquipPanel_daimondBtn()
    elseif action == "EquipeLevelUpUI_close" then 
        objectID.upgradeView:UpgradeEquipPanel_closeBtn()
    elseif action == "LevelUpPopupUI_levelUp" then 
        objectID.upgradeView:UpgradeEquipPanel_upgradePanelShowUpgradeBtn()
    elseif action == "LevelUpPopupUI_close" then 
        objectID.upgradeView:UpgradeEquipPanel_upgradePanelShowCloseBtn()
        
    elseif action == "EquipSmeltUI_explain" then 
        objectID.mergeView:MergeEquipPanel_desriptBtn()
    elseif action == "EquipSmeltUI_smelt" then 
        objectID.mergeView:MergeEquipPanel_mergeBtn()
    elseif action == "EquipSmeltUI_close" then 
        objectID.mergeView:MergeEquipPanel_closeBtn()
    elseif action == "ExplainCloseBtn" then 
        objectID.mergeView:MergeEquipPanel_desriptCloseBtn()
    elseif string.find(action, "EquipSmeltMatBtn") then
        objectID.mergeView:MergeEquipPanel_unequipItemBtn(action)
        
    elseif action == "EquipHandBookUI_close" then 
        objectID.handbookView:HandBookEquipPanel_closeBtn()
    elseif action == "HandBookPopupUI_close" then 
        objectID.handbookView:HandBookEquipPanel_infoCloseBtn()

    elseif action == "EquipExtractUI_goldOne" then 
        objectID.equipExtract:extractEquipPanel_coinForOneBtn()
    elseif action == "EquipExtractUI_goldTen" then 
        objectID.equipExtract:extractEquipPanel_coinForTenBtn()
    elseif action == "EquipExtractUI_diamondOne" then 
        objectID.equipExtract:extractEquipPanel_diamondForOneBtn()
    elseif action == "EquipExtractUI_diamondTen" then 
       objectID.equipExtract:extractEquipPanel_diamondForTenBtn()
    elseif action == "EquipExtractUI_close" then 
       objectID.equipExtract:extractEquipPanel_closeBtn()
    elseif action == "Extract_rewardItemOkBtn" then 
       objectID.equipExtract:rewardItemOkBtn()

    elseif action == "EquipeGetItemsUI_close" then 
       objectID:CloseGetItemsPanel()

    elseif action == "EquipBack"  then
        objectID:BackBtn()

    elseif tonumber(button.name) then
        objectID:listBtnDistributeOnClick(button)
        -- print(action)
    end
end

function UICtrlEquipLua:UIPanelControlOnPress(button)
    local action = button.name
    -- if self.scene == nil then
    --     self.scene = LuaShell.getRole(find("sceneUI"):GetInstanceID())
    -- end

    self.scene:listBtnDistributeOnPress(button)

end
