--[[
    author：赵名飞
    猫老师
]]

CatTeacherPet = class (BasePet)
CatTeacherPet.type = 'CatTeacherPet'

function CatTeacherPet:Awake()
    self.super.Awake(self)
end
function CatTeacherPet:initParam()
    self.super.initParam(self)
end

--进入萌宠主动技能发动状态
function CatTeacherPet:triggerCaptainSkill()
    self.gameObject.transform.parent = GetCurrentSceneUI().mainCamera.gameObject.transform
    self.gameObject.transform.localPosition = Vector3(-30,0,0) --移出视野范围
    --self.gameObject.transform.localScale = UnityEngine.Vector3(1,1,1)
    self.character.transform.localRotation = Quaternion.Euler(0,90,0)
    self.stateMachine:changeState(CatTeacherCaptainState.new())
    local petTxt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local skill_id = petTxt:GetData(self.petTypeID,TxtFactory.S_MOUNT_ACTIVE_SKILLS)
    self.role:playSkill(skill_id,self.petTypeID)
end