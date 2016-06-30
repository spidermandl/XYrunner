
--[[
    --奖池item
	author : sunkai
]]
ItemLevelReward = class()

function ItemLevelReward:init(scene,ItemObj,parent)
    self.ItemObj = ItemObj
    self.ItemObj.gameObject:SetActive(true)
    self.parent = parent
    self.scene = scene
    
    if parent~=nil then
        self.ItemObj.gameObject.transform.parent = parent.gameObject.transform
        self.ItemObj.gameObject.transform.localPosition = Vector3.zero
        self.ItemObj.gameObject.transform.localScale = Vector3.one
    end
    self.iconTab = {}
    for i = 1,4 do 
	   self.iconTab[i] = getUIGameObject(self.ItemObj.gameObject,"icon"..i)
    end
    self.bg = getUIGameObject(self.ItemObj.gameObject,"bg")
    self.num = getUIGameObject(self.ItemObj.gameObject,"num")
     self.otherNum = getUIGameObject(self.ItemObj.gameObject,"num2")
    self.scene:boundButtonEvents(self.ItemObj)
	self:SetBg(false)
    self:SetCount(false)
    self:SetOtherCount(false)
end


function ItemLevelReward:SetData(id,type)
    self.ItemObj.gameObject.name = "ItemLevelReward_"..id
    self.id  = tonumber(id)
    self.type = tonumber(type)
    print ("id : "..id)
    --1=材料配置 2=装备配置 3=宠物配置
    if  self.type == 1 then
        local txt  = TxtFactory:getTable(TxtFactory.MaterialTXT)
           self:SetIconSprite(self.type,txt:GetData(id,"MATERIAL_ICON"))
        print(txt:GetData(id,"MATERIAL_ICON"))
     
    elseif  self.type == 2 then
        local txt  = TxtFactory:getTable(TxtFactory.EquipTXT)
      self:SetIconSprite(self.type, txt:GetData(tonumber(id),"EQUIPMENT_ICON"))
           print(txt:GetData(id,"EQUIPMENT_ICON"))
    elseif  self.type == 3 then
      
        local txt  = TxtFactory:getTable(TxtFactory.MountTypeTXT)
        local _txt  = TxtFactory:getTable(TxtFactory.MountTXT)
        local tableID = _txt:GetData(id,TxtFactory.S_MOUNT_TYPE)
        print(tableID)
        self:SetIconSprite(self.type,txt:GetData(tableID,"PET_ICON_LIST")) 
        print(txt:GetData(tableID,"PET_ICON"))
     --金币
    elseif self.type == 4 then
          self:SetIconSprite(4,"jinbi")
     --钻石   
    elseif self.type == 5 then
           self:SetIconSprite(4,"zuanshi")
    --经验
    elseif self.type == 6 then
         self:SetIconSprite(4,"exp")
    --体力     
    elseif self.type == 7 then
         self:SetIconSprite(4,"tili")
     --
     elseif self.type == 8 then
         self:SetIconSprite(4,"duobaobi")
    else
        error("ItemLevelReward not have type : "..type)
    end
end

function ItemLevelReward:SetBg(active)
      self.bg.gameObject:SetActive(active)
end

function ItemLevelReward:SetIconSprite(type,spriteName)
    for i= 1,4 do
        if i == type then
            self.iconTab[i].gameObject:SetActive(true)
            local sprite = getUIComponent( self.iconTab[type].gameObject,"UISprite")
            sprite.spriteName = spriteName
            --sprite:MakePixelPerfect()
        else
            self.iconTab[i].gameObject:SetActive(false)
        end
    end
end

function ItemLevelReward:SetOtherCount(count)
    if count == nil then
        self.otherNum.gameObject:SetActive(false)
        return
    end
    if count == false then
         self.otherNum.gameObject:SetActive(false)
    else
        self.otherNum.gameObject:SetActive(true)
        getUIComponent(self.otherNum.gameObject,"UILabel").text ="x"..count
    end
end

function ItemLevelReward:SetCount(count)
    if count == nil then
        self.num.gameObject:SetActive(false)
        return
    end
    if count == false then
         self.num.gameObject:SetActive(false)
    else
        self.num.gameObject:SetActive(true)
        getUIComponent(self.num.gameObject,"UILabel").text = count
    end
end





