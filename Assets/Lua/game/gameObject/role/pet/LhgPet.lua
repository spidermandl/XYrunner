--[[
author:赵名飞
魉皇鬼 
]]
LhgPet = class(BasePet)
LhgPet.type = 'LhgPet'

function LhgPet:Awake()
	self.super.Awake(self)
end
function LhgPet:initParam()
    self.super.initParam(self)
end

--进入萌宠主动技能发动状态
function LhgPet:triggerCaptainSkill()
    self.gameObject.transform.parent = GetCurrentSceneUI().mainCamera.gameObject.transform
    self.gameObject.transform.localPosition = Vector3(-100,0,0) --移出视野范围
    self.character.transform.localRotation = Quaternion.Euler(0,90,0)
    self.stateMachine:changeState(LhgCaptainState.new())
    local petTxt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local skill_id = petTxt:GetData(self.petTypeID,TxtFactory.S_MOUNT_ACTIVE_SKILLS)
    self.role:playSkill(skill_id,self.petTypeID)
end