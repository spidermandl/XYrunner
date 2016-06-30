--[[
author:Desmond
跑酷结算界面按钮事件传递
]]
UICtrlSettlement = class(BaseUILua)
--UICtrlChapterLua
UICtrlSettlement.tag = "UICtrlSettlement"
UICtrlSettlement.roleName = "UICtrlSettlement"
UICtrlSettlement.scene = nil --场景scene lua

function UICtrlSettlement:Start()
	local  sceneUI = find(ConfigParam.SceneOjbName)
	self.scene = LuaShell.getRole(sceneUI.gameObject:GetInstanceID())
end

--外部调用接口
function UICtrlSettlement:DoUIButton(buttonType,button)
	-- print("按钮名字"..button.name.."::Type::"..buttonType)
	
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
function UICtrlSettlement:OnClick(button)
 --    if button.name == "BtnRestart_FailureUI" then
	--     self:UIPanelControl("BtnRestart_FailureUI")
	-- elseif button.name == "BtnBack_FailureUI" then
	--    	self:UIPanelControl("BtnBack_FailureUI")
	-- elseif button.name == "VictoryUIPanel" then
	--    	self:UIPanelControl("VictoryUIPanel")
	-- end 
	local flag = self.super.UIPanelControl(self,button)
    if flag == true then
        return
    end
	self:UIPanelControl(button.name)
	    self:PlayButEffectSound()
end

--按下事件
function UICtrlSettlement:OnPress(button)
	if button.name=="BtnJump" then
		self:LongPress(button)
	end
end

--释放事件
function UICtrlSettlement:OnRelease(button)
	if button.name=="BtnJump" then
		--self:DoAction("drop")
		table.remove(self.PressingList,self:FindButton(button.name))
	end
end

--双击事件
function UICtrlSettlement:OnDoubleClick(button)

end


--长按事件
function UICtrlSettlement:LongPress(button)
	self.TarButtonTime=UnityEngine.Time.time
	table.insert(self.PressingList,button.name)
end

--长按要执行的事件
function UICtrlSettlement:LongFunction(buttonName)
	if buttonName=="BtnJump" then
		--self:DoAction("dive")
	end
end

--查找名字在列表中的位置
function UICtrlSettlement:FindButton(buttonName)
	for i=1,table.getn(self.PressingList) do
		if self.PressingList[i]==buttonName then
			return i
		end
	end
end

function UICtrlSettlement:UIPanelControl(action)
  
	
	local objectID = self.scene
	if action == "BtnRestart_FailureUI" then
		objectID:uiResultEvent("FailureUI_Restart")
	elseif action == "BtnBack_FailureUI" then
		objectID:uiResultEvent("FailureUI_Back")

	elseif action == "BtnBack_GuideOverUI" then
		-- objectID:uiResultEvent("GuideUI_Back")

		objectID.resultView:GuideUI_Back()
	elseif action == "BtnRestart_GuideOverUI" then
		-- objectID:uiResultEvent("GuideUI_Restart")
		objectID.resultView:GuideUI_Restart()
	elseif action == "VictoryUIPanel" then
		objectID:uiResultEvent("VictoryUIPanelClick")
	elseif action == "EndlessSettlementUI_close" then
		objectID.resultView:okBtn()
	elseif action == "EndlessSettlementUI_okBtn" then
		objectID.resultView:okBtn()
	elseif action == "EndlessSettlementUI_shareBtn" then
		objectID.resultView:shareBtn()
	elseif action == "OkBut" then
			objectID.PlayerLevelUpView:close()
	end  

end
