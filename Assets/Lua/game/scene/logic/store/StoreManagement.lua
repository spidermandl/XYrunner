--[[
author:赵名飞
商城系统 数据部分

_req  : 请求
_resp : 回复
]]
StoreManagement = class()

StoreManagement.userTable = nil --玩家数据表
StoreManagement.scene = nil --场景lua

function StoreManagement:Awake(targetscene)
  self.scene = targetscene
	self.userTable = TxtFactory:getTable(TxtFactory.UserTXT)

  local memCache = TxtFactory:getTable("MemDataCache")
  if memCache:getTable(TxtFactory.StoreInfo) == nil then
    local tabel = {}
    memCache:setTable(TxtFactory.StoreInfo,tabel)
  end
end


--[[
message ShopInfo {
  optional int32 id       =1;
  optional int32 money_type =2;//货币类型
  optional int32 money      =3;//货币数量
  optional int32 object_id  =4;//购买物品的id
  optional int32 object_num =5;//购买物品的数量
  optional int32 money_off  =6;//货币打折 100
  optional int32 limit_type =7;//限制的方式(1打折时限2购买时限3限购数量)
  optional int32 limit_time =8;//限制的时间
}
]]
--根据不同的商城类型把数据放在不同列名下
function StoreManagement:SetStoreTabel( tName,column,value)

    TxtFactory:setValue(tName,column,value)
    local shopType = tonumber(column)
    if shopType == 4 then
      self.scene.storeGiftBagView:checkSend()
    elseif shopType == 7 then
      self.scene.storePayView:checkSend()
    elseif shopType == 5 then
      self.scene.storeBuildView:checkSend()
    elseif shopType == 6 then
      self.scene.storeResourceView:checkSend()
    elseif shopType == 2 then
      self.scene.snatchStoreView:checkSend()
    elseif shopType == 11 then
      self.scene.ladderStoreView:checkSend()
    end
end

-- 设置购买所需消耗物品类型的Icon  1（金币）2（钻石)3（夺宝货币 4(RMB) 5- 天梯币
function StoreManagement:GetIconName(itemType)
	if itemType == 1 then
		return "jinbi"
	elseif itemType == 2 then
		return "zuanshi"
	elseif itemType == 3 then
		return "duobaobi"
  elseif itemType == 5 then
    return "tiantibi"
	elseif itemType == 4 then
		return ""
	end
end

--根据商城类型获取商城道具的列表
function StoreManagement:GetStoreTabel(shopId)
  local tab = TxtFactory:getValue(TxtFactory.StoreInfo,shopId)
  --error(TxtFactory.StoreInfo.."   商城type："..shopId.."tab:"..tostring(tab))
  return tab
end

-- 请求商城数据
function StoreManagement:SendStoreInfoReq(shopId)	
    --do return end
	local json = require "cjson"
    --local msg = {shop_id = tonumber(shopId)}
   -- local strr = json.encode(msg)
      local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {shop_id = tonumber(shopId)}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.ShopListRequest()
        message.shop_id = tonumber(shopId)
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
        code = MsgCode.ShopListRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.ShopListResponse,self)
    NetManager:SendPost(NetConfig.STOREINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    print("发送商城请求,商城类型是："..shopId)
end
-- 获取到商城数据
function StoreManagement:GetStoreInfoResp(resp)
    local json = require "cjson"
    local infos = json.decode(resp.data)
    self:SetStoreTabel(TxtFactory.StoreInfo,infos.shop_id,infos.bin_shops)
end
--[[
  optional int32 item_tid  = 1;//id
  optional int32 item_num  = 2;//数量
  optional int32 use_type  = 3;//使用类别 0 什么也不干 1 给宠物升级
  optional int32 use_data  = 4;//使用的数据 1时添加要送的宠物
]]
--购买道具请求
function StoreManagement:SendBuyItemReq(id,num)
	local json = require "cjson"
	--local msg = { item_tid =  id,item_num = num or 1}
   -- local strr = json.encode(msg)
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = { item_tid = id, item_num = num or 1 }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.BuyItemRequest()
        message.item_tid = id
        message.item_num = num or 1
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.BuyItemRequest,
              data = strr, -- strr
             }
    MsgFactory:createMsg(MsgCode.BuyItemResponse,self)
    NetManager:SendPost(NetConfig.STORE_BUYITEM,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end
--购买道具回复
function StoreManagement:getBuyItems(resp)
    local json = require "cjson"
    local tab = json.decode(resp.data)
  	if tab.result == 1 then
  		print("购买成功")

      local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)  --扣除金币钻石
      if not tab.use_coins then
  			tab.use_coins = 0
  		end
  		if not tab.use_diamond then
  			tab.use_diamond = 0
  		end
      
      if not tab.gold then
  			tab.gold = 0
  		end
  		if not tab.diamond then
  			tab.diamond = 0
  		end
      if not tab.strength_add then
        tab.strength_add = 0
      end
      
      memData:AddUserInfo(-tab.use_coins, -tab.use_diamond)
     -- memData:AddUserInfo(tab.gold, tab.diamond)
      memData:AddUserInfo(tab.gold, tab.diamond,tab.strength_add)
      memData:AddUserInfoItemForType(TxtFactory.BagItemsInfo,tab.bin_items)
     --结算装备
      memData:AddUserInfoItemForType(TxtFactory.EquipInfo ,tab.bin_equips)
     --结算宠物
      memData:AddUserInfoItemForType(TxtFactory.PetInfo,tab.bin_pets)
      -- 加体力
      --self.userInfo[TxtFactory.USER_STRENGTH] = tab.strength  
      
      local serverData = {}
      serverData.gold = tab.gold
      serverData.diamond = tab.diamond
      serverData.itemInfoList = tab.bin_items
      serverData.equipInfoList = tab.bin_equips
      serverData.petInfoList = tab.bin_pets
      serverData.strength = tab.strength_add 
      local itemObjList =   self.scene:CreatItemList(serverData)
      self.scene:rewardItemsShow(itemObjList)
      self.scene:UpdatePlayerInfo()
       if self.BuyItemFinish ~= nil then
          self.BuyItemFinish(self.scene)
       end
       
    elseif tab.result == 2 then
        self.scene:promptWordShow("没有足够的金币！")
    elseif tab.result == 3 then
        self.scene:promptWordShow("没有足够的钻石！")
    elseif tab.result == 4 then
        self.scene:promptWordShow("无效的商城道具！")
  	elseif tab.result == 5 then
        self.scene:promptWordShow("没有足够的夺宝币")
    elseif tab.result == 6 then
        self.scene:promptWordShow("没有足够的天梯币")
    elseif tab.result == 7 then
        self.scene:promptWordShow("体力超出上限,不需要购买")
    else
      self.scene:promptWordShow("返回无效！")
    end
    
end

--购买成功之后的回掉
function StoreManagement:SetBuyItemDelegate(fun)
    self.BuyItemFinish = fun 
end

