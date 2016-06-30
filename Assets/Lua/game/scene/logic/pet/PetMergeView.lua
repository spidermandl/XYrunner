--[[
author:Huqiuxiang
萌宠融合功能逻辑
]]

PetMergeView = class ()

PetMergeView.scene = nil --场景scene
PetMergeView.management = nil -- 数据model

PetMergeView.explanPanel = nil -- 说明面板

PetMergeView.panel = nil -- 面板
PetMergeView.petTable = nil 
PetMergeView.myPetPanel = nil -- 我的萌宠面板
PetMergeView.mergePetTab = nil -- 融合存放萌宠tab
PetMergeView.leftIconRoot = nil 
PetMergeView.rightIconRoot = nil 
PetMergeView.leftBtn = nil 
PetMergeView.rightBtn = nil 
PetMergeView.leftpetBtn = nil 
PetMergeView.rightpetBtn = nil
PetMergeView.tipLabel = nil -- 融合提示文本

PetMergeView.aidItemPanel = nil -- 物品面板
PetMergeView.petSlot = nil 
PetMergeView.slotLeft = 1
PetMergeView.slotRight = 2

PetMergeView.explanPanel = nil -- 说明界面

PetMergeView.state = false -- 是否在融合状态

-- 初始化
function PetMergeView:init(target)
	self.scene = target
	self.management = self.scene.petManagement
	self.petTable = TxtFactory:getTable("MountTypeTXT")
	self.panel = self.scene:LoadUI("Pet/PetMergeUI")
	self.mergePetTab = {}
	self.leftIconRoot = self.panel.transform:FindChild("UI/info/PetMergeUI_leftRoot") 
	self.rightIconRoot = self.panel.transform:FindChild("UI/info/PetMergeUI_rightRoot")  
	self.leftBtn = self.panel.transform:FindChild("UI/PetMergeUI_coinBtn")
	self.rightBtn = self.panel.transform:FindChild("UI/PetMergeUI_diamonBtn")
	self.leftpetBtn = self.panel.transform:FindChild("UI/info/PetMergeUI_leftPetBtn")
	self.rightpetBtn = self.panel.transform:FindChild("UI/info/PetMergeUI_rightPetBtn")
	self.tipLabel = self.panel.transform:FindChild("UI/descrip/des1"):GetComponent("UILabel")
	self.scene:boundButtonEvents(self.panel)
	self.leftBtn.gameObject:SetActive(false)
	self.rightBtn.gameObject:SetActive(false)
	self.scene:SetUiAnChor()
	self:SetActive(false)
end

function PetMergeView:SetActive(enable)
	self.panel:SetActive(enable)
	if not enable then
		self:mergeEnd()
	end
end

-- 升星融合按钮 
function PetMergeView:coinMergeBtn()
	if self.state == true then
		return
	end
	if not self:isMoneyEnough(self.leftBtn) then
		return
	end
	local slotLeft = self.mergePetTab[self.slotLeft] -- 左边萌宠的id
	local slotRight = self.mergePetTab[self.slotRight]-- 右边萌宠的id
	-- 以上场的萌宠不能融合
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local curPetTab = petInfo[TxtFactory.CUR_PETS]
	for u = 1, #curPetTab do 
		if --[[curPetTab[u] == slotLeft or]] curPetTab[u] == slotRight  then
			local word = "已上场的怪不能升星融合"
			self.scene:promptWordShow(word)
			return
		end
	end

	self.management:sendMergePets()
	self.state = true
end

-- 变异融合按钮
function PetMergeView:diamondMergeBtn()
	if self.state == true then
		return
	end
	if not self:isMoneyEnough(self.rightBtn) then
		return
	end
	local slotLeft = self.mergePetTab[self.slotLeft] -- 左边萌宠的id
	local slotRight = self.mergePetTab[self.slotRight]-- 右边萌宠的id
	local slotLeftTid = self.management:idDataForTid(slotLeft)
	local slotRightTid = self.management:idDataForTid(slotRight)

	-- 以上场的萌宠不能融合
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local curPetTab = petInfo[TxtFactory.CUR_PETS]
	for u = 1, #curPetTab do 
		if curPetTab[u] == slotLeft or curPetTab[u] == slotRight  then
			local word = "已上场的怪不能变异融合"
			self.scene:promptWordShow(word)
			return
		end
	end
	
	self.management:sendPetVariation(slotLeft,slotRight)
	self.state = true
end

-- 说明按钮
function PetMergeView:explanBtn()
	if self.explanPanel == nil then
        self.explanPanel = SnatchExplainView.new()
        self.explanPanel:init(self.scene)
        self.explanPanel:InitData("1004002")
    end
    self.explanPanel:ShowView()
end

-- 关闭说明按钮
function PetMergeView:CloseExplanBtn()
	self.explanPanel:HiddenView()
end

-- 创建我的萌宠面板
function PetMergeView:creatMyPetPanel()
	if self.myPetPanel ~= nil then
		destroy(self.myPetPanel)
	end

	self.myPetPanel = self.scene:LoadUI("Pet/PetMypetUI")
	-- 添加按钮监听脚本
	self.scene:boundButtonEvents(self.myPetPanel)
	local ui =  self.myPetPanel.gameObject.transform:FindChild("UI")

	local grid = ui.gameObject.transform:FindChild("grid")
	local itemsGrid = grid.gameObject.transform:FindChild("PetMypetUI_itemsGrid")

	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS] 
	local _txt = TxtFactory:getTable(TxtFactory.MountTXT)
	for i = 1, #petTab do
		local tid = petTab[i].tid
		local icon = self.scene:creatPetIcon(tid,itemsGrid,self.panel)
		icon.name = petTab[i].id
		local level = _txt:GetData(tid, TxtFactory.S_MOUNT_LVL) -- 等级
		local levelLabel = icon.transform:FindChild("levelLabel")-- 更新等级信息
		levelLabel.gameObject:SetActive(true)
		local plabel = levelLabel:GetChild(0):GetComponent("UILabel")
		plabel.text = "lv." .. tostring(level)
		local joinTag = icon.transform:FindChild("tag") -- 上场标识
		joinTag.gameObject:SetActive(petTab[i].slot ~= 0)
	end
	itemsGrid:GetComponent("UIGrid"):Reposition()
	grid:GetComponent("UIScrollView"):ResetPosition()
end

-- 创建辅助道具面板
function PetMergeView:creatAidItemPanel()


end

-- 关闭辅助道具面板
function PetMergeView:aidItemPanel_closeBtn()
	destroy(self.aidItemPanel)
end

-- 左边萌宠按钮
function PetMergeView:leftPetBtn()
	self:creatMyPetPanel()
	self.myPetPanel.gameObject.transform.localPosition = Vector3(180,0,0)
	self.petSlot = self.slotLeft
end

-- 右边萌宠按钮
function PetMergeView:rightPetBtn()
	self:creatMyPetPanel()
	self.myPetPanel.gameObject.transform.localPosition = Vector3(-180,0,0)
	self.petSlot = self.slotRight
end

-- 我的萌宠面板关闭按钮
function PetMergeView:myPetPanel_closeBtn()
	destroy(self.myPetPanel)

end

-- 物品按钮
function PetMergeView:itemBtn()
	if self.aidItemPanel ~= nil then
		destroy(self.aidItemPanel)
	end

	self.aidItemPanel = self.scene:LoadUI("Pet/PetAuxiliaryItemUI")
	-- 添加按钮监听脚本
	self.scene:boundButtonEvents(self.aidItemPanel)

	-- closeBtn = find("PetAuxiliaryItemUI_close")
	-- local  closeBtnComponent = closeBtn.gameObject.transform:GetComponent("UIButtonMessage")
	-- closeBtnComponent.target = self.panel.gameObject

end

-- 我的萌宠面板Icon点击
function PetMergeView:myPetPanel_iconListOnClick(btn)
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local curPetTab = petInfo[TxtFactory.CUR_PETS]
    local petTab = petInfo[TxtFactory.BIN_PETS]
	local id = tonumber(btn.name)
	local tid = nil
	for i = 1, #petTab do
		if petTab[i].id == id then
			tid = petTab[i].tid
		end
	end

	-- 判断另一个孔是否已经存在
	for o = 1, #self.mergePetTab do
		if self.mergePetTab[o] == id then
			-- print("另一个位置已上场")
			local word = "另一个位置已上场"
			self.scene:promptWordShow(word)
			return
		end
	end

	-- print("融合萌宠选中"..tostring(tid)..id)
	self:creatIconBig(tid)

	self.mergePetTab[self.petSlot] = id

	self:btnStateSet()
	
	petInfo[TxtFactory.MERGE_PETSSLOTTAB] = self.mergePetTab
	
	-- 关闭我的萌宠界面
	self:myPetPanel_closeBtn()
end


function PetMergeView:btnStateSet()
	if #self.mergePetTab < 2 then
		self.leftBtn.gameObject:SetActive(false)
		self.rightBtn.gameObject:SetActive(false)
		return
	end 

	local slotLeft = self.mergePetTab[self.slotLeft]
	local slotRight = self.mergePetTab[self.slotRight]
	local slotLeftTid = self.management:idDataForTid(slotLeft) -- 主宠tid
	local slotRightTid = self.management:idDataForTid(slotRight)-- 副宠tid

	-- 获得该宠物信息(服务器同步信息)
    local leftPetInfo = self.management:GetPetInfoById(slotLeft)
    local rightPetInfo = self.management:GetPetInfoById(slotRight)
	local mainPetSkill = leftPetInfo.skill2 -- 主宠副技能tid
	local mainPetSkill_val = leftPetInfo.skill2_val -- 主宠副技能 经验值
	local passivePetSkill = rightPetInfo.skill2 -- 副宠副技能tid
	local passivePetSkill_val = rightPetInfo.skill2_val -- 副宠副技能 经验值

	local _txt = TxtFactory:getTable(TxtFactory.MountTXT)
	local petPassiveStar = _txt:GetData(slotRightTid,TxtFactory.S_MOUNT_STAR)-- 副宠星级
	local petMainStar = _txt:GetData(slotLeftTid,TxtFactory.S_MOUNT_STAR)-- 主宠星级
	local petPassiveLevel = _txt:GetData(slotRightTid,TxtFactory.S_MOUNT_LVL)-- 副宠等级
	local petMainLevel = _txt:GetData(slotLeftTid,TxtFactory.S_MOUNT_LVL)-- 主宠等级
	local ctidl = _txt:GetData(slotLeftTid, TxtFactory.S_MOUNT_TYPE) -- 左种类
    local ctidr = _txt:GetData(slotRightTid, TxtFactory.S_MOUNT_TYPE) -- 右种类

	local petMainType = self.petTable:GetData(ctidl,"RANK")
	local petPassiveType = self.petTable:GetData(ctidr,"RANK")

	-- 判断金币还是钻石
	local valueType = self.management:GetUpSkillNeed(mainPetSkill,mainPetSkill_val,petMainType,petPassiveType)

	-- 变异
		self.rightBtn.gameObject:SetActive(true)
		local price = self.management:getPetVariationPrice()
		self:btnValueSet(self.rightBtn,1,price)
	if ctidl ~= ctidr then
		self.tipLabel.text = "主宠被动技能升级"
	else
		self.tipLabel.text = "主宠主动技能升级"
	end
	if petMainStar < 5 then
		self.tipLabel.text = "主宠物升星+" .. self.tipLabel.text
	end
	-- 满级不能升
	if petMainStar > 5 and petMainLevel >= petMainStar * 5 + 5 then
		return
	end
	print("petPassiveStar"..petPassiveStar.."petMainStar"..petMainStar.."petMainLevel"..petMainLevel)
	-- 升星
	if petMainLevel >= petMainStar * 5 + 5 and petPassiveStar == petMainStar then
		print("升星")
		self.leftBtn.gameObject:SetActive(true)
		valueType = self.management:upStarTpye(petMainStar)
		local price = self.management:getPetUpStarPrice(petMainStar,valueType)
		self:btnValueSet(self.leftBtn,valueType,price)
	else
		print("升被动技能")
		self.leftBtn.gameObject:SetActive(true)
		local price = self.management:getPassiveSkillPrice(valueType,petMainType,mainPetSkill,petPassiveStar)
		self:btnValueSet(self.leftBtn,valueType,price)
	end
	-- 升副技能

end

-- 按钮价格显示
function PetMergeView:btnValueSet(btn,valueType,valueEnd)
	local iconSpriteName = nil
	if valueType == 1 then
		iconSpriteName = "zuanshi"
	elseif valueType == 2 then
		iconSpriteName = "jinbi"
	end
	local icon = btn.gameObject.transform:FindChild("icon"):GetComponent("UISprite")
	icon.spriteName = iconSpriteName

	local label = btn.gameObject.transform:FindChild("Label"):GetComponent("UILabel")
	label.text = valueEnd
end

-- 按钮提示是否有足够经费
function PetMergeView:isMoneyEnough(btn)
	local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	print("btn="..tostring(btn))
	local icon = btn.transform:FindChild("icon"):GetComponent("UISprite")
	local label = btn.transform:FindChild("Label"):GetComponent("UILabel")
	local num = tonumber(label.text)
	local can = false
	local text = ""
	if icon.spriteName == "zuanshi" then
		can = UserInfo[TxtFactory.USER_DIAMOND] >= num
		text = "钻石"
	elseif icon.spriteName == "jinbi" then
		can = UserInfo[TxtFactory.USER_GOLD] >= num
		text = "金币"
	end
	if not can then
		self.scene:promptWordShow(text.."不足")
	end
	return can
end

-- 左右侧创建大icon
function PetMergeView:creatIconBig(tid)
	local iconParent = nil
	if self.petSlot == self.slotLeft then
		iconParent = self:setBigIconBack(self.leftIconRoot,self.leftpetBtn,false)
	elseif self.petSlot == self.slotRight then
		iconParent = self:setBigIconBack(self.rightIconRoot,self.rightpetBtn,false)
	end

	self:clearBigIcon(iconParent)
	local icon =  self.scene:creatPetIconBig(tid,iconParent)
	icon.transform.localScale = Vector3(1.4,1.4,1)
	 -- 信息按钮
    local infoBtn = icon.transform:FindChild("petIconInfoBtn")
    infoBtn.gameObject:SetActive(false)
	local iconMes = icon.transform:FindChild("SeletePetIcon")
	iconMes.gameObject:SetActive(false)

end

function PetMergeView:setBigIconBack(root,btn,state)
	local iconParent = root
	local bg = btn.gameObject.transform:FindChild("icon")
	bg.gameObject:SetActive(state)

	return iconParent
end

-- 清空大icon图片
function PetMergeView:clearBigIcon(iconParent)
	for i=1,iconParent.gameObject.transform.childCount do
		destroy(iconParent.gameObject.transform:GetChild(i-1).gameObject)
	end
end

-- 融合完毕 成功
function PetMergeView:mergeEnd()
	self:clearBigIcon(self.leftIconRoot)
	self:setBigIconBack(self.leftIconRoot,self.leftpetBtn,true)
	self:clearBigIcon(self.rightIconRoot)
	self:setBigIconBack(self.rightIconRoot,self.rightpetBtn,true)
	self.leftBtn.gameObject:SetActive(false)
	self.rightBtn.gameObject:SetActive(false)
	-- 清除数据
	self.mergePetTab = {}
	-- for k,v in pairs(self.mergePetTab) do 
	-- 	table.remove(self.mergePetTab,k)
	-- end
	self.state = false
end

-- 融合结束
function PetMergeView:stateChange()
	self.state = false
end