--[[
author:Desmond
皮卡丘队长技能
]]
PikachuCaptainState =  class (BasePetState)
PikachuCaptainState._name = "PikachuCaptainState"
PikachuCaptainState.stage = nil --状态步骤

PikachuCaptainState.appear_act = nil  --出现动作
PikachuCaptainState.ongoing_act = nil --持续动作
PikachuCaptainState.end_act = nil --结束动作
PikachuCaptainState.ongoing_time = nil --持续时间
PikachuCaptainState.ongoing_time_cap = nil --持续时间上限
PikachuCaptainState.CD_time = nil --CD时间上限
PikachuCaptainState.act_map = nil --动作stage索引table
PikachuCaptainState.effect_map = nil --动作特效索引table
PikachuCaptainState.lastEffect =nil --记录播放过的特效

PikachuCaptainState.aristSpeed = nil -- 萌宠冲向玩家速度
PikachuCaptainState.ContinuedSpeed = nil -- 萌宠飞行速度
PikachuCaptainState.CleanMonsterDistance = nil --清怪范围
PikachuCaptainState.mainCamera = nil --场景摄像机
PikachuCaptainState.cameraD_F_Distance = nil --摄像机偏差值
PikachuCaptainState.camera_Fix_Time = nil --摄像机拉远时间
PikachuCaptainState.camera_Reset_Time = nil --摄像机恢复时间

function PikachuCaptainState:Enter(role)
	self.super.Enter(self,role)
    self.stage = 1
    self.ongoing_time = 0 
    self.ongoing_time_cap = 0
    self.player.stateMachine:changeState(SprintState.new()) --进入冲刺状态
    local petTxt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local skillTxt = TxtFactory:getTable(TxtFactory.PetSkillMainTXT)
    local actionTxt = TxtFactory:getTable(TxtFactory.PetAnimTXT)
    local skill_id = petTxt:GetData(role.petTypeID,TxtFactory.S_MOUNT_ACTIVE_SKILLS)
    local action_id = skillTxt:GetData(skill_id,TxtFactory.S_MAIN_SKILL_ACTION_ID)
    self.CleanMonsterDistance = tonumber(skillTxt:GetData(skill_id,TxtFactory.S_MAIN_SKILL_TARGET_SHAPE_PARA))
    local cameraInfo = skillTxt:GetData(skill_id,TxtFactory.S_MAIN_SKILL_D_F_DISTANCE)
    cameraInfo = lua_string_split(cameraInfo,"|")
    --获取摄像机作用时间
    self.camera_Fix_Time = tonumber(cameraInfo[2])
    self.camera_Reset_Time = self.camera_Fix_Time
    cameraInfo = lua_string_split(cameraInfo[1],";")
    --获取摄像机偏差Vector3(0,2,-9)
    self.cameraD_F_Distance = Vector3(tonumber(cameraInfo[1]),tonumber(cameraInfo[2]),tonumber(cameraInfo[3]))
    --GamePrint("  self.camera_Fix_Time:".. self.camera_Fix_Time.."	self.camera_Reset_Time:"..self.camera_Reset_Time..
    --	"		self.cameraD_F_Distance:"..tostring(self.cameraD_F_Distance))
    --test
    local time_array = lua_string_split(skillTxt:GetData(skill_id,TxtFactory.S_MOUNT_SKILL_CONTINUED_LEN),",")
    self.ongoing_time_cap = tonumber(time_array[1]) 
    time_array = lua_string_split(skillTxt:GetData(skill_id,TxtFactory.S_MOUNT_SKILL_SKILL_CD),",")
    self.CD_time = tonumber(time_array[1])
    --test end
	--GamePrint ("---------------function PikachuCaptainState:Enter(role) "..tostring(self.act_map[self.stage]))
	local appear_act = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_ACTION)
	local ongoing_act = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_ACTION)
	local end_act = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_END_ACTION)
    self.act_map = {}
    self.act_map[1] = appear_act
    self.act_map[2] = ongoing_act
    self.act_map[3] = self.act_map[2]
    self.act_map[4] = self.act_map[2]

    local appear_effect = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_EFFECT)
    local link_effect = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_LINK_EFFECT)
	local ongoing_effect = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_EFFECT)
	local end_effect = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_END_EFFECT)
    self.effect_map = {}
    self.effect_map[1] = appear_effect
    self.effect_map[2] = link_effect
    self.effect_map[3] = ongoing_effect
    self.effect_map[4] = end_effect

    self.aristSpeed = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_SPEED)
    self.ContinuedSpeed = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_SPEED)
    self.mainCamera = GetCurrentSceneUI().mainCamera
    local pos = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_POSITION)
    pos = lua_string_split(pos,";")
    role.character.gameObject.transform.localPosition = Vector3(tonumber(pos[1]),tonumber(pos[2]),tonumber(pos[3])) --设置初始位置
end

function PikachuCaptainState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
	role.character.gameObject.transform.localPosition = Vector3.MoveTowards(role.character.gameObject.transform.localPosition,self.player.character.transform.localPosition,dTime*self.aristSpeed)
	--靠近玩家
	if self.stage == 1 then
		local distance = math.abs (role.character.gameObject.transform.localPosition.x-self.player.character.transform.localPosition.x)
		--偏差
		if  distance < 1 then
			self.stage = 2
		end
	--提前播放衔接特效
	elseif self.stage == 2 then
		GetCurrentSceneUI().uiCtrl:ShowWhite() 	--show白背景
		--拉远摄像机
		local state = CameraFollowState.new() --拉远状态
    	state.zAxisFixedPoint = self.cameraD_F_Distance
    	state.zAxisMoveingTime = self.camera_Fix_Time
    	self.mainCamera.stateMachine:changeState(state)

		self.stage = 3
	--隐藏玩家
	elseif self.stage == 3 then
		role.character.transform.localScale = UnityEngine.Vector3(2.5,2.5,2.5)
		self.player.stateMachine:changeState(PlayerHideState.new()) --进入隐藏状态
		--self.player:setSuitVisible(false)
		local cureentState = PathFindingState.new() --加入寻路状态
    	cureentState.duringTime = self.ongoing_time_cap
    	cureentState.X_MoveSpeed = self.ContinuedSpeed
    	cureentState.Z_MoveSpeed = self.ContinuedSpeed
    	cureentState.isNeedSwing = false
    	cureentState.CleanMonsterDistance = self.CleanMonsterDistance
    	self.player.stateMachine:addSharedState(cureentState)

	    self:PlayEffect(role,self.effect_map[3],true)
		self.stage = 4
	--正常移动
	elseif self.stage == 4 then
		self.ongoing_time = self.ongoing_time + dTime
		
		if self.ongoing_time >= self.ongoing_time_cap and self.player.stateMachine.sharedStates["PathFindingState"] == nil then
			role.stateMachine:changeState(nil)
		end
	end
	--播放动作
	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	if self.act_map[self.stage]~=nil and animInfo:IsName(self.act_map[self.stage]) == false then
		self.animator:Play(self.act_map[self.stage])
	end
end

function PikachuCaptainState:Exit(role)
	self.super.Exit(self,role)
    self.player.gameObject.transform:Translate(0,0,0)--下降偏移量
    --self.player:setSuitVisible(true)
	self.player.stateMachine:changeState(RunState.new())
	role:inactive()
	self:PlayEffect(role,self.effect_map[4])
	GetCurrentSceneUI().uiCtrl:SetSkillCDTime(self.CD_time) 	--记录CD时间
	--恢复摄像机
	local state = CameraZForwardState.new() --恢复状态
    state.zAxisFixedPoint = Vector3.zero
    state.zAxisMoveingTime = self.camera_Reset_Time
    self.mainCamera.stateMachine:changeState(state)
    self.player.stateMachine:removeSharedStateByName("PlayingSkillState")
end

function PikachuCaptainState:PlayEffect(role,effectName,loop)
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