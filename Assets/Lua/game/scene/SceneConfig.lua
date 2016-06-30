--[[
    场景跳转设置
	author:Desmond
]]

SceneConfig = {
	
	nextScene = "ui_login",--下一个跳转scene
	loginScene = "ui_login",--登录scene
    buildingScene = "ui_building",--城建scene
	storyScene = "chapter_scene",--"Level_1_1",  --选关卡scene
	selectChapterScene = "SelectChapter_scene", -- 选小关场景
	runningScene = "Level_1_1",
	suitScene = "ui_suit",
	equipScene = "Equip_scene",
	petScene = "Pet_scene",
	mountScene = "ui_mount",
	endlessScene = "ui_endless",
	levelStory = "level_story",
	taskScene = "ui_task",
	guideSceneA = "Level_T_1",
	guideSceneB = "Level_T_2",
	snathScene = "ui_snatch", -- 夺宝奇兵场景
	transationScene="transation_scene",
	testScene = "test",
	
}

if RoleProperty.corePlayOnly == true then
	SceneConfig.nextScene = SceneConfig.testScene
end

PreLoad = {}
PreLoad[SceneConfig.loginScene] = {
		"Prefabs/".."UI/login/BeginLoginUI",
		"Prefabs/".."UI/login/LogInUI",
		"Prefabs/".."UI/login/ServerlistUI",
		"BigRes/login_scene",
	}

require "game/scene/SceneConst"
require "game/scene/BaseScene"
require "game/scene/BaseView"
require "game/scene/UITransitionManager"
require "game/scene/ChapterScene"
require "game/scene/UIbuildingScene"
require "game/scene/UISuitScene"  
require "game/scene/UILogInScene" 
require "game/scene/UIEquipScene"
require "game/scene/ChildLevelScene"
require "game/scene/UIPetScene"
require "game/scene/BattleScene"
require "game/scene/UIMountScene"
require "game/scene/UIEndlessScene"
require "game/scene/UIDialogue"
require "game/scene/common/ModelShow"
require "game/scene/common/PromptWordShowView"
require "game/scene/common/ConsultBoxView"
require "game/scene/common/ItemTips"
require "game/scene/common/ExtractUIAnim"
require "game/scene/common/PlayerLevelUpView"
require "game/scene/common/LoadingBehaviour"
require "game/scene/logic/guide/GuideUIShow"
require "game/scene/TestScene"
require "game/scene/TransationScene"
require "game/scene/common/RewardItemsShow"
require "game/scene/UISnatchScene"
require "game/scene/logic/PreLoad"
require "game/scene/common/ItemGetPath"
require "game/scene/AssetCheckScene"
require "game/scene/common/ErrorMessageView"
require "game/scene/common/GotoStoreView"

