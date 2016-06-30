--[[
阿狸扔瓶子状态
作者：Huqiuxiang
]]
AliThrowingBottlesState = class (BasePetState) 
AliThrowingBottlesState._name = "AliThrowingBottlesState"
AliThrowingBottlesState.distance = 0
AliThrowingBottlesState.player = nil  -- 主角
AliThrowingBottlesState.animator = nil 

function AliThrowingBottlesState:Enter(role)
    self.super.Enter(self,role)
    self.animator = role.character:GetComponent("Animator")
    self.animator:Play("idle")
    self.player = LuaShell.getRole(LuaShell.DesmondID)
end

AliThrowingBottlesState.animTime = 40
function AliThrowingBottlesState:Excute(role,dTime)
    self.super.throwItem(self,role,dTime)
end

function AliThrowingBottlesState:Exit(role)
	-- self.super.Exit(self,role)
end

--------生成药瓶
function AliThrowingBottlesState:bottleCreat(role)
    self.throwItemObj = newobject(Util.LoadPrefab("Items/StaminaBottle_item"))
    self.throwItemObj.transform.position = role.gameObject.transform.position
    self.throwItemObj.transform:Translate(0,1.5,0)
    self.throwItemObj.transform.rotation = Quaternion.Euler(0,90,0)

    self.effect = newobject(Util.LoadPrefab("Effects/Common/ef_pet_guangquan"))
    self.effect.transform.position = role.gameObject.transform.position
end

--------药瓶运动轨迹
function AliThrowingBottlesState:bottleMove(role,dTime)
   self.super.bottleMove(self,role,dTime)
end

function AliThrowingBottlesState:Upbase(role,dTime) --上升
   self.super.Upbase(self,role,dTime)
end

function AliThrowingBottlesState:Dropbase(role,dTime) --下落过程
   self.super.Dropbase(self,role,dTime)
end