--UIEndlessScene
--[[
ui无尽逻辑
Huqiuxiang
]]

UIEndlessScene = class (BaseScene)
UIEndlessScene.uiRoot = nil 
UIEndlessScene.endlessManagement = nil -- 无尽数据管理
UIEndlessScene.rankView = nil -- 开头排行面板
UIEndlessScene.itemsView = nil -- 道具使用面板
UIEndlessScene.rankUpView = nil -- 排名上升面板
UIEndlessScene.resourceView = nil -- 资源面板
UIEndlessScene.CurretView = ""
UIEndlessScene.sceneParent = nil -- 打开这个界面的场景
UIEndlessScene.asyncPvpVsView = nil -- 异步pvpVS界面

require "game/scene/logic/endless/RankView"
require "game/scene/logic/endless/EndlessManagement"
require "game/scene/logic/endless/ItemsView"
require "game/scene/logic/endless/ResourceView"
require "game/scene/logic/Challenge/ChallengeVsView"
require "game/scene/logic/AsyncPvp/AsyncPvpVsView"

function UIEndlessScene:Awake()
	-- print("UIEndlessScene:Awake")
   -- self.uiRoot = newobject(Util.LoadPrefab("UI/battle/UI Root"))
	--self.uiRoot.name = 'UI Root'
    self.uiRoot = find("UI Root")
    self.scene = self
    self.sceneTarget = self:AddUIButtonCtrlOnObj(self.uiRoot,"UICtrlEndlessLua")
    -- self.rankPanel = self:LoadUI("Pet/EndlessRankUI")
    self.endlessManagement = EndlessManagement.new()
    self.endlessManagement.scene = self
    self.endlessManagement:init()
    self.CurretView = "RankView"
    self.rankView = RankView.new()
    self.rankView.scene = self
    self.rankView:init()
    local sceneUI = find(ConfigParam.SceneOjbName)
    self.playerTopInfoPanel = LuaShell.getRole(sceneUI.gameObject:GetInstanceID()).playerTopInfoPanel
    self.itemsView = ItemsView.new()
    self.itemsView.scene = self

    self.resourceView = ResourceView.new()
    self.resourceView.scene = self
    self.resourceView:init()
    self.modelShow = ModelShow.new()
    self.modelShow:Init(self)


    self:boundButtonEvents(self.uiRoot)	
    -- 显示人物模型预览
    self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    self.modelShow:ChooseCharacter(self.UserInfo[TxtFactory.USER_SEX])
   -- self:petShow()
    self.modelShow:petShow()
    --[[
    self.RetrunDelegate = function (scene)
        if   self.CurretView == "RankView" then
            --scene:ChangScene(SceneConfig.buildingScene)
            --GamePrint("aaaaaaaaaaaaaaaaa")
            self:ClearChallangeInfo()
            self:SetActive(false)
           -- GamePrint("=========="..tostring(self.sc))
            self.sceneParent:SetActive(true)
            scene.rankView.effect:SetActive(false)
        elseif self.CurretView == "itemsView" then
            self.itemsView:destroy()
            self.rankView:init()
        end
    end
    ]]--
    -- 副UI管理类
  --  self.UIChild = UISceneFactory.new()
   -- self.UIChild:Init()

end
function UIEndlessScene:Update()
    if self.VsView ~= nil then
        self.VsView:Update()
    end
    if self.asyncPvpVsView ~= nil then
        self.asyncPvpVsView:Update()
    end
    --self.super:Update()
end
--[[
function UIEndlessScene:petShow()
    local petTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local  petTab = TxtFactory:getTable(TxtFactory.MemDataCache):getCurPetTab()
    -- print("上次萌宠数量"..petTab[1])
    local tab = {["fly"] =nil,["left"]=nil,["right"]=nil}
    for i =1, #petTab do
        -- local id = self.petTable:GetData(i,'ID')
        local ctid = tonumber(string.sub(tostring(petTab[i]),1,-5)) 
        local petTpye = petTable:GetData(ctid,"TYPE")
        if petTpye == "1" then
            petTab["fly"] = ctid
        end
        if petTpye == "2" then
            if petTab["left"] == nil then
                petTab["left"] = ctid
            else 
                petTab["right"] = ctid
            end
        end
    end
    self.modelShow:ChooseCommonPet( petTab["fly"],petTab["left"],petTab["right"])
end
]]--
-- 加载界面
function UIEndlessScene:LoadUI(name)
    local path = "UI/"..name
    local obj = newobject(Util.LoadPrefab(path))
    obj.gameObject.transform.parent = self.uiRoot.gameObject.transform
    obj.gameObject.transform.localPosition = Vector3.zero
    obj.gameObject.transform.localScale = Vector3.one
    return obj
end

-- 更新道具面板list
function UIEndlessScene:updateItemsList()
    self.itemsView:listUpdate()
end
--退出无尽界面清空挑战信息
function UIEndlessScene:ClearChallangeInfo()
    GamePrint("退出无尽界面清空挑战数据")
    TxtFactory:setMemDataCacheTable(TxtFactory.ChallengeInfo,nil)
    TxtFactory:setMemDataCacheTable(TxtFactory.ReplyChallengeInfo,nil)
end
-- 更新排行界面
function UIEndlessScene:updateRankList(rankInfo)
    -- print("rankInfo"..#rankInfo)
    self.rankView:listUpdate(rankInfo)
end


-- 开头界面 next按钮
function UIEndlessScene:rankView_nextBtn()
    self.rankView:nextBtn()
    self.itemsView:init()
end

-- 道具使用面板 next 按钮
function UIEndlessScene:itemsView_nextBtn()
    self.itemsView.effect.gameObject:SetActive(false)
    self.itemsView:nextBtn()
end

-- 道具购买按钮
function UIEndlessScene:itemsView_itemBuyBtn(Btn)
    self.itemsView:itemBuyBtn(Btn)
end

-- 开始界面 经典按钮
function UIEndlessScene:rankView_jingdianBtn()
    self.rankView:jingdianBtn()
end

-- 开始界面 天梯按钮
function UIEndlessScene:rankView_tiantiBtn()
    self.rankView:tiantiBtn()
end

-- 开始界面 远征按钮
function UIEndlessScene:rankView_yuanzhengBtn()
    self.rankView:yuanzhengBtn()
end

-- 开始界面 list送体力按钮
function UIEndlessScene:rankView_tiliBtn(Btn)
    self.rankView:tiliBtn(Btn)
end

function UIEndlessScene:StartRunning()
    -- destroy(self.panel)
   
   self:ChangScene("level_endless")
end

-- 下面的四个界面按钮
-- 通过子UI的名字返回子UI的lua对象
function UIEndlessScene:GetUIChild(name)
    return self.sceneParent.UIChild:Get(name)
end
--套装按钮
function UIEndlessScene:UIBuilding_SuitBtn()
    -- UpgradeType.Upgrade = UpgradeType.suit
    -- self:ChangScene(SceneConfig.suitScene)
	self:SetActive(false )
    self:GetUIChild(SceneConfig.suitScene):SetActive(true)
    self:GetUIChild(SceneConfig.suitScene):SetOpenViewClass(self)
    
end

--萌宠按钮
function UIEndlessScene:UIBuilding_PetBtn()
    -- self:ChangScene(SceneConfig.petScene)
	self:SetActive(false )
    self:GetUIChild(SceneConfig.petScene):SetActive(true)
    self:GetUIChild(SceneConfig.petScene):SetOpenViewClass(self)
end

--装备按钮
function UIEndlessScene:UIBuilding_EquipBtn()
    -- self:ChangScene(SceneConfig.equipScene)
	self:SetActive(false)
    self:GetUIChild(SceneConfig.equipScene):SetActive(true)
    self:GetUIChild(SceneConfig.equipScene):SetOpenViewClass(self)
end
--进入VS界面
function UIEndlessScene:ShowChallengeVSView(CurretView,friendInfo)
    self.VsView = ChallengeVsView.new()
    self.VsView:Awake(CurretView,friendInfo)
end

-- 进入异步pvpVS界面
function UIEndlessScene:ShowAsyncPvpVSView(CurretView,friendInfo)
    self.asyncPvpVsView = AsyncPvpVsView.new()
    self.asyncPvpVsView:Awake(CurretView,friendInfo)
end
--坐骑按钮
function UIEndlessScene:UIBuilding_MountBtn()
    -- self:ChangScene(SceneConfig.mountScene)
	local word = "该功能暂未开放,敬请期待!!!"
    self:promptWordShow(word)
    
    return
	
	--self:SetActive(false )
    --self:GetUIChild(SceneConfig.mountScene):SetActive(true)
end
-- 关闭当前的UI 显示副UI
function UIEndlessScene:SetActive(active)
    if active then
       -- GamePrint("active == true")
         self.modelShow:ChooseCharacter(self.UserInfo[TxtFactory.USER_SEX])
        -- self:petShow()
        self.modelShow:petShow()
    else
        --GamePrint("active ==false")
       self.modelShow:SetActive(active,self.modelShow.commonFlyPet)
	   self.modelShow:SetActive(active,self.modelShow.commonAidPet)
	   self.modelShow:SetActive(active,self.modelShow.character)
    end
    
    self.resourceView:SetActive(active)
  
    if   self.CurretView == "RankView" then
       self.rankView:SetActive(active)
    elseif self.CurretView == "itemsView" then
        self.itemsView:SetActive(active)
    end
end


-- 设置打开这个界面的场景
function UIEndlessScene:SetSceneTarget(sceneParent)
	self.sceneParent = sceneParent
end
