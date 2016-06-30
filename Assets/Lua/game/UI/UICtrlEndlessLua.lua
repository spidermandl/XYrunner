--[[
萌宠UI逻辑
huqiuxiang
]]
UICtrlEndlessLua = class (BaseUILua)

function UICtrlEndlessLua:Awake()
    self.super.Awake(self)
    local sceneUI = find(ConfigParam.SceneOjbName)
    local mainscene = LuaShell.getRole(sceneUI.gameObject:GetInstanceID())
    self.scene = mainscene:GetUIChild(SceneConfig.endlessScene)
end

--外部调用接口
function UICtrlEndlessLua:DoUIButton(buttonType,button)
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
function UICtrlEndlessLua:OnClick(button)
    -- print("点击了"..button.name)
    local flag = self.super.UIPanelControl(self,button)
    if flag == true then
        return
    end
    self:UIPanelControl(button)
    self:PlayButEffectSound()
end

--按下事件
function UICtrlEndlessLua:OnPress(button)
    -- self:UIPanelControlOnPress(button)
end

-- 
function UICtrlEndlessLua:UIPanelControl(button)

    
    local action = button.name
    --local object = find("sceneUI")
    --local objectID = LuaShell.getRole(object.gameObject:GetInstanceID())
    local objectID = self.scene
    if action == "EndlessRankUI_next" then -- 开始界面 next按钮
        objectID:rankView_nextBtn()
    elseif action == "EndlessItemsUI_next" then -- 道具界面 上场按钮 CommonTopUI_back
        objectID:itemsView_nextBtn()
    elseif string.find(action, "ItemsView_itemBuyBtn" )then -- 开始界面 后退按钮 CommonTopUI_back
        objectID:itemsView_itemBuyBtn(button)    
    elseif action == "EndlessRankUI_jingdian" then -- 开始界面 后退按钮 CommonTopUI_back
        objectID:rankView_jingdianBtn()    
    elseif action == "EndlessRankUI_tianti" then -- 开始界面 后退按钮 CommonTopUI_back
        objectID:rankView_tiantiBtn()    
    elseif action == "EndlessRankUI_yuanzheng" then -- 开始界面 后退按钮 CommonTopUI_back
        objectID:rankView_yuanzhengBtn()    
    elseif action == "RankView_tiliBtn" then -- 开始界面 后退按钮 CommonTopUI_back
        objectID:rankView_tiliBtn(button)  
    elseif button.name == "ChapterUI_role" then -- 角色
        objectID:UIBuilding_SuitBtn()
    elseif button.name == "ChapterUI_pet" then -- 宠物
       objectID:UIBuilding_PetBtn()
    elseif button.name == "ChapterUI_equip" then -- 装备
       objectID:UIBuilding_EquipBtn()
    elseif button.name == "ChapterUI_mount" then -- 坐骑
       objectID:UIBuilding_MountBtn()   
    end
end

