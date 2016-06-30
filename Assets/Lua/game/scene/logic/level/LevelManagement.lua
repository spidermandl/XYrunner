--[[
author:Desmond

]]
LevelManagement = class()

LevelManagement.scene = nil --对应场景
LevelManagement.userTable = nil  --用户表
LevelManagement.chapterTable = nil    --配置表读取

function LevelManagement:Awake(targetScene)
  self.scene = targetScene
	self.userTable = TxtFactory:getTable("UserTXT")
	self.chapterTable = TxtFactory:getMemDataCacheTable(TxtFactory.ChapterInfo)
  
end


--开始跑酷信息 (发送)
function LevelManagement:sendStartRunning()
    local json = require "cjson"
    print("SELECTED_BATTLE_ID : "..self.chapterTable[TxtFactory.SELECTED_BATTLE_ID])
    local msg = {battle_id = self.chapterTable[TxtFactory.SELECTED_BATTLE_ID]}
    local strr = json.encode(msg)
    
     local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = {battle_id = self.chapterTable[TxtFactory.SELECTED_BATTLE_ID]}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = battle_pb.StartBattleRequest()
        message.battle_id = tonumber(self.chapterTable[TxtFactory.SELECTED_BATTLE_ID])
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    local param = {
              code = MsgCode.StartBattleRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.StartBattleResponse, self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    print("开始跑酷信息 发送")
end


--[[
    //领取奖杯中心奖励
message CupGetRequest {
	enum MSGTYPE { ID=17010;}
	optional int32 cup_id =1;
}

message CupGetResponse{
	enum MSGTYPE { ID=17011;}
	enum RESULT {
		FAILED 			= 0;
		SUCCESS 		= 1;
		INVALID_ID      = 2;//无效的id
		EXIST_ID        = 3;//已经领取
		INVALID_CUP     = 4;//奖杯数不够
	}
	optional RESULT result 	  		= 1;
	optional int32  cup_id    		= 2;
	optional ItemInfo item_info 	= 3;
	optional PetInfo pet_info 		= 4;
	optional EquipInfo equip_info 	= 5;
}
]]--

--开始跑酷信息 (回复)
function LevelManagement:getStartRunning(info)
    local json = require "cjson"
  	local tab = json.decode(info.data)
  	local memCache = TxtFactory:getTable("MemDataCache")

    print("开始跑酷信息 回复")
      local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
    memData:AddUserInfo(0,0,tonumber("-"..self.scene.LevelStartView.LIGHT_USE))
    --self.scene:UpdatePlayerInfo()
    self.scene:StartRunning()
end

--发送奖杯获取奖励消息
function LevelManagement:sendGetCupMsg(cupid)
    print("")
    local json = require "cjson"
   -- local msg = {cup_id = tonumber(cupid)}
   -- local strr = json.encode(msg)
   
    local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = {cup_id = tonumber(cupid)}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = battle_pb.CupGetRequest()
        message.cup_id = tonumber(cupid)
        strr = ZZBase64.encode(message:SerializeToString())
    end
   
    local param = {
              code = MsgCode.CupGetRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.CupGetResponse, self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

--接收奖杯获取奖励
function LevelManagement:respondGetCupMsg(tab)
    --已经领取奖杯物品塞到本地数据里面去
   table.insert(self.chapterTable[TxtFactory.CUPS_REWARD],tab.cup_id)
       local memDataCache = TxtFactory:getTable(TxtFactory.MemDataCache)
   --获取的物品
   if tab.item_info ~= nil then
        local items = {}
        items[1] = tab.item_info
        memDataCache:AddUserInfoItemForType(TxtFactory.BagItemsInfo,items)
   end
   
    --结算装备
    if tab.equip_info ~= nil then
        local equips = {}
        equips[1] = tab.equip_info
       memDataCache:AddUserInfoItemForType(TxtFactory.EquipInfo,equips)
    end
    --结算宠物
    if tab.pet_info~=nil then
        local pets = {}
        pets[1] = tab.pet_info
        memDataCache:AddUserInfoItemForType(TxtFactory.PetInfo,pets)
    end

   --刷新物品的状态
   self.scene.LevelCupCenterView:InitItem()
   self.scene.LevelCupCenterInfoView:ShowRewardView()
   self.scene.LevelCupCenterInfoView:SetShowView(false)
   
end
