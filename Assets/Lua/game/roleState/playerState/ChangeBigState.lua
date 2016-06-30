--[[
变大状态
author:Huqiuxiang
]]
ChangeBigState = class(BasePlayerState)
ChangeBigState._name = "ChangeBigState"
ChangeBigState.startTime = nil
ChangeBigState.duringTime = 3 
ChangeBigState.effect = nil --技能特效

function ChangeBigState:Enter(role)
	self.startTime = UnityEngine.Time.time
	self.duringTime = self.duringTime + (self.duringTime * role.property.StateBonusTime) --本身持续时间 + 角色增益时间
	self.effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_TZ_qiaoba_bianda")--创建特效
    self.effect.transform.parent = role.gameObject.transform
    self.effect.transform.localPosition = UnityEngine.Vector3(0,0,0)
    role.gameObject.transform.localScale = UnityEngine.Vector3(RoleProperty.EnlargeScale, RoleProperty.EnlargeScale, RoleProperty.EnlargeScale)
	--print ("----------------------------------------------- function ChangeBigState:Enter------------------------")
end

function ChangeBigState:Excute(role,dTime)
	if UnityEngine.Time.time - self.startTime > self.duringTime then
		role.stateMachine:removeSharedState(self)
		return
	end

end

function ChangeBigState:Exit(role)
	role.gameObject.transform.localScale = UnityEngine.Vector3(1,1,1)
	if self.effect ~= nil then
		PoolFunc:inactiveObj(self.effect)
	end
end