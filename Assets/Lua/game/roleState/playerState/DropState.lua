--[[
落地状态
author:Desmond
]]

DropState  =  class(BasePlayerState)
DropState.dropPoint = 0 --下降高度
DropState.dropDistance = 0 --下降距离
DropState.effect = nil 
DropState._name="DropState"

function DropState:Enter(role)
	--GamePrint ("----------------------------->>>>>>>  function DropState:Enter(role)")
	self.super.Enter(self,role)

	--self.animator:Play("single drop descend");
	self.super.playAnimation(self,role,"single drop descend")
	
	role.property.moveDir.y = math.abs(role.property.moveDir.y) --y向量速度,方向向下
	self.dropPoint = role.gameObject.transform.position.y
end

function DropState:Excute(role,dTime)
	--GamePrint("-----------------------function DropState:Excute(role,dTime) 1")
	self.super.Excute(self,role,dTime)

    local landPoint,flag = self.super.BaseDrop(self,role,dTime)
    self.dropDistance = self.dropPoint-landPoint

    if flag == true then
    	--GamePrint("-----------------------function DropState:Excute(role,dTime) 2")
	    local effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
		local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_single_drop")
		effectManager:addObject(effect)
		effect.transform.parent = role.gameObject.transform.parent
		effect.transform.position = role.gameObject.transform.position
		effect.transform.localScale = role.gameObject.transform.localScale

    end
end

function DropState:Exit(role)

end