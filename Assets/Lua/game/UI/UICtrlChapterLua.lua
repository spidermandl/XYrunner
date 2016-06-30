--[[
UICtrlChapterLua
UI 选大章逻辑
hanli_xiong 重构
]]
UICtrlChapterLua = class(BaseUILua)
UICtrlChapterLua.tag = "UICtrlChapterLua"
UICtrlChapterLua.roleName = "UICtrlChapterLua"
UICtrlChapterLua.sceneUI = nil

function UICtrlChapterLua:Awake()
    self.super.Awake(self)
    local sceneUI = find(ConfigParam.SceneOjbName)
    local mainscene = LuaShell.getRole(sceneUI.gameObject:GetInstanceID())
    self.scene = mainscene:GetUIChild(SceneConfig.storyScene)
end

--外部调用接口
function UICtrlChapterLua:DoUIButton(buttonType,button)
	--print("按钮名字"..button.name.."::Type::"..buttonType)
	if buttonType=="OnClick" then
		self:OnClick(button)
	-- elseif buttonType=="OnPress" then
	-- 	self:OnPress(button)
	-- elseif buttonType=="OnRelease" then
	-- 	self:OnRelease(button)
	-- elseif buttonType=="OnDoubleClick" then
	-- 	self:OnDoubleClick(button)
	end
end

--点击事件
function UICtrlChapterLua:OnClick(button)
    self:UIPanelControl(button)
	self:PlayButEffectSound()
end

--奖杯按钮
function UICtrlChapterLua:UIPanelControl(button)
	--print("fddddddddddddddddddd")
  	local flag = self.super.UIPanelControl(self,button)
    if flag == true then
        return
    end
	local action = button.name
    --local object = find("sceneUI")
    --local objectID = LuaShell.getRole(object.gameObject:GetInstanceID())
    local objectID = self.scene
    if action == "ChapterSceneBackBtn" then -- 开始界面 next按钮
        objectID:ChapterSceneBackBtnOnClick()
	end
end
