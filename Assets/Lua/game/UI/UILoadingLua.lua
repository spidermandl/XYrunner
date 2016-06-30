--[[UILoadingLua控制类]]

UILoadingLua = class(BaseBehaviour)

UILoadingLua.tag = "UILoadingLua"

UILoadingLua.LoadingPanel=nil		--控制Loading的显示面板
UILoadingLua.Person=nil				--人物对应的sprite
UILoadingLua.Text=nil				--loading字对应的父物体
UILoadingLua.Texts={}				--loading子物体列表
UILoadingLua.PersionIndex=0			--人物显示图片指针
UILoadingLua.TimeOld=0				--记录人物时间
UILoadingLua.TimeOld1=0				--记录loading时间
UILoadingLua.Lengths=0				--记录loading子物体长度
UILoadingLua.LoadingIndex=1			--loading指针
UILoadingLua.LoadingIndex2=1		--loading指针
UILoadingLua.IsShowLoading=false	--loading是否显示
UILoadingLua.SceneNameLabel = nil   --场景名字显示的label
--UILoadingLua.progressLabel = nil 
UILoadingLua.progressFront = nil 
UILoadingLua.scene = nil
IsStartLoading = false

function UILoadingLua:Awake()
	self.LoadingPanel=self.gameObject.transform:Find("LoadingPanel")
	local RightDown=self.LoadingPanel:Find("RightDown")
	self.Person = getUIComponent(self.LoadingPanel,"Center/Slider/Thumb/Person","UISprite")
	self.slider = getUIComponent(self.LoadingPanel,"Center/Slider","UISlider")
	self.TipsLab = getUIComponent(self.LoadingPanel,"Center/Tips/Label","UILabel")
	self.Thumb = getUIGameObject(self.LoadingPanel,"Center/Slider/Thumb/EffectObj")
end

function UILoadingLua:Start()
	IsStartLoading= false
	self.LoadingPanel.gameObject:SetActive(false)
	if UnityEngine.Application.loadedLevelName ~= nil then
		self:StartLoading()
		self:LoadNextScene(SceneConfig.nextScene)
	end
end

function UILoadingLua:LoadNextScene(scene)
	self.scene = scene
	PreLoad.Load(scene)
end

function UILoadingLua:StartLoading()
	self.LoadingPanel.gameObject:SetActive(true)
	self.TimeOld=UnityEngine.Time.time
	self.TimeOld1=UnityEngine.Time.time
	self.IsShowLoading=true
	
	local tableTXT = TxtFactory:getTable(TxtFactory.TipsTXT) 
	local id = math.random(1,tableTXT:GetLineNum() )
	self.TipsLab.text = tableTXT:GetData(id,"CONTENT")
	--创建特效
	local effect = newobject(Util.LoadPrefab("Effects/UI/ef_ui_loading"))
	effect.gameObject.transform.parent = self.Thumb.transform
	effect.gameObject.transform.localPosition = Vector3.zero
	effect.gameObject.transform.localScale = Vector3.one
	SetEffectOrderInLayer(effect,100)
end


function UILoadingLua:LongingDonghua()
	if self.IsShowLoading then
		if  UnityEngine.Time.time-self.TimeOld>0.04 then
			self.TimeOld=UnityEngine.Time.time
			self.Person.spriteName= tostring(self.PersionIndex)
			if self.PersionIndex<11 then
				self.PersionIndex=self.PersionIndex+1
			else
				self.PersionIndex=0
			end
		end

		if UnityEngine.Time.time-self.TimeOld1>1.5 then
			self.TimeOld1=UnityEngine.Time.time
		end

	end
end

local localPress = 0
function UILoadingLua:Update()
	self:LongingDonghua()
	if not IsStartLoading and Util.PreLoadProcess >= 1 then
		self:Create(StartRoutine,self.scene,self)
	elseif not IsStartLoading then
		self:SetLoadingPercentage(Util.PreLoadProcess/1.2)
		localPress = Util.PreLoadProcess/1.2
	end

	self:UIcoroutineUpdate()

	if(IsStartLoading ) then
		if UILoadingLuaasync.progress>0.89 then

			localPress = localPress+0.02
			self:SetLoadingPercentage(localPress)
			
			if(UnityEngine.Time.time- StartTime>=2) then
				UILoadingLuaasync.allowSceneActivation = true
				IsStartLoading  = false
				localPress = 0
			end	
			
		else
			localPress = localPress+0.02
			self:SetLoadingPercentage(localPress)
		end
	end
	
	-- print(UILoadingLuaasync.progress)
end

UILoadingLuaasync = nil 
UILoadingLua.displayProgress = 0 
StartTime = 0

function StartRoutine(scene,self)
	-- print (" ------------------------>>>>>>>>>>StartRoutine(scene) "..scene)
	StartTime = UnityEngine.Time.time
	-- Util.LoadScene(scene)
	-- PreLoad.Load(scene)
	local async = UnityEngine.Application.LoadLevelAsync(scene)
	async.allowSceneActivation = false
	UILoadingLuaasync = async
	IsStartLoading  = true
	coroutine.wait(2)
	
end

function UILoadingLua:SetLoadingPercentage(progress)

	if progress > 1 then
        self.slider.value = 1
         return
	end
    self.slider.value = progress

end

--------------------------------------------------------coroutine---------------------------------------------------------------------------------
UILoadingLua.co=nil
local ThisTime=0
local IsUpdate=false
-- local targetTime=0


function UILoadingLua:Create(fun ,...)
	self.co=coroutine.create(fun,...)
	if coroutine.running()==nil then
		local flag, msg = coroutine.resume(self.co,...)
		if not flag then
			error(msg)
		end
	end
end


--update中调用
function UILoadingLua:UIcoroutineUpdate()
	--print("------------------ function UILoadingLua:UIcoroutineUpdate() 1")
	if IsUpdate then
		if ThisTime-UnityEngine.Time.deltaTime>0 then
			--print("------------------ function UILoadingLua:UIcoroutineUpdate() 2")
			IsUpdate=false
			coroutine.resume(self.co)
		end
	end
end
