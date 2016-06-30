--[[
author: hanli_xiong
子关卡选择场景
]]
require "game/scene/logic/level/LevelManagement"
require "game/scene/logic/chapter/LevelStartView"
require "game/scene/logic/chapter/LevelSelectView"
require "game/scene/logic/chapter/LevelCupCenterView"
require "game/scene/logic/chapter/LevelBagView"
require "game/scene/logic/chapter/LevelBagInfoView"
require "game/scene/logic/chapter/LevelCupTaskView"
require "game/scene/logic/chapter/LevelCupCenterInfoView"

ChildLevelScene = class(BaseScene)


-- 场景物体
ChildLevelScene.levelItemPrefab = "Level/scenes_screen_xpot01"
ChildLevelScene.levelItemParent = nil -- 子关卡选项的父节点

ChildLevelScene.levelSceneObj = nil -- 解决后面的点击问题 将场景中3d物品放入到这个GameObject中
ChildLevelScene.levelItemFlag = "LevelItem"
ChildLevelScene.levelItemObjs = {}



-- 选关状态：选择中／准备开始
ChildLevelScene.curState = nil
ChildLevelScene.ChooseLevel = 1
ChildLevelScene.ShowLevelInfo = 2

-- 外部数据表
ChildLevelScene.localTxt = nil
ChildLevelScene.cacheTxt = nil

ChildLevelScene.uiDialogue = nil -- 管理对话
ChildLevelScene.curLevelId = 0  -- 当前选中的关卡Id

ChildLevelScene.sceneParent = nil -- 打开这个界面的场景
ChildLevelScene.sceneTargetCameraId = nil -- 父节点的摄像机值ID

ChildLevelScene.sceneState = nil  -- 界面状态

function ChildLevelScene:Awake()

	self.mainCamera = find("Camera"):GetComponent(UnityEngine.Camera.GetClassType())
	SetCameraParam(1008,self.mainCamera)
	
	self.localTxt = TxtFactory:getTable(TxtFactory.ChapterTXT)
	-- self.localTxt:PrintTxt()
	self.cacheTxt = TxtFactory:getMemDataCacheTable(TxtFactory.ChapterInfo)

	--self.uiRoot = newobject(Util.LoadPrefab("UI/battle/UI Root"))
	--self.uiRoot.name = 'UI Root'
	self.uiRoot = find("UI Root")
	self.sceneTarget = self:AddUIButtonCtrlOnObj(self.uiRoot,"UISelectChapterCtrl")
	
    local scenePrefabName = self.localTxt:GetData(self.cacheTxt[TxtFactory.SELECTED_CHAPTER_ID].."001","SCENE_BG")
	
	self.scenePrefab = newobject(Util.LoadPrefab("Level/"..scenePrefabName))
			
	--self.levelItemParent = find("sceneUI")
	-- 解决后面的点击问题 将场景中3d物品放入到这个GameObject中
	self.levelSceneObj = GameObject.New()
	 self.levelItemParent = GameObject.New()
	 self.scenePrefab.transform.parent = self.levelSceneObj.transform
	 self.levelItemParent.transform.parent = self.levelSceneObj.transform
	 
	 self.levelItemParent.transform.localPosition = UnityEngine.Vector3(-21,-5,0.33)
    self.levelItemParent.name = "levelItemParent"
	
	self.uiCamera = find("CameraUI"):GetComponent(UnityEngine.Camera.GetClassType())
	self.uictrl = UICtrlBase.new()
	self.uictrl:Awake()
	self.levelManagement = LevelManagement.new()
    self.levelManagement:Awake(self)

end

function ChildLevelScene:Start()
	self:InitUI()
   -- self:InitLevelItems()
	--self:ShowLevelEffect()
end

function ChildLevelScene:Update()
	if not(self.sceneState) then
		return
	end
    self:CheckClickItem()
end

-- 初始化所有UI
function ChildLevelScene:InitUI()
	--模型
	self.modelShow = ModelShow.new()
    self.modelShow:Init(self)

	-- 显示人物模型预览
    self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    self.modelShow:ChooseCharacter(self.UserInfo[TxtFactory.USER_SEX])
    --self:petShow()
	self.modelShow:petShow()
	
	--小关卡选择
	self.LevelSelectView = LevelSelectView.new()
	self.LevelSelectView:init(self)
	self.LevelSelectView:SetShowView(true)
	
	--开始剧情关卡
	self.LevelStartView = LevelStartView.new()
	self.LevelStartView:init(self)
	
	--奖杯中心
	self.LevelCupCenterView = LevelCupCenterView.new()
	self.LevelCupCenterView:init(self)
	
	--奖杯任务
	self.LevelCupTaskView = LevelCupTaskView.new()
	self.LevelCupTaskView:init(self)
	
	--背包材料
	self.LevelBagView = LevelBagView.new()
	self.LevelBagView:init(self)
	
	--材料信息界面
	self.LevelBagInfoView = LevelBagInfoView.new()
	self.LevelBagInfoView:init(self)
	
	--奖杯中心信息界面
	self.LevelCupCenterInfoView = LevelCupCenterInfoView.new()
	self.LevelCupCenterInfoView:init(self)
	
	
	
	--self.UIChild = UISceneFactory.new()
    --self.UIChild:Init()
	
	
	--[[
	  self.RetrunDelegate = function (self) 
		if self.curState == self.ChooseLevel then
			self:ChangScene(SceneConfig.buildingScene)
   		elseif self.curState == self.ShowLevelInfo then
			self:EnableLevelItmes(true)
			self.curState = self.ChooseLevel
			self:ShowLevelEffect()
   	 	end
    end
	]]--

	
	self.curState = self.ChooseLevel
	if TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_IS_RESTART) then
		self:RestartStoryLevel()
		TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_IS_RESTART,false)
	end
	
	
end

-- 返回事件
function ChildLevelScene:LevelSceneBackBtnOnClick()
    --GamePrint("aaaaaaaaaaaaaaaaaaaaa")
   -- self.sceneParent:SetIsBuildScene(true)
	
	if self.curState == self.ChooseLevel then
		--self:ChangScene(SceneConfig.buildingScene)
		self:SetActive(false)
		self.sceneParent:SetActive(true)
    	SetCameraParam(self.sceneTargetCameraId,self.mainCamera)
   	elseif self.curState == self.ShowLevelInfo then
		self:EnableLevelItmes(true)
		self.curState = self.ChooseLevel
		self:ShowLevelEffect()
   	end
    
end

function ChildLevelScene:ShowLevelEffect()

	
	self.effect = newobject(Util.LoadPrefab("Effects/Scenes/ef_scenes_xpot01"))
	self.effect.gameObject.transform.parent = self.levelItemParent.gameObject.transform

	self.effect.gameObject:SetActive(false)

	local battleID = tonumber(self.cacheTxt[TxtFactory.SELECTED_BATTLE_ID])
	local CurchapterID =tonumber( self.cacheTxt[TxtFactory.SELECTED_CHAPTER_ID])
	if battleID ~=nil and battleID >1000 then
		local txt = TxtFactory:getTable(TxtFactory.ChapterTXT)
		local chapterID = txt:GetData(battleID,TxtFactory.S_CHAPTER_TYPE)
		if  chapterID == CurchapterID then
			
			local indx = self.tableIndex[battleID]
			local obj = self.levelItemObjs[indx]
			self.effect.gameObject.transform.parent = obj.gameObject.transform
			self.effect.transform.localPosition =Vector3.zero
			self.effect.gameObject.transform.localRotation =  Quaternion.Euler(0,0,0)
			self.effect.gameObject:SetActive(true)
		end	
	end
end



-- 通过子UI的名字返回子UI的lua对象
function ChildLevelScene:GetUIChild(name)
    return self.UIChild:Get(name)
end
--套装按钮
function ChildLevelScene:UIBuilding_SuitBtn()
    -- UpgradeType.Upgrade = UpgradeType.suit
    -- self:ChangScene(SceneConfig.suitScene)
	self:SetActive(false )
    self:GetUIChild(SceneConfig.suitScene):SetActive(true)
	self:GetUIChild(SceneConfig.suitScene):SetOpenViewClass(self)
end

--萌宠按钮
function ChildLevelScene:UIBuilding_PetBtn()
    -- self:ChangScene(SceneConfig.petScene)
	self:SetActive(false )
    self:GetUIChild(SceneConfig.petScene):SetActive(true)
	self:GetUIChild(SceneConfig.petScene):SetOpenViewClass(self)
end

--装备按钮
function ChildLevelScene:UIBuilding_EquipBtn()
    -- self:ChangScene(SceneConfig.equipScene)
	self:SetActive(false )
    self:GetUIChild(SceneConfig.equipScene):SetActive(true)
	self:GetUIChild(SceneConfig.equipScene):SetOpenViewClass(self)
end

--坐骑按钮
function ChildLevelScene:UIBuilding_MountBtn()
    -- self:ChangScene(SceneConfig.mountScene)
	local word = "该功能暂未开放,敬请期待!!!"
    self:promptWordShow(word)
    
    return
	
	--self:SetActive(false )
    --self:GetUIChild(SceneConfig.mountScene):SetActive(true)
end

function ChildLevelScene:SetActive(active )
	-- 场景关闭
	self.sceneState = active
	if active then
        SetCameraParam(1008,self.mainCamera)
		-- 初始化关卡数据
		self:InitLevelItems()
		self:ShowLevelEffect()
    end
	--self.scenePrefab:SetActive(active)
	--self.levelItemParent:SetActive(active)
	self.levelSceneObj:SetActive(active)
	if self.curState == self.ChooseLevel then
		self.LevelSelectView:SetShowView(active)
	elseif self.curState ==  self.ShowLevelInfo then
		self.LevelStartView:SetShowView(active)
	end
end

--[[ 
function ChildLevelScene:petShow()
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
--]]
-- 清除以前的关卡
function ChildLevelScene:ClearLevelItems()


	if self.effect ~= nil then
		GameObject.Destroy(self.effect)
	end
	self.effect = nil
	
	if self.levelItemObjs ~= nil then
		--printf("count=="..#self.storeItems)
		for i = 1 , #self.levelItemObjs do
			if self.levelItemObjs[i] ~= nil then
				GameObject.Destroy(self.levelItemObjs[i])
			end
		end
	end
	
	self.levelItemObjs = {}
end

-- 初始化所有的子关卡选项
function ChildLevelScene:InitLevelItems()
	-- 清除关卡
	self:ClearLevelItems()
	--用于保存索引值
	self.tableIndex = {} 
	local chapterID = self.cacheTxt[TxtFactory.SELECTED_CHAPTER_ID]
    for i = 1, self.localTxt:GetChildLevelNum(chapterID) do
    	local levelId = chapterID * 1000 + i
		if self.cacheTxt.chapter_info[levelId] == true then
			 self.levelItemObjs[i] = newobject(Util.LoadPrefab("Level/scenes_screen_xpot01"))
			 local starNum = 0 
			 if self.cacheTxt.chapter_star[levelId] ~= nil then
			 	starNum = self.cacheTxt.chapter_star[levelId]
			 end
			local itemObj =  self.levelItemObjs[i]
			 for i = 1,3 do 
			 	local starParent = getUIGameObject(itemObj,"pos"..i)
				 local starObj 
			 	if i <= starNum then
					starObj = newobject(Util.LoadPrefab("Level/scenes_screen_xpotstar01"))
				else
					starObj = newobject(Util.LoadPrefab("Level/scenes_screen_xpotstar01a"))	 
				end
				starObj.transform.parent = starParent.transform
				starObj.transform.localPosition = Vector3.zero
				starObj.transform.localRotation =  Quaternion.Euler(0,0,0)
			end
		else
			self.levelItemObjs[i] = newobject(Util.LoadPrefab("Level/scenes_screen_xpot01a"))
		end
 
    	self.levelItemObjs[i].name = self.levelItemFlag .. " " .. levelId
    	self.levelItemObjs[i].transform.parent = self.levelItemParent.transform
    	self.levelItemObjs[i].transform.localPosition = self.localTxt:GetLevelPos(levelId)
		self.levelItemObjs[i].transform.localRotation =self.localTxt:GetLevelRotation(levelId)
    	self.levelItemObjs[i].transform.localScale = Vector3.one
    	local collider = self.levelItemObjs[i]:GetComponent(UnityEngine.BoxCollider.GetClassType())
    	collider.isTrigger = true
    	-- 初始化关卡小节得星数量
		self.tableIndex[levelId] = i
    	if not self.cacheTxt.chapter_info[tonumber(levelId)] then -- 如果改章节没有解锁
	        self:LightStars(self.levelItemObjs[i].transform, 0)
    	end
    end
end

-- 点选子关卡事件检测
function ChildLevelScene:CheckClickItem()
	
	-- if Input.GetMouseButtonUp(0) then
	-- 		self.effect.gameObject:SetActive(false)
	-- end
	
	if self:GetIsDelayModelClick() then
		return
	end
	
    if self:uiSelected(self.uiCamera) then
		return
	end
	
	-- --特效
	-- if Input.GetMouseButtonDown(0) then
	-- 	local ray = UnityEngine.Camera.main:ScreenPointToRay(Input.mousePosition)
	-- 	local flag,hitinfo = UnityEngine.Physics.Raycast (ray, nil, 500)
	-- 	if flag == false then
	-- 		return
	-- 	elseif string.find(hitinfo.collider.gameObject.name, self.levelItemFlag) then
	-- 		self:OnClickDown(hitinfo.collider.gameObject)
	-- 	end
	-- end


    if Input.GetMouseButtonDown(0) then
		--return
		self:OnClickLevelItem()
    end

   
	
    
end

 -- 射线查询(点击小关卡)
function ChildLevelScene:OnClickLevelItem()
	local ray = self.mainCamera:ScreenPointToRay(Input.mousePosition)
	local flag,hitinfo = UnityEngine.Physics.Raycast (ray, nil, 500)
	if flag == false then
		return
	elseif string.find(hitinfo.collider.gameObject.name, self.levelItemFlag) then
		self:OnClickLevel(hitinfo.collider.gameObject)
	end
end

-- function ChildLevelScene:OnClickDown(obj)
-- 	if obj == nil then
-- 		return
-- 	end
-- 	local strTable = lua_string_split(obj.name, ' ')
-- 	if #strTable < 2 then
-- 		return
-- 	end
	
-- 	local levelId = strTable[2]
-- 	if not self.cacheTxt.chapter_info[tonumber(levelId)] then -- 如果改章节没有解锁
--         return
--     end
	
-- 	self.effect.gameObject.transform.parent = obj.gameObject.transform
--  	self.effect.transform.localPosition =Vector3.zero
-- 	self.effect.gameObject.transform.localRotation =  Quaternion.Euler(0,0,0)
-- 	self.effect.gameObject:SetActive(true)
-- end

-- 点击子关卡事件处理
function ChildLevelScene:OnClickLevel(obj)
	if obj == nil then
		return
	end
	local strTable = lua_string_split(obj.name, ' ')
	if #strTable < 2 then
		return
	end
	self.curLevelId = strTable[2]
	--local levelId = strTable[2]
	if not self.cacheTxt.chapter_info[tonumber(self.curLevelId)] then -- 如果改章节没有解锁
        warn("该关尚未解锁！")
		self:promptWordShow("该关尚未解锁！")
        return
    end
	
	--  TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,2)
    -- 	self:ChangScene(SceneConfig.endlessScene)
	--  if true then
	--  return
	--  end
	
	-- 弹出剧情
	self:TextStartJuQing()
	
	--[[   
	self.effect.gameObject:SetActive(false)
		
	self:EnableLevelItmes(false)
	self:SelectChildLevel(levelId)
	self.curState = self.ShowLevelInfo
	]]--
	-- SceneConfig.nextScene = SceneConfig.runningScene
	-- local uiloading = newobject(Util.LoadPrefab("UI/uiloading"))
end

function ChildLevelScene:RestartStoryLevel()
	self.LevelSelectView:SetShowView(false)
	self.LevelStartView:SetShowView(true)	
	print("RestartStoryLevel")
	self.LevelStartView:SetLevelInfo(self.cacheTxt.selected_battle_id)
end

-- 选择子关卡
function ChildLevelScene:SelectChildLevel(levelId)
	print("关卡小节---" .. levelId)
    TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,1)
    local ScenesId = self.localTxt:GetData(levelId,"ScenesId")
    -- local levelName = self.localTxt:GetData(levelId,"Name")
    self.cacheTxt.selected_battle_id = levelId
  
	TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_STORY,ScenesId)
    self.LevelStartView:SetLevelInfo(levelId)
end


function ChildLevelScene:StartRunning()
	  SceneConfig.nextScene = "level_story"
	self:ChangScene(SceneConfig.nextScene)
end

function ChildLevelScene:TopPanel_Back()
	
end

-- 显示／隐藏所有子关卡选项及相关UI
function ChildLevelScene:EnableLevelItmes(enable)
    for i = 1, self.levelItemParent.transform.childCount do
    	self.levelItemParent.transform:GetChild(i - 1).gameObject:SetActive(enable)
    end
    self.LevelSelectView:SetShowView(enable)
    self.LevelStartView:SetShowView(not enable)
end

function ChildLevelScene:SetModelShow(active)
	if active then
		-- 刷新
		self.modelShow:ChooseCharacter(self.UserInfo[TxtFactory.USER_SEX])
    	--self:petShow()
		self.modelShow:petShow()
	else
		self.modelShow:SetActive(active,self.modelShow.commonFlyPet)
		self.modelShow:SetActive(active,self.modelShow.commonAidPet)
		self.modelShow:SetActive(active,self.modelShow.character)
	end
	
end

-- 点亮关卡星星(子关卡item, 点亮数量)
function ChildLevelScene:LightStars(trans, num)
	for i = 1, trans.childCount do
		if i > num then
			--trans:GetChild(i - 1).gameObject:SetActive(false)
		else
			--trans:GetChild(i - 1).gameObject:SetActive(true)
		end
	end
end

-- 显示剧情
function ChildLevelScene:TextStartJuQing()
	--GamePrint("levelId ==="..levelId)
	local str = self.localTxt:GetData(self.curLevelId,"DIALOG")
	local tab = string.split(str, ",")
	
	--GamePrint("===="..tab[1])
	
	-- 已经打过或者没有剧情
	if  self.cacheTxt.chapter_star[tonumber(self.curLevelId)] ~= nil or tonumber(tab[1]) == -1 then
		self:dialogIsOver()
		return
	end
	--self:DialogueUIPanelShow(tab,self)
	-- 通过城建场景打开
	GetCurrentSceneUI():DialogueUIPanelShow(tab,self)
end

-- 恢复速度
function ChildLevelScene:dialogIsOver()
	
	self.effect.gameObject:SetActive(false)
		
	self:EnableLevelItmes(false)
	self:SelectChildLevel(self.curLevelId)
	self.curState = self.ShowLevelInfo
end

-- 对话框下一页 按钮
function ChildLevelScene:uiDialogue_nextBtn()
	self.uiDialogue:btnOnClick()
end

-- 创建对话框面板
function ChildLevelScene:DialogueUIPanelShow(tab,item)
    self.uiDialogue = UIDialogue.new()
    self.uiDialogue.infoTab = tab
    self.uiDialogue:init(self.uiRoot.gameObject,tab,item)
end

-- 设置打开这个界面的场景
function ChildLevelScene:SetSceneTarget(sceneParent)
	self.curState = self.ChooseLevel
	self.sceneParent = sceneParent
	self.UIChild = sceneParent.UIChild
end

-- 设置摄像机的值
function ChildLevelScene:SetSceneTargetCameraId(sceneTargetCameraId)
	self.sceneTargetCameraId = sceneTargetCameraId
end

