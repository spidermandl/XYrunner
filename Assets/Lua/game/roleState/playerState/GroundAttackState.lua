--[[
author:Desmond
角色地面攻击状态 共享状态
]]

GroundAttackState = class (BasePlayerState)--(BaseAttackState)
GroundAttackState._name = "GroundAttackState"
GroundAttackState.timeAggregate = 0 --计时
GroundAttackState.isCommbo = false --是否连击
GroundAttackState.stage = 1 --攻击动画阶段步骤
GroundAttackState.leastTime = 0 --最少攻击时间
GroundAttackState.damageStartTime = 0 --伤害开始时间
GroundAttackState.damageEndTime = 0 --伤害结束时间
GroundAttackState.commboTime = 0 --连击生效时间段
GroundAttackState.damageColliderVec = nil --伤害判定范围
GroundAttackState.atkIDs = nil --攻击配置表id
GroundAttackState.damageItem = nil --攻击判定碰撞物

GroundAttackState.isAnimFinished = false --动画是否结束

function GroundAttackState:Enter(role)
	--GamePrint ("------------function GroundAttackState:Enter(role)")
    self.super.Enter(self,role)
    self.atkIDs = self.super.BaseAttackEnter(self,role)
	self.stage = 1
    self:initData(role)

end
--[[ 初始化数据 ]]
function GroundAttackState:initData(role)
	self.isCommbo = false
	self.timeAggregate = 0
	self.isAnimFinished = false
	self:removeATKCollider(role)
    
    --读表配置攻击参数
    local atkTable = TxtFactory:getTable(TxtFactory.ATKAnimTXT)
    self.leastTime = tonumber(atkTable:GetData(self.atkIDs[self.stage],TxtFactory.S_ATK_ANIM_MIN_TIME))
    self.damageStartTime = tonumber(atkTable:GetData(self.atkIDs[self.stage],TxtFactory.S_ATK_ANIM_DAMAGE_START))
	self.damageEndTime = tonumber(atkTable:GetData(self.atkIDs[self.stage],TxtFactory.S_ATK_ANIM_DAMAGE_END))
	self.commboTime = tonumber(atkTable:GetData(self.atkIDs[self.stage],TxtFactory.S_ATK_ANIM_COMBO_TIME))
	--print ("least time: "..tostring(self.leastTime).." combo time: "..tostring(self.commboTime))
	local array = lua_string_split(atkTable:GetData(self.atkIDs[self.stage],TxtFactory.S_ATK_ANIM_DAMAGE_SCALE),",")
	self.damageColliderVec = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) --碰撞位置
    --GamePrint("------------function GroundAttackState:initData(role) ")
    --播放攻击动画
    self.super.playAnimation(self,role,atkTable:GetData(self.atkIDs[self.stage],TxtFactory.S_ATK_ANIM_ACTION))

    --攻击动画对应的特效
	local effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
	local effect = PoolFunc:pickObjByPrefabName("Effects/Common/"..atkTable:GetData(self.atkIDs[self.stage],TxtFactory.S_ATK_ANIM_EFFECT))
	effectManager:addObject(effect)
	effect.transform.parent=role.gameObject.transform
	effect.transform.position = role.gameObject.transform.position
	effect.transform.localScale = role.gameObject.transform.localScale
	effect.transform.rotation = UnityEngine.Quaternion.Euler(0,0,0)
    
end

--[[
移除攻击判断碰撞
]]
function GroundAttackState:removeATKCollider(role)
	if self.damageItem ~= nil then
		self.damageItem:inactiveSelf()
		self.damageItem = nil
	end
end

function GroundAttackState:Excute(role,dTime)
	self.timeAggregate = self.timeAggregate + dTime
    
	if self.isCommbo == true then --进入连击
		self.stage = self.stage + 1

        if self.stage == 2 then
        	self:initData(role)

		elseif self.stage == 3 then
			self:initData(role)

		elseif self.stage == 4 then
			self:initData(role)

		else
			self.isCommbo = false
		end
		--GamePrint("-----------------function GroundAttackState:Excute(role,dTime) "..tostring(self.stage))

	end

	if self.timeAggregate >= self.damageStartTime and self.timeAggregate <= self.damageEndTime then --在碰撞伤害区间内

		if self.damageItem == nil then
		    local obj = PoolFunc:pickObjByLuaName("AttackAffectItem")
		    obj:SetActive(false)
		    local sub = obj:GetComponent(BundleLua.GetClassType())

		    obj.transform.parent = role.gameObject.transform
		    obj.transform.localPosition = UnityEngine.Vector3(self.damageColliderVec.x/2, self.damageColliderVec.y/2, 0)
		    obj.transform.localRotation = Quaternion.Euler(0,0,0)
		    obj.transform.localScale = self.damageColliderVec
		    
		    if sub == nil then --第一次创建物体
		        sub = obj:AddComponent(BundleLua.GetClassType())
		        sub.luaName = "AttackAffectItem"
		        LuaShell.setPreParams(obj:GetInstanceID(),nil)--预置构造参数
		    else --重用加载
		        local lua = LuaShell.getRole(obj:GetInstanceID())
		        lua:initParam()
		    end
		    obj:SetActive(true)
		    self.damageItem = LuaShell.getRole(obj:GetInstanceID())
		end
	end
    --print ("------------function GroundAttackState:Excute(role,dTime) "..tostring(self.timeAggregate))
    if self.timeAggregate > self.damageEndTime then --碰撞伤害时间已过
    	self:removeATKCollider(role)
    end

    --配表时间完成
    if self.timeAggregate > self.leastTime + self.commboTime then
		self:removeATKCollider(role)
		role.stateMachine:removeSharedState(self)
		--GamePrint("---------if self.timeAggregate > self.leastTime + self.commboTime then ")
		return
    end

    --动画时间完成
    --self.animator.speed =1
	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
    if animInfo.normalizedTime >= 1.0 then --动画结束
    	--GamePrint("if animInfo.normalizedTime >= 1.0 then --动画结束")
    	self.super.playAnimation(self,role,"run")
    	self.isAnimFinished = true
		return
	end

end

--[[ role:角色 为lua对象 ]]
function GroundAttackState:Exit(role)
	if self.isAnimFinished ~= true then --当动画播放时间大于 配表完成时间
		self.super.playAnimation(self,role,"run")
	end
	self:removeATKCollider(role)
end

--连续攻击触发
function GroundAttackState:commbo(role)
	--GamePrint("-----------function GroundAttackState:commbo(role) "..tostring(self.timeAggregate))
	if self.timeAggregate >= self.leastTime and self.timeAggregate <= self.leastTime + self.commboTime and self.stage < #self.atkIDs then --小于时间间隔，触发commbo
		--GamePrint ("-----------function GroundAttackState:commbo(role) ".." "..tostring(self.stage).." "..tostring(self.timeAggregate))
		self.isCommbo = true
	-- elseif self.timeAggregate > self.leastTime + self.commboTime then--重新开始攻击
	-- 	print ("-----------function GroundAttackState:commbo(role) restart")
	-- 	self:Enter(role)
	end
end










