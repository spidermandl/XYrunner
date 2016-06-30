--[[
author: hanli_xiong
坐骑UI事件监听
]]

UIMountCtrl = class(BaseUILua)

UIMountCtrl.sceneUI = nil

function UIMountCtrl:Awake()
    local scene = find(ConfigParam.SceneOjbName)
    local mainscene = LuaShell.getRole(scene.gameObject:GetInstanceID())
    self.sceneUI = mainscene:GetUIChild(SceneConfig.mountScene)
end

--外部调用接口
function UIMountCtrl:DoUIButton(buttonType,button)
    -- print("按钮名字"..button.name.."::Type::"..buttonType)
    if buttonType=="OnClick" then
        self:OnClick(button)
    elseif buttonType=="OnPress" then
        if button.name == "MountSkillBtn" then
            self.sceneUI:ShowMountSkill(true) -- 坐骑技能
        elseif button.name == "MountAttrBtn" then
            self.sceneUI:ShowMountAttr(true) -- 坐骑属性
        end
    elseif buttonType=="OnRelease" then
        if button.name == "MountSkillBtn" then
            self.sceneUI:ShowMountSkill(false) -- 坐骑技能
        elseif button.name == "MountAttrBtn" then
            self.sceneUI:ShowMountAttr(false) -- 坐骑属性
        end
    elseif buttonType=="OnDoubleClick" then
        -- self:OnDoubleClick(button)
    end
end

--点击事件
function UIMountCtrl:OnClick(button)
    local flag = self.super.UIPanelControl(self,button)
    if flag == true then
        return
    end
    if button.name == "MountMainUI_close" then -- 返回
        self.sceneUI:BackToBuildScene()
    elseif button.name == "MountMainUI_upgradeBtn" then -- 升级按钮
		self.sceneUI:OnBtnUpLevel()
    elseif button.name == "LevelUpPopupUI_close" then -- 关闭升级界面
        self.sceneUI:ShowLevelUpPannel(false)
    elseif button.name == "LevelUpPopupUI_levelUp" then -- 确认升级
        self.sceneUI:OnBtnUpLevel()
    elseif button.name == "CommonPromptUI_Background" then -- 提示板 关闭按钮
        self.sceneUI:promptWordShowClose()
    elseif string.find(button.name, self.sceneUI.mountItemFlag) then -- 选中坐骑
        self.sceneUI:ChooseMount(button.name)
    end
    self:PlayButEffectSound()
end
