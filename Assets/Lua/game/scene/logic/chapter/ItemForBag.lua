
--[[
    --背包
	author : sunkai
]]
ItemForBag = class()

function ItemForBag:init(scene,ItemObj,parent)

    self.ItemObj = ItemObj
    self.ItemObj.gameObject:SetActive(true)
    self.parent = parent
    self.scene = scene
    self.ItemObj.gameObject.transform.parent = parent.gameObject.transform
    self.ItemObj.gameObject.transform.localPosition = Vector3.zero
    self.ItemObj.gameObject.transform.localScale = Vector3.one
	self.Icon = getUIComponent(self.ItemObj.gameObject,"icon","UISprite")
    self.bg = getUIComponent(self.ItemObj.gameObject,"Background","UISprite")
    self.NumLab = getUIComponent(self.ItemObj.gameObject,"count","UILabel")
    
    self.scene:boundButtonEvents( self.ItemObj)
	
end

function ItemForBag:SetData(tid,num)
    self.ItemObj.gameObject.name = "ItemForBag_"..tid
    local materialTXT = TxtFactory:getTable(TxtFactory.MaterialTXT)

 	local iconData = materialTXT:GetData(tid,"MATERIAL_ICON")
 	self.Icon.spriteName = iconData
     self.NumLab.text = num
end
