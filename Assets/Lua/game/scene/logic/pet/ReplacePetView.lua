--[[
author:gaofei
替换萌宠界面
]]

ReplacePetView = class()

ReplacePetView.scene = nil -- 父场景
ReplacePetView.panel = nil -- 面板
ReplacePetView.petGrid = nil

ReplacePetView.petId = nil -- 当前要上场的宠物ID
-- 初始化
function ReplacePetView:init(targetScene, gameObj)
	self.scene = targetScene
	self.panel = gameObj
	self.petGrid = self.panel.transform:Find("Grid")
	self:ShowReplaceView(true)
	self.scene:boundButtonEvents(self.panel)
	self:ShowReplaceView(false)
end

-- 激活界面
function ReplacePetView:ShowReplaceView(enable)
	self.panel:SetActive(enable)
	if not enable then
		for i = 0 , self.petGrid.childCount-1 do
			destroy(self.petGrid:GetChild(i).gameObject)
		end
	end
end

-- 加载两个支援宠物
function ReplacePetView:InitChoice(petId)
	self.petId = petId
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local curPetTab = petInfo[TxtFactory.CUR_PETS]
	if curPetTab[2] == curPetTab[3] then
		error("same pet on")
		return
	end
	local index = 1
	for j = 0 , self.petGrid.childCount-1 do
		self.petGrid:GetChild(j).gameObject:SetActive(false)
	end
	local petTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
	local _txt = TxtFactory:getTable(TxtFactory.MountTXT)
	--local ReplacePetSolt2,ReplacePetSolt3 = nil,nil
	for i = 1,#curPetTab do
		local id = curPetTab[i]
		local tid = self.scene.petManagement:idDataForTid(id)
		local icon = self.scene:creatPetIcon(tid, self.petGrid)
		-- 隐藏感叹号
		icon.transform:Find("petIconInfoBtn").gameObject:SetActive(false)
		local ctid = _txt:GetData(tid,TxtFactory.S_MOUNT_TYPE)
		local level = _txt:GetData(tid, TxtFactory.S_MOUNT_LVL) -- 等级
		local btn = icon.transform:Find("SeletePetIcon")
		btn.name = "ReplacePetSolt"..i
		local levelLabel = icon.transform:Find("levelLabel")-- 更新等级信息
		levelLabel.gameObject:SetActive(true)
		local plabel = levelLabel:GetChild(0):GetComponent("UILabel")
		plabel.text = "lv." .. tostring(level)
		self.scene:boundButtonEvents(icon)

--[[		if i == 2 then
			ReplacePetSolt2 = btn
		elseif i == 3 then
			ReplacePetSolt3 = btn
		end]]
		self:SetReplacePet(btn,i,id)
	end
	
--[[	if ReplacePetSolt2 ~= nil then
		AddonClick(ReplacePetSolt2,function ( ... )
			-- body
			self.scene:uiReplacePetEvent("ReplaceLeft")
		end)
	else
		AddonClick(ReplacePetSolt2,function () end)
	end
	if ReplacePetSolt3 ~= nil then
		AddonClick(ReplacePetSolt3,function ( ... )
			-- body
			self.scene:uiReplacePetEvent("ReplaceRight")
		end)
	else
		AddonClick(ReplacePetSolt3,function () end)
	end]]

	local grid = self.petGrid:GetComponent("UIGrid")
	grid:Reposition()
end

function ReplacePetView:SetReplacePet(btn,i,oldid)
	-- body
	AddonClick(btn,function(btn)
		-- body
		local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
		if petInfo[TxtFactory.DUI_ZHANG] == oldid then
			print("队长贝替换 ！！！")
			petInfo[TxtFactory.DUI_ZHANG] = self.petId
			self.scene.petManagement:sendPetSetHeroRequest()
		end
		print("替换支援宠物"..tostring(i))
		self:ShowReplaceView(false)
		self.scene.petManagement:ReplacePetJoinState(self.petId, i)
		self.scene:petMainView_ListUpdate()
	end)
end
-- 2号为支援宠物
function ReplacePetView:ReplaceLeft()
	self:ShowReplaceView(false)
	print("替换2号支援宠物")
	self.scene.petManagement:ReplacePetJoinState(self.petId, 2)
	self.scene:petMainView_ListUpdate()
end

-- 3号为支援宠物
function ReplacePetView:ReplaceRight()
	self:ShowReplaceView(false)
	print("替换3号支援宠物")
	self.scene.petManagement:ReplacePetJoinState(self.petId, 3)
	self.scene:petMainView_ListUpdate()
end

