--[[
 角色起跳状态
]]
JumpState = class(BasePlayerState)
JumpState.state = nil
JumpState.READY = 0
JumpState.ASCEND = 1
JumpState.TOP =2
JumpState.max_normalize_time=1
JumpState._name = "JumpState"

function JumpState:Enter(role)
	self.super.Enter(self,role)
	role.property.moveDir.y=role.property.jumpSpeed --初始向量速度

	--self.animator:Play("single jump ready")
	self.super.playAnimation(self,role,"single jump ready")
	self.state = self.READY
    local effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_single_jump")
	effectManager:addObject(effect)
    effect.transform.parent = role.gameObject.transform.parent
    effect.transform.position = role.gameObject.transform.position
    effect.transform.localScale = role.gameObject.transform.localScale
    if role.stateMachine.sharedStates["MidasTouchState"] ~= nil then
    	role.stateMachine.sharedStates["MidasTouchState"]:CreatePrize(role)
    end
    if role.stateMachine.sharedStates["JumpReduceSkillCd"] ~= nil then
    	role.stateMachine.sharedStates["JumpReduceSkillCd"]:ReduceSkillCd(role)
    end
end

function JumpState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
	
	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	--print ("-------------------------------->>>> function JumpState:Excute(role,dTime) "..tostring(role.property.moveDir.x))
	if self.state == self.READY then --起跳动作
		if animInfo.normalizedTime >= 1.0 then --动画结束
			--self.animator:Play("single jump ascend");
			--self.animator:Play("single jump top");
			self.state = self.ASCEND
			--return
		end

	end

	--上升过程:

	local dHeight = (role.property.moveDir.y - role.property.jumpACC * dTime ) * dTime
	role.property.moveDir.y = role.property.moveDir.y - role.property.jumpACC* dTime
    role.gameObject.transform:Translate(role.property.moveDir.x*dTime,dHeight,0, Space.World)
    
	if role.property.moveDir.y > role.property.transionSpeed then
	
	else -- 升至最高点开始下落:
		--print ("----------------function JumpState:Excute(role,dTime) "..tostring(role.isHanging))
		if role.isHanging == true then --处于吸墙跳
			role.stateMachine:changeState(WallClimbState.new())
			return
		end
		role.stateMachine:changeState(JumpTopState.new())
	end

end

function JumpState:Exit(role)

end