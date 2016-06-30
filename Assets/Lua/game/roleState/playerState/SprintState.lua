--[[
冲击状态
author:Desmond
]]
SprintState = class (BasePlayerState)

SprintState.previousState = nil

SprintState._name = "SprintState"
SprintState.effect = nil
SprintState.effectManager = nil
SprintState.startTime = nil
SprintState.duringTime = 3 --技能持续时间
SprintState.connectState = nil --衔接状态，冲刺结束后进入该状态
SprintState.connectEffect = nil --衔接特效
SprintState.battleScene = nil --战斗场景
SprintState.landingPoint = nil --神圣模式降落点

function SprintState:Enter(role)
    self.super.Enter(self,role)
    role.property.moveDir.x= role.moveSpeedVect * role.property.sprintSpeed --初始向量速度
    role.gameObject.transform:Translate(0,1,0)--上升偏移量

    self.previousState = role.stateMachine:getPreState()

    self.startTime = UnityEngine.Time.time

	--self.animator:Play("sprint speed")
	self.super.playAnimation(self,role,"sprint speed")
	self.effectManager = PoolFunc:pickSingleton("EffectGroup")
    self.effect  = PoolFunc:pickObjByPrefabName("Effects/Common/ef_pleyer_male_chongci")
    self.effect.transform.parent=role.gameObject.transform
    self.effect.transform.position = role.gameObject.transform.position
    self.effect.transform.localScale = role.gameObject.transform.localScale
    self.effectManager:addObject(self.effect)

    --self.effect.transform.rotation = UnityEngine.Quaternion.Euler(0,90,0)
    --local pArray = self.effect.gameObject.transform:GetComponentsInChildren(UnityEngine.ParticleSystem.GetClassType())
    --local length = pArray.Length-1 
    --print ("--------------------------------------------------function SprintState:Enter(role) "..tostring(length))
    --for i=0,length do
    --	System.Array.GetValue(pArray,i):Play()
	--end

    if self.previousState._name == "RunState" then
    	--self.effect.gameObject.transform:Find("Particle System"):GetComponent(UnityEngine.ParticleSystem.GetClassType()):Play()
	else
		self.isAirAtk = true

	end
	self.battleScene = GetCurrentSceneUI()
end


function SprintState:Excute(role,dTime)
    self.super.Excute(self,role,dTime)

	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	if animInfo:IsName("sprint speed") == false then
		self.animator:Play("sprint speed")
		--self.super.playAnimation(self,role,self.animName)
	end
    if UnityEngine.Time.time - self.startTime > self.duringTime then  
       	local flag = self.super.isOnGround(self,role,dTime)
		if self.previousState._name == "RunState"  and flag == true then
			role.stateMachine:changeState(_G[self.previousState._name].new())
		elseif self.previousState._name == "DoubleDropState" or self.previousState._name == "DoubleJumpState" then
			role.stateMachine:changeState(DoubleDropState.new())
		else
			role.stateMachine:changeState(DropState.new())
		end

		return
	end
	if self.connectState ~= nil then --在冲刺过程中找最近的下落点，如果没有有生成下一段路面
		if self.landingPoint == nil then
			self.landingPoint = self.battleScene:loadNextRoad()
		end
	end
	if self.connectState ~= nil and self.connectEffect == nil then --是否需要创建特效
		if UnityEngine.Time.time - self.startTime > self.duringTime * 0.92 then --在冲刺状态进度 92%时候创建衔接特效
			self.effectManager:removeObject(self.effect) --隐藏本身特效
			self.connectEffect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_chuansong_jinshan") --创建衔接特效
		    --self.connectEffect.name = "ef_chuansong_jinshan"
		    self.connectEffect.transform.parent = role.gameObject.transform
		    self.connectEffect.transform.position = role.gameObject.transform.position + Vector3(0.7,-1,-1) --加偏差
		    self.effectManager:addObject(self.connectEffect)
		end
	end

    -- if self.isDroping ==false then
    	role.gameObject.transform:Translate(role.property.moveDir.x*dTime,0,0, Space.World)
	-- else
	-- 	self.super.BaseDrop(self,role,dTime)
	-- end

end

--[[ role:角色 为lua对象 ]]
function SprintState:Exit(role)
	if self.effect ~= nil then
		self.effectManager:removeObject(self.effect)
	end
	if self.connectState ~= nil and UnityEngine.Time.time - self.startTime > self.duringTime then
		local holy = HolyState.new()
		holy.landingPoint = self.landingPoint
		role.stateMachine:addSharedState(holy) -- 主角神圣模式
	end
end