--[[
狮子耳套装状态
作者：秦仕超
]]
LionEarSuitState = class (BasePlayerState) 

LionEarSuitState._name = "LionEarSuitState"
LionEarSuitState.previousState=nil 				------------------当前状态
function LionEarSuitState:Enter(role)
	self.super.Enter(self,role)
	self.previousState = role.stateMachine:getPreState()
	local Lion=GameObject.New()
    Lion:SetActive(false)
    local item = Lion:AddComponent(BundleLua.GetClassType())
    local petName=role.property.PetFlightName
    item.luaName="SoulPet"
    Lion:SetActive(true)
    print("LionEarSuitState")
    Lion.transform.position = role.gameObject.transform.position
    Lion.transform.parent = role.gameObject.transform.parent
    Lion.gameObject.transform.localScale =Vector3(1,1,1)
end

function LionEarSuitState:Excute(role,dTime)
	-- self.super.Excute(self,role,dTime)
	-- local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	-- --print ("-------------------------------->>>>>>>>>> function AttackState:Excute(role,dTime) "..tostring(animInfo.normalizedTime))
	-- if animInfo.normalizedTime >= 1.0 then --动画结束
		-- print (self.previousState._name)
		-- print (tostring(_G[self.previousState._name]))
		local flag = self:isOnGround(role)
		if self.previousState._name == "RunState"  and flag == true then
			role.stateMachine:changeState(_G[self.previousState._name].new())
		elseif self.previousState._name == "DoubleDropState" or self.previousState._name == "DoubleJumpState" then
			role.stateMachine:changeState(DoubleDropState.new())
		else
			role.stateMachine:changeState(DropState.new())
		end

	-- 	return
	-- end

 --    if self.isDroping ==false then
 --    	role.gameObject.transform:Translate(role.property.moveDir.x*dTime,0,0, Space.World)
	-- else
	-- 	self.super.BaseDrop(self,role,dTime)
	-- end
end

function LionEarSuitState:Exit(role)
	self.super.Exit(self,role)
end
