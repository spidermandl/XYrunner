DoubleJumpState = class(BasePlayerState)

DoubleJumpState._name = "DoubleJumpState"
DoubleJumpState.state = nil
DoubleJumpState.ASCEND = 0
DoubleJumpState.TOP =1
DoubleJumpState.max_normalize_time = -1
DoubleJumpState.isDroping = false
DoubleJumpState.effect = nil 
function DoubleJumpState:Enter(role)
	self.super.Enter(self,role)
	--role.gameObject.transform:Translate(0,0.2,0, Space.World)
	--role.character:GetComponent("Animator"):Play("multi jump ascend",0,0)
	self.super.playAnimation(self,role,"multi jump ascend")
	-- print("Animator Play ==> multi jump ascend")
	role.property.moveDir.y = role.property.doubleJumpSpeed --初始向量速度
	self.state = self.ASCEND

    local effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_double_jump")
	effectManager:addObject(effect)
    effect.transform.parent=role.gameObject.transform.parent
    effect.transform.position = role.gameObject.transform.position
    effect.transform.localScale = role.gameObject.transform.localScale
end

function DoubleJumpState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)

	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)

	--上升过程:
	if role.property.moveDir.y > 0.0 or self.state == self.TOP then
		-------------------一小段下降，落地检测---------------------------------
	    local flag =false 
		if role.property.moveDir.y < 0 then
			flag = self.super.isLanding(self,role,dTime)
		end

		if flag == true then 
			-- print("DoubleJumpState flag == true")
			role.stateMachine:changeState(DropState.new())
			return
		end
		---------------------------------------------------------------------
		local acc = role.property.jumpACC --获取加速度
		if role.property.moveDir.y < 0 then
			acc = role.property.dropACC
		end

		local dHeight = (role.property.moveDir.y - acc * dTime ) * dTime
		-- print ("-------------------------------->>>>>> function DoubleJumpState:Excute(role,dTime) v:"
		-- 	..tostring(role.property.moveDir.y).." del: "
		-- 	..tostring(dHeight).." height:"..tostring(role.gameObject.transform.position.y))
		role.property.moveDir.y = role.property.moveDir.y - acc * dTime
        role.gameObject.transform:Translate(role.property.moveDir.x*dTime,dHeight,0, Space.World)

        if self.max_normalize_time>0 and animInfo.normalizedTime >= self.max_normalize_time then --动画结束
        	role.stateMachine:changeState(DoubleDropState.new())
        end
	-- 升至最高点开始下落:
	else
		--print ("-------------------------------->>>>>> function DoubleJumpState:Excute(role,dTime) 2")
		self.state = self.TOP
		self.isDroping = true
		self.max_normalize_time = math.ceil(animInfo.normalizedTime)
	end

end

function DoubleJumpState:Exit(role)
end