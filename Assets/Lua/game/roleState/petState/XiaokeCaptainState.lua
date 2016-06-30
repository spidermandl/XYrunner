--[[
author:赵名飞
小可队长技能
]]
XiaokeCaptainState =  class (BasePetState)
XiaokeCaptainState._name = "XiaokeCaptainState"
XiaokeCaptainState.stage = nil --状态步骤
XiaokeCaptainState.targetPos = nil--停留的目标位置
XiaokeCaptainState.appear_act = nil  --出现动作
XiaokeCaptainState.ongoing_act = nil --持续动作
XiaokeCaptainState.end_act = nil --结束动作
XiaokeCaptainState.ongoing_times = nil --持续次数
XiaokeCaptainState.success_rate = nil --概率
XiaokeCaptainState.CD_time = nil --cd时间
XiaokeCaptainState.act_map = nil --动作stage索引table
XiaokeCaptainState.effect_map = nil --动作特效索引table
XiaokeCaptainState.aristSpeed = nil -- 萌宠冲向玩家速度
XiaokeCaptainState.ContinuedSpeed = nil -- 萌宠飞行速度
XiaokeCaptainState.duringTime = nil --小可出现后持续显示时间
XiaokeCaptainState.jumpScore = nil --跳跃一次加分
function XiaokeCaptainState:Enter(role)
	self.super.Enter(self,role)
    self.stage = 1 
    self.success_rate = 0
    self.duringTime = 0.3
    self.ongoing_times = 0
    self.CD_time = 0
    self.jumpScore = 50
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
    self.success_rate = tonumber(time_array[1])
    --test end
	local appear_act = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_ACTION)
    self.act_map = {}
    self.act_map[1] = appear_act
    self.act_map[2] = appear_act
    self.act_map[3] = appear_act

	local ongoing_effect = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_EFFECT)
	local end_effect = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_END_EFFECT)
    self.effect_map = {}
    self.effect_map[1] = ongoing_effect
    self.effect_map[2] = end_effect

    self.aristSpeed = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_SPEED)
    local pos = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_POSITION)
    pos = lua_string_split(pos,";")
    role.gameObject.transform.localPosition = Vector3(tonumber(pos[1]),tonumber(pos[2]),tonumber(pos[3])) --设置初始位置
    pos = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_POSITION)
    pos = lua_string_split(pos,";")
    self.targetPos = Vector3(tonumber(pos[1]),tonumber(pos[2]),tonumber(pos[3])) --设置停留位置
end

function XiaokeCaptainState:Excute(role,dTime)
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
    		local state = MidasTouchState.new()
    		state.ongoing_times = self.ongoing_times --持续次数
    		state.CD_time = self.CD_time	--CD时间
    		state.ongoing_effect = self.effect_map[1] --产生金币特效
    		state.end_effect = self.effect_map[2] --头顶特效
    		state.jumpScore = self.jumpScore --跳跃加分
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

function XiaokeCaptainState:Exit(role)
	self.super.Exit(self,role)
	role:createEffect()
	role:inactive()
end