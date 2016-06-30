--[[
author:hanli_xiong
坐骑技能信息界面
]]

MountSkillView = class()

MountSkillView.scene = nil -- 所依附的场景对象
MountSkillView.mountTxt = nil -- 坐骑等级信息表
MountSkillView.mountTypeTxt = nil -- 坐骑种类表
MountSkillView.mountSkillTxt = nil -- 坐骑技能信息表

-- ui
MountSkillView.trans = nil -- 技能UI根节点
MountSkillView.infoLabel = nil -- 技能详情文本
MountSkillView.skillIcon = nil -- 技能图标

MountSkillView.curmount = nil -- 当前显示的ID

-- 初始化成员及UI对象
function MountSkillView:Init(targetScene, transform)
	self.mountTxt = TxtFactory:getTable(TxtFactory.MountTXT)
	self.mountTypeTxt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
	self.mountSkillTxt = TxtFactory:getTable(TxtFactory.PetSkillMainTXT)
	self.scene = targetScene
	self.trans = transform
	self.infoLabel = self.trans:Find("LvpLabel"):GetComponent('UILabel')
	self.infoLabel.text = ""

end

function MountSkillView:SetActive(enable, tid)
	self.trans.gameObject:SetActive(enable)
	if enable then
		self:ShowMountSkill(tid)
	end
end

-- 显示坐骑技能详情 mountId = 1230010
function MountSkillView:ShowMountSkill(mountId)
	if mountId == self.curmount then
		return
	else
		self.curmount = mountId
	end
	local skillId = self.mountTypeTxt:GetData(self.mountTxt:GetTypeID(mountId), "ACTIVE_SKILLS")
	-- print("skillId = " .. skillId)
	local str = "技能名称:[FF0000]" .. self.mountSkillTxt:GetData(skillId, "NAME") .. "[-]\n"
	str = str .. self.mountSkillTxt:GetData(skillId, "SKILL_DSC")

	self.infoLabel.text = str
end

