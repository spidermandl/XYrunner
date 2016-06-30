--[[
author:Desmond
角色被障碍物挡住状态
]]
DeadState = class (BasePlayerState)
DeadState._name = "DeadState"

function DeadState:Enter(role)
    --print ("---------------------function DeadState:Enter(role) 1")
	self.super.Enter(self,role)
    
    role:isOnCollision(true) --移除碰撞 死亡状态防止和其他物体发生逻辑
    self.super.playAnimation(self,role,"corpse")

    role.property.moveDir=UnityEngine.Vector3(0,0,0) --横向移动速度 1
    -- 若有坐骑，隐藏坐骑
    if role.mount ~= nil then 
    	local mountState = role.stateMachine:getSharedState(role.mount)
    	if mountState ~= nil then
            mountState:playRoleAnimation("corpse")
    		mountState:SetActive(false)
    	end
    end
    
    role:fallDown()--计算掉坑伤害


end

function DeadState:Excute(role,dTime)
    --role.gameObject.transform:Translate(0,0,0, Space.World)
end

function DeadState:Exit( role )
    role:isOnCollision(false)
end