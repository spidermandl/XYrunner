--UISuitListenerLua
--[[
ui套装 按钮监听 发送事件
]]

UISuitListenerLua = class (BaseUILua)
UISuitListenerLua.tag = "UISuitListenerLua"
UISuitListenerLua.roleName = "UISuitListenerLua"

UISuitListenerLua.scene = nil --场景scene lua

function UISuitListenerLua:Awake()
	local sceneUI = find(ConfigParam.SceneOjbName)
	local mainscene = LuaShell.getRole(sceneUI.gameObject:GetInstanceID())
	self.scene = mainscene:GetUIChild(SceneConfig.suitScene)
end

--外部调用接口
function UISuitListenerLua:DoUIButton(buttonType,button)
	--print("按钮名字"..button.name.."::Type::"..buttonType)
	
	if buttonType=="OnClick" then
		self:OnClick(button)
	elseif buttonType=="OnPress" then
		self:OnPress(button)
	elseif buttonType=="OnRelease" then
		self:OnRelease(button)
	elseif buttonType=="OnDoubleClick" then
		-- self:OnDoubleClick(button)
	end
end

--点击事件
function UISuitListenerLua:OnClick(button)
    -- local flag = self.super.UIPanelControl(self,button)
    -- if flag == true then
    --     return
    -- end
	-- print("OnClick:"..button.name)
	if button.name=="BtnLeft" then
		self:UIPanelControl("BtnLeft")
		-- self:MoveLeft()
	elseif button.name=="BtnRight" then
	    self:UIPanelControl("BtnRight",button)
		-- self:MoveRight()
	elseif button.name=="BtnBuy" then
	    self:UIPanelControl("BtnBuy",button)
		-- self:BuySuit()
	elseif button.name=="BtnBuy1" then
	--------直接购买
		self:UIPanelControl("BtnBuy1",button)
		-- self:BuyDirectly()
	elseif button.name=="BtnUpgrade" then
	    self:UIPanelControl("BtnUpgrade",button)
		-- self:Upgrade()
	elseif button.name=="BtnReturn" then
	    self:UIPanelControl("BtnReturn",button)
		-- Loading(SceneConfig.buildingScene)
	elseif button.name == "CommonPromptUI_Background" then
		self:UIPanelControl("CommonPromptUI_Background",button)	
	elseif tonumber(button.name) then
		self:UIPanelControl("nil",button)
		-- self:ChangeSelect(button.name,true)
		-- self:CorrectBoxPosition()
	end
	self:PlayButEffectSound()
end

--按下事件
function UISuitListenerLua:OnPress(button)
	-- print("OnPress:"..button.name)
end

--释放事件
function UISuitListenerLua:OnRelease(button)
	-- print("OnRelease:"..button.name)
	if tonumber(button.name) then
		self.scene:updateScrollArraw()
	end
end


function UISuitListenerLua:UIPanelControl(action,button)
	if action == "BtnLeft" then
	    self.scene:MoveLeft()
	elseif action == "nil" then
	    self.scene:updateSelection(button.name)
	elseif action == "BtnRight" then
	    self.scene:MoveRight()
	elseif action == "BtnBuy" then
	    self.scene:BuySuit()  
	elseif action == "BtnBuy1" then
	    self.scene:BuyDirectly()  
	elseif action == "BtnUpgrade" then
	    self.scene:Upgrade()  
	elseif action == "BtnReturn" then
	    self.scene:BackBtn()
	-- elseif action == "Trigget3DP" then
	--     self.scene.ModelCtr:StartRotating()
	-- elseif action == "Trigget3DR" then
	--     self.scene.ModelCtr:EndRotating()
	-- elseif action == "Trigget3DRt" then
	--     self.scene.targetPositionX = 0
	--     -- objectID:Upgrade()  
	elseif action == "CommonPromptUI_Background" then
		self.scene:promptWordShowClose()

	end  
end