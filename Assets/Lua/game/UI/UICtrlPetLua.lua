--[[
萌宠UI逻辑
huqiuxiang
]]
UICtrlPetLua = class (BaseUILua)

function UICtrlPetLua:Awake()
    self.super.Awake(self)
    local sceneUI = find(ConfigParam.SceneOjbName)
    local mainscene = LuaShell.getRole(sceneUI.gameObject:GetInstanceID())
    self.scene = mainscene:GetUIChild(SceneConfig.petScene)
end
--外部调用接口
function UICtrlPetLua:DoUIButton(buttonType,button)
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
function UICtrlPetLua:OnClick(button)
   local flag = self.super.UIPanelControl(self,button)
    if flag == true then
        return
    end

    self:UIPanelControl(button)
    self:PlayButEffectSound()

end

--按下事件
function UICtrlPetLua:OnPress(button)
    -- self:UIPanelControlOnPress(button)
end


function UICtrlPetLua:UIPanelControl(button)
 
    local objectID = self.scene
    local action = button.name
    if action == "PetMainUI_handBook" then -- 主界面 图鉴按钮
        --objectID:petMainView_handbookBtn()
    elseif action == "PetMainUI_joinBtn" then -- 主界面 上场按钮
        --objectID:petMainView_joinBtn()
    elseif action == "PetMainUI_giftBtn" then -- 主界面 送礼按钮
        --objectID:petMainView_giftBtn()
    elseif action == "PetMainUI_allBtn" then -- 主界面 全部按钮
        --objectID:petMainView_allBtn(button)
    elseif action == "PetMainUI_aidBtn" then -- 主界面 支援按钮
        --objectID:petMainView_aidBtn()
    elseif action == "PetMainUI_flightBtn" then -- 主界面 飞行按钮
        --objectID:petMainView_flightBtn()
    elseif action == "PetMainUI_close" then -- 主界面 关闭
        --objectID:petMainView_backBtn()
    elseif action == "PetMainUI_smelt" then -- 主界面 萌宠抽取按钮
        --objectID:petMainView_extractBtn()
    elseif action == "PetMainUI_merge" then -- 主界面 萌宠融合按钮
        --objectID:petMainView_mergeBtn()
    elseif action == "PetMainUI_myGiftCloseBtn" then -- 主界面 萌宠融合按钮
        --objectID:petMainView_myGiftCloseBtn()

    elseif action == "PetExtractUI_close" then -- 抽取界面 关闭按钮
        --objectID:petExtractView_closeBtn()
    elseif action == "PetExtractUI_coinBtn" then -- 抽取界面 金币按钮
        --objectID:petExtractView_coinBtn()
    elseif action == "PetExtractUI_diamondBtn" then -- 抽取界面 钻石按钮
        --objectID:petExtractView_diamondBtn()
    elseif action == "PetExtractUI_pieceBtn" then -- 抽取界面 碎片按钮
        --objectID:petExtractView_pieceBtn()
    elseif action == "PetExtractPetShowUI_close" then -- 抽取界面 展示界面关闭按钮
        --objectID:petShowPanel_closeBtn()
    elseif action == "Extract_rewardItemOkBtn" then -- 抽取界面 展示界面关闭按钮
        --objectID:petExtractView_rewardItemOkBtn()

    elseif action == "PetMergeUI_close" then -- 融合界面 关闭按钮
        --objectID:petMergeView_closeBtn()
    elseif action == "PetMergeUI_coinBtn" then -- 融合界面 金币融合按钮
        --objectID:petMergeView_coinMergeBtn()
    elseif action == "PetMergeUI_diamonBtn" then -- 融合界面 钻石融合按钮
        --objectID:petMergeView_diamondMergeBtn()
    elseif action == "PetMergeUI_leftPetBtn" then -- 融合界面 左侧按钮
        --objectID:petMergeView_leftPetBtn()
    elseif action == "PetMergeUI_rightPetBtn" then -- 融合界面 右侧按钮
        --objectID:petMergeView_rightPetBtn()
    elseif action == "PetMergeUI_itemAddBtn" then -- 融合界面 物品按钮
        --objectID:petMergeView_itemBtn()
    elseif action == "PetMypetUI_close" then -- 融合界面 我的萌宠面板关闭按钮
        ---objectID:petMergeView_myPetPanel_closeBtn()
    elseif action == "PetAuxiliaryItemUI_close" then -- 融合界面 支援道具面板关闭按钮
        --objectID:petMergeView_aidItemPanel_closeBtn()
    elseif action == "PetMergeUI_explanBtn" then
        --objectID:petMergeView_explanBtn()
    elseif action == "ExplainCloseBtn" then
        --objectID:petMergeView_CloseExplanBtn()

    elseif action == "PetHandbookUI_close" then -- 图鉴界面 关闭按钮
        --objectID:petHandbookView_closeBtn()
    elseif string.find(action, "PetHandbook_zhaohuang") then
        --objectID:petHandbookView_zhaohuan(button)
    elseif string.find(action, "petExpItemsBuy") then
        --objectID:petMainView_buyItems(button)

    elseif action == "petIconInfoBtn" then -- 萌宠icon 信息按钮
        --objectID:creatIconInfoPanel(button)
    elseif action == "PetInfoUI_close" then -- 萌宠icon信息面板 关闭按钮
        --objectID:petIconInfoPanel_closeBtn()
    elseif action == "CommonPromptUI_Background" then -- 萌宠提示板 关闭按钮
        --objectID:promptWordShowClose()

    elseif action == "BuyItemUI_close" then --
        --objectID:buyItemPanelClose()
    elseif action == "BuyItemUI_buy" then -- 
        --objectID:petMainView_buyBtn()
    elseif action == "BuyItemUI_addBtn" then -- 
        --objectID:buyItemJia()
    elseif action == "BuyItemUI_subtractBtn" then -- 
        --objectID:buyItemJian()
    elseif action == "BuyItemUI_maxBtn" then -- 
        --objectID:buyItemMax()
    elseif action == "ReplacePetSolt2" then -- 
        --objectID:uiReplacePetEvent("ReplaceLeft")
    elseif action == "ReplacePetSolt3" then -- 
        --objectID:uiReplacePetEvent("ReplaceRight")
    elseif action == "ReplacePetCloseBtn" then
        --objectID:uiReplacePetEvent("ShowReplaceView", false)
    elseif action == "SeletePetIcon" then
        --objectID:listBtnOnClick(button)
    end
end

