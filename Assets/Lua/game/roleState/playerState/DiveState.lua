--[[
角色滑翔状态
author:Desmond
]]
DiveState = class(BasePlayerState)

DiveState._name = "DiveState"
DiveState.follower = nil


function DiveState:Enter(role)	
    self.super.Enter(self,role)
	if self.animator~=nil then
    	--self.animator:Play("single drop descend")
    	self.super.playAnimation(self,role,"single drop descend")
	end
	role.property.moveDir.y=role.property.diveSpeed --初始向量速度
	role.property.jumpACC = 0
    role.property.dropACC = 0

    self:setFollower(role)
end

function DiveState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)

    self.super.BaseDrop(self,role,dTime)

end

function DiveState:Exit(role)
	role.property.jumpACC = RoleProperty.jumpACC
    role.property.dropACC = RoleProperty.dropACC

    --print ("----------------------------------function DiveState:Exit(role) "..tostring(self.follower))
	if self.follower ~= nil then
		self.follower:playVanishExplode()
		--GameObject.Destroy(self.follower.gameObject)
	end
end

function DiveState:setFollower(role)
    local mount = role:getMountState()

    if mount == nil then
	elseif mount._name == "CNMMountState" then
	elseif mount._name == "UFOMountState" then --ufo 没有跟随
		return
	end

	self.follower = role:createPet(role:getPlyPetTypeID())
	self.follower:triggerFollowerSkill()
end