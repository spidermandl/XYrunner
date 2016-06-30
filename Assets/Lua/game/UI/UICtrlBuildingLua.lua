UICtrlBuildingLua = class (BaseUILua)
--UICtrlChapterLua
UICtrlBuildingLua.tag = "UICtrlBuildingLua"
UICtrlBuildingLua.roleName = "UICtrlBuildingLua"
UICtrlBuildingLua.guideManagement = nil 

function UICtrlBuildingLua:Awake()
	self.super.Awake(self)
end

function UICtrlBuildingLua:Start()
	--self.guideManagement = self.scene.GuideSystem
end


--外部调用接口
function UICtrlBuildingLua:DoUIButton(buttonType,button)
	--print ("------------------------------function UICtrlBuildingLua:DoUIButton(buttonType,button) ")
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
function UICtrlBuildingLua:OnClick(button)
	local flag = self.super.UIPanelControl(self,button)
    if flag == true then
        return
    end
	
	self:UIPanelControl(button)
	self:PlayButEffectSound()
end



--按下事件
function UICtrlBuildingLua:OnPress(button)
	
end

--释放事件
function UICtrlBuildingLua:OnRelease(button)
	if self.scene == nil then
		local object = find("sceneUI")
		self.scene = LuaShell.getRole(object.gameObject:GetInstanceID())
	end
	--print(" button.name : "..button.name)
	if string.find(button.name, "GameSetting_") then
		self.scene:OnGameSetSoundBtn()
	end
end

--双击事件
function UICtrlBuildingLua:OnDoubleClick(button)

end

--查找名字在列表中的位置
function UICtrlBuildingLua:FindButton(buttonName)
	for i=1,table.getn(self.PressingList) do
		if self.PressingList[i]==buttonName then
			return i
		end
	end
end


function UICtrlBuildingLua:UIPanelControl(Btn)
	--GamePrint("0000000000000")
	if self.guideManagement ~= nil then
		local flag = self.guideManagement:getCurBtn(Btn)
		if flag == false then
			return
		end
	end

	local action = Btn.name

	-- print("button -- " .. action)
	if action == "BtnRunning_Building-UI" then
		self.scene:UIBuilding_RunningBtn()
	elseif action == "BtnTurn" then
		self.scene:UIBuilding_BtnTurn()
	elseif action == "BtnTurnOff_RankingUI" then
		self.scene:UIRanking_BtnTurnOff()
	elseif action == "BtnTurnOn_RankingUI" then
		self.scene:UIRanking_BtnTurnOn()
	elseif action == "BtnRes_Building-UI 4" then
		self.scene:UIBuilding_EquipBtn()
	elseif action == "BtnRes_Building-UI 1" then
		self.scene:UIBuilding_SuitBtn()
	elseif action == "BtnRes_Building-UI 2" then
		self.scene:UIBuilding_PetBtn()
	elseif action == "BtnRes_Building-UI 3" then
		self.scene:UIBuilding_MountBtn()
	elseif action == "BtnRes_Building-UI 5" then
		-- self.scene:UIBuilding_EndlessBtn()
		self.scene:UIBuilding_FriendBtn()
	elseif action == "BtnRes_Building-UI 6" then
		self.scene:StoreBtnOnClick()
	elseif action == "BtnRes_Building-UI 7" then
		self.scene:UIBuilding_EndlessBtn()
	elseif action == "Building_Email" then
		self.scene:ShowEmailSystem()
	elseif action == "Building_Task" then
		self.scene:ShowTaskSystem()
	elseif action == "BagUI_close" then
		self.scene:BagUI_close()
	elseif action == "BuildingTop_PlayserSetting" then
		self.scene:ShowPlayerSetting(true)
	elseif action == "PlayerSetting_Close" or action == "PlayerSetting_ExcCancel" then
		self.scene:ShowPlayerSetting(false)
	elseif action == "PlayerSetting_ExcOk" then
		self.scene:OnExchangeGift()
	elseif action == "GiftList_ExcOk" then
		self.scene:OnGetGiftOk()
	elseif action == "PlayerSettingHome" then
		self.scene:OnThirdHomePage()
	elseif action == "PlayerSettingService" then
		self.scene:OnGMService()
	elseif action == "PlayerSettingExit" then
		self.scene:OnExit()
	elseif action == "PlayerSettingHelp" then
		self.scene:OnGMService()
	elseif action == "EmailSystem_Close" then
		self.scene.EmailSystemPanel:CloseWnd()
	elseif action == "EmailGetBtn" then
		self.scene:GetEmailReward(Btn)
	elseif action == "TaskSystemUI_back" then
		self.scene:UIBuilding_taskSystemView_backBtn()
	elseif string.find(action, "Email_") then
		self.scene:OnEmailBtnDown(action)
	elseif string.find(action, "PlyaerSettingBtn_") then
		self.scene:SwitchTable(action)
	elseif string.find(action, "GameSettingBtn_") then
		self.scene:OnGameSetSwitchBtn(action)

	elseif action == "UITaskItem_senderName" then
		self.scene:UIBuilding_taskSystemView_itemsOnClick(Btn)
	elseif action == "UITaskGuideItem_senderName" or action == "getState"  then
		self.scene:UIBuilding_taskSystemView_itemsOnClick(Btn)
	elseif action == "startstate" then
		self.scene.TaskSystemPanel:GotoBtn(Btn)
	elseif action == "TaskInfoUI_stateBtn" then
		self.scene:UIBuilding_taskSystemView_stateBtn()
	elseif action == "TaskInfoUI_getRewardBtn" then
		self.scene:UIBuilding_taskSystemView_taskingBtn()
	elseif action == "BroadCastSceneClose"  then
    	self.scene:BroadCastSceneClose()
    elseif action == "RankingSystem_Close"  then
    	self.scene:UIRanking_BtnTurnOff()
	elseif action == "Building_Activity"  then
    	--self.scene:UIBuilding_ActivityBtn()
	elseif action == 'SurveySend' then
		self.scene:surveyUIEvent("SurveySendOnClick")
	elseif action == 'SurverUICloseBtn' then
		self.scene:surveyUIEvent("SurverUICloseBtnOnClick")
	
	elseif action == "CommonPromptUI_Background" then -- 提示板 关闭按钮
        self.scene:promptWordShowClose()
    elseif action == "itemTipBg" then -- 提示板 关闭按钮
        self.scene:CloseItemTips()
    elseif action == "ItemGetPath_BtnClose" then -- 道具寻路 关闭按钮
        self.scene:CloseItemGetPath()
    elseif action == "ItemGetPath_BtnExchange" then
        self.scene:ItemGetPathGotoStore()
    elseif action == "ItemGetPath_BtnGoto" then
        self.scene:ItemGetPathGotoFuben()
    elseif action == "building_info" then
	   	self.scene:showBuildingInfo()
    elseif action == "buildMessage_close" then
    	self.scene:closeBuildingInfo()
    elseif action == "building_upgrade" then
    	self.scene:showUpgradeBuilding()
    elseif action == "buildingScreenBg" then
   		self.scene:FecthHarvest(Btn)
    elseif action == "buildLevelUp_close" then
    	self.scene:closeBuildingUpgrade()
    elseif action == "building_harvest" then
    	self.scene:claimHarvest()
	elseif action == "buildLevelUp_levelUp" then
		self.scene:buildLevelUp()
	elseif action == "buildShowItem" then
		self.scene:ShowItemGetPath(tonumber(Btn.gameObject.transform.parent.name))
	elseif action == "building_enter" then
		self.scene:joinBuilding()
	elseif action == "Friend_TopBtnClose" then
		self.scene:FriendUIEvent("HideView")
	elseif action == "Friend_TopBtnFriend" then
		self.scene:FriendUIEvent("FriendTopBtnFriendClick")
	elseif action == "Friend_TopBtnReq" then
		self.scene:FriendUIEvent("FriendTopBtnReqClick")
	elseif action == "Friend_TopBtnAdd" then
		self.scene:FriendUIEvent("FriendTopBtnAddClick")
	elseif action == "Friend_TopBtnDelete" then
		self.scene:FriendUIEvent("FriendTopBtnDeleteClick")
	elseif action == "Friend_TopBtnAll" then
		self.scene:FriendUIEvent("FriendTopBtnAllClick")
	elseif action == "Friend_TopBtnQuit" then
		self.scene:FriendUIEvent("FriendTopBtnQuitClick")
	elseif action == "Friend_TopBtnSeek" then
		self.scene:FriendUIEvent("FriendTopBtnSeekClick")
	elseif action == "Friend_BtnTili" then
		self.scene:FriendUIEvent("FriendItemBtnTiliClick",Btn)
	elseif action == "Friend_BtnTiaozhan" then
		self.scene:FriendUIEvent("FriendItemBtnTiaozhanClick",Btn)
	elseif action == "Friend_BtnFangwen" then
		self.scene:FriendUIEvent("FriendItemBtnFangwenClick",Btn)
	elseif action == "Friend_BtnYes" then
		self.scene:FriendUIEvent("FriendItemBtnYesClick",Btn)
	elseif action == "Friend_BtnNo" then
		self.scene:FriendUIEvent("FriendItemBtnNoClick",Btn)
	elseif action == "Friend_BtnAdd" then
		self.scene:FriendUIEvent("FriendItemBtnAddClick",Btn)
	elseif action == "Friend_BtnDelete" then
		self.scene:FriendUIEvent("FriendItemBtnDeleteClick",Btn)
	elseif action == "FriendSeek_BtnSeek" then
		self.scene:FriendUIEvent("FriendSeekBtnSeek")
	elseif action == "FriendSeek_BtnClose" then
		self.scene:FriendUIEvent("FriendSeekBtnClose")
	elseif action == "FriendInfo_BtnDelete" then
		self.scene:FriendUIEvent("FriendInfoBtnDelete")
	elseif action == "FriendInfo_BtnClose" then
		self.scene:FriendUIEvent("FriendInfoBtnClose")
	elseif action == "Friend_LastPage" then
		self.scene:FriendUIEvent("FriendBtnLastPage")
	elseif action == "Friend_NextPage" then
		self.scene:FriendUIEvent("FriendBtnNextPage")
	elseif action == "LadderMain_BtnGrading" then
		self.scene:LadderUIEvent("LadderGradingBtnOnClick")
	elseif action == "LadderMain_BtnConfirm 1" then
		self.scene:LadderUIEvent("LadderConfirmBtnOnClick")
	elseif action == "LadderMain_BtnDanGrading" then
		self.scene:LadderUIEvent("LadderDanGradingBtnOnClick")
	elseif action == "LadderSeek_BtnClose" then
		self.scene:LadderUIEvent("LadderSeekCloseBtnOnClick")
	elseif action == "Ladder_BtnClose" then
		self.scene:LadderUIEvent("LadderCloseBtnOnClick")
	elseif action == "LadderRank_PromotionBtn" then
		self.scene:LadderUIEvent("LadderRankPromotionBtnOnClick")
	elseif action == "LadderPromoted_BtnClose" then
		self.scene:LadderUIEvent("LadderPromotedCloseBtnOnClick")
	elseif action == "LadderPromoted_BtnDuanWei" then
		self.scene:LadderUIEvent("LadderDanGradingBtnOnClick")
	elseif action == "LadderPromoted_BtnPromoted" then
		self.scene:LadderUIEvent("LadderPromotedBtnOnClick")
	elseif action == "LadderRanking_BtnExplain" then
		self.scene:LadderUIEvent("LadderRankingExplainBtnOnClick")
	elseif action == "ExplainCloseBtn" then
		self.scene:LadderUIEvent("LadderExplainCloseBtnOnClick")
	elseif action == "LadderRanking_BtnReward" then
		self.scene:LadderUIEvent("LadderRankingRewardBtnOnClick")
	elseif action == "LadderRankingTip_BtnClose" then
		self.scene:LadderUIEvent("LadderRankingRewardCloseBtnOnClick")
	elseif action == "LadderRankingItem_BtnTiaozhan" then
		self.scene:LadderUIEvent("LadderRankingItemTiaozhanBtnOnClick",Btn)
	elseif action == "LadderRanking_BtnShop" then
		self.scene:LadderUIEvent("LadderRankingShopBtnOnClick")
	elseif action == "SnatchStoreCloseBtn" then
        self.scene:LadderStoreUIEvent("HiddenView")
    elseif action == "StoreBuyBtn_1" then
        self.scene:LadderStoreUIEvent("StoreBuyBtnOnClick",Btn)
    elseif action == "StoreItemInfo_1" then
        self.scene:LadderStoreUIEvent("StoreItemInfoOnClick",Btn)
	elseif action == "SelectModeViewBack" then
		self.scene.selectModeView:CloseWnd()
	elseif string.find(action,"ItemSeletModel") then
		self.scene.selectModeView:BtnClick(Btn)
	elseif action == "Activity_LeftBtn" then
		self.scene:ActivityUIEvent("ActivityLeftBtnOnClick")
	elseif action == "Activity_RightBtn" then
		self.scene:ActivityUIEvent("ActivityRightBtnOnClick")
	elseif action == "Activity_CloseBtn" then
		self.scene:ActivityUIEvent("ActivityCloseBtnOnClick")
	elseif action == "Building_Survey" then
		self.scene:OpenSurveyView()	
	elseif action == "Open_ButtonOk" then
		self.scene:OpenFunctionGoOK()
	elseif action == "Open_ButtonGoTo" then
		self.scene:OpenFunctionGoTo(self,"UIPanelControl")
	elseif action == "SveneDayActivity_CloseBtn" then
		self.scene:sveneDayActivityViewUIEvent("SveneDayActivityCloseBtnOnClick")
	elseif action == "SveneDayActivity_GetBtn" then
		self.scene:sveneDayActivityViewUIEvent("SveneDayActivityGetBtnOnClick")
	elseif action == "Building_SignIn" then
		self.scene:UIBuilding_SveneDayActivityBtn()
	elseif action == "Building_Notice" then
		self.scene:UIBuilding_ActivityBtn()
	elseif action == "Building_OnlineReward" then
		self.scene:UIBuilding_OnlineActivityBtn()
	end  
	if self.guideManagement ~= nil then
		self.guideManagement:stepCheck()
	end

end



