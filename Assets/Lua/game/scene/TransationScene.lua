--[[
author:Desmond
切换场景过渡scene
]]
TransationScene = class(BaseScene)

TransationScene.name = "TransationScene" --类名

TransationScene.uiRoot = nil --ui 跟节点

TransationScene.avatorPicIndex = 0 --序列帧序号
TransationScene.timeAggregate = 0 --时间累积
TransationScene.loadingProgress = nil --加载进度
TransationScene.loadingTime = 0 --loading加载总时间

function TransationScene:Awake()
	--print ("------------------------function TransationScene:Awake() ")
	-- if SceneConfig.nextScene ~= SceneConfig.buildingScene and SceneConfig.nextScene ~= SceneConfig.loginScene then
	-- 	return
	-- end
	self.uiRoot = find("UI Root")
	self.LoadingPanel= find("LoadingPanel")--self.gameObject.transform:Find("LoadingPanel")

	self.Person = getObjectComponent(self.LoadingPanel,"UISprite","Center/Slider/Thumb/Person")
	self.slider = getObjectComponent(self.LoadingPanel,"UISlider","Center/Slider")
	self.TipsLab = getObjectComponent(self.LoadingPanel,"UILabel","Center/Tips/Label")
	self.Thumb = getChildByPath(self.LoadingPanel,"Center/Slider/Thumb/EffectObj")
    -- LuaShell.addUserData(self.Person)
    -- LuaShell.addUserData(self.slider)
    -- LuaShell.addUserData(self.TipsLab)
    -- LuaShell.addUserData(self.Thumb)

	local tableTXT = TxtFactory:getTable(TxtFactory.TipsTXT)
	local id = math.random(1,tableTXT:GetLineNum())
	self.TipsLab.text = tableTXT:GetData(id,"CONTENT")

	--创建特效
	local effect = newobject(Util.LoadPrefab("Effects/UI/ef_ui_loading"))
	--local effect = GameObject.Instantiate(UnityEngine.Resources.Load("Prefabs/Effects/UI/ef_ui_loading"))
	effect.gameObject.transform.parent = self.Thumb.transform
	effect.gameObject.transform.localPosition = Vector3.zero
	--effect.gameObject.transform.position = self.Thumb.transform.position
	effect.gameObject.transform.localScale = Vector3.one

	SetEffectOrderInLayer(effect,100)
	--LuaShell.addUserData(effect)
	--releaseMemory()
end

function TransationScene:Start()
	-- local set = PreLoad[SceneConfig.nextScene]
	-- if set ~= nil then
	-- 	Util.PreLoad(set)
	-- end
    
	coroutine.start(self.loadScene,self)
end

--异步加载scene
function TransationScene:loadScene()
	local async = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(SceneConfig.nextScene)
	--local async = UnityEngine.Application.LoadLevelAsync("void")
	async.allowSceneActivation = false
	self.loadingProgress = async
end

function TransationScene:Update()
	--GamePrint ("----------------function TransationScene:Update() 1 "..tostring(TransationSceneAsync))
	-- if SceneConfig.nextScene ~= SceneConfig.buildingScene and SceneConfig.nextScene ~= SceneConfig.loginScene then
	-- 	return
	-- end

	self:loadingAnim()
    if self.loadingProgress == nil then
    	coroutine.start(self.loadScene,self)
     	return
	end

	if self.loadingTime < Util.getLoadingProgress() then
		self.loadingTime = self.loadingTime + UnityEngine.Time.deltaTime
	end
    
	self:SetSliderValue(self.loadingTime)


    if Util.getLoadingProgress() < 1 or self.loadingTime < 1 then --资源没有加载完
    	return
    end

    local progress = self.loadingProgress.progress
	if progress > 0.89 then
		self.loadingProgress.allowSceneActivation = true
	else
		if progress > 1 or self.loadingProgress.allowSceneActivation == true then
			progress = 1
			
		end
		
		self:SetSliderValue(progress)
	end
end

function TransationScene:loadingAnim()
	local timeFrame = 0.04
    self.timeAggregate = self.timeAggregate + UnityEngine.Time.deltaTime
	if  self.timeAggregate > timeFrame then
		self.timeAggregate = 0
		--print ("----------------function TransationScene:loadingAnim() "..tostring(self.avatorPicIndex))
		self.Person.spriteName = tostring(self.avatorPicIndex)
		self.avatorPicIndex = self.avatorPicIndex + 1
		self.avatorPicIndex = self.avatorPicIndex - math.floor(self.avatorPicIndex/12)*12
	end

end

-- 设置进度条的值
function TransationScene:SetSliderValue(value)
	if value >= self.slider.value then
		self.slider.value = value
	end
end


--销毁--
function TransationScene:OnDestroy()
    GamePrint("-----------------TransationScene:OnDestroy-->>>-----------------")
    -- destroy(self.Person)
    -- destroy(self.slider)
    -- destroy(self.TipsLab)
    -- destroy(self.Thumb)
    -- destroy(effect)
    --Util.UserdataGC()
    -- LuaShell.clear()
    -- releaseMemory()
end

