--[[
author:hanli_xiong
通用的模型展示类
]]

ModelShow = class()

ModelShow.scene = nil -- 附属场景
ModelShow.modelRoot = nil -- 模型的根节点
ModelShow.name = "ModelShow"
ModelShow.prefabName = "Player/modelShow"

ModelShow.userTable = nil -- 玩家数据表
ModelShow.mountTable = nil -- 玩家坐骑宠物表
ModelShow.suitTable = nil -- 玩家套装表
ModelShow.buildTable = nil -- 建筑物表

-- 模型展内容
ModelShow.character = nil -- 角色节点
ModelShow.characterList = nil
ModelShow.pet = nil -- 宠物节点
ModelShow.petList = nil
ModelShow.mount = nil -- 坐骑节点
ModelShow.mountList = nil
ModelShow.doublePet = nil -- 双宠物节点 -- 用于融合宠物
ModelShow.leftPetList = nil
ModelShow.rightPetList = nil
ModelShow.equip = nil -- 装备节点
ModelShow.equipList = nil
ModelShow.suit = nil -- 套装节点
ModelShow.suitList = nil
ModelShow.building = nil -- 建筑物节点
ModelShow.buildingList = nil

ModelShow.commonFlyPet = nil -- 通用飞行宠
ModelShow.commonFlyPetList = nil 
ModelShow.commonAidPet = nil -- 通用支援宠
ModelShow.commonLeftAidPetList = nil
ModelShow.commonRightAidPetList = nil

-- 通用模型展示方法
ModelShow.commonShow = nil -- fun(模型父节点, 模型列表, 要展示的模型ID, 模型名)

-- 初始化模型展
function ModelShow:Init(targetScene)
	self.scene = targetScene
	-- 数据
	self.userTable = TxtFactory:getTable(TxtFactory.UserTXT)
	self.mountTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
	self.suitTable = TxtFactory:getTable(TxtFactory.SuitTXT)
	self.buildTable = TxtFactory:getTable(TxtFactory.BuildingTXT) --获取建筑表

	-- 模型展根节点
	self.modelRoot = find(self.name)
	if self.modelRoot == nil then
		self.modelRoot = newobject(Util.LoadPrefab(self.prefabName))
	end
	
	self.modelRoot.name = self.name
	self.character = self.modelRoot.transform:Find("character")
	self.characterList = {}
	self.pet = self.modelRoot.transform:Find("pet")
	self.petList = {}
	self.petList2 = {}
	self.CurShowModer = {}
	self.mount = self.modelRoot.transform:Find("mount")
	self.mountList = {}
	self.doublePet = self.modelRoot.transform:Find("doublePet")
	self.leftPetList = {}
	self.rightPetList = {}
	self.equip = self.modelRoot.transform:Find("equip")
	self.equipList = {}
	self.suit = self.modelRoot.transform:Find("suit")
	self.suitList = {}
	self.building = self.modelRoot.transform:Find("building")
	self.buildingList = {}
	self.commonFlyPet = self.modelRoot.transform:Find("commonFlyPet")
	self.commonFlyPetList = {}
	self.commonAidPet = self.modelRoot.transform:Find("commonAidPet")
	self.commonRightAidPetList = {}
	self.commonLeftAidPetList = {}

	-- 定义通用模型展示方法
	self.commonShow = function (parent, modelList, modelId, modelName, m_position, m_rotation, m_scale)
		parent.gameObject:SetActive(true)
		for i=0, parent.childCount-1 do
			parent:GetChild(i).gameObject:SetActive(false)
		end
		if modelId == nil then -- 如果模型ID为空
			return
		end
		if not m_position then m_position = Vector3.zero end
		if not m_rotation then m_rotation = Quaternion.identity end
		if not m_scale then m_scale = Vector3.one end
		if modelList[modelId] == nil then
			modelList[modelId] = newobject(Util.LoadPrefab(modelName))
			self:FormatLayer(modelList[modelId])
			modelList[modelId].name = parent.gameObject.name .. "_" .. modelId
			modelList[modelId].transform.parent = parent
			--[[modelList[modelId].transform.localPosition = m_position
			modelList[modelId].transform.localScale = m_scale
			-- modelList[modelId].transform.localRotation = Quaternion.identity
			modelList[modelId].transform.localRotation = m_rotation]]
		else
			modelList[modelId]:SetActive(true)
		end
			local ttform = modelList[modelId].transform
			ttform.localPosition = m_position
			ttform.localScale = m_scale
			-- ttform.localRotation = Quaternion.identity
			ttform.localRotation = m_rotation
	end
end

-- 格式化模型层级
function ModelShow:FormatLayer(obj)
	obj.layer = 11 -- 模型展层
	if obj.transform.childCount == 0 then
		return
	end
	for i=0, obj.transform.childCount-1 do
		self:FormatLayer(obj.transform:GetChild(i).gameObject)
	end
end

-- obj = modelshow.character
function ModelShow:SetActive(enable, obj)
	if obj then
		obj.gameObject:SetActive(enable)
		return
	end
	local trans = self.modelRoot.transform
	for i=0, trans.childCount-1 do
		trans:GetChild(i).gameObject:SetActive(false)
	end
end

-- obj = modelshow.character
function ModelShow:GetActive(obj)
	if obj then
		return obj.gameObject.activeSelf
	else
		return false
	end
end

-- 选择角色
function ModelShow:ChooseCharacter(charId)
	local pName = "Player/"
	local suit_id = TxtFactory:getTable(TxtFactory.MemDataCache):getPlayerSuit()
    charId = self.suitTable:GetData(suit_id, TxtFactory.S_SUIT_TYPE)
	if charId ~= nil then
		local uInfo = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
		local modelName = self.suitTable:GetModelName(uInfo[TxtFactory.USER_SEX], charId)
		pName = pName .. modelName .."_generic"
	end
	
	local p, r, s = self.suitTable:GetTransform(charId)
	self.commonShow(self.character, self.characterList, charId, pName, p, r, s)
end

-- 选择坐骑 如果此ID不存在则隐藏所有坐骑模型
function ModelShow:ChooseMount(mountId)
	local pName = "Mount/"
	if mountId ~= nil then
		pName = pName .. self.mountTable:GetData(mountId, "MODEL")
	end
	
	local p, r, s = self.mountTable:GetTransform(mountId)
	self.commonShow(self.mount, self.mountList, mountId, pName, p, r, s)
end

-- 选择宠物 如果此ID不存在则隐藏所有宠物模型
function ModelShow:ChoosePet(petId, scale,showEf)

	if self.CurShowModer[1] ~= nil then
		self.CurShowModer[1]:SetActive(false)
		self.CurShowModer[1] = nil
	end
	if self.CurShowModer[2] ~= nil then
		self.CurShowModer[2]:SetActive(false)
		self.CurShowModer[2] = nil
	end

	local pName = "Pet/"
	if petId ~= nil then
		pName = pName .. self.mountTable:GetData(petId, "MODEL")
	end

	if scale then
		self.pet.localScale = scale
	else
		self.pet.localScale = Vector3.one
	end
	local p, r, s = self.mountTable:GetTransform(petId)

	p = Vector3.zero
	--r = Quaternion.Euler(tonumber(0),tonumber(180),tonumber(0))

	self.commonShow(self.pet, self.petList, petId, pName, p, r, s)
	local effectTrans = self.pet.transform:FindChild("ef_modelshow_liuguang")
	if showEf then
		effectTrans.gameObject:SetActive(true)
		SetEffectOrderInLayer(effectTrans,3) -- 设置特效层
	else
		effectTrans.gameObject:SetActive(false)
	end
	--GamePrintTable("CurShowModer 22231313131313")
	self.CurShowModer[0] = self.petList[petId]
end
ModelShow.petList2 = nil
ModelShow.CurShowModer = nil
function ModelShow:AddPetMode(petId,modelList,parent)
	-- body
	local pName = "Pet/".. self.mountTable:GetData(petId, "MODEL")

	modelList[petId] = newobject(Util.LoadPrefab(pName))
	local ttform = modelList[petId].transform
	ttform.gameObject.name = parent.gameObject.name .. "_" .. petId
	self:FormatLayer(ttform.gameObject)
	ttform.parent = parent
	return ttform.gameObject
end
function ModelShow:GetPetMode(petId,modelList)
	-- body
	local obj1 = modelList[petId]
	if obj1 == nil then
		obj1 = self:AddPetMode(petId,modelList,self.pet)
		obj1:SetActive(false)
	end
	return obj1
end
function ModelShow:InitPetModelPos(petId,ttform)
	self.pet.localScale = Vector3.one
	local p, r, s = self.mountTable:GetTransform(petId)
	if not p then p = Vector3.zero end
	if not r then r = Quaternion.identity end
	if not s then s = Vector3.one end
	ttform.localPosition = p
	ttform.localRotation = r
	ttform.localScale = s
end

function ModelShow:ChoosePet2(petId,pos)

	if self.CurShowModer[0] ~= nil then
		self.CurShowModer[0]:SetActive(false)
		self.CurShowModer[0] = nil
	end
	if self.CurShowModer[pos] ~= nil then
		self.CurShowModer[pos]:SetActive(false)
	end

	local obj1 = self:GetPetMode(petId,self.petList)
	if obj1.activeSelf then
		GamePrintTable("petList2 ="..tostring(petId))
	   obj1 = self:GetPetMode(petId,self.petList2)
	end
	obj1:SetActive(true)

	local ttform = obj1.transform
	self:InitPetModelPos(petId,ttform)
	local camerTar = self.modelRoot.transform;
	if pos == 1 then
		ttform.localPosition = ttform.localPosition + Vector3.New(-1.2,0,0)
		--ttform.localRotation = ttform.localRotation*Quaternion.Euler(0,-5,0)
		--ttform:LookAt(camerTar)
	elseif pos == 2 then
		ttform.localPosition = ttform.localPosition + Vector3.New(1.2,0,0)
		 --ttform.localRotation = ttform.localRotation*Quaternion.Euler(0,10,0)
		--ttform:LookAt(camerTar)
	end
	self.CurShowModer[pos] = obj1

end
-- 选择左右宠物 如果为nil则不展示
function ModelShow:ChooseDoublePet(leftPet, rightPet)
	self.doublePet.gameObject:SetActive(true)
	local left = self.doublePet:GetChild(0)
	local right = self.doublePet:GetChild(1)

	-- 左宠物
	local pName = "Pet/"
	if leftPet ~= nil then
		pName = pName .. self.mountTable:GetData(leftPet, "MODEL")
	end
	self.commonShow(left, self.leftPetList, leftPet, pName)
	-- 右宠物
	pName = "Pet/"
	if rightPet ~= nil then
		pName = pName .. self.mountTable:GetData(rightPet, "MODEL")
	end
	self.commonShow(right, self.rightPetList, rightPet, pName)
end

-- 选择套装
function ModelShow:ChooseSuit(suitId)
	local pName = "Player/"
	if suitId ~= nil then
		local uInfo = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
		local modelName = self.suitTable:GetModelName(uInfo[TxtFactory.USER_SEX], suitId)
		pName = pName .. modelName .."_generic"
	end
	
	local p, r, s = self.suitTable:GetTransform(suitId)
	self.commonShow(self.suit, self.suitList, suitId, pName, p, r, s)
end

-- 选择装备
function ModelShow:ChooseEquip(equipId)
	local pName = "Player/"
	if equipId ~= nil then
		local uInfo = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
		local modelName = self.suitTable:GetModelName(uInfo[TxtFactory.USER_SEX], equipId)
		pName = pName .. modelName .."_generic"
	end
	
	local p, r, s = self.suitTable:GetTransform(equipId)
	self.commonShow(self.equip, self.equipList, equipId, pName, p, r, s)
end

-- 选择装备
function ModelShow:ChooseBuilding(buildId)
	local pName = "Building/"
	if buildId ~= nil then
		pName = pName .. self.buildTable:GetData(buildId, "MODEL")
	end
	
	local p, r, s = self.buildTable:GetTransform(buildId)
	self.commonShow(self.building, self.buildingList, buildId, pName, p, r, s)
end

-- 选择 通用 飞行宠物
function ModelShow:ChooseCommonPet(flyPetId,AidPetLeft,AidPetRight)
	self.commonAidPet.gameObject:SetActive(true)
	local pName = "Pet/"
	local left = self.commonAidPet:GetChild(0)
	local right = self.commonAidPet:GetChild(1)
	if flyPetId ~= nil then
		pName = pName .. self.mountTable:GetData(flyPetId, "MODEL")
	end
	local p, r, s = self.mountTable:GetTransform(flyPetId)
	self.commonShow(self.commonFlyPet, self.commonFlyPetList, flyPetId, pName, p, r, s)
	pName = "Pet/"
	if AidPetLeft ~= nil then
		pName = pName .. self.mountTable:GetData(AidPetLeft, "MODEL")
	end
	p, r, s = self.mountTable:GetTransform(AidPetLeft)
	self.commonShow(left, self.commonLeftAidPetList, AidPetLeft, pName, p, r, s)
	pName = "Pet/"
	if AidPetRight ~= nil then
		pName = pName .. self.mountTable:GetData(AidPetRight, "MODEL")
	end
	p, r, s = self.mountTable:GetTransform(AidPetRight)
	self.commonShow(right, self.commonRightAidPetList, AidPetRight, pName, p, r, s)
end

-- 删除preb
function ModelShow:DestroyPet()
	GameObject.Destroy(self.modelRoot)
end

-- 显示人物模型以及他的宠物
function ModelShow:petShow()
    local petTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local  petTab = TxtFactory:getTable(TxtFactory.MemDataCache):getCurPetTab()
    -- print("上次萌宠数量"..petTab[1])
   -- local tab = {["fly"] =nil,["left"]=nil,["right"]=nil}
    for i =1, #petTab do
        -- local id = self.petTable:GetData(i,'ID')
        local ctid = tonumber(string.sub(tostring(petTab[i]),1,-5)) 
        --local petTpye = petTable:GetData(ctid,"TYPE")
		petTab[i] = ctid
		--[[
        if petTpye == "1" then
            petTab["fly"] = ctid
        end
        if petTpye == "2" then
            if petTab["left"] == nil then
                petTab["left"] = ctid
            else 
                petTab["right"] = ctid
            end
        end
		]]--
    end
    self:ChooseCommonPet( petTab[1],petTab[2],petTab[3])
end
