--[[
author:Desmond
关卡测试
]]
UITestLua = class(BaseUILua)

function UITestLua:Awake()
	print ("--------------function UITestLua:Awake() ")
    self.super.Awake(self)
end
--外部调用接口
function UITestLua:DoUIButton(buttonType,button)
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
function UITestLua:OnClick(button)
    local flag = self.super.UIPanelControl(self,button)
    if flag == true then
        return
    end
     self:UIPanelControl(button)
     self:PlayButEffectSound()
end

--按下事件
function UITestLua:OnPress(button)
    -- self:UIPanelControlOnPress(button)
end


function UITestLua:UIPanelControl(button)
	print ("-------------------function UITestLua:UIPanelControl(button) ")
    if self.scene == nil then
        local object = find("sceneUI")
        self.scene = LuaShell.getRole(object.gameObject:GetInstanceID())
    end
    self.scene:runTest(button.name)
end