--[[
author:赵名飞
哈比队长技能
]]
HabiCaptainState =  class (BasePetState)
HabiCaptainState._name = "HabiCaptainState"
HabiCaptainState.stage = nil --状态步骤
HabiCaptainState.targetPos = nil--停留的目标位置
HabiCaptainState.appear_act = nil  --出现动作
HabiCaptainState.ongoing_act = nil --持续动作
HabiCaptainState.end_act = nil --结束动作
HabiCaptainState.ongoing_time = nil --持续时间
HabiCaptainState.ongoing_time_cap = nil --持续时间上限
HabiCaptainState.CD_time = nil --CD时间
HabiCaptainState.act_map = nil --动作stage索引table
HabiCaptainState.effect_map = nil --动作特效索引table
HabiCaptainState.lastEffect =nil --记录播放过的特效
HabiCaptainState.CleanMonsterDistance = nil --清怪范围
HabiCaptainState.aristSpeed = nil -- 萌宠冲向玩家速度
HabiCaptainState.ContinuedSpeed = nil -- 萌宠飞行速度
function HabiCaptainState:Enter(role)
	self.super.Enter(self,role)
    self.stage = 1
    self.ongoing_time = 0 
    self.ongoing_time_cap = 0
    --self.player.stateMachine:changeState(SprintState.new()) --进入冲刺状态
    local petTxt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local skillTxt = TxtFactory:getTable(TxtFactory.PetSkillMainTXT)
    local actionTxt = TxtFactory:getTable(TxtFactory.PetAnimTXT)
    local skill_id = petTxt:GetData(self.player:getCaptainPetTypeID(),TxtFactory.S_MOUNT_ACTIVE_SKILLS)
    local action_id = skillTxt:GetData(skill_id,TxtFactory.S_MAIN_SKILL_ACTION_ID)
    
    self.CleanMonsterDistance = tonumber(skillTxt:GetData(skill_id,TxtFactory.S_MAIN_SKILL_TARGET_SHAPE_PARA))
    --test
    local time_array = lua_string_split(skillTxt:GetData(skill_id,TxtFactory.S_MOUNT_SKILL_CONTINUED_LEN),",")
    self.ongoing_time_cap = tonumber(time_array[1])
    time_array = lua_string_split(skillTxt:GetData(skill_id,TxtFactory.S_MOUNT_SKILL_SKILL_CD),",")
    self.CD_time = tonumber(time_array[1])
    --test end
	local appear_act = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_ACTION)
	local ongoing_act = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_ACTION)
    self.act_map = {}
    self.act_map[1] = appear_act
    self.act_map[2] = ongoing_act
    self.act_map[3] = ongoing_act
	local ongoing_effect = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_EFFECT)
    self.effect_map = {}
    self.effect_map[1] = ongoing_effect

    self.aristSpeed = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_SPEED)
    self.EnemytManager = PoolFunc:pickSingleton("EnemyGroup")
    local pos = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_POSITION)
    pos = lua_string_split(pos,";")
    role.gameObject.transform.localPosition = Vector3(tonumber(pos[1]),tonumber(pos[2]),tonumber(pos[3])) --设置初始位置
    pos = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_POSITION)
    pos = lua_string_split(pos,";")
    self.targetPos = Vector3(tonumber(pos[1]),tonumber(pos[2]),tonumber(pos[3])) --设置停留位置
    --GetCurrentSceneUI().mainCamera.gameObject.transform.localScale = Vector3.one
end

function HabiCaptainState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
	role.gameObject.transform.localPosition = Vector3.MoveTowards(role.gameObject.transform.localPosition,self.targetPos,dTime*self.aristSpeed)
	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	--靠近玩家
	if self.stage == 1 then
		local distance = math.abs (role.gameObject.transform.localPosition.x-self.targetPos.x)
		--偏差
		if  distance < 1 then
			role.character.transform.localScale = UnityEngine.Vector3(2,2,2)
			self.stage = 2
		end
	--播放攻击
	elseif self.stage == 2 then
		if animInfo.normalizedTime > 0.9 then --动画结束
			self:PlayEffect(role,self.effect_map[1],true)
			--加入清屏状态
    		local CleanState = CleanMonsterState.new()
    		CleanState.CleanMonsterDistance = self.CleanMonsterDistance
    		self.player.stateMachine:addSharedState(CleanState)

			self.ongoing_time = 0
			self.stage = 3
		end
	--检查时间与次数
	elseif self.stage == 3 then
		if self.ongoing_time < self.ongoing_time_cap then
			self.EnemytManager:CleanEnemyByDistance(self.CleanMonsterDistance) --清怪
			self.ongoing_time = self.ongoing_time + dTime
		else
			role.stateMachine:changeState(nil)
		end
	end
	--播放动作
	if self.act_map[self.stage]~=nil and animInfo:IsName(self.act_map[self.stage]) == false then
		self.animator:Play(self.act_map[self.stage])
	end
end

function HabiCaptainState:Exit(role)
	self.super.Exit(self,role)
	role:createEffect()
	role:inactive()
	self.player.stateMachine:removeSharedStateByName("CleanMonsterState")
	self.player.stateMachine:removeSharedStateByName("PlayingSkillState")
	GetCurrentSceneUI().uiCtrl:SetSkillCDTime(self.CD_time) 	--记录CD时间
end

function HabiCaptainState:PlayEffect(role,effectName,loop)
	if effectName == nil or effectName == "" then
		return
	end
	local effectManager = PoolFunc:pickSingleton("EffectGroup")
	if self.lastEffect ~= nil then 
		effectManager:removeObject(self.lastEffect)
	end
    local effect  = PoolFunc:pickObjByPrefabName("Effects/Common/"..effectName)
    effect.transform.parent=role.gameObject.transform.parent
    effect.transform.position = role.gameObject.transform.position
    effect.transform.localScale = role.gameObject.transform.localScale
    self.lastEffect = effect
    effectManager:addObject(effect,loop)
end