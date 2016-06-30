--[[
author : Desmond
空中攻击状态
]]
AirAttackState = class (BasePlayerState)

AirAttackState._name = "AirAttackState"
AirAttackState.damageStartTime =nil --伤害开始时间
AirAttackState.damageEndTime = nil --伤害结束时间
AirAttackState.duringTime = nil --状态持续时间
AirAttackState.effectName = nil --特效
AirAttackState.animName = nil --动作名字
AirAttackState.isCombo = false
function AirAttackState:Enter(role)
	self.super.Enter(self,role)
	self.startTime = UnityEngine.Time.time
	local atk_id = self.super.BaseAttackEnter(self,role,true)

    -- if role:hasMount() == true then --有座骑
    --     self.super.playAnimation(self,role,"attack on ground")
    --     return
    -- end
    

	--self.animator:Play("attack in air")
	    --读表配置攻击参数
    local atkTable = TxtFactory:getTable(TxtFactory.ATKAnimTXT)
    self.damageStartTime = tonumber(atkTable:GetData(atk_id,TxtFactory.S_ATK_ANIM_DAMAGE_START))
	self.damageEndTime = tonumber(atkTable:GetData(atk_id,TxtFactory.S_ATK_ANIM_DAMAGE_END))
	--self.commboTime = tonumber(atkTable:GetData(self.atkIDs[self.stage],TxtFactory.S_ATK_ANIM_COMBO_TIME))
	--GamePrint("-------------------function AirAttackState:Enter(role) "..tostring(atk_id))
	local array = lua_string_split(atkTable:GetData(atk_id,TxtFactory.S_ATK_ANIM_DAMAGE_SCALE),",")
	self.damageColliderVec = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) --碰撞位置
    array = lua_string_split(atkTable:GetData(atk_id,TxtFactory.S_ATK_ANIM_ATK_DISTANCE),",")
    self.duringTime = self:GetDuringTimeBySpeed(role.property.moveDir.x,array)
    if self.isCombo == true then
		self.duringTime = self.duringTime / 2
	end
    self.effectName = atkTable:GetData(atk_id,TxtFactory.S_ATK_ANIM_EFFECT)
    --播放攻击动画
    self.animName = atkTable:GetData(atk_id,TxtFactory.S_ATK_ANIM_ACTION)
    self.super.playAnimation(self,role,self.animName)
end


function AirAttackState:Excute(role,dTime)

    --role.property.moveDir.x = RoleProperty.flyAtkSpeed
    
	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	if self.animName~=nil and animInfo:IsName(self.animName) == false then
		--self.animator:Play(self.animName)
		self.super.playAnimation(self,role,self.animName)
	end
	local allTime = UnityEngine.Time.time - self.startTime
	-- 创建攻击判定碰撞
	if allTime > self.damageStartTime and self.damageItem == nil then
		self:createAtkCollider(role)
	end
	if allTime > self.duringTime then --动画结束
        local previousState = role.stateMachine:getPreState()
		if previousState._name == "DoubleDropState" or previousState._name == "DoubleJumpState" then
			role.stateMachine:changeState(DoubleDropState.new())
            role.stateMachine:addSharedState(FlyATKBlockState.new())
		else
			role.stateMachine:changeState(DropState.new())
            role.stateMachine:addSharedState(FlyATKBlockState.new())
		end
		return
	end
	
	role.gameObject.transform:Translate(role.property.moveDir.x*dTime,0,0, Space.World)
	
end

--[[ role:角色 为lua对象 ]]
function AirAttackState:Exit(role)
	role.property.moveDir.y = 0
	self:removeATKCollider(role)
end
--[[
创建攻击判断碰撞
]]
function AirAttackState:createAtkCollider(role)
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

	local effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/"..self.effectName)
    effectManager:addObject(effect)
    effect.transform.parent=role.gameObject.transform
    effect.transform.position = role.gameObject.transform.position
    effect.transform.localScale = role.gameObject.transform.localScale
    effect.transform.rotation = UnityEngine.Quaternion.Euler(0,0,0)
end
--[[
移除攻击判断碰撞
]]
function AirAttackState:removeATKCollider(role)
	if self.damageItem ~= nil then
		self.damageItem:inactiveSelf()
		self.damageItem = nil
	end
end
--根据移动速度取需要持续时间,speed 速度 ，disTab 距离
function AirAttackState:GetDuringTimeBySpeed(speed,disTab)
	local speedTab = {8,9,10,12}
	local tab = {}
	for k, v in pairs(speedTab) do
		tab[v] = k
	end
	--根据速度取得index
	if speed < speedTab[1] then 
		speed = speedTab[1] 
	end
	if speed > speedTab[#speedTab] then
		speed = speedTab[#speedTab]
	end
	local index = tab[speed]
	if disTab[index] ~= nil then
		local dis = tonumber(disTab[index])
		return  dis / speed--返回距离/速度
	else
		GamePrint("找不到对应的速度："..speed)
		return 0.5
	end
end





