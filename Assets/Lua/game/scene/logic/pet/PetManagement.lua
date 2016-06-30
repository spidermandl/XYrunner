--[[
 author: Huqiuxiang
 萌宠功能逻辑 数据部分
]]
PetManagement = class ()
 
PetManagement.userTable = nil  --用户表
PetManagement.scene = nil -- 场景lua

PetManagement.petTypeTable = nil -- 萌宠类型配置表
PetManagement.petTable = nil -- 萌宠信息表
PetManagement.MaterialTable = nil -- 物品配置表消息
PetManagement.petMergeTable = nil -- 融合配置表消息
PetManagement.PetSkillPassiveTXT = nil -- 融合配置表消息
PetManagement.battleItemsTable = nil -- 商城配置表

-- 初始化
function PetManagement:init()
	self.userTable = TxtFactory:getTable(TxtFactory.UserTXT)
	self.petTypeTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
	self.petTable = TxtFactory:getTable(TxtFactory.MountTXT)
	self.battleItemsTable = TxtFactory:getTable(TxtFactory.StoreConfigTXT)
	self.MaterialTable = TxtFactory:getTable(TxtFactory.MaterialTXT)
	self.petMergeTable = TxtFactory:getTable(TxtFactory.PetMergeTXT)
	self.petSkillPassiveTable = TxtFactory:getTable(TxtFactory.PetSkillPassiveTXT)
	-- self:getPetInfo()
end

-- 获取萌宠信息
function PetManagement:getPetInfo()
	local cur_pets = self.userTable:getValue("cur_pets")
	local bin_pets = self.userTable:getValue("bin_pets")
    local bin_pet = {}
	if bin_pets == nil then
		bin_pets = {}
	end
	for i = 1, #bin_pets do
		local  id  = bin_pets[i].id

		local tid = bin_pets[i].tid
		local ctid = self.petTable:GetData(tid, TxtFactory.S_MOUNT_TYPE)
		-- print("tid"..tid)
		local petType = self.petTypeTable:GetData(ctid,"TYPE")
		-- print("type"..petType)
		local tab = {id = nil ,tid = nil , slot = nil }
		if petType == "1" or petType == "2" then
			tab.id = id
			tab.tid = tid
			tab.slot = 0
			for u =1, #cur_pets do
				if id == cur_pets[u] then
					tab.slot = u

				end
			end

            bin_pet[#bin_pet + 1] = tab
		end
	end

	local memCache = TxtFactory:getTable("MemDataCache")
    local t = {}
  	memCache:setTable(TxtFactory.PetInfo,t)

	TxtFactory:setValue(TxtFactory.PetInfo,TxtFactory.BIN_PETS,bin_pet)
	TxtFactory:setValue(TxtFactory.PetInfo,TxtFactory.CUR_PETS,cur_pets)
	-- local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	-- local petTab = petInfo[TxtFactory.BIN_PETS]

end


-- 获取背包信息(发送)
function PetManagement:sendMaterialList()
	local json = require "cjson"
	local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.ItemListRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.ItemListRequest,
              data = strr, -- strr
            }


    MsgFactory:createMsg(MsgCode.ItemListResponse,self)
    NetManager:SendPost(NetConfig.ITEMINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end

-- 获取背包信息（返回）
function PetManagement:getMaterialList(info)
	local json = require "cjson"
  	local tab = json.decode(info.data)
  	local memCache = TxtFactory:getTable("MemDataCache")
  	if tab.bin_items == nil then
  		tab.bin_items = {}
  	end

  	memCache:setTable(TxtFactory.BagItemsInfo,tab)

end

-- 获取萌宠碎片（返回）
function PetManagement:getPetPieces()
	local material = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo)
	local flag = false -- 判断有没有字段 
	if material ~= nil then
		for i = 1, #material.bin_items do
		local materialType = string.sub(tostring(material.bin_items[i].tid),1,-4)
		-- print(materialType)
			if tonumber(materialType) == 130 then
				TxtFactory:setValue(TxtFactory.BagItemsInfo,TxtFactory.ITEMS_PETPIECE,material.bin_items[i])
				flag = true
				-- print("塞碎片")
			end
		end
	end


	if flag == false then
		local tab = {tid = 130101, num = 0 }
		TxtFactory:setValue(TxtFactory.BagItemsInfo,TxtFactory.ITEMS_PETPIECE,tab)
		-- print("塞碎片")
	end
end


-- 支援宠删选
function PetManagement:getAidPetTab()
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]
	local tab = {}
	for i = 1, #petTab do
		local tid =petTab[i].tid
		local ctid = self.petTable:GetData(tid, TxtFactory.S_MOUNT_TYPE)
		local petType = self.petTypeTable:GetData(ctid,"TYPE")
		if petType == "2" then
			tab[#tab +1] = petTab[i]
		end
	end

	TxtFactory:setValue(TxtFactory.PetInfo,TxtFactory.AID_PETS,tab)
end

-- 飞行宠删选
function PetManagement:getFlightPetTab()
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]
	local tab = {}
	for i = 1, #petTab do
		local tid = petTab[i].tid
		local ctid = self.petTable:GetData(tid, TxtFactory.S_MOUNT_TYPE)
		local petType = self.petTypeTable:GetData(ctid,"TYPE")
		if petType == "1" then
			tab[#tab +1] = petTab[i]
		end
	end

	TxtFactory:setValue(TxtFactory.PetInfo,TxtFactory.FLY_PETS,tab)
end

-- 筛选已经拥有的宠物经验材料
function PetManagement:getExpItemsTab()
	local BagItemsInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo)
	local tab = {}

	-- 已拥有萌宠经验物品
	for i =1 , #BagItemsInfo.bin_items do
		local id = BagItemsInfo.bin_items[i].tid
		local num = BagItemsInfo.bin_items[i].num
		local materialType = self.MaterialTable:GetData(id,"MATERIAL_TYPE")
    	if num > 0 and materialType == "6" then
			tab[#tab + 1] = BagItemsInfo.bin_items[i]
		end
	end
	-- print("所有材料".. #BagItemsInfo.bin_items.."已经拥有的宠物经验材料"..#tab)
	return tab
end

-- 设置宠物上场或下场状态
function PetManagement:SetPetJoinState(target_id)
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]
	local curPetTab = petInfo[TxtFactory.CUR_PETS]
	print("设置宠物上场或下场状态:"..tostring(target_id))
	local _info = self:GetPetInfoById(target_id)
	if not _info then
		error("找不到该宠物:"..tostring(target_id))
		return
	end
	local tid = _info.tid
	local ctid = self.petTable:GetData(tid, TxtFactory.S_MOUNT_TYPE) -- 种类
    local slot = _info.slot
	local stype = _info.slot == 0
	if slot ~= 0 then
		-- 下场逻辑
		
		if curPetTab[1] == target_id then
			--self.scene:promptWordShow("飞行宠物不能下场")
			curPetTab[1] = 0
			_info.slot = 0
			return
		end
		
		if curPetTab[2] == target_id then
			curPetTab[2] = 0
			_info.slot = 0
		elseif curPetTab[3] == target_id then
			curPetTab[3] = 0
			_info.slot = 0
		end
	else
		-- 上场逻辑
		local petType = 1 -- 1-- 表示飞行宠物 2- 表示支援宠物
		petType = self.petTypeTable:GetData(ctid,"TYPE")
		
		for i = 1 ,#curPetTab do
			if curPetTab[i] == 0 then
				-- 有空位置
				_info.slot = 1
				curPetTab[i] = target_id
				return
			end
		end
		self.scene:ChooseOnePetToReplace(target_id)
		--[[
		-- 选择的是飞行宠物
		if tonumber(petType) == 1 then
			if curPetTab[1] ~= 0 then
				local _info1 = self:GetPetInfoById(curPetTab[1])
				_info1.slot = 0
			end
			_info.slot = 1
			curPetTab[1] = target_id
		end
		-- 选择的是支援宠物
		if tonumber(petType) == 2 then
			if curPetTab[2] == 0 then
				_info.slot = 1
				curPetTab[2] = target_id
			elseif curPetTab[3] == 0 then
				_info.slot = 1
				curPetTab[3] = target_id
			else	
				-- local _info2 = self:GetPetInfoById(curPetTab[2])
				-- local _info3 = self:GetPetInfoById(curPetTab[3])
				-- curPetTab[3] = curPetTab[2]
				-- curPetTab[2] = target_id
				-- _info.slot = 1
				-- _info3.slot = 0
				self.scene:ChooseOnePetToReplace(target_id)
			end
		end
		]]--
	end
	--warn("pet1:"..curPetTab[1].."&pet2:"..curPetTab[2].."&pet3:"..curPetTab[3])
end

-- 替换上场宠物
function PetManagement:ReplacePetJoinState(target_id, place)
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local curPetTab = petInfo[TxtFactory.CUR_PETS]
	local _info = self:GetPetInfoById(target_id)
	local _infoold = self:GetPetInfoById(curPetTab[place])
	if not _info or not _infoold then
		error("找不到该宠物:"..tostring(target_id).."或:"..tostring(curPetTab[place]))
		return
	end
	_info.slot = 1
	_infoold.slot = 0
	curPetTab[place] = target_id
end

-- 萌宠上下场 判断 （发送）
function PetManagement:sendPetJoin()
	GamePrint("ggggggggggggg")
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local curPetTab = petInfo[TxtFactory.CUR_PETS]
	local json = require "cjson"
    --local msg = { cur_pets = curPetTab }
    --local strr = json.encode(msg)
	
	 local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = { cur_pets = curPetTab }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = pet_pb.SelPetRequest()
        for i = 1 , #curPetTab do
             message.cur_pets:append(curPetTab[i])
	    end
        strr = ZZBase64.encode(message:SerializeToString())
    end
	
    local param = {
              code = MsgCode.SelPetRequest,
              data = strr, -- strr
             }
    MsgFactory:createMsg(MsgCode.SelPetResponse,self)
    NetManager:SendPost(NetConfig.PET_EXCHANGE,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 萌宠上下场（返回）
function PetManagement:getPetJoin(info)
	local json = require "cjson"
  	local tab = json.decode(info.data)

  	if tab.result ~= 1 then
  		print("选择上场萌宠失败")
  		return
  	end
  	local ret_curpets = tab.cur_pets
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	-- local petTab = petInfo[TxtFactory.BIN_PETS]
	local curPetTab = petInfo[TxtFactory.CUR_PETS]
	if curPetTab[1] == ret_curpets[1] and curPetTab[2] == ret_curpets[2] and curPetTab[3] == ret_curpets[3] then
		print("选择上场萌宠成功")
	else
		petInfo[TxtFactory.CUR_PETS] = ret_curpets
	end
end

-- 根据ID判断是否满级
function PetManagement:isMaxLevel(tid)
	local next_tid = self.petTable:GetNextLevel(tid)
	return tonumber(next_tid) == tonumber(tid)
end

-- 根据ID判断是否需要升星
function PetManagement:isNeedUpStar(tid)
	local next_tid = self.petTable:GetNextLevel(tid)
	local cur_star = self.petTable:GetData(tid, TxtFactory.S_MOUNT_STAR) -- 当前等级星级
	local next_star = self.petTable:GetData(next_tid, TxtFactory.S_MOUNT_STAR) -- 下一等级星级
	return cur_star ~= next_star
end

-- 萌宠升级（发送）
function PetManagement:sendPetUpgrade()
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local uid = petInfo[TxtFactory.PETMAIN_SELECTED]
	local expItemSelectBtn = petInfo[TxtFactory.EXPITEM_SELECTED]
	local tid = self:idDataForTid(uid)
  	if not tid then return end
  	if self:isMaxLevel(tid) then
  		warn("该宠物已经满级了")
  		return
  	end

	local json = require "cjson"
	--local msg = { pet_uid = uid , item_uid = expItemSelectBtn}
    --local strr = json.encode(msg)
	 local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = { pet_uid = uid , item_uid = expItemSelectBtn}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = pet_pb.UpgradePetRequest()
        message.pet_uid = uid
        message.item_uid = expItemSelectBtn
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.UpgradePetRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.UpgradePetResponse,self)
    NetManager:SendPost(NetConfig.PET_UPGRADE,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end

-- 萌宠升级（返回）
function PetManagement:getPetUpgrade(info)
	local json = require "cjson"
  	local tab = json.decode(info.data)
	local cur_tid = 0
	local cur_exp = 0
  	if tab.result == 1 then
  		local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
		local petTab = petInfo[TxtFactory.BIN_PETS]

		-- local BagItemsInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo)
		local itemsInfo = self:getExpItemsTab()

		-- itemsInfo = tab.
		for i=1 ,#petTab do
			if petTab[i].id == tab.pet_info.id then
				cur_tid = petTab[i].tid
				petTab[i].tid = tab.pet_info.tid
				petTab[i].exp =  tab.pet_info.exp
			end
		end
		for i=1 ,#itemsInfo do
			if itemsInfo[i].tid == tab.item_info.tid then
				itemsInfo[i].num = tab.item_info.num
			end
		end

		TxtFactory:setValue(TxtFactory.PetInfo,TxtFactory.BIN_PETS,petTab)
		self.scene:OnUpgradeSucceed(cur_tid~=tab.pet_info.tid)
		self.scene:UpStarCheck(tab.pet_info.tid)

  	elseif tab.result == 2 then
  		print("物品不存在")
  	elseif tab.result == 0 then
  		-- 其他错误
  	end

end

-- 萌宠融合 发送
function PetManagement:sendMergePets()
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local mergePetTab = petInfo[TxtFactory.MERGE_PETSSLOTTAB]
	--GamePrintTable(mergePetTab)
	local slotLeft = mergePetTab[1]
	local slotRight = mergePetTab[2]
	-- if mergePetTab == nil or slotLeft == nil or slotRight == nil then

	local json = require "cjson"
	--local msg = { pet_uid1 =  slotLeft , pet_uid2 = slotRight}
   -- local strr = json.encode(msg)
	local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = { pet_uid1 =  slotLeft , pet_uid2 = slotRight}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = pet_pb.PetMergeRequest()
        message.pet_uid1 = slotLeft
		message.pet_uid2 = slotRight
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.PetMergeRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.PetMergeReponse,self)
    NetManager:SendPost(NetConfig.PET_MERGE,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    -- self:petMemDataCacheTableRemove(slotLeft)
    -- self:petMemDataCacheTableRemove(slotRight)

end

-- 萌宠融合 升星 返回
function PetManagement:getMergePets(info)
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local mergePetTab = petInfo[TxtFactory.MERGE_PETSSLOTTAB]
	local json = require "cjson"
	local tab = json.decode(info.data)

	GamePrintTable("萌宠融合 升星 返回")
	GamePrintTable(tab)
  	if tab.result == 1 then
  		-- 清除之前两个融合萌宠信息
  		local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
		local mergePetTab = petInfo[TxtFactory.MERGE_PETSSLOTTAB]
		local slotLeft = mergePetTab[1]
		local slotRight = mergePetTab[2]
		tab.new_pet.slot = self:idDataForSlot(slotLeft)
    	self:petMemDataCacheTableRemove(slotLeft)
    	self:petMemDataCacheTableRemove(slotRight)

    	-- 添加新萌宠信息
		--tab.new_pet.slot = 0 
		self:petMemDataCacheTableAdd(tab.new_pet)
		self.scene:creatPetShowPanel(tab.new_pet.id)
		self.scene:petMergeView_mergeEnd(tab.new_pet)
		local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
		memData:AddUserInfo(-tab.gold,-tab.diamond) -- 刷新面板
		self.scene:UpdatePlayerInfo()
  	else
	  	-- print("融合失败")
	  	if self.scene.petMergeView ~= nil then
			self.scene.petMergeView:stateChange() -- 融合状态改变
		else
			self.scene.petMainView:mergeFail()
		end
	end
end
--  萌宠 技能升级
function PetManagement:sendPetUpgradeSkillRequest()
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local mergePetTab = petInfo[TxtFactory.MERGE_PETSSLOTTAB]

	local slotLeft = mergePetTab[1]
	local slotRight = mergePetTab[2]

	local json = require "cjson"

	local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = { pet_uid1 =  slotLeft , pet_uid2 = slotRight}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = pet_pb.PetUpgradeSkillRequest()
        message.pet_uid1 = slotLeft
		message.pet_uid2 = slotRight
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.PetUpgradeSkillRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.PetUpgradeSkillResponse,self,"getPetUpgradeSkillResponse",PetMergeMsg.new())
    NetManager:SendPost(NetConfig.PET_JINENG,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end
--  萌宠 技能升级 返回
function PetManagement:getPetUpgradeSkillResponse(info)
	GamePrintTable("萌宠 技能升级 返回")
 	GamePrintTable(info)

 	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local mergePetTab = petInfo[TxtFactory.MERGE_PETSSLOTTAB]
	local json = require "cjson"
	local tab = json.decode(info.data)
  	if tab.result == 1 then
  		-- 清除之前两个融合萌宠信息
  		local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
		local mergePetTab = petInfo[TxtFactory.MERGE_PETSSLOTTAB]
		local slotLeft = mergePetTab[1]
		local slotRight = mergePetTab[2]
		tab.new_pet.slot = self:idDataForSlot(slotLeft)
    	self:petMemDataCacheTableRemove(slotLeft)
    	self:petMemDataCacheTableRemove(slotRight)

    	-- 添加新萌宠信息
		--tab.new_pet.slot = 0 
		self:petMemDataCacheTableAdd(tab.new_pet)
		self.scene:creatPetShowPanel(tab.new_pet.id)
		self.scene:petMergeView_mergeEnd(tab.new_pet)
		local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
		memData:AddUserInfo(-tab.gold,-tab.diamond) -- 刷新面板
		self.scene:UpdatePlayerInfo()
  	else
	  	-- print("技能升级 失败")
	  	if self.scene.petMergeView ~= nil then
			self.scene.petMergeView:stateChange() -- 融合状态改变
		else
			self.scene.petMainView:mergeFail()
		end
	end
end

--  萌宠 设置队长
function PetManagement:sendPetSetHeroRequest()
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local duizhang = petInfo[TxtFactory.DUI_ZHANG]


	local json = require "cjson"

	local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = { pet_uid =  duizhang }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = pet_pb.PetSetHeroRequest()
        message.pet_uid = duizhang
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.PetSetHeroRequest,
              data = strr, -- strr
             }
    --GamePrintTable("萌宠 设置队长="..duizhang)
    MsgFactory:createMsg(MsgCode.PetSetHeroResponse,self,"getPetSetHeroResponse",PetMergeMsg.new())
    NetManager:SendPost(NetConfig.PET_DUIZHANG,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end
--  萌宠 设置队长 返回
function PetManagement:getPetSetHeroResponse(info)
	--GamePrintTable("萌宠 设置队长 返回")
	--GamePrintTable(info)
	local json = require "cjson"
	local tab = json.decode(info.data)
	local result = tab.result
  	if  result == 1 then
  		--成功
  	else 
  		-- print("设置队长失败")
	end
end
-- 升副技能
function PetManagement:GetUpSkillNeed(petMainSkillId,petMainSkillId_val,petMainType,petPassiveType)
	local valueType = nil -- 价格类型 1 为钻石 2 为金币
	local curSkill_val = petMainSkillId_val -- 副技能当前值
	local maxSkill_val = self.petSkillPassiveTable:GetData(petMainSkillId,"SKILL_END")
	local nextSkill_val = nil

	local nextSkillYF = "PET_"..petPassiveType.."_EXP"
	nextSkill_val = tonumber(self.petSkillPassiveTable:GetData(petMainSkillId,nextSkillYF))

	-- 如果升级该被动技能将使得该被动技能属性值超过最大属性值的80% 则花钻石 否则花金币
	if curSkill_val + nextSkill_val > maxSkill_val * 0.8 then
		valueType = 1
	else
		valueType = 2
	end
	return valueType
end

function PetManagement:petTypeToNum(t)
	local num = nil
	if t == "B" then
		num = 1
	elseif t == "A" then
		num = 2
	elseif t == "S" then
		num = 3
	elseif t == "SS" then
		num = 4
	end

	return num
end

-- 升星钻石金币类型判断
function PetManagement:upStarTpye(star)
	local valueType = nil
	if star == 1 then
		valueType = 2
	else
		valueType = 1
	end
	return valueType 
end

-- 获得萌宠变异价格
function PetManagement:getPetVariationPrice()
	local diamondData = tonumber(self.petMergeTable:GetData(101001,"PROBABILITY_PRICE")) 
	return diamondData
end

-- 获得萌宠升星价格
function PetManagement:getPetUpStarPrice(star,typeValue)
	local priceKey = nil
	local priceBase = nil
	if typeValue == 2 then
		priceKey = "GOLD_PRICE"
		priceBase = tonumber(self.petMergeTable:GetData(101001,priceKey))
	elseif typeValue == 1 then
		priceKey = "DIAMOND_PRICE"
		local DIAMOND_PRICE = self.petMergeTable:GetData(101001,priceKey)
		local DIAMOND_PRICEd = string.gsub(DIAMOND_PRICE,'"',"")
		local DIAMOND_PRICE_array = lua_string_split(tostring(DIAMOND_PRICEd),",")
		priceBase = tonumber(DIAMOND_PRICE_array[star-1])

	end

	local star_modulus = self.petMergeTable:GetData(101001,"STAR_MODULUS")
	local star_modulusd = string.gsub(star_modulus,'"',"")
	local star_modulus_array = lua_string_split(tostring(star_modulusd),";")
	local star_modulus_value = tonumber(star_modulus_array[star])

	local valueEnd = priceBase * star_modulus_value

	print("升星"..valueEnd)
	return	valueEnd

end

-- 获得萌宠副技能升级价格
function PetManagement:getPassiveSkillPrice(priceType,petMainType,petMainSkillId,petPassiveStar)
	local up_skill_val = nil
	local valueEnd = nil
	local typeNum = self:petTypeToNum(petMainType)
	local zhu_pet_modulus = self.petSkillPassiveTable:GetData(petMainSkillId,"ZHU_PET_MODULUS")
	local zhu_pet_modulusd = string.gsub(zhu_pet_modulus,'"',"")
	local zhu_pet_modulus_array = lua_string_split(tostring(zhu_pet_modulusd),";")
	local zhu_pet_modulus_value = tonumber(zhu_pet_modulus_array[typeNum])
	local star_modulus = self.petSkillPassiveTable:GetData(petMainSkillId,"STAR_MODULUS")
	local star_modulusd = string.gsub(star_modulus,'"',"")
	local star_modulus_array = lua_string_split(tostring(star_modulusd),";")
	local star_modulus_value = tonumber(star_modulus_array[petPassiveStar])

	local priceData = nil
	if priceType == 1 then
		priceData = "UP_SKILL_DIAMIND"
	elseif priceType == 2 then
		priceData = "UP_SKILL_GOLD"
	end
	
	up_skill_val = tonumber(self.petSkillPassiveTable:GetData(petMainSkillId,priceData))

	valueEnd = up_skill_val * zhu_pet_modulus_value * star_modulus_value

	return valueEnd
end

-- 萌宠变异 发送
function PetManagement:sendPetVariation(petleft,petright)
	local diamondData = tonumber(self.petMergeTable:GetData(101001,"PROBABILITY_PRICE")) 
	-- print("diamondData"..diamondData)
	local json = require "cjson"
	--local msg = { pet1 =  petleft , pet2 = petright , diamond = diamondData }
   -- local strr = json.encode(msg)
	
	local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = { pet1 =  petleft , pet2 = petright , diamond = diamondData }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = pet_pb.PetVariationRequest()
        message.pet1 = petleft
		message.pet2 = petright
		message.diamond = diamondData
        strr = ZZBase64.encode(message:SerializeToString())
    end
	
    local param = {
              code = MsgCode.PetVariationRequest,
              data = strr, -- strr
             }
    GamePrintTable("变异 petleft＝"..petleft.."||petright ="..petright)
    MsgFactory:createMsg(MsgCode.PetVariationResponse,self)
    NetManager:SendPost(NetConfig.PET_VARIAT,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 萌宠变异 返回
function PetManagement:getPetVariation(info)

	GamePrintTable("萌宠变异 萌宠变异 返回")
	GamePrintTable(info)
	local json = require "cjson"
	local tab = json.decode(info.data)
  	if tab.result == 1 then
  		-- 清除之前两个融合萌宠信息
  		local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
		local mergePetTab = petInfo[TxtFactory.MERGE_PETSSLOTTAB]
		local slotLeft = mergePetTab[1] -- 主宠
		local slotRight = mergePetTab[2] -- 副宠
    	self:petMemDataCacheTableRemove(slotLeft)
    	self:petMemDataCacheTableRemove(slotRight)
		-- 清楚上场信息
    	-- 添加新萌宠
  		tab.new_pet.slot = 0 
		self:petMemDataCacheTableAdd(tab.new_pet)
		self.scene:creatPetShowPanel(tab.new_pet.id)
		self.scene:petMergeView_mergeEnd(tab.new_pet)
		--融合音效
		TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.variation_success)
		local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
		if not tab.gold then tab.gold = 0 end
		if not tab.diamond then tab.diamond = 0 end
		memData:AddUserInfo(-tab.gold,-tab.diamond) -- 刷新面板
		self.scene:UpdatePlayerInfo()
	elseif tab.result == 0 then
		local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
		if not tab.gold then tab.gold = 0 end
		if not tab.diamond then tab.diamond = 0 end
		memData:AddUserInfo(-tab.gold,-tab.diamond) -- 刷新面板
		local word = "变异失败"
		self.scene:promptWordShow(word)
  	end

  	if self.scene.petMergeView then
  		self.scene.petMergeView:stateChange() -- 融合状态改变
  	else
  		self.scene.petMainView.isSendMessage = false
  	end
end

-- 萌宠抽取 发送
function PetManagement:sendPetLettory(l_type,l_id,l_coins,l_diamond)
	--GamePrint("@@@@@@@@@@@@@@@@")
	local json = require "cjson"
	--local msg = { lottery_type =  l_type , lottery_id = l_id , lottery_coins = l_coins , lottery_diamond = l_diamond}
    --local strr = json.encode(msg)
	
	local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = { lottery_type =  l_type , lottery_id = l_id , lottery_coins = l_coins , lottery_diamond = l_diamond}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = pet_pb.PetLotteryRequest()
        message.lottery_type = l_type
		message.lottery_id = l_id
		message.lottery_coins = l_coins
		message.lottery_diamond = l_diamond
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.PetLotteryRequest,
              data = strr, -- strr
             }
    MsgFactory:createMsg(MsgCode.PetLotteryResponse,self)
    NetManager:SendPost(NetConfig.PET_SLOT,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end

-- 萌宠抽取 返回
function PetManagement:getPetLettory(info)
	-- 改为可以抽取
	self.scene.petExtractView.state = false
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]
	local json = require "cjson"
	local tab = json.decode(info.data)
  	if tab.result == 1 then
  		-- print("抽取成功")
  		-- tab.new_pet
		
		if tab.mail_reward ~= nil and #tab.mail_reward > 0 then
			-- 背包已经满,通过邮件发放
			 --local word = "钻石不够"
			 
        	 self.scene:promptWordShow("持有数已达上限，未获取物品请在邮件中查收")
			 return
		end
		  
	
		-- 保存数据
		
		local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
		memData:AddUserInfo(tab.gold,tab.diamond)
		self.scene:UpdatePlayerInfo()
		
		memData:AddUserInfoItemForType(TxtFactory.BagItemsInfo,tab.bin_items)
		--结算装备
		memData:AddUserInfoItemForType(TxtFactory.EquipInfo ,tab.bin_equips)
		--结算宠物
		memData:AddUserInfoItemForType(TxtFactory.PetInfo,tab.bin_pets)
	
		--[[
  		for i = 1, #tab.bin_pets do
  			tab.bin_pets[i].slot = 0 
			self:petMemDataCacheTableAdd(tab.bin_pets[i])
		end
		]]--
		self.scene:petExtractView_creatPetExtractAnim(tab.gold,tab.diamond,tab.bin_equips,tab.bin_items,tab.bin_pets,tab.lottery_id)
		-- 5 金币单抽 6 钻石单抽 8 碎片抽
		if tab.lottery_id == 5 or  tab.lottery_id == 6 or tab.lottery_id == 8 then
			--单抽
			TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.gacha_1)
		elseif tab.lottery_id == 7 then
			--十连抽
			TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.gacha_10)
		end

		-- 碎片扣除碎片 
		if tab.lottery_id == 8 then
			local lotteryTXT = TxtFactory:getTable(TxtFactory.LotteryDataTXT)
			local ticket = lotteryTXT:GetData(100108,"TICKET")
			local idTabd = string.gsub(ticket,'"',"") -- 去引号
    		local array = lua_string_split(tostring(idTabd),",") 
    		local num = tonumber(array[2])
    		-- print('碎片扣除碎片')
    		self.MaterialTable = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo)
    		local petPiece = self.MaterialTable[TxtFactory.ITEMS_PETPIECE]
    		petPiece.num = petPiece.num - num -- 扣除碎片
			-- self.scene:petExtractView_updatePetPieceUI() -- 刷新ui 
		end
		-- self.scene:creatPetShowPanel(tab.new_pet.id)
		--print("剩于金币时间"..tab.lottGoldTime)
		--print("剩于钻石时间"..tab.lottDiamTime)
		local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
		UserInfo[TxtFactory.USER_LOTT_GOLD]=tab.lottGoldTime+os.time()
		UserInfo[TxtFactory.USER_LOTT_DIAMOND]=tab.lottDiamTime+os.time()
		
		
		memData:AddUserInfo(-tab.lottery_coins,-tab.lottery_diamond) -- 刷新面板
  		self.scene:UpdatePlayerInfo()
	elseif tab.result == 4 then
		-- 金币不足
		self.scene:promptWordShow("金币不足")
	elseif tab.result == 5 then
		-- 钻石不足
		--self.scene:promptWordShow("钻石不足")
		self.scene:OpenGotoStoreView("钻石不足,是否需要前往商城购买!",4)
  	end
	--local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
  	
end

-- 萌宠召唤 发送
function PetManagement:sendCallPet(petId,itemId)
	local json = require "cjson"
	--local msg = { item_uid =  itemId , pet_type_id = petId}
    --local strr = json.encode(msg)
	
	local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = { item_uid =  itemId , pet_type_id = petId}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = pet_pb.PetCallingRequest()
        message.item_uid = itemId
		message.pet_type_id = petId
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.PetCallingRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.PetCallingResponse,self)
    NetManager:SendPost(NetConfig.PET_CALL,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end

-- 萌宠召唤 返回
function PetManagement:getCallPet(info)
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]
	local json = require "cjson"
	local tab = json.decode(info.data)
  	if tab.result == 1 then
  		tab.pet_info.slot = 0 
		self:petMemDataCacheTableAdd(tab.pet_info)

		local BagItemsInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo)
		for i = 1, #BagItemsInfo.bin_items do
			if BagItemsInfo.bin_items[i].id == tab.item_info.id then
				BagItemsInfo.bin_items[i] = tab.item_info
				if tab.item_info.num == 0 then
					table.remove(BagItemsInfo.bin_items,i)
				end
				TxtFactory:setMemDataCacheTable(TxtFactory.BagItemsInfo,BagItemsInfo)
			end
		end
		TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.levelup)
		
		self.scene:petHandbookView_listUpdate()
		self.scene:creatPetShowPanel(tab.pet_info.id)
	end
	
end

-- 获取萌宠碎片数据
function PetManagement:getPetPiece()
	local bagInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo) -- bin_items
	local petOnlyTab = self.petTypeTable:GetPetIdList()
	local piecePetTab = {}


	for o = 1, #petOnlyTab do
		local MaterialPetId = self.petTypeTable:GetData(petOnlyTab[o],"CALL_TICKET")
		local idTabd = string.gsub(MaterialPetId,'"',"")
		local array = lua_string_split(tostring(idTabd),",")
		-- print(array[1])
		for k,v in pairs(bagInfo.bin_items) do 
			local tab = {material = nil , tid = nil , maxNum = nil }
			if v.tid == tonumber(array[1]) then
				tab.material = v
				tab.tid = petOnlyTab[o]
				tab.maxNum = tonumber(array[2])
				piecePetTab[#piecePetTab+1] = tab
			end
		end 
	end

	TxtFactory:setValue(TxtFactory.PetInfo,TxtFactory.PIECE_PETS,piecePetTab)
end

-- 根据uid 取宠物
function PetManagement:idPetData(id)
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]

	local ret = nil
	-- print("id"..id)
	for i = 1,#petTab do
		if  petTab[i].id == id then
			ret = petTab[i]
			break
		end
	end

	return ret
end

-- 根据uid 取tid 如果尚未拥有则返回nil
function PetManagement:idDataForTid(id)
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]

	local tid = nil
	-- print("id"..id)
	for i = 1,#petTab do
		if petTab[i].id == id then
			tid = petTab[i].tid
		end
	end

	return tid
end

-- 根据uid 取slot
function PetManagement:idDataForSlot(id)
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]

	local slot = nil
	-- print("id"..id)
	for i = 1,#petTab do
		if petTab[i].id == id then
			slot = petTab[i].slot
		end
	end

	return slot
end

-- 通过ID或者tid得到PetInfo
function PetManagement:GetPetInfoById(id)
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]
	local idnumber = tonumber(id)

	for i=1, #petTab do
		if petTab[i].id == idnumber then
			return petTab[i]
		end
		if petTab[i].tid == idnumber then
			return petTab[i]
		end
	end
	return nil
end

-- 萌宠动态表里删除
function PetManagement:petMemDataCacheTableRemove(id)
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]

	for k,v in pairs(petTab) do 
		if v.id == id then
			table.remove(petTab,k)
			break
		end
	end
end

-- 萌宠动态表里添加
function PetManagement:petMemDataCacheTableAdd(petData)
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]
	petTab[#petTab +1] = petData
end

-- 道具数据刷新
function PetManagement:petItemUpdate(item)
	local BagItemsInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo)

	local get = true
	-- 已拥有萌宠经验物品
	for i =1 , #BagItemsInfo.bin_items do
		if BagItemsInfo.bin_items[i].tid == item.tid then
			BagItemsInfo.bin_items[i] = item
			get = false
		end
	end

	-- 之前未拥有
	if get == true then
		BagItemsInfo.bin_items[#BagItemsInfo.bin_items+1] = item
	end
end

-- 道具购买 发送
function PetManagement:sendBugItems(id, num)
-- print("id"..id)
	local json = require "cjson"
	--local msg = { item_tid = id, item_num = num }
   -- local strr = json.encode(msg)
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = { item_tid = id, item_num = num }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.BuyItemRequest()
        message.item_tid = id
        message.item_num = num
        strr = ZZBase64.encode(message:SerializeToString())
    end
	
    local param = {
              code = MsgCode.BuyItemRequest,
              data = strr, -- strr
            }

    MsgFactory:createMsg(MsgCode.BuyItemResponse,self)
    NetManager:SendPost(NetConfig.ITEM_PETBUY,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end

-- 道具购买 返回
function PetManagement:getBuyItems(info)
	local json = require "cjson"
	local tab = json.decode(info.data)
  	if tab.result == 1 then
  		-- print("购买成功")
		local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)  --扣除金币钻石
  		if tab.bin_items then
  			memData:AddUserInfoItemForType(TxtFactory.BagItemsInfo,tab.bin_items)
  		end
  		self.scene:petMainView_ListUpdate()
  		self.scene:petMainView_expItemsListUpdate()

  		if not tab.use_coins then
  			tab.use_coins = 0
  		end
  		if not tab.use_diamond then
  			tab.use_diamond = 0
  		end
  		memData:AddUserInfo(-tab.use_coins,-tab.use_diamond) -- 刷新面板
  		self.scene:UpdatePlayerInfo()
		TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.buy_success)
		
  	end
end

-- 金币抽取是否免费
function PetManagement:isCoinFree()
	local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	return UserInfo[TxtFactory.USER_LOTT_GOLD] < os.time()
end

-- 金币抽取是否免费
function PetManagement:isDiamondFree()
	local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	return UserInfo[TxtFactory.USER_LOTT_DIAMOND] < os.time()
end

-- 品质筛选
function PetManagement:GetPetTablyByPZ(pzSp)
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]
	local tab = TxtFactory.PetInfo[pzSp]
	if tab == nil then
		tab = {}
		for i = 1, #petTab do
			local tid =petTab[i].tid
			local ctid = self.petTable:GetData(tid, TxtFactory.S_MOUNT_TYPE)
			local petType = self.petTypeTable:GetData(ctid,"RANK_ICON_2")
			if petType == pzSp then
				tab[#tab +1] = petTab[i]
			end
		end
		TxtFactory:setValue(TxtFactory.PetInfo,pzSp,tab)
	end
	return tab
end