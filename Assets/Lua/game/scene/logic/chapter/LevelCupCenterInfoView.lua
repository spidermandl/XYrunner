

--[[
    奖杯中心界面
	sunkai
]]
LevelCupCenterInfoView = class()
LevelCupCenterInfoView.panel = nil
LevelCupCenterInfoView.scene = nil 

function LevelCupCenterInfoView:init(targetScene)
	self.scene = targetScene
	self.uiRoot = targetScene.uiRoot
	
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/Chapter/LevelCupCenterInfoView"))
    	self.panel.gameObject.transform.parent = self.uiRoot.gameObject.transform
    	self.panel.gameObject.transform.localPosition = Vector3.zero
    	self.panel.gameObject.transform.localScale = Vector3.one
	end
	self.txtTab =  TxtFactory:getTable(TxtFactory.StoryCupTXT)

    self.iconParent = getUIGameObject(self.panel,"UI/title/MaterialInfo/info/iconParent")
	self.nameLab = getUIComponent(self.panel,"UI/title/MaterialInfo/info/MaterialPopupUI_nameLabel","UILabel")
	self.descLab = getUIComponent(self.panel,"UI/title/MaterialInfo/info/MaterialPopupUI_type","UILabel")
	self.GetBtn = getUIGameObject(self.panel,"UI/title/LevelCupCenterInfoView_get")
	self.shortBtn = getUIGameObject(self.panel,"UI/title/LevelCupCenterInfoView_bugou")
	self.shortBtn.gameObject:SetActive(false)
	self.scene:boundButtonEvents(self.panel)
	self:SetShowView(false)
	
end

function LevelCupCenterInfoView:ShowRewardView()
    local item = newobject(self.itemObj)
    local itemObjs = {}
    itemObjs[1] = item
    self.scene:rewardItemsShow(itemObjs)
end

function LevelCupCenterInfoView:SetData(tableIndex,itemCanReward,item)
	print("LevelCupCenterInfoView  item id :"..tableIndex)
	local myStoryCupTXT = TxtFactory:getTable(TxtFactory.StoryCupTXT)
    local type = myStoryCupTXT:GetData(tonumber(tableIndex),"PROP_TYPOE")
    
    -- 物品是否可以领取
    if not itemCanReward then
        self.shortBtn.gameObject:SetActive(true)
        self.GetBtn.gameObject:SetActive(false)
    else
         self.shortBtn.gameObject:SetActive(false)
        self.GetBtn.gameObject:SetActive(true)
    end
    
    self.TableID = myStoryCupTXT:GetData(tonumber(tableIndex),"ID")

     local itemId  =  myStoryCupTXT:GetData(tonumber(tableIndex),"PROP_ID")
    local name = ""
     local desc= "" 
     self.type = tonumber(type)
     --1=材料配置 2=装备配置 3=宠物配置
    if  self.type == 1 then
         local txt  = TxtFactory:getTable(TxtFactory.MaterialTXT)
        name =  txt:GetData(itemId,"NAME")
        desc = txt:GetData(itemId,"MATERIALDESC")
        print(txt:GetData(itemId,"MATERIAL_ICON"))
        
    elseif  self.type == 2 then
        local txt  = TxtFactory:getTable(TxtFactory.EquipTXT)
        name =  txt:GetData(tonumber(itemId) - 100,"NAME")
        desc = txt:GetData(tonumber(itemId) - 100,"EQUIPMENTDESC")
        print(txt:GetData(itemId,"EQUIPMENT_ICON"))
    elseif  self.type == 3 then
        local _txt  = TxtFactory:getTable(TxtFactory.MountTXT)
        itemId = _txt:GetData(itemId, TxtFactory.S_MOUNT_TYPE)
         local txt  = TxtFactory:getTable(TxtFactory.MountTypeTXT)
        name =  txt:GetData(itemId,"NAME") 
        desc = txt:GetData(itemId,"PETDESC")
    else
        error("ItemLevelReward not have type : "..type)
    end
    if self.itemObj~= nil then
         GameObject.Destroy(self.itemObj)
          self.itemObj = nil
    end
    self.itemObj = newobject(item.rewardItemObj)
    self.itemObj.transform.parent = self.iconParent.transform
    self.itemObj.gameObject.transform.localPosition = Vector3.zero
    self.itemObj.gameObject.transform.localScale = Vector3.one
        
    self.nameLab.text = name
    self.descLab.text = desc
end

--得到材料点击事件
function LevelCupCenterInfoView:GetClick(btn)
	print("GetMaterial : "..btn.name)
     self.scene.levelManagement:sendGetCupMsg( self.TableID)
end

--不够点击事件
function LevelCupCenterInfoView:GetShortOfClick(btn)
	print("CompositeMaterial : "..btn.name)
    self.scene:promptWordShow("奖杯数量不足,快去收集奖杯吧")
end

function LevelCupCenterInfoView:SetShowView(active)
	self.panel.gameObject:SetActive(active)
end


