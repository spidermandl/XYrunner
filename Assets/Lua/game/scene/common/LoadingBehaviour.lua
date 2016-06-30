--[[
author:Desmond
切换场景 loading view
]]
LoadingBehaviour = class(BaseBehaviour)

LoadingBehaviour.scene = nil --场景
LoadingBehaviour.uiRoot = nil --ui 跟节点

LoadingBehaviour.async = nil --加载进程
LoadingBehaviour.avatorPicIndex = 0 --序列帧序号
LoadingBehaviour.timeAggregate = 0 --时间累积

function LoadingBehaviour:Awake()
--[[
	self.uiRoot = find("UI Root")
    --local uiloading = newobject(Util.LoadPrefab("UI/loading/LoadingView"))
 
    -- uiloading.gameObject.transform.parent = self.uiRoot.transform
    -- uiloading.transform.localPosition = Vector3.zero
    -- uiloading.transform.localScale = Vector3.one

	self.LoadingPanel=self.gameObject.transform:Find("LoadingPanel")
	local RightDown=self.LoadingPanel:Find("RightDown")
	self.Person = getUIComponent(self.LoadingPanel,"Center/Slider/Thumb/Person","UISprite")
	self.slider = getUIComponent(self.LoadingPanel,"Center/Slider","UISlider")
	self.TipsLab = getUIComponent(self.LoadingPanel,"Center/Tips/Label","UILabel")
	self.Thumb = getUIGameObject(self.LoadingPanel,"Center/Slider/Thumb/EffectObj")


	local tableTXT = TxtFactory:getTable(TxtFactory.TipsTXT) 
	local id = math.random(1,tableTXT:GetLineNum() )
	self.TipsLab.text = tableTXT:GetData(id,"CONTENT")
	--创建特效
	local effect = newobject(Util.LoadPrefab("Effects/UI/ef_ui_loading"))
	effect.gameObject.transform.parent = self.Thumb.transform
	effect.gameObject.transform.localPosition = Vector3.zero
	effect.gameObject.transform.localScale = Vector3.one
	SetEffectOrderInLayer(effect,100)
]]--
end

function LoadingBehaviour:Update()
	--self:loadingAnim()
    
    if self.async == nil then
    	coroutine.start(self.loadScene,self)
    	return
	end
    
	if self.async.progress>0.89 then
		self.async.allowSceneActivation = true
	end
end

function LoadingBehaviour:loadingAnim()
	local timeFrame = 0.04
    self.timeAggregate = self.timeAggregate + UnityEngine.Time.time
	if  self.timeAggregate > timeFrame then
		self.timeAggregate = 0
		--print ("----------------function LoadingBehaviour:loadingAnim() "..tostring(self.avatorPicIndex))
		self.Person.spriteName = tostring(self.avatorPicIndex)
		self.avatorPicIndex = self.avatorPicIndex + 1
		self.avatorPicIndex = self.avatorPicIndex - math.floor(self.avatorPicIndex/12)*12
	end

end

--开始loading协程
function LoadingBehaviour:loadScene()
	self.async = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(SceneConfig.nextScene)
	self.async.allowSceneActivation = false
	
end
