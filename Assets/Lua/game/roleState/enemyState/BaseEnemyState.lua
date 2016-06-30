--BaseEnemyState
--[[
敌人状态基类
author:Huqiuxiang
]]

BaseEnemyState = class(IState)
BaseEnemyState.animator = nil

BaseEnemyState.isBackwards = true --后退
BaseEnemyState.isDying = false --是否死亡
BaseEnemyState.positionX = 0
BaseEnemyState.idCanDestroy = false

function BaseEnemyState:Enter(role)
	self.animator = role.animator

	--self.effectArray = {}
end

function BaseEnemyState:Excute(role,dTime)
end

function BaseEnemyState:Exit(role)
end


--受击Enter
function BaseEnemyState:DefStateEnter(role)
	role.HP = role.HP - role:getPlayer().property.attack
	if role.HP < 1 then --受伤 死亡判断
		self.animator:Play("defend")
		--GameObject.Destroy(role.collider)
		self.idCanDestroy = true
	else
		self.animator:Play("defend") -- 受击动画
	end			
    self.stage = self.BACKWARDS
    self.positionX = role.gameObject.transform.position.x
    --播放特效
	local effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
	local hitEff = PoolFunc:pickObjByPrefabName("Effects/Common/ef_npc_hit")
	effectManager:addObject(hitEff)

    hitEff.transform.parent=role.gameObject.transform.parent
    local pos = role.gameObject.transform.position
    pos.y = pos.y + 0.5
    pos.x = pos.x + 0.5
    hitEff.transform.position = pos
    hitEff.transform.localScale = role.gameObject.transform.localScale

end

--受击Excute
function BaseEnemyState:DefStateExcute(role,dTime,isState)
	--如果死亡 用死亡距离 如果受击 用受击距离
	local posX = self.idCanDestroy and ConfigParam.EnemyDefBackwardsDis or ConfigParam.EnemyDieBackwardsDis
	if self.isBackwards == true then --后退
		if role.gameObject.transform.position.x > self.positionX + posX then
			self.isBackwards = false
		else
			role.gameObject.transform:Translate(ConfigParam.EnemyDefBackwardsVel*dTime,0,0, Space.World)
		end
	end

	if self.isBackwards == false then --如果移动到位置
		if self.idCanDestroy then --如果死亡
			local effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
			local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_npc_death")
			effectManager:addObject(effect)
			effect.transform.parent = role.gameObject.transform.parent
			effect.transform.localPosition = role.gameObject.transform.localPosition
			effect.transform.localScale = role.gameObject.transform.localScale
			
			role:inactiveSelf()
			
			self.idCanDestroy = false
			role.stage = role.DESTROY
	        
	        --print ("------------------- function BaseEnemyState:DefStateExcute(role,dTime) "..tostring(role.enemyId))
	        if role.enemyId ~= nil then--计算杀怪得分
	    		role:getPlayer():killEnemy(role.enemyId)
	    	end
	    else --否则受击
	    	if isState ~= nil then
	    		role.stateMachine:changeState(isState) --受击后切换到 待机状态 或其他状态
	    	end
		end
	end
end

--受击Exit
function BaseEnemyState:DefStateExit(role)
	--print ("------------------------------------------function EnemyDefState:Exit(role) ")
end

--攻击Enter
function BaseEnemyState:AtkStateEnter(role)
    self.animator:Play("attack")
end

--攻击Excute
function BaseEnemyState:AtkStateExcute(role,dTime,isState)
	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	if animInfo.normalizedTime >= 1.0 then --动画结束
    	role.stateMachine:changeState(isState)
	end
end

--待机Enter
function BaseEnemyState:IdlStateEnter(role)
	--print ("---------------------function BaseEnemyState:IdlStateEnter(role) 1")
    self.animator:Play("idle")
end

--待机Excute  普通近战怪攻击距离判定
function BaseEnemyState:IdlStateExcute(role,state)

end

