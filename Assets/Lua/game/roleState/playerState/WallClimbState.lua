--[[
角色吸住墙状态
author:Desmond
]]
WallClimbState = class(BasePlayerState)

WallClimbState._name = "WallClimbState"
WallClimbState.rigidTime = 0 --吸强停顿时间
WallClimbState.camera = nil 


HangingSurface.stayTime =0 -- 墙壁可以停留时间
HangingSurface.acceleration =0 -- 人物下滑加速度

function WallClimbState:Enter(role)
    GamePrint("------------------------function WallClimbState:Enter(role) ")
	self.camera = LuaShell.getBattleCamera()
    self.super.Enter(self,role)

    self.super.playAnimation(self,role,"hanging")
	role.property.moveDir.y = -role.property.hangingSpeed --初始向量速度
	role.stateMachine:addSharedState(HangingBlockState.new())
end

function WallClimbState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
    
    self.rigidTime = self.rigidTime + dTime

    local landed = self.super.isOnGround(self,role) --判断脚碰地面
    local dY = role.property.moveDir.y*dTime --下降高度(根据加速度计算位置)
    --local dY = self.acceleration * dTime * dTime
    if landed == true or self.rigidTime < RoleProperty.hangingRigidTime then -- 在墙上停留
    	dY = 0
    end
    role.gameObject.transform:Translate(0,dY,0, Space.World) -- 下滑

    if landed == true then
        GamePrint("------------------------function WallClimbState:Excute(role,dTime) ")
        role.stateMachine:changeState(RunState.new())
	end

end

function WallClimbState:Exit(role)
    --print("===========================离开墙壁===========================")
	role.property.moveDir.y = 0
    local effectManager = PoolFunc:pickSingleton("EffectGroup")
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_wall_L_jump")
    effectManager:addObject(effect)
    effect.transform.parent = role.gameObject.transform.parent
    effect.transform.position = Vector3.zero
    effect.transform.localScale = Vector3.one
end

function WallClimbState:SetValue(stayTime,acceleration)
      self.stayTime = stayTime
      self.acceleration = acceleration
end

