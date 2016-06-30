--[[
author:huqiuxiang
新手引导城建
]]

GuideBuildingScene = class()
GuideBuildingScene.scene = nil -- 城建scene
GuideBuildingScene.stepScene = nil -- 进度
GuideBuildingScene.effect = nil -- 引导手指
GuideBuildingScene.GudieRunningSceneTXT = nil 
GuideBuildingScene.GudieUISceneTXT = nil
GuideBuildingScene.management = nil 
GuideBuildingScene.curGuideBtn = nil -- 当前引导按钮
GuideBuildingScene.btnProgress = nil -- 按钮引导步骤

function GuideBuildingScene:init(targetscene)
	self.scene = targetscene
	self.GudieUISceneTXT = TxtFactory:getTable(TxtFactory.GudieUISceneTXT) 
    local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	self.stepScene = user[TxtFactory.USER_GUIDE] -- 获取进度

	self.btnProgress = 0 -- 按钮引导步骤
	self.management = GuideManagement.new()
	self.management:init(self)
 	TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,1)
 	if RoleProperty.isNaviceOpen == false then
		self.stepScene = 5
		self.management:setValue(TxtFactory.AccountInfo,TxtFactory.ACCOUNT_GUIDE,5)
	end

	self:stepCheck() -- 进度执行
end

-- 提示表现
function GuideBuildingScene:effectShow(btnName)
	local Btn = find(btnName)
	-- 生成跳动手指
	if self.effect ~= nil then
		destroy(self.effect.gameObject)
	end
	-- print("btnName"..btnName)
	self.effect = newobject(Util.LoadPrefab("UI/guide/shouzhi"))
    self.effect.gameObject.transform.parent = Btn.gameObject.transform
    self.effect.gameObject.transform.localPosition = Vector3(0,100,0)
    self.effect.gameObject.transform.localScale = Vector3.one
end

function GuideBuildingScene:stepCheck()
	if self.stepScene == 0 then -- 进度1
		self:stepOne()
	elseif self.stepScene == 1 then -- 进度2
		self:stepTwo()
	elseif self.stepScene == 2 then -- 进度2
		--self:stepThree()
		self:stepFour()
	elseif self.stepScene == 3 then -- 进度2
		--self:stepFour()
	end

end

--
function GuideBuildingScene:getCurBtn(Btn)
	local flag = true
	if self.curGuideBtn == nil then
		flag = true
		return flag
	end

	if Btn.name ~= self.curGuideBtn then
		flag = false
		return flag
	else
		flag = true
		return flag
	end
end

-- 对话结束返回
function GuideBuildingScene:dialogIsOver()
	-- print("对话结束")
	self.stepScene = self.stepScene + 1
	self.management:sendGuideProgress(self.stepScene) -- 保存进度
	self:stepCheck()
end

-- 新手引导一(剧情对话)
function GuideBuildingScene:stepOne()
	local tab = {} 
    local idTab = self.GudieUISceneTXT:GetData(3001,"CONTENT_ID") -- 对话id
    local idTabd = string.gsub(idTab,'"',"")
    local array = lua_string_split(tostring(idTabd),",")
	self.scene:DialogueUIPanelShow(array,self)
end

-- 新手引导二（跑酷场景一）
function GuideBuildingScene:stepTwo()
	-- print("按钮强制")
	-- 读配置表 获取按钮
	local btn = self.GudieUISceneTXT:GetData(4001,"BUTTON") -- 执行的按钮 名字
	self:effectShow(btn)
	self.curGuideBtn = btn
end

-- 新手引导三（新手任务）
function GuideBuildingScene:stepThree()
	-- print("任务引导")
	self.btnProgress = self.btnProgress + 1
	local btnTab = self.GudieUISceneTXT:GetData(5002,"BUTTON")  -- 执行的按钮 名字
	local idTabd = string.gsub(btnTab,'"',"")
    local array = lua_string_split(tostring(idTabd),",")
    if self.btnProgress > #array then
    	self.stepScene = self.stepScene + 1
    	self.management:sendGuideProgress(self.stepScene)
    	self:stepCheck()
    	return
    end
    -- if self.curGuideBtn == "TaskInfoUI_stateBtn" then -- 发送 完成任务后保存
    -- 		-- 发送新手引导进度请求
    -- 		self.management:sendGuideProgress(self.stepScene + 1)
    -- 		print("进度"..self.stepScene + 1)
    -- end

    -- print("self.btnProgress "..self.btnProgress.."btn"..array[self.btnProgress])
	self:effectShow(array[self.btnProgress])
	self.curGuideBtn = array[self.btnProgress]
	-- print("当前按钮"..self.curGuideBtn)
end

-- 新手引导四（跑酷场景二）
function GuideBuildingScene:stepFour()
	local btn = self.GudieUISceneTXT:GetData(4001,"BUTTON")-- 执行的按钮 名字
	self:effectShow(btn)
	self.curGuideBtn = btn
end