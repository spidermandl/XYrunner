--[[
author:Huqiuxiang
萌宠图鉴界面逻辑
]]

PetHandbookView = class ()

PetHandbookView.scene = nil --场景scene
PetHandbookView.management = nil -- 数据model
PetHandbookView.mountTxt = nil -- 坐骑宠物表
PetHandbookView.petTable = nil -- 坐骑宠物类型表

PetHandbookView.panel = nil -- 面板
PetHandbookView.items = nil 
PetHandbookView.itemGrid = nil -- icon的root
PetHandbookView.petDescrip = nil -- 宠物描述
PetHandbookView.modelShow = nil

-- 初始化
function PetHandbookView:init(target)
	self.scene = target
	self.management = self.scene.petManagement
	self.petTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
	self.mountTxt = TxtFactory:getTable(TxtFactory.MountTXT)
	self.modelShow = self.scene.modelShow
	self.panel = self.scene:LoadUI("Pet/PetHandbookUI")
	self.items = self.panel.transform:FindChild("UI/items")
	self.itemGrid = self.items:GetChild(0)
	self.petDescrip = self.panel.transform:Find("UI/title/leftLabel"):GetComponent("UILabel")
	self.scene:SetUiAnChor()
	self:initPetList()
	self.scene:boundButtonEvents(self.panel)
	self:SetActive(false)

	--关闭
	AddonClick(self.panel.transform:FindChild("UI/left/PetHandbookUI_close"),function( ... )
		-- body
		self.scene:petHandbookView_closeBtn()
	end)
end

function PetHandbookView:SetActive(enable)
	self.panel:SetActive(enable)
	if enable then
		self:listUpdate()
		local btn = self.itemGrid.gameObject.transform:GetChild(0) -- 默认选中第一个
		self:iconListOnClick(btn.gameObject)
	end
end

function PetHandbookView:initPetList()
	local mountTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
	local petOnlyTab = mountTable:GetPetIdList()
	local item = nil
	for k,v in pairs(petOnlyTab) do
		local tid = self.mountTxt:GetData(v, TxtFactory.S_MOUNT_INIT_ID) -- 初始ID
		if self:PetIsOpen(tid) then
			item = self.scene:creatPetIcon(tid,self.itemGrid)
			item.name = v
			local starGrid = item.transform:FindChild("starGrid")
			starGrid.gameObject:SetActive(false)
			self:SetOnclickIcon(item,tid)
		end
	end
end

function PetHandbookView:SetOnclickIcon(item,tid)
	-- body
	local btn = item.transform:FindChild("SeletePetIcon")
	AddonClick(btn,function(btn)
		-- body
		self:iconListOnClick(btn.transform.parent.gameObject)
	end) 
end
-- 更新图鉴列表
function PetHandbookView:listUpdate()
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS] -- 当前拥有的宠物
	self.management:getPetPiece()
	local piecePet = petInfo[TxtFactory.PIECE_PETS] -- 萌宠碎片

	-- local iconName = "blackIcon"

	-- 碎片
	-- for u = 1, #piecePet do
	-- 	local tid  = tonumber(piecePet[u].tid) * 10000 + 11 
	-- 	if self:PetIsOpen(tid) then
	-- 		local icon = self.scene:creatPetIcon(tid,self.itemGrid,self.panel)
	-- 		icon.name = iconName

	-- 		local maxNum = tonumber(piecePet[u].maxNum)
	-- 		local pNum = tonumber(piecePet[u].material.num)
	-- 		local pieceNum = icon.gameObject.transform:FindChild("pieceNum")
 --    		pieceNum.gameObject:SetActive(true)
 --    		local plabel = pieceNum:GetChild(0):GetComponent("UILabel")
 --    		plabel.text = tostring(maxNum) .. "/" .. tostring(pNum)

 --    		-- 品质更改外框
 --    		local rankData = "chongwutb5"
 --    		local rankIcon = icon.gameObject.transform:FindChild("iconback"):GetComponent("UISprite")
 --    		rankIcon.spriteName = rankData
	-- 		if pNum >= maxNum then
	-- 			rankIcon.spriteName = "chongwutb0"
	-- 		    	-- 名字更改
 --    			local nameLabel = icon.gameObject.transform:FindChild("name").gameObject.transform:GetComponent("UILabel")
 --    			nameLabel.text = ""
 --    			icon.name = "PetHandbook_zhaohuang,"..piecePet[u].tid.."_"..piecePet[u].material.id
	-- 		end

 --    		local starGrid = icon.gameObject.transform:FindChild("starGrid")
 --    		starGrid.gameObject:SetActive(false)

 --    		local infoBtn = icon.gameObject.transform:FindChild("petIconInfoBtn")
 --    		infoBtn.gameObject:SetActive(false)
	-- 	end
	-- end
	local grid = self.itemGrid:GetComponent("UIGrid")
    grid:Reposition() -- 自动排列
	local sv = self.items:GetComponent("UIScrollView")
    sv:ResetPosition()
end

-- 判断宠物是否开放
function PetHandbookView:PetIsOpen(petID)
	local m_type = self.mountTxt:GetData(petID,TxtFactory.S_MOUNT_TYPE)
	local open_type = self.petTable:GetData(m_type,"OPEN_TYPE")
	if tonumber(open_type) == 1 then
		return true
	end
	return false
end

-- icon 点击
function PetHandbookView:iconListOnClick(btn)
	local pet_type = btn.name
	local tid = self.mountTxt:GetData(pet_type, TxtFactory.S_MOUNT_INIT_ID) -- 初始ID

	local iconParent = find("PetHandbookUI_iconLeftRoot")
	for i = 1, iconParent.gameObject.transform.childCount do
        destroy(iconParent.gameObject.transform:GetChild(0).gameObject)
    end

	local icon = self.scene:creatPetIconBig(tid,iconParent)
	--icon.gameObject.transform.localScale = Vector3(1.5,1.5,1)
	local infoBtn = icon.gameObject.transform:FindChild("petIconInfoBtn")
    infoBtn.gameObject:SetActive(false)
    local ic = icon.gameObject.transform:FindChild("icon")
	local bigIcon = ic:Find("bigIcon") -- 隐藏背景图
	bigIcon.gameObject:SetActive(false)
	local stars = ic:Find("starGrid")
	stars.gameObject:SetActive(false)
	self.petDescrip.text = self.petTable:GetData(pet_type, "PETDESC")

	-- 显示宠物模型
	self.modelShow:ChoosePet(pet_type)
end

-- 召唤
function PetHandbookView:zhaohuan(btn)
	local array = lua_string_split(tostring(btn.name),"_")
	self.management:sendCallPet(tonumber(array[2]),tonumber(array[3]))
end

