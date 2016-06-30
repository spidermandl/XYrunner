--[[
author:赵名飞
可达鸭队长技能
]]
PsyduckCaptainState =  class (BasePetState)
PsyduckCaptainState._name = "PsyduckCaptainState"
PsyduckCaptainState.stage = nil --状态步骤
PsyduckCaptainState.targetPos = nil--停留的目标位置
PsyduckCaptainState.CD_time = nil --cd时间
PsyduckCaptainState.act_map = nil --动作stage索引table
PsyduckCaptainState.effect_map = nil --动作特效索引table
PsyduckCaptainState.aristSpeed = nil -- 萌宠冲向玩家速度
PsyduckCaptainState.ContinuedSpeed = nil -- 萌宠飞行速度
PsyduckCaptainState.duringTime = nil --小可出现后持续显示时间

function PsyduckCaptainState:Enter(role)
	self.super.Enter(self,role)
    self.stage = 1 
    self.duringTime = 1
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
    self.success_rate = tonumber(time_array[1])
    --test end
    local appear_act = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_ACTION)
	local ongoing_act = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_ACTION)
	local end_act = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_END_ACTION)
    self.act_map = {}
    self.act_map[1] = ongoing_act
    self.act_map[2] = end_act
    self.act_map[3] = appear_act
	self.PrizeItemId = skillTxt:GetData(skill_id,TxtFactory.S_MAIN_SKILL_GAIN_VALUE)
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

function PsyduckCaptainState:Excute(role,dTime)
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
			--加入清屏状态
			if self.act_map[self.stage]~=nil and animInfo:IsName(self.act_map[self.stage]) == false then
				self.animator:Play(self.act_map[self.stage])
			else
				if animInfo.normalizedTime >= 1.0 then
					self:createMagnet(role)
					self.stage = 3
				end
			end
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
function PsyduckCaptainState:createMagnet(role)
	local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
	local luaName = txt:GetData(self.PrizeItemId,TxtFactory.S_MATERIAL_CLASS)
	local item = PoolFunc:pickObjByLuaName(luaName)
	item.transform.parent = find("item").transform
	item.transform.position = role.gameObject.transform.position
	item.transform.localRotation = Quaternion.Euler(0,90,0)
	item.transform.position.z = self.player.gameObject.transform.position.z
	item:SetActive(false)
	local sub = item:GetComponent(BundleLua.GetClassType())
	if sub == nil then
		sub = item:AddComponent(BundleLua.GetClassType())
		LuaShell.setPreParams(item:GetInstanceID(),self.PrizeItemId)--预置构造参数
		sub.luaName = luaName
	else
		local lua = LuaShell.getRole(item:GetInstanceID())
		lua.bundleParams = self.PrizeItemId
        lua:initParam()
	end
	item:SetActive(true)
end

function PsyduckCaptainState:Exit(role)
	self.super.Exit(self,role)
	role:createEffect()
	role:inactive()
	GetCurrentSceneUI().uiCtrl:SetSkillCDTime(self.CD_time) 	--记录CD时间
	self.player.stateMachine:removeSharedStateByName("PlayingSkillState")
end