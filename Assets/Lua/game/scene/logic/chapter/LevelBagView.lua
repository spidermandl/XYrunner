
--[[
	关卡背包
	sunkai
]]
require "game/scene/logic/chapter/ItemForBag"

LevelBagView = class()
LevelBagView.panel = nil
LevelBagView.scene = nil 

function LevelBagView:init(targetScene)
	self.scene = targetScene
	self.uiRoot = targetScene.uiRoot
	
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/Chapter/LevelBagView"))
    	self.panel.gameObject.transform.parent = self.uiRoot.gameObject.transform
    	self.panel.gameObject.transform.localPosition = Vector3.zero
    	self.panel.gameObject.transform.localScale = Vector3.one

	end
	self.ItemforBagGrid = getUIGameObject(self.panel,"UI/items/grid")
	self.ItemObjList = {}
	self.scene:boundButtonEvents( self.panel)
	self:SetShowView(false)
	
end

function LevelBagView:SetData()
	local BagItemsInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo)
	local itemList = BagItemsInfo.bin_items
	local index = 1
	self.ItemDataList = {}
    for i = 1 ,#itemList do 
        local item = ItemForBag.new()
		local itemObj
		if self.ItemObjList[index] == nil then
			itemObj = newobject(Util.LoadPrefab("UI/Chapter/ItemForBag"))
			self.ItemObjList[index] = itemObj
		end
		
        item:init(self.scene, self.ItemObjList[index] ,self.ItemforBagGrid)
       
		local tid = tonumber(itemList[i].tid)
        item:SetData(tid,itemList[i].num)
		
        self.ItemDataList[tid] = item
		index = index + 1
    end
    
    	--多了的就删掉
	for i = index,#self.ItemObjList do
		GameObject.Destroy(self.ItemObjList[i])
	end
     
    self.ItemforBagGrid:GetComponent("UIGrid"):Reposition()
	self.ItemforBagGrid:GetComponent("UIGrid").repositionNow = true
end

function LevelBagView:ItemClick(btn)
	print("btn name : "..btn.name)
	local str= string.split(btn.name,"_")
	self.scene.LevelBagInfoView:SetData(str[2])
	self.scene.LevelBagInfoView:SetShowView(true)
end

function LevelBagView:SetShowView(active)
	self.panel.gameObject:SetActive(active)
	if active then
		self:SetData()
	end
end


