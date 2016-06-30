--[[
author:gaofei
说明界面（通用界面 只需要传入界面编号就可以）
]]

SnatchExplainView = class ()

SnatchExplainView.scene = nil --场景scene
SnatchExplainView.panel = nil -- 界面

-- 初始化
function SnatchExplainView:init(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Snatch/SnatchExplainView"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
	self.explainTabel = self.panel.transform:Find("Anchors/UI/Scroll View/Table")
	self.scene:boundButtonEvents(self.panel)
	--self:InitData()
	self:HiddenView()
   
end

-- 初始化数据
function SnatchExplainView:InitData(explainId)
	local titleCount = tonumber(explainId) % 1000
	local gameExplainTabel = TxtFactory:getTable("GameExplainConfigTXT")
	for i = 1 , titleCount do
		local tileTxt =gameExplainTabel:GetData(explainId,"TITLE_"..i)
		local contentTxt =  gameExplainTabel:GetData(explainId,"CONTENT_"..i)
		local obj  = newobject(Util.LoadPrefab("UI/Snatch/ExplainItem"))
		obj.transform:Find("Title"):GetComponent("UILabel").text =tileTxt
		obj.transform:Find("Desc"):GetComponent("UILabel").text =string.gsub(contentTxt, '/n/', "\n")
		obj.transform.parent = self.explainTabel.transform
		obj.transform.localPosition = Vector3.zero
    	obj.transform.localScale = Vector3.one
	end
	
	local itemTable = self.explainTabel:GetComponent("UITable")
	itemTable:Reposition()
	itemTable.repositionNow = true
end

--激活暂停界面
function SnatchExplainView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function SnatchExplainView:HiddenView()
	self.panel:SetActive(false)
end