--[[
author:Desmond
自动更新界面
]]
AssetCheckScene = class(BaseScene)

AssetCheckScene.progress = nil
AssetCheckScene.loadInfo = nil
AssetCheckScene.versionInfo = nil

AssetCheckScene.step = nil

function AssetCheckScene:Awake()
	--GamePrint("-----------------AssetCheckScene Awake--->>>-----------------")
    self:initUI()
end

function AssetCheckScene:initUI()
	local ui = find("LoadAssetsUI")
	self.progress=ui.transform:Find("Progress").gameObject
	self.loadInfo=ui.transform:Find("InfoLabel"):Find("Info"):GetComponent("UILabel")
	self.versionInfo=ui.transform:Find("version"):GetComponent("UILabel")
	
end

--启动事件--
function AssetCheckScene:Start()
	self.versionInfo.text = "version " .. tostring(Application.version)
end

function AssetCheckScene:Update()
	--GamePrint("---------------------function AssetCheckScene:Update() ")

	local aggreate, progress, msg = Util.getAssetsChecking()

	if string.find(msg,"error:") == 1 then --有错误
		GamePrint("--------------------- "..tostring(msg))
		return
	end

	self.loadInfo.text = msg
	if aggreate > 0 then
		BundleTools.setSlideProgress(self.progress,progress/aggreate)
		self.progress:SetActive(true)
	else
		self.progress:SetActive(false)
	end
end

--解析配置文件