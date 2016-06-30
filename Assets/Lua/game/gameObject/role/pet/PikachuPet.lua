--[[
    author：赵名飞
]]
PikachuPet = class (BasePet)
PikachuPet.type = 'PikachuPet'
function PikachuPet:Awake()
    self.super.Awake(self)
end

function PikachuPet:initParam()
    self.super.initParam(self)
end

--进入萌宠主动技能发动状态
function PikachuPet:triggerCaptainSkill()
    self.character.transform.localPosition = UnityEngine.Vector3(-100,0,0) --移出屏幕
    self.character.transform.localScale = UnityEngine.Vector3(1.5,1.5,1.5)
    self.character.transform.rotation = Quaternion.Euler(0,90,0)
    self.stateMachine:changeState(PikachuCaptainState.new())
    local petTxt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local skill_id = petTxt:GetData(self.petTypeID,TxtFactory.S_MOUNT_ACTIVE_SKILLS)
    self.role:playSkill(skill_id,self.petTypeID)
end

