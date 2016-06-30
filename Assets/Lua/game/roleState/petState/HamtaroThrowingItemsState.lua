--[[
哈姆太郎扔东西状态 HamtaroThrowingItemsState
作者：Huqiuxiang
]]
HamtaroThrowingItemsState = class (BasePetState) 
HamtaroThrowingItemsState._name = "HamtaroThrowingItemsState"
HamtaroThrowingItemsState.distance = 0
HamtaroThrowingItemsState.player = nil  -- 主角
HamtaroThrowingItemsState.animator = nil 

function HamtaroThrowingItemsState:Enter(role)
    self.super.Enter(self,role)
    self.animator = role.character:GetComponent("Animator")
    self.animator:Play("idle")
    self.player = LuaShell.getRole(LuaShell.DesmondID)
end

HamtaroThrowingItemsState.animTime = 40
function HamtaroThrowingItemsState:Excute(role,dTime)
    self.super.throwItem(self,role,dTime)
end

function HamtaroThrowingItemsState:Exit(role)
	-- self.super.Exit(self,role)
end

function HamtaroThrowingItemsState:bottleCreat(role)
    local itemName = nil
    local nub = math.random(1,3) 
    if nub == 1 then
        itemName = "ChangeBigBottle_item"
    elseif nub == 2 then
        itemName = "magnet_item"
    elseif nub == 3 then
        itemName = "InvincibleItem_item"
    end


    self.throwItemObj = newobject(Util.LoadPrefab("Items/"..itemName))
    self.throwItemObj.transform.position = role.gameObject.transform.position
    self.throwItemObj.transform:Translate(0,1.5,0)
    self.throwItemObj.transform.rotation = Quaternion.Euler(0,90,0)

    self.effect = newobject(Util.LoadPrefab("Effects/Common/ef_pet_guangquan"))
    self.effect.transform.position = role.gameObject.transform.position
end

function HamtaroThrowingItemsState:bottleMove(role,dTime)
   self.super.bottleMove(self,role,dTime)
end

function HamtaroThrowingItemsState:Upbase(role,dTime) --上升
   self.super.Upbase(self,role,dTime)
end

function HamtaroThrowingItemsState:Dropbase(role,dTime) --下落过程
   self.super.Dropbase(self,role,dTime)
end