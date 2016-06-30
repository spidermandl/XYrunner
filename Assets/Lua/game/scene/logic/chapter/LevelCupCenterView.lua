
--[[
	奖杯中心
	sunkai
]]
require "game/scene/logic/chapter/ItemCupCenter"
LevelCupCenterView = class()
LevelCupCenterView.panel = nil
LevelCupCenterView.scene = nil 

function LevelCupCenterView:init(targetScene)
	self.scene = targetScene
	self.uiRoot = targetScene.uiRoot
	
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/Chapter/LevelCupCenterView"))
    	self.panel.gameObject.transform.parent = self.uiRoot.gameObject.transform
    	self.panel.gameObject.transform.localPosition = Vector3.zero
    	self.panel.gameObject.transform.localScale = Vector3.one
	end
	self.chapterTable =TxtFactory:getMemDataCacheTable(TxtFactory.ChapterInfo)
	
	self.ItemCupCenterGrid = getUIGameObject(self.panel,"UI/items/grid")
	self.CupsCountLab= getUIComponent(self.panel,"UI/currentCupCount/cupValue","UILabel")
	self.ItemObjList = {}
	self.CupsCount = self:GetCupsCount()
	self.scene:boundButtonEvents(self.panel)
	self:SetShowView(false)
	self.ItemDataList = {}
end



function LevelCupCenterView:SetData()
	self.CupsCountLab.text = self.CupsCount
	
	self:InitItem()
end

function LevelCupCenterView:GetCupsCount()
	local count = 0
	local cupList = self.chapterTable.cupList 
	for key,value in pairs(cupList) do
    	if value~=nil then
			for i = 1,#value do
				if value[i]~= 0 then
					count = count + 1
				end		
			end
		end
    end
	return count
end

function LevelCupCenterView:InitItem()
		--物品
	local  txt=  TxtFactory:getTable(TxtFactory.StoryCupTXT)
	local itemList = txt.TxtLines
	local index = 1

    for i = 1 ,txt:GetLineNum() do 
	
		local itemObj
		if self.ItemObjList[index] == nil then
			self.ItemDataList[i] = ItemCupCenter.new()
			itemObj = newobject(Util.LoadPrefab("UI/Chapter/ItemCupCenter"))
			self.ItemObjList[index] = itemObj
		end
        self.ItemDataList[i]:init(self.scene, self.ItemObjList[index] ,self.ItemCupCenterGrid)
        self.ItemDataList[i]:SetData(i,self.CupsCount)
		index = index + 1
    end
    
    	--多了的就删掉
	for i = index,#self.ItemObjList do
		GameObject.Destroy(self.ItemObjList[i])
	end
     
    self.ItemCupCenterGrid:GetComponent("UIGrid"):Reposition()
	self.ItemCupCenterGrid:GetComponent("UIGrid").repositionNow = true
end

function LevelCupCenterView:ItemClick(btn)
	print("btn name : "..btn.name)
	local str= string.split(btn.name,"_")
	local index = tonumber(str[2])
	local itemData = self.ItemDataList[index]
	--如果已经领取的话就不用显示了
	if not itemData.itemReward then
		self.scene.LevelCupCenterInfoView:SetData(str[2],itemData.itemCanReward,itemData)
		self.scene.LevelCupCenterInfoView:SetShowView(true)
	end
end

function LevelCupCenterView:SetShowView(active)
	self.panel.gameObject:SetActive(active)
	if active then 
		self:SetData()
	end
end


