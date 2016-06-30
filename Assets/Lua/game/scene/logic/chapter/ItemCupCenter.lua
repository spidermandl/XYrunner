
--[[
    --奖杯item
	author : sunkai
]]
ItemCupCenter = class()

function ItemCupCenter:init(scene,ItemObj,parent)

    self.ItemObj = ItemObj
    self.ItemObj.gameObject:SetActive(true)
    self.parent = parent
    self.scene = scene
    self.ItemObj.gameObject.transform.parent = parent.gameObject.transform
    self.ItemObj.gameObject.transform.localPosition = Vector3.zero
    self.ItemObj.gameObject.transform.localScale = Vector3.one
    
	-- self.Icon = getUIComponent(self.ItemObj.gameObject,"icon","UISprite")
    -- self.bg = getUIComponent(self.ItemObj.gameObject,"Background","UISprite")
    self.cupNumLab = getUIComponent(self.ItemObj.gameObject,"normal/cupValue","UILabel")
    self.cupNumObj = getUIGameObject(self.ItemObj.gameObject,"normal/cupValue")
    --正常没有领取的
    self.normal = getUIGameObject(self.ItemObj.gameObject,"normal")
    
    --可以领取的
    self.canGetLab = getUIComponent(self.ItemObj.gameObject,"normal/canGet","UILabel")
    self.canGetObj = getUIGameObject(self.ItemObj.gameObject,"normal/canGet")
    
    self.canGetObj.gameObject:SetActive(false)
    --已经领取的显示
    self.get = getUIGameObject(self.ItemObj.gameObject,"get")
    self.get.gameObject:SetActive(false)
    --是否已经领取
    self.itemReward = false
    
    --是否可以领取
    self.itemCanReward = false
    
    self.chapterTable =TxtFactory:getMemDataCacheTable(TxtFactory.ChapterInfo)
    self.scene:boundButtonEvents(self.ItemObj)
	
end

function ItemCupCenter:SetData(tableIndex,cupsCount)
    self.ItemObj.gameObject.name = "ItemCupCenter_"..tableIndex
    local myStoryCupTXT = TxtFactory:getTable(TxtFactory.StoryCupTXT)
    local type = myStoryCupTXT:GetData(tableIndex,"PROP_TYPOE")
    local tableId= myStoryCupTXT:GetData(tableIndex,"ID")
    local  open_Count = myStoryCupTXT:GetData(tableIndex,"OPEN_COUNT")
    self.cupNumLab.text = open_Count
    local count = myStoryCupTXT:GetData(tableIndex,"PROP_COUNT")
        
     local id  =  myStoryCupTXT:GetData(tableIndex,"PROP_ID")
    -- print("id : "..id)
     
    --可以领取的情况
    local localItemCanReward = false
    
    if cupsCount>=tonumber(open_Count) then
        localItemCanReward = true
        self.canGetObj.gameObject:SetActive(true)
        self.cupNumObj.gameObject:SetActive(false)
    end
  if self.rewardItemObj==nil then
         self.rewarditem = ItemLevelReward.new()
        self.rewardItemObj = newobject(Util.LoadPrefab("UI/Chapter/ItemLevelReward"))
    end
    
    self.rewarditem:init(self.scene, self.rewardItemObj , self.ItemObj)
    self.rewarditem:SetData(tonumber(id),tonumber(type))
    self.rewarditem:SetCount(count)
    self.rewarditem:SetBg(true)
    
    --如果已经领取
    if self:GetReward(tableId) then
         self.normal.gameObject:SetActive(false) 
         self.rewarditem:SetCount(false)
         self.get.gameObject:SetActive(true)
         self.itemReward = true
    end
    self.itemCanReward = not self.itemReward and localItemCanReward

end

--是否已经领取了
function ItemCupCenter:GetReward(id)
    local ret = false
    local list = self.chapterTable[TxtFactory.CUPS_REWARD]
    for i = 1,#list do
        if tonumber(id) == list[i] then
            ret = true
        end
    end
    return ret
end
