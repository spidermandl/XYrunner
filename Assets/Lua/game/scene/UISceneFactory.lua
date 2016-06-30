--[[
author:hanli_xiong
用于主场景集成管理其他副UI
]]

UISceneFactory = class()

UISceneFactory.UIMain = nil -- 主场景
UISceneFactory.UIList = nil -- 副UI列表

function UISceneFactory:Init(main)
	self.UIMain = main
	self.UIList = {}
end

function UISceneFactory:Update()
	for k,v in pairs(self.UIList) do
		v:Update()
	end
end

function UISceneFactory:Add(key, value)
	self.UIList[key] = value
	value:Awake()
	value:Start()
	value:SetActive(false)
end

function UISceneFactory:Get(key)
	if self.UIList[key] == nil then
		--warn("UISceneFactory:Get(" .. key .. ") is nil")
		if key == SceneConfig.suitScene then
			self:Add(SceneConfig.suitScene, UISuitScene.new())
		elseif key == SceneConfig.equipScene then
			self:Add(SceneConfig.equipScene, UIEquipScene.new())
		elseif key == SceneConfig.petScene then
			self:Add(SceneConfig.petScene, UIPetScene.new())
		elseif key == SceneConfig.mountScene then
			self:Add(SceneConfig.mountScene, UIMountScene.new())
		elseif key == SceneConfig.snathScene then
			self:Add(SceneConfig.snathScene, UISnatchScene.new())
		elseif key == SceneConfig.endlessScene then
			self:Add(SceneConfig.endlessScene,UIEndlessScene.new())
		elseif key == SceneConfig.storyScene then
			self:Add(SceneConfig.storyScene,ChapterScene.new())
		elseif key == SceneConfig.selectChapterScene then
			self:Add(SceneConfig.selectChapterScene,ChildLevelScene.new())
		end
	end
	return self.UIList[key]
end