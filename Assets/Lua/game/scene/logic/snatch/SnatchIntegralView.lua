--[[
author:gaofei
夺宝奇兵积分奖励界面
]]

SnatchIntegralView = class ()

SnatchIntegralView.scene = nil --场景scene
SnatchIntegralView.panel = nil -- 界面

-- 初始化
function SnatchIntegralView:init(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Snatch/SnatchIntegralView"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
	self.grid = self.panel.transform:Find("Anchors/UI/Scroll View/Grid")
	self.integralNum = self.panel.transform:Find("Anchors/UI/IntegralNum"):GetComponent("UILabel")
	
   
end

-- 初始化数据
function SnatchIntegralView:InitData()
	-- 设置积分 
	
	self.integralNum.text = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_SCORE)
	local snatchIntegraltabel = TxtFactory:getTable("SnatchIntegralConfigTXT") -- 商城表
	local   materialTabel = TxtFactory:getTable("MaterialTXT")  -- 材料表
	for i = 1 ,snatchIntegraltabel:GetLineNum() do
		local obj  = newobject(Util.LoadPrefab("UI/Snatch/TemplateSnatchIntegralItem"))
		obj.transform.parent = self.grid.transform
		obj.transform.localPosition = Vector3.zero
    	obj.transform.localScale = Vector3.one
		-- 设置分数
		obj.transform:Find("Score"):GetComponent("UILabel").text = snatchIntegraltabel:GetData(i,"INTEGRAL_LV")
		
		-- 设置奖励
		local rewardParentObj = obj.transform:Find("Table")
		local rewards = lua_string_split(snatchIntegraltabel:GetData(i,"INTEGRAL_REWARD"),";")
		for j = 1,#rewards do
			local rewardObj  = newobject(Util.LoadPrefab("UI/Snatch/RewardItem"))
			local strs = lua_string_split(rewards[j],"=")
			rewardObj.transform:Find("Label"):GetComponent("UILabel").text = strs[2]
			--printf("id=="..strs[1])
			--printf("name==="..materialTabel:GetData(strs[1],"MATERIAL_ICON"))
			rewardObj.transform:Find("Icon"):GetComponent("UISprite").spriteName = materialTabel:GetData(strs[1],"MATERIAL_ICON")
		
			rewardObj.transform.parent = rewardParentObj.transform
			rewardObj.transform.localPosition = Vector3.zero
    		rewardObj.transform.localScale = Vector3.one
		end
		
		local itemTable = rewardParentObj:GetComponent("UITable")
		itemTable:Reposition()
		itemTable.repositionNow = true
	end
	
	local itemGrid = self.grid:GetComponent("UIGrid")
	itemGrid:Reposition()
	itemGrid.repositionNow = true
	self.scene:boundButtonEvents(self.panel)
end

--激活暂停界面
function SnatchIntegralView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function SnatchIntegralView:HiddenView()
	self.panel:SetActive(false)
end