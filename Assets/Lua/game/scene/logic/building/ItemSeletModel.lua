
--[[
    --背包
	author : sunkai
]]
ItemSeletModel = class()

function ItemSeletModel:init(scene,ItemObj,parent)

    self.ItemObj = ItemObj
    self.ItemObj.gameObject:SetActive(true)
    self.parent = parent
    self.scene = scene
    self.ItemObj.gameObject.transform.parent = parent.gameObject.transform
    self.ItemObj.gameObject.transform.localPosition = Vector3.zero
    self.ItemObj.gameObject.transform.localScale = Vector3.one
	self.Icon = getUIComponent(self.ItemObj.gameObject,"Texture","UITexture")
    self.ModelSprite = getUIComponent(self.ItemObj.gameObject,"Texture/Sprite","UISprite") 
    self.scene:boundButtonEvents( self.ItemObj)
end

function ItemSeletModel:SetData(data,index)
    self.ItemObj.name = "ItemSeletModel_"..index
    self.Icon.mainTexture = Util.LoadPrefabByPath("BigPic/",data.icon)
    self.ModelSprite.spriteName = data.modelSprite
end
