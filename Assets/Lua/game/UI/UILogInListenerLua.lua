--[[
ui登陆注册 按钮监听 发送事件 UILogInListenerLua
]]

UILogInListenerLua = class (BaseUILua)
UILogInListenerLua.tag = "UILogInListenerLua"
UILogInListenerLua.roleName = "UILogInListenerLua"

--外部调用接口
function UILogInListenerLua:DoUIButton(buttonType,button)
	-- print("按钮名字"..button.name.."::Type::"..buttonType)
	
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
function UILogInListenerLua:OnClick(button)
	-- if button.name=="LogInUIRegisterBtn" then
	-- 	self:UIPanelControl("LogInUIRegisterBtn")
	-- elseif button.name=="LogInUILogInBtn" then
	--     self:UIPanelControl("LogInUILogInBtn")
	-- elseif button.name=="ServerlistUIStartGameBtn" then
	--     self:UIPanelControl("ServerlistUIStartGameBtn")
	-- elseif button.name=="ServerlistUIChangeIDBtn" then
	--     self:UIPanelControl("ServerlistUIChangeIDBtn")
	-- elseif button.name=="SelectBtn" then
	--     self:UIPanelControl("SelectBtn")
	-- elseif button.name=="ServerlistUIServerlistTabelClose" then -- ServerlistUIClose LogInUIClose SelectCharacterUIShaiziBtn
	--     self:UIPanelControl("ServerlistUIServerlistTabelClose")
	-- elseif button.name=="ServerlistUIClose" then

	-- elseif button.name=="LogInUIClose" then
        
	-- elseif button.name=="SelectCharacterUIRolemanBtn" then
 --        self:UIPanelControl("SelectCharacterUIRolemanBtn")
	-- elseif button.name=="SelectCharacterUIRolewomanBtn" then
 --        self:UIPanelControl("SelectCharacterUIRolewomanBtn")
	-- elseif button.name=="SelectCharacterUIClose" then
 --        self:UIPanelControl("SelectCharacterUIClose")
	-- elseif button.name=="SelectCharacterUIDoBtn" then
 --        self:UIPanelControl("SelectCharacterUIDoBtn")
 --    elseif button.name=="SelectCharacterUIShaiziBtn" then
 --        self:UIPanelControl("SelectCharacterUIShaiziBtn")
	-- else
 --        self:UIPanelControl(button.name)
	-- end

	local flag = self.super.UIPanelControl(self,button)
    if flag == true then
        return
    end
    -- print("点击了"..button.name)
    self:UIPanelControl(button)

	--这个没有继承BaseUILua
	TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.button)
end

--按下事件
function UILogInListenerLua:OnPress(button)
end

--释放事件
function UILogInListenerLua:OnRelease(button)
end


function UILogInListenerLua:UIPanelControl(button)
	-- local object = find("Object")
	-- local objectID = LuaShell.getRole(object.gameObject:GetInstanceID())
	local action = button.name
	if action == "LogInUIRegisterBtn" then
		    self.scene:OpenRegisterView()
	elseif action == "LogInUILogInBtn" then
            self.scene:LogInBtnAction()
    elseif action == "ServerlistUIChangeIDBtn" then
            self.scene:ChangeIDBtnAction()
    elseif action == "SelectBtn" then
            self.scene:SelectServerBtnAction()
    elseif action == "ServerlistUIServerlistTabelClose" then
            self.scene:ServerlistUIServerlistTabelCloseBtnAction()
    elseif action == "ServerlistUIClose" then

    elseif action == "LogInUIClose" then
    	
    elseif action == "SelectCharacterUIRolemanBtn" then
            self.scene:ManSelectBtnAction()
    elseif action == "SelectCharacterUIRolewomanBtn" then
            self.scene:WoManSelectBtnAction()
    elseif action == "SelectCharacterUIClose" then
            self.scene:CharacterCloseBtnAction()
    elseif action == "SelectCharacterUIDoBtn" then
            self.scene:CharacterOkBtnAction()
	elseif action=="SelectCharacterUIShaiziBtn" then
            self.scene:suijiNameBtnAction()
    elseif action=="AccountLogin" then
        	self.scene:AccountLogin()
    else
            --self.scene:ServerlistTabBtnAction(action)
	end  
end