--[[
对话UI监听
huqiuxiang
]]
UICtrlDialogueLua = class (BaseUILua)
UICtrlDialogueLua.scene = nil 

function UICtrlDialogueLua:Awake()
    local sceneUI = find("sceneUI")
    if sceneUI == nil then
        sceneUI = find("Object")
    end
    self.scene = LuaShell.getRole(sceneUI.gameObject:GetInstanceID())
end

--外部调用接口
function UICtrlDialogueLua:DoUIButton(buttonType,button)
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
function UICtrlDialogueLua:OnClick(button)
	local flag = self.super.UIPanelControl(self,button)
    if flag == true then
        return
    end
    -- print("点击了"..button.name)
    self:UIPanelControl(button)
    self:PlayButEffectSound()
end

--按下事件
function UICtrlDialogueLua:OnPress(button)
    -- self:UIPanelControlOnPress(button)
end

-- 
function UICtrlDialogueLua:UIPanelControl(button)

    local action = button.name
    if action == "DialogueUI_next" then -- next按钮
        self.scene:uiDialogue_nextBtn()
    end
end