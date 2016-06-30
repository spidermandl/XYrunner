

--[[
	sunkai
]]
LevelBagInfoView = class()
LevelBagInfoView.panel = nil
LevelBagInfoView.scene = nil 

function LevelBagInfoView:init(targetScene)
	self.scene = targetScene
	self.uiRoot = targetScene.uiRoot
	
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/Chapter/LevelBagInfoView"))
    	self.panel.gameObject.transform.parent = self.uiRoot.gameObject.transform
    	self.panel.gameObject.transform.localPosition = Vector3.zero
    	self.panel.gameObject.transform.localScale = Vector3.one
	end
	self.Icon = getUIComponent(self.panel,"UI/title/MaterialInfo/info/Background/icon","UISprite")
	self.nameLab = getUIComponent(self.panel,"UI/title/MaterialInfo/info/MaterialPopupUI_nameLabel","UILabel")
	self.descLab = getUIComponent(self.panel,"UI/title/MaterialInfo/info/MaterialPopupUI_type","UILabel")
	self.fromLab = getUIComponent(self.panel,"UI/title/MaterialInfo/typeLab/Label","UILabel")
	self.fromObj = getUIGameObject(self.panel,"UI/title/MaterialInfo/typeLab")
	self.GetBtn = getUIGameObject(self.panel,"UI/title/MaterialPopupUI1_get")
	self.CompositeMaterialBtn = getUIGameObject(self.panel,"UI/title/MaterialPopupUI1_composite")
	self.CompositeMaterialBtnCenter = getUIGameObject(self.panel,"UI/title/MaterialPopupUI1_composite 1")
	self.scene:boundButtonEvents( self.panel)
	self:SetShowView(false)
	
end

function LevelBagInfoView:SetData(itemid)
	print("LevelBagInfoView  item id : "..itemid)
	local materialTXT = TxtFactory:getTable(TxtFactory.MaterialTXT)
 	local iconData = materialTXT:GetData(itemid,"MATERIAL_ICON")
 	self.Icon.spriteName = iconData
	self.nameLab.text = materialTXT:GetData(itemid,"NAME")
	self.descLab.text = materialTXT:GetData(itemid,"MATERIALDESC")
	self.GetBtn.gameObject:SetActive(true)
	self.fromObj.gameObject:SetActive(true)
	local from = materialTXT:GetData(itemid,"COME_FROM")
	self.from = from
	if from == "" then
		self:SetNoFromObjActive(false)
	else
		self:SetNoFromObjActive(true)
		local levelid = materialTXT:GetData(itemid,"COME_FROM")
		local ChapterTxt  = TxtFactory:getTable(TxtFactory.ChapterTXT)
		local desc = ChapterTxt:GetData(levelid,"Name")
		self.fromLab.text = desc
		
	end
end

function LevelBagInfoView:SetNoFromObjActive(active)
	self.GetBtn.gameObject:SetActive(active)
		self.fromObj.gameObject:SetActive(active)
		self.CompositeMaterialBtnCenter.gameObject:SetActive(not active)
		self.CompositeMaterialBtn.gameObject:SetActive(active)
end

--得到材料点击事件
function LevelBagInfoView:GetMaterialClick(btn)
	print("GetMaterial : "..btn.name)
	
	 local info =TxtFactory:getMemDataCacheTable(TxtFactory.ChapterInfo)   
	  if self.from ~="" then
	  	local levelID =  tonumber(self.from)
	  	if info.chapter_info[levelID]  then
		  	self:SetShowView(false)
			self.scene.LevelBagView:SetShowView(false)
			info.selected_battle_id = levelID
			print("levelid: "..levelID)
			self.scene.LevelSelectView:SetShowView(false)
			self.scene.LevelStartView:SetLevelInfo(levelID)
			self.scene.LevelStartView:SetShowView(true)
			self.scene:SetIsDelayModelClick()
		else
			warn("该关尚未解锁！")
				self.scene:promptWordShow("该关尚未解锁！")
        	return
		end
		
	 else
	 	
	 end
end

--合成材料点击事件
function LevelBagInfoView:CompositeMaterial(btn)
	print("CompositeMaterial : "..btn.name)
	self.scene:promptWordShow("暂未开放")
end

function LevelBagInfoView:SetShowView(active)
	self.panel.gameObject:SetActive(active)
end


