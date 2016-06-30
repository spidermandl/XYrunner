--[[
   author:Huqiuxiang
   主角磁铁状态
]]

MagnetState = class(BasePlayerState)
MagnetState._name = "MagnetState"
MagnetState.startTime = nil
MagnetState.isShowEffect = true
MagnetState.stage = nil -- 磁铁三阶段 0 为 一直开启阶段  1 为 关闭 一直开启阶段  2 为 时间限定阶段
MagnetState.duringTime = 3
MagnetState.distance = 3 -- 磁铁范围

function MagnetState:Enter(role)
	self.startTime = UnityEngine.Time.time
	self.duringTime = self.duringTime + (self.duringTime * role.property.StateBonusTime) --本身持续时间 + 角色增益时间
	if self.isShowEffect == true then
	    local effectGroup = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
	    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_prop_xitieshi")--创建特效
	    effect.transform.parent = role.gameObject.transform
	    effect.transform.localPosition = Vector3.zero
	    effectGroup:addObject(effect)
	end
end

function MagnetState:Excute(role,dTime)
	if self.stage == 0 then  -- 一直开启阶段

	elseif self.stage == 1 then -- 关闭 一直开启阶段
		-- print("self.stage == 1 ")
        role.stateMachine:removeSharedState(self)
	elseif self.stage == 2 then -- 时间限定阶段
        if self.duringTime > 0 and UnityEngine.Time.time - self.startTime > self.duringTime then
			role.stateMachine:removeSharedState(self)
			return
		end
    end
end

function MagnetState:Exit(role)

end
