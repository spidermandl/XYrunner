--[[
小熊赠送礼物状态
作者：huqiuxiang
]]
LittleBearGivingState = class (BasePetState) 

LittleBearGivingState._name = "LittleBearGivingState"
LittleBearGivingState.duringTime = 2.5
LittleBearGivingState.startTime = nil

function LittleBearGivingState:Enter(role)
    self.animator = role.character:GetComponent("Animator")
    self.animator:Play("attack")
    self.player = LuaShell.getRole(LuaShell.DesmondID)

    self.startTime = UnityEngine.Time.time
end

function LittleBearGivingState:Excute(role,dTime)
    if UnityEngine.Time.time - self.startTime > self.duringTime then
         self.animator:Play("idle")
    end
end

function LittleBearGivingState:Exit(role)
	-- self.super.Exit(self,role)
end

-- function AliThrowingBottlesState:ThrowingBottles( ... )
-- 	local args={...}
-- 	self.character  =
--         newobject(Util.LoadPrefab("Items/"..tostring(args[2])))
--         self.character:SetActive(false)
--         local item = self.character:AddComponent(BundleLua.GetClassType())
--         self.character.name=args[3]
--         item.luaName =ar[4]
--         self.character.transform.parent=args[1].gameObject.transform
--         -- self.character.transform.rotation=Vector3(0,0,0)
--         self.character.transform.localPosition=self.StartPosition
--         self.character:SetActive(true)
-- end