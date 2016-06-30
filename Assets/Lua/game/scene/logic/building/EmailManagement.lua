--[[
author:hanli_xiong
邮件系统数据管理
]]

EmailManagement = class()

EmailManagement.scene = nil
EmailManagement.userTable = nil -- 玩家数据表

function EmailManagement:Awake(targetscene)
	self.scene = targetscene
	self.userTable = TxtFactory:getTable(TxtFactory.UserTXT) 
end

-- 获取邮件列表 发送
function EmailManagement:SendSystemEmail()
	local json = require "cjson"
    local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = charinfo_pb.GetMailListRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
   -- local msg = {}
   -- local strr = json.encode(msg)
    local param = {
        code = MsgCode.GetMailListRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.GetMailListResponse,self)
    NetManager:SendPost(NetConfig.DEFAULT,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    print("url"..AppConst.SocketAddress)
end

-- 获取邮件列表 接收
function EmailManagement:GetSystemEmail(response)
	local json = require "cjson"
 	local tab = json.decode(response.data)

    GamePrintTable("邮件返回")
    GamePrintTable(tab)
    local bin_m = tab.bin_mails
    if bin_m == nil then
        bin_m = {}
    end

    TxtFactory:setMemDataCacheTable(TxtFactory.EmailInfo, bin_m)
    if self.scene.EmailSystemPanel~=nil then    
        self.scene.EmailSystemPanel:UpdateEmail(  self.scene.EmailSystemPanel.ToggleType)
    end
    local memCache = TxtFactory:getTable(TxtFactory.MemDataCache)
    if #bin_m>0 then
        self.scene:SetRedPoint("email",true)
    else
        self.scene:SetRedPoint("email",false)
    end
    
end

-- 获取可用装备格子
function EmailManagement:GetCanUSeBagNum()
    -- body
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local unlocknum = EquipInfoTab["unlocknum"] --已解锁格子
    local Usenum = EquipInfoTab["bin_equips"] ~= nil and #EquipInfoTab["bin_equips"] or 0

    return unlocknum - Usenum
end

-- 获取邮件奖励 发送
function EmailManagement:SendEmailReward(tab)
    if #tab == 0 then
        print ("have not  email reward")
        return
    end
    --GamePrintTable("领取邮件 领取邮件 领取邮件 领取邮件")
    --GamePrintTable(tab)
    --return
    local itemNum = 0
    local levelNum = self:GetCanUSeBagNum()
    local addStrength = 0
    for i = 1 , #tab do
        local mail0 = self:GetMailInfoById(tab[i])
        local curNum = mail0["bin_items"] ~= nil and #mail0["bin_items"] or 0
        itemNum = itemNum + curNum
        
        if tonumber(mail0.tid) == 11 and  tonumber(mail0.strength) > 0 then
            addStrength = addStrength + tonumber(mail0.strength)
        end

    end

    if itemNum > levelNum then
        self.scene:promptWordShow("当前装备格子已满，无法领取")
        return
    end
    local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    local vipFeatureConfigTXT = TxtFactory:getTable(TxtFactory.VipFeatureConfigTXT)
    if addStrength > 0 and UserInfo[TxtFactory.USER_STRENGTH] >= tonumber(vipFeatureConfigTXT:GetData(1,"STORAGE_MAX")) then
        self.scene:promptWordShow("体力已满，无法领取")
        return
    end

    local mailInfo = self:GetMailInfoById(tab[1])

    if mailInfo ~= nil and mailInfo.tid ==  12 then --是应战邮件不发送领取协议
        --GamePrint("----------  mailInfo ~= nil and mailInfo.tid ==  12")
        --记录挑战者数据
        local challengeTab = {}
        challengeTab[TxtFactory.REPLYCHALLENGE_FRIENDID] = tonumber(mailInfo.from_uid)
        challengeTab[TxtFactory.REPLYCHALLENGE_MAILID] = tonumber(mailInfo.id)
        challengeTab[TxtFactory.REPLYCHALLENGE_FRIENDNAME] = mailInfo.from_name
        challengeTab[TxtFactory.REPLYCHALLENGE_FRIENDSCORE] = tonumber(mailInfo.text)
        TxtFactory:setMemDataCacheTable(TxtFactory.ReplyChallengeInfo,challengeTab)

        --进入无尽界面
        self.scene.EmailSystemPanel:SkipEndlessScene()
        return
    end
    -- 检查 背包格子
    --GamePrintTable(tab)
    
    local json = require "cjson"
   -- local msg = { bin_mails =tab }
   -- local strr = json.encode(msg)
       local strr = nil
     if AppConst.isPBencrypted == false then --pb不加密
       local msg = { bin_mails =tab }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = charinfo_pb.GetMailItemRequest()
        for i = 1 , #tab do
              --printf("petid ==="..curDefendPets[i])
             message.bin_mails:append(tab[i])
        end
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
        code = MsgCode.GetMailItemRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.GetMailItemResponse,self)
    NetManager:SendPost(NetConfig.DEFAULT,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 获取邮件奖励 接收
--[[
    message GetMailItemResponse{
enum MSGTYPE { ID=16007;}
	enum RESULT
	{
		E_FAILED = 0;
		E_SUCCESS =1;
	}
	optional RESULT result = 1;
	optional int32 coins = 2;
	optional int32 diamond = 3;
	optional int32 strength = 4;
	optional PetInfo pet_info = 5;
	repeated EquipInfo bin_equips = 6; 
	repeated int32 bin_mails = 7;//宸茬粡棰嗗彇鐨勯偖浠剁殑id鍒楄〃
	repeated ItemInfo bin_items = 8;//棰嗗彇鐨勬潗鏂?

}

    --]]
function EmailManagement:GetEmailReward(response)
    --GamePrint("    EmailManagement:GetEmailReward     ")
    local json = require "cjson"
    local tab = json.decode(response.data)
    local re = tonumber(tab.result) -- 反馈结果
    if re == 0 then
        print("反馈服务器错误")
    elseif re == 1 then
        local memDataCache =  TxtFactory:getTable(TxtFactory.MemDataCache)
      
      
      --结算物品
       memDataCache:AddUserInfoItemForType(TxtFactory.BagItemsInfo,tab.bin_items)
        --结算装备
       memDataCache:AddUserInfoItemForType(TxtFactory.EquipInfo ,tab.bin_equips)
       memDataCache:AddUserInfo(tab.coins, tab.diamond,tab.strength)

      --结算宠物
        local pets = {}
        if tab.pet_info~=nil then
            
            pets[1] = tab.pet_info
            memDataCache:AddUserInfoItemForType(TxtFactory.PetInfo,pets)
        end
        local serverData = {}
        serverData.gold = tab.coins
        serverData.diamond = tab.diamond
        serverData.exp = 0
        serverData.strength = tab.strength
        serverData.explorer_gold = tab.explorer_gold
        serverData.itemInfoList = tab.bin_items
        serverData.equipInfoList = tab.bin_equips
        serverData.petInfoList = pets
        
       local itemObjList=  self.scene:CreatItemList(serverData)
       self.scene:rewardItemsShow(itemObjList)
       
        if  self:GetMailInfoById(tab.bin_mails[1]) ~= nil and self:GetMailInfoById(tab.bin_mails[1]).tid ==  12 then
            --self.scene.EmailSystemPanel:SkipEndlessScene()
            self:RemoveMailList(tab.bin_mails)
            --GamePrint("发起应战成功")
        else
            self:RemoveMailList(tab.bin_mails)
            self.scene.EmailSystemPanel:OnGetRewardSucceed()
            --GamePrint("获取邮件奖励成功!")
        end
        local nowScene = GetCurrentSceneUI()
        local sub = nowScene.gameObject:GetComponent(BundleLua.GetClassType())
        if sub.luaName ~= "UIbuildingScene" then
            --GamePrint("sub.luaName ~= UIbuildingScene")
            return
        end
        --GamePrint("sub.luaName == UIbuildingScene")
        if self.scene.SetRedPoint == nil then return end
        local Info = TxtFactory:getMemDataCacheTable(TxtFactory.EmailInfo)
        self.scene:UpdatePlayerInfo()
        if #Info>0 then
            self.scene:SetRedPoint("email",true)
        else
            self.scene:SetRedPoint("email",false)
        end
    end
    
end
function EmailManagement:GetMailInfoById( id )
    local table = TxtFactory:getMemDataCacheTable(TxtFactory.EmailInfo)
    local info = nil
    for i = #table ,1,-1 do
        if table[i].id == id then
            info = table[i]
        end
    end
    return info
end

function EmailManagement:RemoveMailList(removeList)
  	local Info = TxtFactory:getMemDataCacheTable(TxtFactory.EmailInfo)
     if removeList ~=nil then 
        for i = #Info ,1,-1 do
            for j = 1,#removeList do 
                if Info[i].id == removeList[j] then
                    table.remove(Info,i)
                end
            end
        end
     end
end




