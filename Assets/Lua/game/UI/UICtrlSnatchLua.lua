--[[
夺宝奇兵监听类
gaofei
]]
UICtrlSnatchLua = class (BaseUILua)


function UICtrlSnatchLua:Awake()
    self.super.Awake(self)
    local sceneUI = find(ConfigParam.SceneOjbName)
    local mainscene = LuaShell.getRole(sceneUI.gameObject:GetInstanceID())
    self.scene = mainscene:GetUIChild(SceneConfig.snathScene)
end

--外部调用接口
function UICtrlSnatchLua:DoUIButton(buttonType,button)
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
function UICtrlSnatchLua:OnClick(button)
    self:UIPanelControl(button)
    self:PlayButEffectSound()
end

-- 
function UICtrlSnatchLua:UIPanelControl(button)
    local action = button.name
  --  local object = find("sceneUI")
        local flag = self.super.UIPanelControl(self,button)
    if flag == true then
        return
    end
    local objectID = self.scene
    --printf("---------"..action)
    if action == "BackBtn" then
        objectID:BackBtnOnClick()
    elseif action == "itemTipBg" then -- 提示板 关闭按钮
        self.scene:CloseItemTips()
    elseif action == "RefreshRivalBtn" then
        objectID:RefreshRivalBtnOnClick()
    elseif action == "SuitBtn" then
        objectID:SuitBtnOnClick()
    elseif action == "PetBtn" then
        objectID:PetBtnOnClick()
    elseif action == "MountBtn" then
        objectID:MountBtnOnClick()
    elseif action == "StrongholdBtn" then
        objectID:StrongholdBtnOnClick()
    elseif action == "StoreBtn" then
        objectID:StoreBtnOnClick()
    elseif action == "ExplainBtn" then
        objectID:ExplainBtnOnClick()
    elseif action == "StrongholdCloseBtn" then
        objectID:snatchStrongholdViewEvent("SnatchStrongholdViewCloseBtnOnClick")
    elseif action == "GainBtn" then
        objectID:snatchStrongholdViewEvent("GainBtnOnClick")
    elseif action == "AddPetDefend" then
        objectID:snatchStrongholdViewEvent("AddPetDefendOnClick") 
    elseif action == "ExplainCloseBtn" then
        objectID:snatchExplainViewEvent("HiddenView")
    elseif action == "RivalInfoCloseBtn" then
        objectID:snatchRivalInfoViewEvent("HiddenView")
    elseif action == "SnatchBattleBtn" then
        objectID:snatchRivalInfoViewEvent("SnatchBattleBtnOnClick")
    elseif action == "EquipBtn" then
        objectID:EquipBtnOnClick()
    elseif action == "SnatchStoreCloseBtn" then
        objectID:snatchStoreViewEvent("HiddenView")
    elseif action == "StoreBuyBtn_1" then
        objectID:snatchStoreViewEvent("StoreBuyBtnOnClick",button)
    elseif action == "StoreItemInfo_1" then
        objectID:snatchStoreViewEvent("StoreItemInfoOnClick",button)
    elseif action == "IntegralBtn" then
        objectID:IntegralBtnOnClick() 
    elseif action == "IntegralCloseBtn" then
         objectID:snatchIntegralViewEvent("HiddenView")
    elseif action == "PetDefengCloseBtn" then
         objectID:snatchPetDefendViewEvent("HiddenView")
    elseif action == "SeletePetIcon" then
         objectID:snatchPetDefendViewEvent("SeletePetIconOnClick",button)
    end
end

