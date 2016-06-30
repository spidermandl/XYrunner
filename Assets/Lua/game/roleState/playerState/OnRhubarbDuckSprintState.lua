--[[
author: Desmond
在大黄鸭上冲刺状态
]]

OnRhubarbDuckSprintState = class (BasePlayerState)

OnRhubarbDuckSprintState._name = "OnRhubarbDuckSprintState"
OnRhubarbDuckSprintState.skillId = nil
OnRhubarbDuckSprintState.ongoing_time_cap = nil --持续时间
OnRhubarbDuckSprintState.camera_Fix_Time = nil --摄像机拉远时间
OnRhubarbDuckSprintState.camera_Reset_Time = nil --摄像机恢复时间
OnRhubarbDuckSprintState.mainCamera = nil --主摄像机
OnRhubarbDuckSprintState.effect = nil --特效
OnRhubarbDuckSprintState.effectManager = nil --特效管理类
OnRhubarbDuckSprintState.character = nil --保存的角色模型
function OnRhubarbDuckSprintState:Enter(role)
	self.super.Enter(self,role)
    local skillTxt = TxtFactory:getTable(TxtFactory.PetSkillMainTXT)
    local actionTxt = TxtFactory:getTable(TxtFactory.PetAnimTXT)
    local action_id = skillTxt:GetData(self.skillId,TxtFactory.S_MAIN_SKILL_ACTION_ID) --获取动作ID
    local cleanMonsterDistance = tonumber(skillTxt:GetData(self.skillId,TxtFactory.S_MAIN_SKILL_TARGET_SHAPE_PARA)) --清屏距离
    local cameraInfo = skillTxt:GetData(self.skillId,TxtFactory.S_MAIN_SKILL_D_F_DISTANCE)
    cameraInfo = lua_string_split(cameraInfo,"|")
    --获取摄像机作用时间
    self.camera_Fix_Time = tonumber(cameraInfo[2])
    self.camera_Reset_Time = self.camera_Fix_Time
    cameraInfo = lua_string_split(cameraInfo[1],";")
    --获取摄像机偏差Vector3(2,0.5,-9)
    local cameraD_F_Distance = Vector3(tonumber(cameraInfo[1]),tonumber(cameraInfo[2]),tonumber(cameraInfo[3]))
    local time_array = lua_string_split(skillTxt:GetData(self.skillId,TxtFactory.S_MOUNT_SKILL_CONTINUED_LEN),",")
    self.ongoing_time_cap = tonumber(time_array[1]) --获取持续时间
    --test end
    local ongoing_act = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_ACTION)
    self.act_map = {}
    self.act_map[1] = ongoing_act

    local appear_effect = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_EFFECT)
    local ongoing_effect = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_EFFECT)
    local end_effect = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_END_EFFECT)

    self.effect_map = {}
    self.effect_map[1] = appear_effect
    self.effect_map[2] = ongoing_effect
    self.effect_map[3] = end_effect

    local continuedSpeed = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_CONTINUED_SPEED)
    self.mainCamera = GetCurrentSceneUI().mainCamera

    local cureentState = PathFindingState.new() --加入寻路状态
    cureentState.duringTime = self.ongoing_time_cap
    cureentState.X_MoveSpeed = continuedSpeed
    cureentState.Z_MoveSpeed = continuedSpeed
    cureentState.CleanMonsterDistance = cleanMonsterDistance
    role.stateMachine:addSharedState(cureentState)
    --加载坐骑
    self.mount = PoolFunc:pickObjByPrefabName("Mount/".."dragon_mount")
    self.mount.transform.parent = role.gameObject.transform
    self.mount.transform.localRotation = Quaternion.Euler(0,90,0)
    self.mount.transform.localScale = UnityEngine.Vector3(2,2,2)
    self.mount.transform.localPosition = UnityEngine.Vector3.zero
    self.mountAnimator = self.mount:GetComponent("Animator")
    self.mountAnimator:Play(self.act_map[1])
    --role:initSuit("")
    role.animator:Play("RidingDragon")
    local uInfo = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    local bip = nil
    if uInfo[TxtFactory.USER_SEX] == 0 then
        bip = self.mount.transform:Find("Mount_Dragon@skin/Bip001/Dummy_for_male")
    elseif uInfo[TxtFactory.USER_SEX] == 1 then
        bip = self.mount.transform:Find("Mount_Dragon@skin/Bip001/Dummy_for_girl")
    end
    if bip ~= nil then
        role.character.transform.parent = bip.gameObject.transform
        role.character.transform.localPosition = Vector3.zero
        role.character.transform.localRotation = Quaternion.Euler(0,-90,0)
    end
    --龙冲刺特效
    self.effectManager = PoolFunc:pickSingleton("EffectGroup")
    self.effect = {}
    self.effect[1] = PoolFunc:pickObjByPrefabName("Effects/Common/"..self.effect_map[1]) --冲刺特效
    self.effect[1].transform.parent = self.mount.transform
    self.effect[1].transform.localRotation = Quaternion.Euler(0,0,0)
    self.effect[1].transform.localPosition = UnityEngine.Vector3(0,0,0)
    self.effect[1].transform.localScale = Vector3.one

    self.effect[2] = PoolFunc:pickObjByPrefabName("Effects/Common/"..self.effect_map[2])
    self.effect[2].transform.parent = find("Bone_R_wing03_01").gameObject.transform --右翅膀骨骼点
    self.effect[2].transform.localRotation = Quaternion.Euler(0,0,0)
    self.effect[2].transform.localPosition = UnityEngine.Vector3(0,0,0)
    self.effect[2].transform.localScale = Vector3.one

    self.effect[4] = PoolFunc:pickObjByPrefabName("Effects/Common/"..self.effect_map[2])
    self.effect[4].transform.parent = find("Bone_L_wing03_01").gameObject.transform --左翅膀骨骼点
    self.effect[4].transform.localRotation = Quaternion.Euler(0,0,0)
    self.effect[4].transform.localPosition = UnityEngine.Vector3(0,0,0)
    self.effect[4].transform.localScale = Vector3.one

    self.effect[3] = PoolFunc:pickObjByPrefabName("Effects/Common/"..self.effect_map[2])
    self.effect[3].transform.parent = find("Bone_tail03").gameObject.transform --尾巴骨骼点
    self.effect[3].transform.localRotation = Quaternion.Euler(0,0,0)
    self.effect[3].transform.localPosition = UnityEngine.Vector3(0,0,0)
    self.effect[3].transform.localScale = Vector3.one
    
    
    self.effectManager:addObject(self.effect[1],true)
    self.effectManager:addObject(self.effect[2],true)
    self.effectManager:addObject(self.effect[3],true)
    self.effectManager:addObject(self.effect[4],true)
    --拉远摄像机
    local state = CameraFollowState.new() --拉远状态
    state.zAxisFixedPoint = cameraD_F_Distance
    state.zAxisMoveingTime = self.camera_Fix_Time
    self.mainCamera.stateMachine:changeState(state)
end

function OnRhubarbDuckSprintState:Excute(role,dTime)
end
function OnRhubarbDuckSprintState:Exit(role)
    role.character.transform.parent = role.gameObject.transform
    role.character.transform.localPosition = Vector3.zero
    PoolFunc:inactiveObj(self.mount)

    local endEffect = PoolFunc:pickObjByPrefabName("Effects/Common/"..self.effect_map[3])
    endEffect.transform.parent = role.gameObject.transform
    endEffect.transform.localRotation = Quaternion.Euler(0,0,0)
    endEffect.transform.localPosition = UnityEngine.Vector3.zero
    self.effectManager:addObject(endEffect)
        --恢复摄像机
    local state = CameraZForwardState.new() --恢复状态
    state.zAxisFixedPoint = Vector3.zero
    state.zAxisMoveingTime = self.camera_Reset_Time
    self.mainCamera.stateMachine:changeState(state)
    --隐藏特效
    self.effectManager:removeObject(self.effect[1])
    self.effectManager:removeObject(self.effect[2])
    self.effectManager:removeObject(self.effect[3])
    self.effectManager:removeObject(self.effect[4])
end
