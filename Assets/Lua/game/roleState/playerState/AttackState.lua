--[[
author:Desmond
角色攻击状态
]]
AttackState = class (BasePlayerState)

AttackState._name = "AttackState"
AttackState.effect = nil
AttackState.flyATKgap = 0.5 --空中攻击时间间隔
AttackState.isLanded = false --是否在地面

function AttackState:Enter(role)
    self.super.Enter(self,role)
    role:countATK() --记录攻击次数
    local ackTimes = role:getATKCount()
    --and role:isPetOn(TxtFactory.S_ROLE_CHINCHILLAS_ID) == true
    --GamePrint("ackTimes   :"..ackTimes)
    --if (ackTimes % RoleProperty.AttackTimesMax) == 0 and role:isPetOn(TxtFactory.S_ROLE_CHINCHILLAS_ID) == true then 
    --满足龙猫触发条件
        --print("满足龙猫释放条件，现在攻击次数是："..ackTimes)
        --role:createPet(TxtFactory.S_ROLE_CHINCHILLAS_ID)
    --end
    
------------------------秦仕超 添加龙猫下落触发-------------------------------
    -- role.aggregateATKTime = role.aggregateATKTime + 1 --攻击次数累计
    -- -- print("role.aggregateATKTime :"..role.aggregateATKTime)
    -- if role.aggregateATKTime == role.property.ChinchillasSummonedByAtkTimes then
    --     createPet(role,"Pet/chinchillas")
    -- 	role.aggregateATKTime = 0
    -- end
-------------------------------------------------------------


    if role:hasMount() == true then --有座骑
        self.super.playAnimation(self,role,"attack on ground")
        return
    end
    
    self.isLanded = self.super.isOnGround(self,role)

    if self.isLanded == true then
    	--self.animator:Play("attack on ground")
    	self.super.playAnimation(self,role,"attack on ground")

        local effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
        local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_pleyer_male_atk03")
        effectManager:addObject(effect)
        effect.transform.parent=role.gameObject.transform
	    effect.transform.position = role.gameObject.transform.position
	    effect.transform.localScale = role.gameObject.transform.localScale
	    effect.transform.rotation = UnityEngine.Quaternion.Euler(0,0,0)

	else
		--self.animator:Play("attack in air")
		self.super.playAnimation(self,role,"attack in air")

        local effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
        local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_pleyer_male_atk04")
        effectManager:addObject(effect)
        effect.transform.parent=role.gameObject.transform
	    effect.transform.position = role.gameObject.transform.position
	    effect.transform.localScale = role.gameObject.transform.localScale
	    effect.transform.rotation = UnityEngine.Quaternion.Euler(0,0,0)

	end
end


function AttackState:Excute(role,dTime)
    if self.isLanded == true then
        self.super.Excute(self,role,dTime)
    else
        --role.property.moveDir.x = RoleProperty.flyAtkSpeed
    end
	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	-- print ("-------------------------------->>>>>>>>>> function AttackState:Excute(role,dTime) "
    --        ..tostring(animInfo.normalizedTime)..' '..tostring(animInfo.loop))

	if animInfo.normalizedTime >= 1.0 then --动画结束
        local previousState = role.stateMachine:getPreState()
		local flag = self.super.isOnGround(self,role)
		if flag == true  then --or previousState._name == "DefendState"
			role.stateMachine:changeState(_G[previousState._name].new())
            --print("previousState._name "..previousState._name)
		elseif previousState._name == "DoubleDropState" or previousState._name == "DoubleJumpState" then
			role.stateMachine:changeState(DoubleDropState.new())
            role.stateMachine:addSharedState(FlyATKBlockState.new())
		else
			role.stateMachine:changeState(DropState.new())
            role.stateMachine:addSharedState(FlyATKBlockState.new())
		end

		return
	end
    -- if self.isDroping ==false then
	role.gameObject.transform:Translate(role.property.moveDir.x*dTime,0,0, Space.World)
	-- else
	-- 	self.super.BaseDrop(self,role,dTime)
	-- end

end

--[[ role:角色 为lua对象 ]]
function AttackState:Exit(role)

end



