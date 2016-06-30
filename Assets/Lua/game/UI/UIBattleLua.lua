--[[
author:Desmond
跑酷场景 ui事件控制类
]]

UIBattleLua = class(BaseUILua)

UIBattleLua.type = "UIBattleLua"
--------------------------------------------------Button事件的操作-----------------------------------------------------------------------
UIBattleLua.TarButtonTime = 0 						--记录长按时间
UIBattleLua.PressingList = nil					--记录长按中的button名字

function UIBattleLua:Awake()
	self.super.Awake(self)
	--self.super.setUpdate(self,true)
	self.scene.uiEventCtrl = self
	self.PressingList = {}
end

function UIBattleLua:Start()

end

--由于场景切换时取消物体活跃，启动后update先运行，所以update中的组件都要判定是否为空
function UIBattleLua:Update()
	--print ("---------------function UIBattleLua:Update() ")
	self:Pressing()
end

--外部调用接口
function UIBattleLua:DoUIButton(buttonType,button)
	--print("按钮名字"..button.name.."::Type::"..buttonType)
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
function UIBattleLua:OnClick(button)
	local flag = self.super.UIPanelControl(self,button)
    if flag == true then
        return
    end
	-- printf('-------------------'..button.name)
	--是否是button音效
	
	if button.name=="BtnAttack" then
		self:PlayOtherEffectSound(SoundType.run_attack)
		self:DoAction("attack")
	elseif button.name=="BtnSpeedUp" then
		if self.scene.BattleGuideView.isGuideLevel == false  then
			self:PlayOtherEffectSound(SoundType.item_shield)
			self:DoAction("sprint")
		end
	elseif button.name=="BtnPause" then
		self.scene:doPause()
	-- elseif button.name =="BtnJump"then
	-- 	self:DoAction("jump")
	else 
		self:UIPanelControl(button)
	end
	self:PlayButEffectSound()
end


--按下事件
function UIBattleLua:OnPress(button)
	if button.name=="BtnJump" then
		self:DoAction("jump")
		TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.run_jump)
	end

	self.PressingList[button.name] = UnityEngine.Time.time
end

--释放事件
function UIBattleLua:OnRelease(button)
	if button.name=="BtnJump" then
		--print ("----------------function UIBattleLua:OnRelease(button)")
		self:DoAction("stop_diving")
	end

	self.PressingList[button.name] = nil
end

--双击事件
function UIBattleLua:OnDoubleClick(button)

end


--长按要执行的事件
function UIBattleLua:LongFunction(buttonName)
	if buttonName=="BtnJump" then
		self:DoAction("dive")
	end
end

--循环部分，长按时重复执行长按事件
function UIBattleLua:Pressing()
	for k,v in pairs(self.PressingList) do
		if v ~= nil then
			if UnityEngine.Time.time - v > 0.1 then
				self:LongFunction(k)
			end
		end
	end
end

--执行Desmond中的方法
function UIBattleLua:DoAction(action)
	self.scene:doPlayerAction(action)
end

--ui 事件
function UIBattleLua:UIPanelControl(button)
	local action = button.name
	local objectID = self.scene
	if action == "EndlessSettlementUI_shareBtn" then
		objectID:uiResultEvent("shareBtn")
	elseif action == "EndlessSettlementUI_okBtn" then
		objectID:uiResultEvent("okBtn")
	elseif action=="PauseUIResstart" then
		objectID:uiPauseEvent("RestartGame")
	elseif action=="PauseUIGoOn" then
		objectID:uiPauseEvent("GoOn")
	elseif action=="PauseUIGotoMenu" then
		objectID:uiPauseEvent("GotoMenu")
	elseif action == "OkBut" then
		objectID.PlayerLevelUpView:close()
	elseif action == "BtnRestart_FailureUI" then
		objectID:uiResultEvent("FailureUI_Restart")
	elseif action == "BtnBack_FailureUI" then
		objectID:uiResultEvent("FailureUI_Back")
	elseif action == "BtnBack_GuideOverUI" then
		objectID:uiResultEvent("GuideUI_Back")
	elseif action == "BtnRestart_GuideOverUI" then
		objectID:uiResultEvent("GuideUI_Restart")
	elseif action == "VictoryUIMask" then
		objectID.resultView:VictoryUIPanelClick()
	elseif action == "CloseJumpLabMask" then
		objectID.resultView:CloseSrcoll()
	elseif string.find(button.name, "ItemLevelCup") then
        objectID.resultView:ItemLevelCupClick(button)
	elseif action  == "CupTaskUI_close" then
        self.scene.LevelCupTaskView:SetShowView(false)
	elseif action == "SnatchBattleOkBtn" then
		objectID:uiResultEvent("SnatchBattleOkBtnOnClick")
	elseif action == "SnatchBattleOccupationBtn" then
		objectID:uiResultEvent("SnatchBattleOccupationBtnOnClick")
	elseif action == "SnatchBattleCanelOccupationBtn" then
		objectID:uiResultEvent("SnatchBattleCanelOccupationBtnOnClick")
	elseif action == "SnatchBattleOkOccupationBtn" then
		objectID:uiResultEvent("SnatchBattleOkOccupationBtnOnClick")
	elseif action == "LadderPromotionEnd_OkBtn" then
		objectID:ladderPromotionEndViewUIEvent("LadderPromotionEndOkBtnOnClick")
	elseif action == "LadderPromotionEnd_ShareBtn" then
		objectID:ladderPromotionEndViewUIEvent("LadderPromotionEndShareBtnOnClick")
	elseif action == "LadderChallengeResultOkBtn" then
		objectID:uiResultEvent("LadderChallengeResultViewOnBtnOnClick")
	end  

end






