--[[
author:huqiuxiang
无尽数据管理
]]
EndlessManagement = class()

EndlessManagement.scene = nil --场景scene
EndlessManagement.petTable = nil -- 萌宠表
EndlessManagement.management = nil 
EndlessManagement.userTable = nil  --用户表
EndlessManagement.battleItemsTable = nil 

--初始化界面
function EndlessManagement:init()
	self.battleItemsTable = TxtFactory:getTable(TxtFactory.StoreConfigTXT)
	self.petTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
	self.userTable = TxtFactory:getTable("UserTXT")
	-- 获取材料
	local BagItemsInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo)
	if BagItemsInfo == nil then
		self:sendMaterialList()
	end
	-- self:sendMaterialList()
end

-- 获取材料背包数据
function EndlessManagement:sendItems()
	
end

-- 删选材料背包数据
function EndlessManagement:getItems()
	local BagItemsInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo)
	local tab = {}

	for i =1 , #BagItemsInfo.bin_items do
		local id = BagItemsInfo.bin_items[i].tid
		local cid = string.sub(id,1,-4)

		if tonumber(cid) == 160 or tonumber(cid) == 170 then
			tab[#tab + 1] = BagItemsInfo.bin_items[i]
			-- print(id)
		end
	end

	self:setValue(TxtFactory.BagItemsInfo,TxtFactory.ITEMS_BATTLEINFOTAB,tab)
end

-- 获取背包信息(发送)
function EndlessManagement:sendMaterialList()
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
function EndlessManagement:getMaterialList(info)
	local json = require "cjson"
  	local tab = json.decode(info.data)
  	local memCache = TxtFactory:getTable("MemDataCache")
  	if tab.bin_items == nil then
  		tab.bin_items = {}
  	end

  	memCache:setTable(TxtFactory.BagItemsInfo,tab)

end


-- 发送获取无尽排行数据
function EndlessManagement:sendEndlessRankData(dataTpye,dataPage)
	local json = require "cjson"
  
  local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
      local msg = { rank_type = dataTpye,page = dataPage}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = rank_pb.RankListRequest()
        message.rank_type = dataTpye
        message.page = dataPage
        strr = ZZBase64.encode(message:SerializeToString())
    end
	--local msg = { rank_type = dataTpye,page = dataPage}
   -- local strr = json.encode(msg)
    local param = {
              code = MsgCode.RankListRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.RankListResponse,self)
    NetManager:SendPost(NetConfig.ENDLESS_RANK,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end

-- 获取无尽排行榜数据
function EndlessManagement:getRankData(info)
	local json = require "cjson"
  	local tab = json.decode(info.data)
  	-- if tab.result ~= 1 then
  	-- 	return
  	-- end
    self.scene:updateRankList(tab.bin_ranks)
    -- print("tab.bin_ranks"..#tab.bin_ranks)
  	-- for i = 1, #tab.bin_ranks do

  	-- end

end

-- 发送天梯排行榜数据
function EndlessManagement:sendTiantiRankData()
	

end

-- 获取天梯排行榜数据
function EndlessManagement:getTiantiRankData()
	

end

-- 发送远征排行榜数据
function EndlessManagement:sendYuanzhengRankData()
	

end

-- 获取远征排行榜数据
function EndlessManagement:getYuanzhengRankData()
	

end

-- 发送自己排行所在数据
function EndlessManagement:sendSelfRankData()
	
end

-- 获取自己排行所在数据
function EndlessManagement:getSelfRankData()
	
end


-- 获得携带飞行宠tid
function EndlessManagement:getFlyPetTid()
	local tid = nil
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
  	local petTab = petInfo[TxtFactory.BIN_PETS]

  	for i = 1, #petTab do
  		local ctid = tonumber(string.sub(tostring(petTab[i].tid),1,-5))
  		-- print("ctid"..ctid)
  		local petType = self.petTable:GetData(ctid,"TYPE")
		if petType == "1" and petTab[i].slot ~= 0 then -- 飞行宠
			tid = petTab[i].tid
		end
  	end

	return tid
end

-- 获得携带支援宠tid
function EndlessManagement:getAidPetTid()
	local tidTab = {}
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
  	local petTab = petInfo[TxtFactory.BIN_PETS]

  	for i = 1, #petTab do
  		local ctid = tonumber(string.sub(tostring(petTab[i].tid),1,-5))
  		local petType = self.petTable:GetData(ctid,"TYPE")
		if petType == "2" and petTab[i].slot ~= 0 then -- 飞行宠
			tidTab[#tidTab + 1] = petTab[i].tid
		end
  	end

	return tidTab
end

-- 获取无尽冲关前道具数量
function EndlessManagement:getBattleItemsDataTid()
	local tab = {} -- 放所有道具id
  local endlessItems = {}

	for i =1, self.battleItemsTable:GetLineNum() do
    	local id = self.battleItemsTable:GetData(i,'ID')
		  tab[i] = tonumber(id)
  end

  for o = 1, #tab do 
      local itemType = self.battleItemsTable:GetData(tab[o],'SHOP_TYPE')
      if itemType == "1" then
        -- local tid = self.battleItemsTable:GetData(tab[o],'MATERIAL_ID')
        endlessItems[#endlessItems + 1] = tonumber(tab[o])
      end
  end

	local BagItemsInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo)

    if 	BagItemsInfo == nil then
    	local tabInfo = {}
  		local memCache = TxtFactory:getTable("MemDataCache")
  		tabInfo.bin_items = {}
  		memCache:setTable(TxtFactory.BagItemsInfo,tabInfo)
    end

	self:setValue(TxtFactory.BagItemsInfo,TxtFactory.ITEMS_BATTLEINFODATATAB,endlessItems)

end

-- 道具购买 发送
function EndlessManagement:sendBuyItems()
	local json = require "cjson"
  --[[
	local msg = { pet_uid =  selectBtn , item_uid = expItemSelectBtn}
    local strr = json.encode(msg)
	local param = {
              code = MsgCode.ItemListRequest,
              data = strr, -- strr
            }
    ]]--        
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = { pet_uid =  selectBtn , item_uid = expItemSelectBtn}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.ItemListRequest()
        message.pet_uid = selectBtn
        message.item_uid = expItemSelectBtn
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.ItemListRequest,
              data = strr, -- strr
            }


    MsgFactory:createMsg(MsgCode.ItemListResponse,self)
    NetManager:SendPost(NetConfig.ITEMINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end


-- 道具购买 返回
function EndlessManagement:getBuyItems(info)
	local tab = json.decode(info.data)

  	if tab.result == 1 then	

  		self.scene:updateItemsList()
  	end

end


--为数据表赋值
function EndlessManagement:setValue( tName,column,value)
    TxtFactory:setValue(tName,column,value)
end

--开始跑酷信息 (发送)
function EndlessManagement:sendStartRunning()
    local json = require "cjson"
  --  local msg = {}
  --  local strr = json.encode(msg)
    
   local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
         local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = battle_pb.EndBattleStartRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    local param = {
              code = MsgCode.EndBattleStartRequest,
              data = strr, -- strr
             }


    MsgFactory:createMsg(MsgCode.EndBattleStartResponse, self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    --print("开始跑酷信息 发送")
end

--开始跑酷信息 (回复)
function EndlessManagement:getStartRunning(info)
    local json = require "cjson"
  	local tab = json.decode(info.data)
  	local memCache = TxtFactory:getTable("MemDataCache")
    --print("开始跑酷信息 回复")
    self.scene:StartRunning()
end


------------------------------------------  天梯三种模式  ----------------------------------------
--[[
 	定位赛(请求)
]]--
function EndlessManagement:sendLadderRaceBeginMessage()
    local json = require "cjson"
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = ladder_pb.LadderRaceBeginRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    --local msg = {}
    --local strr = json.encode(msg)
    local param = {
              code = MsgCode.LadderRaceBeginRequest,
              data = strr, -- strr
             }


    MsgFactory:createMsg(MsgCode.LadderRaceBeginResponse, self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    --print("开始跑酷信息 发送")
end

--[[
	定位赛 (回复)
]]--
function EndlessManagement:getLadderRaceBeginMessage(info)
    local json = require "cjson"
  	local tab = json.decode(info.data)
  	local memCache = TxtFactory:getTable("MemDataCache")
    --print("开始跑酷信息 回复")
    if tab.result == 1 then
        self.scene:StartRunning()
    elseif tab.result == 2 then
        self.scene.scene:promptWordShow("天梯关闭")
    elseif tab.result == 3 then
        self.scene.scene:promptWordShow("钻石不足")
    end
    
end

--[[
 	晋级赛(请求)
]]--
function EndlessManagement:sendLadderUpgradeStartMessage()
    local json = require "cjson"
    
     local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = ladder_pb.LadderUpgradeStartRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
   -- local msg = {}
  --  local strr = json.encode(msg)
    local param = {
              code = MsgCode.LadderUpgradeStartRequest,
              data = strr, -- strr
             }


    MsgFactory:createMsg(MsgCode.LadderUpgradeStartResponse, self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    --print("开始跑酷信息 发送")
end

--[[
	晋级赛 (回复)
]]--
function EndlessManagement:getLadderUpgradeStartMessage(info)
    local json = require "cjson"
  	local tab = json.decode(info.data)
  	local memCache = TxtFactory:getTable("MemDataCache")
    if tab.result == 1 then
        self.scene:StartRunning()
    elseif tab.result == 2 then
        self.scene.scene:promptWordShow("天梯关闭")
    end
end