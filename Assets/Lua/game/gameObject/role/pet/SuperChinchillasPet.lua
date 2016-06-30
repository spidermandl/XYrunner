--[[
    author：赵名飞
    超级村长
]]

SuperChinchillasPet = class (BasePet)
SuperChinchillasPet.type = 'SuperChinchillasPet'

function SuperChinchillasPet:Awake()
    self.super.Awake(self)
end
function SuperChinchillasPet:initParam()
    self.super.initParam(self)
end

--进入萌宠主动技能发动状态
function SuperChinchillasPet:triggerCaptainSkill()
    self.gameObject.transform.parent = GetCurrentSceneUI().mainCamera.gameObject.transform
    self.gameObject.transform.localPosition = Vector3(-30,0,0) --移出视野范围
    --self.gameObject.transform.localScale = UnityEngine.Vector3(1,1,1)
    self.character.transform.localRotation = Quaternion.Euler(0,90,0)
    self.stateMachine:changeState(SuperChinchillasCaptainState.new())
    local petTxt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local skill_id = petTxt:GetData(self.petTypeID,TxtFactory.S_MOUNT_ACTIVE_SKILLS)
    self.role:playSkill(skill_id,self.petTypeID)
end