--[[
author:Desmond
二段跳下落
]]
DoubleDropState = class(BasePlayerState)

DoubleDropState._name = "DoubleDropState"
DoubleDropState.dropPoint = 0 --下降高度
DoubleDropState.dropDistance = 0 --下降距离

function DoubleDropState:Enter(role)
	-- print ("----------------------------->>>>>>>  function DoubleDropState:Enter(role)")
	self.super.Enter(self,role)

	--self.animator:Play("multi drop descend");
	self.super.playAnimation(self,role,"multi drop descend")
	role.property.moveDir.y= role.property.dropSpeed+math.abs(role.property.moveDir.y)--y 向量速度,方向向下
	self.dropPoint = role.gameObject.transform.position.y
end

function DoubleDropState:Excute(role,dTime)
    self.super.Excute(self,role,dTime)

    local landPoint,flag = self.super.BaseDrop(self,role,dTime)
    self.dropDistance = self.dropPoint-landPoint
    
    if flag == true then
        local effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
        local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_single_drop")
        effectManager:addObject(effect)
        effect.transform.parent = role.gameObject.transform.parent
        effect.transform.position = role.gameObject.transform.position
        effect.transform.localScale = role.gameObject.transform.localScale

    end
end

function DoubleDropState:Exit(role)

end