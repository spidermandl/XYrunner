
--[[
    --奖杯item
	author : sunkai
]]
ItemLevelCup = class()

function ItemLevelCup:init(scene,ItemObj,parent)

    self.ItemObj = ItemObj
    self.ItemObj.gameObject:SetActive(true)
    self.parent = parent
    self.scene = scene
    
    self.ItemObj.gameObject.transform.parent = parent.gameObject.transform
    self.ItemObj.gameObject.transform.localPosition = Vector3.zero
    self.ItemObj.gameObject.transform.localScale = Vector3.one
	self.Icon = getUIComponent(self.ItemObj.gameObject,"icon","UISprite")
    self.scene:boundButtonEvents(self.ItemObj)
	
end

function ItemLevelCup:SetData(index,taskId)
    self.ItemObj.gameObject.name = "ItemLevelCup_"..index

    self.taskId = taskId
end

function ItemLevelCup:Refresh(isActive,num,finishDel,index,currentNum)
     
      local spriteName = "xiaojiangbei2"
      if isActive then
             --新被领取的奖杯
             self.index = index
            if num ~=nil and self.index  > num   then
                self.scene.resultView.IsOpenCupAnimation = true
                 coroutine.start(CupAnimation,self, "xiaojiangbei",num,finishDel,currentNum)
            else
               -- print("xiaojiangbei ----------------------")
                spriteName =  "xiaojiangbei"
                  self.Icon.spriteName = spriteName
            end
            
     else
          self.Icon.spriteName = spriteName
     end
    
end

function CupAnimation(self,spriteName,num,finishDel,currentNum)
    --print("num : "..num)
    --print("currentNum : "..currentNum)
    coroutine.wait(self.index-num+1)
    self.Icon.spriteName = spriteName
    if currentNum == self.index then
        finishDel(self.scene)
        print("self.index :" ..self.index)
    end
end


