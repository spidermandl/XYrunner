--[[
弹簧落地状态
author:赵名飞
]]

BouncingDropState  =  class(BasePlayerState)
BouncingDropState.dropPoint = 0 --下降高度
BouncingDropState.dropDistance = 0 --下降距离
BouncingDropState.effect = nil 
BouncingDropState._name="BouncingDropState"
function BouncingDropState:Enter(role)
	self.super.Enter(self,role)
	--self.super.playAnimation(self,role,"jump08")
	role.property.moveDir.y = math.abs(role.property.moveDir.y) --y向量速度,方向向下
	self.dropPoint = role.gameObject.transform.position.y
end

function BouncingDropState:Excute(role,dTime)
	--GamePrint("-----------------------function BouncingDropState:Excute(role,dTime) 1")
	self.super.Excute(self,role,dTime)

    local landPoint,flag,road = self.super.BaseDrop(self,role,dTime)
    self.dropDistance = self.dropPoint-landPoint
    if road ~= nil then
    	local del_z = road.gameObject.transform.position.z - role.gameObject.transform.position.z
    	role.gameObject.transform:Translate(0,0,del_z, Space.World)
    end
    if flag == true then	
	    local effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
		local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_single_drop")
		effectManager:addObject(effect)
		effect.transform.parent = role.gameObject.transform.parent
		effect.transform.position = role.gameObject.transform.position
		effect.transform.localScale = role.gameObject.transform.localScale
    end
end

function BouncingDropState:Exit(role)
end