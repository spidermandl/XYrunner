--[[
  author:Desmond
  habi 跟随宠物

]]
HabiPet = class (BasePet)

function HabiPet:Awake()
    -- print("-----------------HabiPet Awake--->>>-----------------")
    self.super.Awake(self)

end

function HabiPet:initParam()
    self.super.initParam(self)
end
--进入萌宠被动技能发动状态（拉人）
function HabiPet:triggerFollowerSkill()
    --设置transform偏移
    self.gameObject.transform.rotation = UnityEngine.Quaternion.Euler(0,-90,0)
    self.character.transform.localRotation = Quaternion.Euler(0,180,0)
    self.character.transform.localScale = Vector3.one
    self.stateMachine:changeState(PetIdleState.new())
    
    self.gameObject.transform.localScale = UnityEngine.Vector3(1.5,1.5,1.5)
    --print("当前人物状态 ："..self.role.stateMachine:getState()._name)   
    if self.role.stateMachine:getState()._name == "DiveState" then
        self.stateMachine:changeState(PetEscortState.new())
        self.gameObject.transform:Translate(-0.6,2,0)  -- 偏移量
    elseif self.role.stateMachine:getState()._name == "DeadState" then
        self.stateMachine:changeState(PetRescueState.new())
        self.gameObject.transform:Translate(0,1,0)  -- 偏移量
    end
    --self:createEffect()
end
--进入萌宠主动技能发动状态
function HabiPet:triggerCaptainSkill()
    self.gameObject.transform.parent = GetCurrentSceneUI().mainCamera.gameObject.transform
    self.gameObject.transform.localPosition = Vector3(-100,0,0) --移出视野范围
    --self.gameObject.transform.localScale = UnityEngine.Vector3(1,1,1)
    self.character.transform.localRotation = Quaternion.Euler(0,90,0)
    self.stateMachine:changeState(HabiCaptainState.new())
    local petTxt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local skill_id = petTxt:GetData(self.petTypeID,TxtFactory.S_MOUNT_ACTIVE_SKILLS)
    self.role:playSkill(skill_id,self.petTypeID)
    GetCurrentSceneUI().uiCtrl:PlaySkillAmination(skill_id,self.petTypeID)
end




