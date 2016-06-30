--[[
author:新手引导
新手引导城建
]]

GuidieuiViewNew = class()
GuidieuiViewNew.scene = nil -- 城建scene

GuidieuiViewNew.shouzhi = nil -- 引导手指
GuidieuiViewNew.GudieRunningSceneTXT = nil 
GuidieuiViewNew.GudieUISceneTXT = nil

local stepScene = nil -- 进度
GuidieuiViewNew.btnProgress = 0 -- 按钮引导步骤

GuidieuiViewNew.panel = nil

GuidieuiViewNew.btn = nil
GuidieuiViewNew.btnBox = nil
GuidieuiViewNew.mask = nil
GuidieuiViewNew.mask_uei = nil
GuidieuiViewNew.array = nil
GuidieuiViewNew.btnBoxSize = nil
GuidieuiViewNew.UICamera = nil
GuidieuiViewNew.mouseIsIn = false
GuidieuiViewNew.management = nil
GuidieuiViewNew.FightIsOverFun = nil --关卡结束回调

function GuidieuiViewNew:init(targetscene)

	if RoleProperty.isNaviceOpen == false then
		return
	end

	self.scene = targetscene
	if targetscene.UICamera == nil then
		self.UICamera = find("CameraUI"):GetComponent(UnityEngine.Camera.GetClassType())     --查找UI摄像头
	else
		self.UICamera = targetscene.UICamera
	end

	self.GudieUISceneTXT = TxtFactory:getTable(TxtFactory.GudieUISceneTXT) 
    local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    			--user[TxtFactory.USER_GUIDE] = 3
	stepScene = user[TxtFactory.USER_GUIDE] -- 获取进度
		--GamePrint("111111111111111"..stepScene)
	if stepScene < 1 then
		stepScene = 1
		user[TxtFactory.USER_GUIDE] = 1
	end
	local uiRoot = find("UI Root").transform
	self.panel = newobject(Util.LoadPrefab("UI/guide/GudiePanelUI")).transform
	self.panel.parent = uiRoot
	self.panel.localPosition = Vector3(0,0,0)
	self.panel.localScale = Vector3(1,1,1)
	self.panel.localRotation= UnityEngine.Quaternion.Euler(0,0,0)
	self.shouzhi = self.panel:FindChild("Shouzhi")

	self.mask = self.panel:FindChild("Mask")
	self.mask_uei = self.mask:GetComponent('UIEventListener')
	-- 服务器数据 模块
	self.management = GuideManagement.new()
	self.management:init(self)
 	TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,1)

	self:Dosteps() -- 进度执行
	--[[if RoleProperty.isTheplotOpen == true then
		
			else
				
			end]]
end
-- 剧情
function GuidieuiViewNew:TheplotOpenShow()
    
end

-- 对话结束回调
function GuidieuiViewNew:DialogueUIPanelShow(tab)
    self.scene:DialogueUIPanelShow(tab,self)
end

function GuidieuiViewNew:SetBtnCallFun(nextNum)
	-- body
	self.mask_uei.onClick = function()
		if self:CheckIsOnClick() then
			--GamePrint("onClick,onClick,onClick")
			if self.btn ~= nil then
				self.btn:SendMessage("OnClick",self.btn,1);
			end
			self.btn = nil 
			self:UpdataBtn(nextNum)
			
		end
	end
	self.mask_uei.onPress = function(go,bl)
		if bl == true then
			--GamePrint("onPress,onPress,onPress")
			--self:CheckIsOnClick()
		end
	end
end

function GuidieuiViewNew:Dosteps()
	-- body
	GamePrintTable("stepScene = "..stepScene);
	if stepScene > self.GudieUISceneTXT:GetLineNum() then
		--GamePrintTable("新手引导结束！！！！");
		GameObject.Destroy(self.panel.gameObject) -- 销毁指示ui
	end
	--  战斗关卡
	local LeveID = self.GudieUISceneTXT:GetData(stepScene,"LEVELID")
	if LeveID ~= nil and LeveID == "1" then
        --if stepScene == 2 then
        TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_STORY,'Level_T_1')        
        self.scene:ChangScene(SceneConfig.levelStory)
--[[        self.FightIsOverFun = function()
        	-- body
	       local MAINID = self.GudieUISceneTXT:GetData(stepScene,"MAINID")
			if MAINID ~= nil and MAINID ~= "" and MAINID ~= "0" then
			   MAINID = tonumber(MAINID)
			else
				MAINID = stepScene + 1
			end
			self.management:setValue(TxtFactory.AccountInfo,TxtFactory.ACCOUNT_GUIDE,tonumber(MAINID))
			self.management:sendGuideProgress(tonumber(MAINID)) -- 保存进度
		end]]
        return
	end

    local idTab = self.GudieUISceneTXT:GetData(stepScene,"CONTENT_ID") -- 对话id
    if idTab ~= nil and  string.len(idTab) ~= 0 then
    	-- 对话
    	if self.mask ~= nil then
    		self.mask.gameObject:SetActive(false)
    	end

    	if self.shouzhi ~= nil then
    		self.shouzhi.gameObject:SetActive(false)
    	end

		local idTabd = string.gsub(idTab,'"',"")
		local array = lua_string_split(tostring(idTabd),",")
    	local oldfun = self.dialogIsOver
		self.dialogIsOver = function()
			--GamePrint("self.dialogIsOver self.dialogIsOver")
			self.dialogIsOver = oldfun
			self:Finishsteps()
		end
		self:DialogueUIPanelShow(array)
		return
	end
	-- 按钮点击
	self:DoClickBtn(stepScene)
end



function GuidieuiViewNew:DoClickBtn(iid)
    -- 按钮
	self.mask.gameObject:SetActive(true)
	--self.mask_uei:CleadCallFun()

	local btnTab = self.GudieUISceneTXT:GetData(iid,"BUTTON")  -- 执行的按钮 名字
	if btnTab == nil then
		return
	end

	local idTabd = string.gsub(btnTab,'"',"")
	self.array = lua_string_split(tostring(idTabd),",")
	--GamePrintTable(self.array)
	self.btnProgress = 0
	self:UpdataBtn(1)
end


function GuidieuiViewNew:UpdataBtn(NextProgress,num)

	if num == nil then
		num = 0
	end
	if self.btnProgress >= NextProgress then
		return
	end

	if 	NextProgress > #self.array then
		self.btnProgress = NextProgress
		self:Finishsteps()
	else
		local nname = self.array[NextProgress]
		-- 替换掉空格
		nname= string.gsub(nname, "*", " ");
		if nname == nil then
			return
		end

		self.btn = find(nname)
		if self.btn == nil then
			local uiRoot = find("UI Root").transform
			local btntf = uiRoot:FindChild(nname)
			if btntf ~= nil then
				self.btn = btntf.gameObject
			end
		end

		if self.btn == nil then
			if num >= 2 then
				GameWarnPrint("找不到按钮 ＝"..nname)
				-- 延迟1秒再找
				coroutine.start(DelayFindClick,self,num+1,NextProgress)
				--self:UpdataBtn(NextProgress+1)
			else
				-- 延迟1秒再找
				coroutine.start(DelayFindClick,self,num+1,NextProgress)
			end
		else
			self.btnProgress = NextProgress
			self.btnBox = self.btn:GetComponent('BoxCollider')
			if self.btnBox == nil then
				GameWarnPrint("按钮错误 ＝"..nname)
				self:UpdataBtn(NextProgress+1)
				return
			end
			self:SetBtnCallFun(self.btnProgress+1)
			local halfSize = self.btnBox.size/2
			local pos1 = self.btn.transform:TransformPoint(self.btnBox.center - halfSize)
			local pos2 = self.btn.transform:TransformPoint(self.btnBox.center + halfSize)
			local btnPos = (pos1 + pos2)*0.5
			pos1 = self.UICamera:WorldToScreenPoint(pos1)
			pos2 = self.UICamera:WorldToScreenPoint(pos2)
			self.btnBoxSize = {pos1,pos2}
			self.shouzhi.gameObject:SetActive(true)
			self.shouzhi.position = btnPos --self.btn.transform.position
		end
	end
end

-- 延迟1秒再找
function DelayFindClick(self,num,NextProgress)
	--GameWarnPrint("延迟1秒再找 0="..nname)
    coroutine.wait(1)
    --GameWarnPrint("延迟1秒再找 1="..nname)
    if self ~= nil then
    	self:UpdataBtn(NextProgress,num)
	end
end

function GuidieuiViewNew:CheckIsOnClick()
	local p = nil
	if Input.touchCount > 0 then
		p = Input.GetTouch(0).position
		--GameWarnPrint("touch =="..p.x..","..p.y)
	else
		--GameWarnPrint("touch ==0")
		p = Input.mousePosition
	end
	
	--local pos1 = self.btnBoxSize[1]
	--local pos2 = self.btnBoxSize[2]
	--GameWarnPrint("pos1 = "..pos1.x..","..pos1.y)
	--GameWarnPrint("mousePosition =="..p.x..","..p.y..","..p.z)
	--GameWarnPrint("pos2 = "..pos2.x..","..pos2.y)
	if p.x >= self.btnBoxSize[1].x and p.x <= self.btnBoxSize[2].x and
	   p.y >= self.btnBoxSize[1].y and p.y <= self.btnBoxSize[2].y then
		return true
	else
		return false
	end
end

function GuidieuiViewNew:Finishsteps()

	local MAINID = self.GudieUISceneTXT:GetData(stepScene,"MAINID")
	--GamePrint("MAINID =="..MAINID);
	if MAINID ~= nil and MAINID ~= "" and tonumber(MAINID) > 0 then
		self.management:setValue(TxtFactory.AccountInfo,TxtFactory.ACCOUNT_GUIDE,tonumber(MAINID))
		self.management:sendGuideProgress(tonumber(MAINID)) -- 保存进度
	end
	stepScene = stepScene + 1
	local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	user[TxtFactory.USER_GUIDE] = stepScene-- 获取进度

	self:Dosteps()
end
