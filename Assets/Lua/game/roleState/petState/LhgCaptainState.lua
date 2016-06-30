--[[
author:赵名飞
魉皇鬼队长技能
]]
LhgCaptainState =  class (BasePetState)
LhgCaptainState._name = "LhgCaptainState"
LhgCaptainState.stage = nil --状态步骤
LhgCaptainState.targetPos = nil--停留的目标位置
LhgCaptainState.appear_act = nil  --出现动作
LhgCaptainState.ongoing_act = nil --持续动作
LhgCaptainState.end_act = nil --结束动作
LhgCaptainState.ongoing_times = nil --持续次数
LhgCaptainState.CD_time = nil --cd时间
LhgCaptainState.act_map = nil --动作stage索引table
LhgCaptainState.effect_map = nil --动作特效索引table
LhgCaptainState.aristSpeed = nil -- 萌宠冲向玩家速度
LhgCaptainState.duringTime = nil --出现后持续显示时间
LhgCaptainState.distance = nil --作用范围
LhgCaptainState.changeItemId = nil --变化的itemid
function LhgCaptainState:Enter(role)
	self.super.Enter(self,role)
    self.stage = 1 
    self.duringTime = 0.5
    self.ongoing_times = 0
    self.CD_time = 0
    local petTxt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local skillTxt = TxtFactory:getTable(TxtFactory.PetSkillMainTXT)
    local actionTxt = TxtFactory:getTable(TxtFactory.PetAnimTXT)
    local skill_id = petTxt:GetData(self.player:getCaptainPetTypeID(),TxtFactory.S_MOUNT_ACTIVE_SKILLS)
    local action_id = skillTxt:GetData(skill_id,TxtFactory.S_MAIN_SKILL_ACTION_ID)
    --test
    local time_array = lua_string_split(skillTxt:GetData(skill_id,TxtFactory.S_MOUNT_SKILL_CONTINUED_LEN),",")
    self.ongoing_times = tonumber(time_array[1])
    time_array = lua_string_split(skillTxt:GetData(skill_id,TxtFactory.S_MOUNT_SKILL_SKILL_CD),",")
    self.CD_time = tonumber(time_array[1])
    time_array = lua_string_split(skillTxt:GetData(skill_id,TxtFactory.S_MOUNT_SKILL_SUCCESS_RATE),",")
    --test end
	local appear_act = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_ACTION)
	local ongoing_act = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_ACTION)
    self.act_map = {}
    self.act_map[1] = appear_act
    self.act_map[2] = appear_act
    self.act_map[3] = ongoing_act

	local ongoing_effect = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_EFFECT)
	local end_effect = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_END_EFFECT)
    self.effect_map = {}
    self.effect_map[1] = ongoing_effect
    self.effect_map[2] = end_effect

    self.aristSpeed = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_SPEED)
    self.distance = skillTxt:GetData(skill_id,TxtFactory.S_MAIN_SKILL_TARGET_SHAPE_PARA)
    self.changeItemId = skillTxt:GetData(skill_id,TxtFactory.S_MAIN_SKILL_GAIN_VALUE)

    local pos = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_POSITION)
    pos = lua_string_split(pos,";")
    role.gameObject.transform.localPosition = Vector3(tonumber(pos[1]),tonumber(pos[2]),tonumber(pos[3])) --设置初始位置
    pos = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_POSITION)
    pos = lua_string_split(pos,";")
    self.targetPos = Vector3(tonumber(pos[1]),tonumber(pos[2]),tonumber(pos[3])) --设置停留位置
end

function LhgCaptainState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
	role.gameObject.transform.localPosition = Vector3.MoveTowards(role.gameObject.transform.localPosition,self.targetPos,dTime*self.aristSpeed)
	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	--靠近玩家
	if self.stage == 1 then
		local distance = math.abs (role.gameObject.transform.localPosition.x-self.targetPos.x)
		--偏差
		if  distance < 1 then
			role.character.transform.localScale = UnityEngine.Vector3(1.5,1.5,1.5)
			self.stage = 2
		end
	--播放攻击
	elseif self.stage == 2 then
			--跳跃产生金币
    		local state = ItemChangeCloverState.new()
    		state.ongoing_times = self.ongoing_times --持续时间
    		state.CD_time = self.CD_time	--CD时间
    		state.distance = self.distance
    		state.itemId = self.changeItemId
    		self.player.stateMachine:addSharedState(state)
			self.stage = 3
	--检查时间
	elseif self.stage == 3 then
		if self.duringTime > 0 then
			self.duringTime = self.duringTime - dTime
		else
			role.stateMachine:changeState(nil)
		end
	end
	--播放动作
	if self.act_map[self.stage]~=nil and self.act_map[self.stage] ~= "" and animInfo:IsName(self.act_map[self.stage]) == false then
		--GamePrint("self.act_map[self.stage] : "..self.act_map[self.stage])
		self.animator:Play(self.act_map[self.stage])
	end
end

function LhgCaptainState:Exit(role)
	self.super.Exit(self,role)
	role:createEffect()
	role:inactive()
end