--[[
author:hanli_xiong
坐骑属性界面
]]

MountAttributeView = class()

MountAttributeView.scene = nil -- 所依附的场景对象
MountAttributeView.mountTxt = nil -- 坐骑等级信息表

-- ui
MountAttributeView.trans = nil -- 属性UI根节点
MountAttributeView.attKey = nil -- 属性名文本
MountAttributeView.attValue = nil -- 属性值文本

MountAttributeView.curmount = nil -- 当前显示的ID

-- 初始化成员及UI对象
function MountAttributeView:Init(targetScene, transform)
	self.mountTxt = TxtFactory:getTable(TxtFactory.MountTXT)
	self.scene = targetScene
	self.trans = transform
	self.attKey = self.trans:Find("attKey"):GetComponent('UILabel')
	self.attValue = self.trans:Find("attValue"):GetComponent('UILabel')
	local str = self.mountTxt.Attribute.ADDSC .. "\n" ..
		self.mountTxt.Attribute.ADDATKSC .. "\n" ..
		self.mountTxt.Attribute.GOLD_SCORE .. "\n" ..
		self.mountTxt.Attribute.ADDHP
	self.attKey.text = str
	self.attValue.text = ""
end

function MountAttributeView:SetActive(enable, tid)
	self.trans.gameObject:SetActive(enable)
	if enable then
		self:ShowMountAttribute(tid)
	end
end

-- 显示坐骑属性详情 mountId = 1230010
function MountAttributeView:ShowMountAttribute(mountId)
	if mountId == self.curmount then
		return
	else
		self.curmount = mountId
	end
	local mountIdNext = self.mountTxt:GetNextLevel(mountId) -- 下一级坐骑ID
	if tonumber(mountId) == tonumber(mountIdNext) then
		self.attValue.text = self.mountTxt:GetData(mountId, "ADDSC") .. "\n" ..
			self.mountTxt:GetData(mountId, "ADDATKSC") .. "\n" ..
			self.mountTxt:GetData(mountId, "COLLECTIONS_SCORE") .. "\n" ..
			self.mountTxt:GetData(mountId, "ADDHP")
		return
	end
	local str = self.mountTxt:GetData(mountId, "ADDSC") .. " >[FF0000] " .. self.mountTxt:GetData(mountIdNext, "ADDSC") .. "[-]\n" ..
		self.mountTxt:GetData(mountId, "ADDATKSC") .. " >[FF0000] " .. self.mountTxt:GetData(mountIdNext, "ADDATKSC") .. "[-]\n" ..
		self.mountTxt:GetData(mountId, "COLLECTIONS_SCORE") .. " >[FF0000] " .. self.mountTxt:GetData(mountIdNext, "COLLECTIONS_SCORE") .. "[-]\n" ..
		self.mountTxt:GetData(mountId, "ADDHP") .. " >[FF0000] " .. self.mountTxt:GetData(mountIdNext, "ADDHP") .. "[-]"
	self.attValue.text = str
end
