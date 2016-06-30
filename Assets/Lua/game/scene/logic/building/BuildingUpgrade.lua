--[[
author:Desmond
建筑升级界面
]]

BuildingUpgrade = class()

BuildingUpgrade.scene = nil -- 依附的场景对象
BuildingUpgrade.modelShow = nil --modelShow
BuildingUpgrade.generateSpeedInfo =nil --生产速度信息
BuildingUpgrade.capacityInfo = nil --容量信息
BuildingUpgrade.building = nil --建筑
BuildingUpgrade.name = nil --名字
BuildingUpgrade.nowLvl = nil --现在等级
BuildingUpgrade.nextLvl = nil --下一等级
BuildingUpgrade.label1 = nil --label1
BuildingUpgrade.label2 = nil --label2
BuildingUpgrade.label3 = nil --label3
BuildingUpgrade.consumeIcon = nil --消耗道具Icon
BuildingUpgrade.consumeQuantity = nil --消耗数量
BuildingUpgrade.btnLabel = nil --按钮文字

BuildingUpgrade.upgradeItems = nil --升级材料
BuildingUpgrade.isMax = nil -- 是否可以升级
BuildingUpgrade.buildingInstanceId = 0 --建筑实例Id
BuildingUpgrade.buildingId = nil    --建筑Id

-- 初始化UI
function BuildingUpgrade:Init(targetscene)
	self.scene = targetscene
    self.modelShow = targetscene.modelShow
	self.gameObject = self.scene:LoadUI("Building/buildLevelUp")
    self.gameObject.transform.localScale = UnityEngine.Vector3(0.8,0.8,0.8)
    
    self.upgradeItems = {}
    --print("--------------function BuildingUpgrade:Init(targetscene) "..tostring(self.gameObject.transform:FindChild("UI/title/material/grid/items1")))
    table.insert(self.upgradeItems,
    	self.gameObject.transform:FindChild("UI/title/material/grid/items1"))
	table.insert(self.upgradeItems,
		self.gameObject.transform:FindChild("UI/title/material/grid/items2"))
	table.insert(self.upgradeItems,
		self.gameObject.transform:FindChild("UI/title/material/grid/items3"))
    self.name = self.gameObject.transform:FindChild("UI/title/info/top/Label"):GetComponent("UILabel")
    self.nowLvl = self.gameObject.transform:FindChild("UI/title/info/top/lvLeft/Label"):GetComponent("UILabel")
    self.nextLvl = self.gameObject.transform:FindChild("UI/title/info/top/lvRight/Label"):GetComponent("UILabel")
    self.label1 = self.gameObject.transform:FindChild("UI/title/info/label1"):GetComponent("UILabel")
	self.label2 = self.gameObject.transform:FindChild("UI/title/info/label2"):GetComponent("UILabel")
	self.label3 = self.gameObject.transform:FindChild("UI/title/info/label3"):GetComponent("UILabel")
    self.consumeIcon = self.gameObject.transform:FindChild("UI/title/buildLevelUp_levelUp/priceIcon"):GetComponent("UISprite")
    self.consumeQuantity = self.gameObject.transform:FindChild("UI/title/buildLevelUp_levelUp/priceIcon/priceLabel"):GetComponent("UILabel")
    self.btnLabel = self.gameObject.transform:FindChild("UI/title/buildLevelUp_levelUp/Label"):GetComponent("UILabel")
    self:SetActive(false)
end

function BuildingUpgrade:SetActive(active)
	self.gameObject:SetActive(active)
    self.modelShow:SetActive(active)

end

--设置面板信息
--建筑id
function BuildingUpgrade:setInfo( building )
	self.building = building
    self.buildingId = building:getBuildingId()
    self.buildingInstanceId = building:getBuildingInstanceId()
    --print("该城建的实例ID为："..self.buildingInstanceId)
    local build_txt = TxtFactory:getTable(TxtFactory.BuildingTXT) --获取建筑表
	local material_txt = TxtFactory:getTable(TxtFactory.MaterialTXT) --获取材料表
	local bagInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo) --玩家材料表
	local lvl = build_txt:GetBulidLevelById(self.buildingId)
	local buildType = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_TYPENAME)  --小屋的类型
    self.isMax = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_MAX_LVL) --是否是最大等级
	local materialStr = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_METERIAL)
    local material_ids = nil
    if materialStr ~= "" then
        material_ids = lua_string_split(materialStr, ';')
    else
        --print(self.buildingId.."该城建没有升级材料")
    end
    if self.isMax == nil and material_ids ~= nil then
		for i=1,#material_ids do --设置升级材料  

			local strs = lua_string_split(material_ids[i],'=')
			--print (strs)
			local m_id = strs[1]
			--print (tostring(m_id))
			local num = strs[2]
	        --print ("-----------------function BuildingUpgrade:setInfo( building ) "..tostring(self.upgradeItems[i]))
	        self.upgradeItems[i].gameObject:SetActive(true)
            self.upgradeItems[i].gameObject.name = m_id
            local icon = self.upgradeItems[i]:FindChild("icon"):GetComponent("UISprite")
	        --print(tostring(m_id))
            local sname = material_txt:GetData(m_id,TxtFactory.S_MATERIAL_MATERIAL_ICON) --设置材料icon
	        icon.spriteName = sname
	        local currentLabel = self.upgradeItems[i]:FindChild("leftLabel"):GetComponent("UILabel")
	        currentLabel.text = '0'
			for i =1 , #bagInfo.bin_items do  --计算材料个数
				local id = bagInfo.bin_items[i].tid
				if tostring(id) == m_id then
					currentLabel.text = tostring(bagInfo.bin_items[i].num)
					break
				end
			end
			
			local requireLabel = self.upgradeItems[i]:FindChild("rightLabel"):GetComponent("UILabel")
			requireLabel.text = '/'..num
		end
    else
        for i = 1,#self.upgradeItems do
            self.upgradeItems[i].gameObject:SetActive(false)
        end
	end
    --设置3d模型
    self.modelShow:ChooseBuilding(self.buildingId)
    --设置升级信息
    self.name.text = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_NAME)
    self.nowLvl.text = lvl
    self.nextLvl.text = lvl+1
    local nowNum = nil
    local nextNum = nil
    if buildType == 1 then --娃娃机枢纽
    	if self.isMax == nil then
    		nowNum = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_PEN)
    		nextNum = build_txt:GetData(self.buildingId+1,TxtFactory.S_BUILDING_PEN)
    		self.label1.text = ""
    		self.label2.text = "[643000]结算得分加成： "..nowNum.."[-][e87173]  +"..nextNum.."[-]"
    		self.label3.text = ""
    	else
    		nowNum = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_PEN)
    		self.label1.text = ""
    		self.label2.text = "[643000]结算得分加成： "..nowNum.."[-][e87173]  +MAX[-]"
    		self.label3.text = ""
    	end
    elseif buildType == 2 then  --游戏币小屋
    	if self.isMax == nil then
    		nowNum = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_SPEED)
    		nextNum = build_txt:GetData(self.buildingId+1,TxtFactory.S_BUILDING_SPEED)
    		self.label1.text = "[643000]产出速度： ".."每分钟 "..nowNum.."[-][e87173]  +"..nextNum.."[-]"
    		nownum = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_MAXGOLD)
    		nextNum = build_txt:GetData(self.buildingId+1,TxtFactory.S_BUILDING_MAXGOLD)
    		self.label2.text = "[643000]生产上限： "..nownum.."[-][e87173]  +"..nextNum.."[-]"
    		self.label3.text = ""
    	else
    		nowNum = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_SPEED)
    		self.label1.text = "[643000]产出速度： ".."每分钟 "..nowNum.."[-][e87173]  +MAX[-]"
    		nownum = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_MAXGOLD)
    		self.label2.text = "[643000]生产上限： "..nownum.."[-][e87173]  +MAX[-]"
    		self.label3.text = ""
    	end
    elseif buildType == 3 then  --仓库 
    	if self.isMax == nil then
    		nowNum = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_CAPACITY)
    		nextNum = build_txt:GetData(self.buildingId+1,TxtFactory.S_BUILDING_CAPACITY)
			self.label1.text = ""
			self.label2.text = "[643000]仓库容量： "..nowNum.."[-][e87173]  +"..nextNum.."[-]"
    		self.label3.text = ""
    	else
    		nowNum = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_CAPACITY)
			self.label1.text = ""
			self.label2.text = "[643000]仓库容量： "..nowNum.."[-][e87173]  +MAX[-]"
    		self.label3.text = ""
    	end

    elseif buildType == 5 then --萌宠小屋
    	if self.isMax == nil then
   			nowNum = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_CAPACITY)
    		nextNum = build_txt:GetData(self.buildingId+1,TxtFactory.S_BUILDING_CAPACITY)
			self.label1.text = ""
			self.label2.text = "[643000]人口上限： "..nowNum.."[-][e87173]  +"..nextNum.."[-]"
    		self.label3.text = ""
    	else
    		nowNum = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_CAPACITY)
			self.label1.text = ""
			self.label2.text = "[643000]人口上限： "..nowNum.."[-][e87173]  +MAX[-]"
    		self.label3.text = ""
    	end
    else
    	self.label1.text = ""
		self.label2.text = ""
    	self.label3.text = ""
	end
    if self.isMax == nil then
        self.btnLabel.text = "升级"
        local gold = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_UPGOLD)
        local zuan = build_txt:GetData(self.buildingId,TxtFactory.S_BUILDING_UPDIAMONDS)
        if gold~="" then
            self.consumeIcon.spriteName = "jinbi"
            self.consumeQuantity.text = gold
        else
            self.consumeIcon.spriteName = "zuanshi"
            self.consumeQuantity.text = zuan
        end
    else
        self.btnLabel.text = "LvlMax"
        self.consumeIcon.spriteName = ""
        self.consumeQuantity.text = ""
    end
	
end

--检测升级
function BuildingUpgrade:checkUpgrade()
	return self.building:checkUpgrade(),self.model
end