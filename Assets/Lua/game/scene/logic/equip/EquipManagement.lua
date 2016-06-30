--[[
   author: Desmond
   装备功能逻辑 数据部分
]]
EquipManagement = class ()
 
EquipManagement.userTable = nil  --用户表
EquipManagement.equipTable = nil   --装备表

EquipManagement.equipScene = nil --装备scene


function EquipManagement:awake()
    self.userTable = TxtFactory:getTable("UserTXT")
    self.equipTable = TxtFactory:getTable("EquipTXT")

    -- self:sendEquipInfo()
end

--获取玩家装备信息 (发送)
function EquipManagement:sendEquipInfo()
    local json = require "cjson"
  --  local msg = {}
  --  local strr = json.encode(msg)
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.EquipsListRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.EquipsListRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.EquipsListResponse,self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    -- print("获取玩家装备信息 发送")
end

-- 获取玩家装备信息（返回）
function EquipManagement:getEquipInfo(info)
    local json = require "cjson"
  	local tab = json.decode(info.data)
  	local memCache = TxtFactory:getTable("MemDataCache")
    if tab.bin_equips == nil then
        tab.bin_equips = {}
    end
  	memCache:setTable(TxtFactory.EquipInfo,tab)
    
    self.equipScene:updateEquipList() -- 通知更新
end

--增加装备格子 (发送)
function EquipManagement:sendExtendSlot() 
    local json = require "cjson"
   -- local msg = { lock_type = 1 }
  --  local strr = json.encode(msg)
    
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = { lock_type = 1 }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.UnlockSlotRequest()
        message.lock_type = 1
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = { 
              code = MsgCode.UnlockSlotRequest,
              data = strr, -- strr
             }
    MsgFactory:createMsg(MsgCode.UnlockSlotResponse,self)
    NetManager:SendPost(NetConfig.EQUIP_UNLOCK,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

--增加装备格子 (返回)
function EquipManagement:getExtendSlot(info)
    -- print("增加装备格子 (返回)")
    local json = require "cjson"
    local tab = json.decode(info.data)
    if tab.result == 1 then -- 添加格子成功
        -- print("增加装备格子 (返回) 成功")

        local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)

        EquipInfoTab.maxnum = tab.maxnum
        EquipInfoTab.unlocknum = tab.unlocknum
        EquipInfoTab.slotnum = tab.slotnum
        EquipInfoTab.unlockslot = tab.unlockslot
        EquipInfoTab.buy_num = EquipInfoTab.buy_num + 1
        self.equipScene:EquipPanel_equipBuyVolumeBack() -- 通知更新

    elseif tab.result == 0 then

    elseif tab.result == 2 then
        self.equipScene:promptWordShow("已达到最大格子数量！")
    elseif tab.result == 3 then
        self.equipScene:promptWordShow("您的钻石不足！")
    end

end

-- 装备/升级 小界面 装备按钮 (发送)
function EquipManagement:sendEquipItem()
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local equipedVolume = self:getEquipedValue() -- 已经装备数量

    if equipedVolume >= EquipInfoTab.unlockslot then
        -- print("格子上锁，无法装备")
        local word = "格子上锁，无法装备"
        self.equipScene:promptWordShow(word)
        return
    end
    -- if self.equipScene.EquipmentUpgradePanel_equipBtnWait == true then
    --     return
    -- end
    -- self.equipScene.EquipmentUpgradePanel_equipBtnWait = true
    -- local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local name = EquipInfoTab[TxtFactory.EQUIPMAIN_SELECTED]

    local itemId = nil 
    local nub = equipedVolume +1

    local json = require "cjson"
   -- local msg = { id = name, slot = nub }
  --  local strr = json.encode(msg)
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = { id = name, slot = nub }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.EquipItemRequest()
        message.id = name
        message.slot = nub
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = { 
              code = MsgCode.EquipItemRequest,
              data = strr, -- strr
             }
    MsgFactory:createMsg(MsgCode.EquipItemResponse,self)
    NetManager:SendPost(NetConfig.EQUIP_EXCHANGE,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end


-- 装备/升级 小界面 装备按钮 (返回)
function EquipManagement:getEquipItem(info)
    -- print("装备成功 (返回)")
    local json = require "cjson"
    local tab = json.decode(info.data)
    if tab.result == 1 then -- 添加格子成功       INVALID_ID     
        local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
        local name = EquipInfoTab[TxtFactory.EQUIPMAIN_SELECTED]

        local equipedVolume = self:getEquipedValue() -- 已经装备数量
        local itemId = nil 
         -- 遍历tab 通过位置找id 修改装备
        for i , v in ipairs(EquipInfoTab.bin_equips) do
            -- print("返回成功 开始遍历 "..v.id.." "..v.slot.." 当前按钮 "..name)
            if v.id ==  name then
                v.slot = equipedVolume +1
            end
        end

    self.equipScene:EquipmentUpgradePanel_equipBtnFromSer()

    -- 装备属性调用
    TxtFactory:getTable(TxtFactory.MemDataCache):exchangeEquip(tab.new_equip.tid,true)

    elseif tab.result == 0 then

    elseif tab.result == 2 then

    end

end

-- 卸载装备/升级 小界面 装备按钮 (发送)
function EquipManagement:sendUnequip(nub)
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    -- if self.equipScene.UnequipmentUpgradePanel_equipBtnWait == true then
    --      return
    -- end
    -- self.equipScene.UnequipmentUpgradePanel_equipBtnWait = true

    -- local name = tonumber(self.equipPanel_isSelectItem.gameObject.name) - 1
    -- local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local name = EquipInfoTab[TxtFactory.EQUIPMAIN_SELECTED]
    local btnSlot = nub
    if btnSlot == nil then
        -- 查找当前按钮在什么位置
        for i , v in ipairs(EquipInfoTab.bin_equips) do
            if v.id ==  name then
                btnSlot = v.slot 
                break
            end
        end
    end

    local json = require "cjson"
    --local msg = { slot = btnSlot }
   -- local strr = json.encode(msg)
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = { slot = btnSlot }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.UnEquipRequest()
        message.slot = btnSlot
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = { 
              code = MsgCode.UnEquipRequest,
              data = strr, -- strr
             }
    MsgFactory:createMsg(MsgCode.UnEquipReponse,self)
    NetManager:SendPost(NetConfig.EQUIP_EXCHANGE,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 卸载装备/升级 小界面 装备按钮 (返回)
function EquipManagement:getUnequip(info)
         -- print("卸载 (返回)")
    local json = require "cjson"
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local tab = json.decode(info.data)
    if tab.result == 1 then -- 添加格子成功
       print("卸载 (返回) 成功")
        -- local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
        local name = EquipInfoTab[TxtFactory.EQUIPMAIN_SELECTED]
         -- 遍历tab 通过位置找id 修改装备
         for i , v in ipairs(EquipInfoTab.bin_equips) do
            -- print("返回成功 开始遍历 "..v.id.." "..v.slot.." 当前按钮 "..name)
            if v.id ==  name then
                v.slot = 0
            end
         end
    self.equipScene:UnequipmentUpgradePanel_equipBtnFromSer()
    TxtFactory:getTable(TxtFactory.MemDataCache):exchangeEquip(tab.old_equip.tid,false)
    elseif tab.result == 0 then

    elseif tab.result == 2 then

    end


end

-- 升级统一发送sc
function EquipManagement:sendEquiplevelUp(coin,diamond)
    -- print("aaaaaaaa")
    -- if self.equipScene.UpgradeEquipPanel_coinBtnWait == true then
    --      return
    -- end
    -- self.equipScene.UpgradeEquipPanel_coinBtnWait = true
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local Btnid = EquipInfoTab[TxtFactory.UPGRADE_SELECTED]


    local json = require "cjson"
    --local msg = { equip_id = Btnid , use_coin = coin, use_diamond = diamond}
    --local strr = json.encode(msg)
    
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = { equip_id = Btnid , use_coin = coin, use_diamond = diamond}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.EquipUpgradeRequest()
        message.equip_id = Btnid
        message.use_coin = coin
        message.use_diamond = diamond
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    local param = { 
              code = MsgCode.EquipUpgradeRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.EquipUpgradeResponse,self)
    NetManager:SendPost(NetConfig.EQUIP_LVL_UP,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end

-- 升级金币按钮（返回）
function EquipManagement:getEquiplevelUp(info)
    -- print("升级 (返回) ") 
    local json = require "cjson"
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local tab = json.decode(info.data)
    local cur_tid = 0
    if tab.result == 1 then -- 添加格子成功  = 2;//不存在的装备 3;//已经到达升级上线 4;//没有足够的金币 5;//没有足够的钻石 6;//升级不成功
       -- print("升级 (返回) 成功")
       local Btnid = EquipInfoTab[TxtFactory.UPGRADE_SELECTED]
       local rtid = tab.upgrade_info.tid
       for i , v in ipairs(EquipInfoTab.bin_equips) do
        -- print("进入 遍历 "..v.id)
          if v.id == Btnid then
                cur_tid = v.tid
               v.tid = rtid
               -- print("v.tid " ..v.tid)
          end
       end
       -- self.equipScene:AddUserInfo()   -- 刷新金币钻石

    self.equipScene:UpgradeEquipPanel_coinBtnFromSer()
    if cur_tid~=rtid then
        self.equipScene:UpgradeEquipAddEffect()
    end
    elseif tab.result == 0 then

    elseif tab.result == 2 then
        local word = "不存在装备"
        self.equipScene:promptWordShow(word)
    elseif tab.result == 3 then
        local word = "已经到达升级上线"
        self.equipScene:promptWordShow(word)
    elseif tab.result == 4 then
        print("没有足够的金币")
    elseif tab.result == 5 then
        print("没有足够的钻石")
    elseif tab.result == 6 then
        local word = "升级失败"
        self.equipScene:promptWordShow(word)
    end

    -- self.equipScene.UpgradeEquipPanel_coinBtnWait = false
end

-- 装备融合（发送）
function EquipManagement:sendEquipMerge()
    local json = require "cjson"
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local equipedInfo = EquipInfoTab[TxtFactory.MERGE_EQUIPEDNFO] -- 融合左侧装备了的容器
    local leftVolumeNum = self:mergeLeftleftVolumeNum(equipedInfo)
    if equipedInfo == nil or leftVolumeNum < 2 then
        local word = "融合装备不足二个"
        self.equipScene:promptWordShow(word)
        return
    end
    GamePrintTable("装备融合（发送） 装备融合（发送） 装备融合（发送）")
    GamePrintTable(equipedInfo)
    -- 把空位 为nil的table去掉
    for k,v in pairs(equipedInfo) do
        if not tonumber(v) then
            table.remove(equipedInfo,k)
        end
    end

    --local msg = { id_list = equipedInfo}
    --local strr = json.encode(msg)
    local strr =  nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = { id_list = equipedInfo}
        strr = json.encode(msg)
    else
        --设置pb data
         local  message = item_pb.EquipMergeRequest()
	     for i = 1 , #equipedInfo do
            message.id_list:append(equipedInfo[i])
	     end
	     strr = ZZBase64.encode(message:SerializeToString())
    end
    
   
    local param = { 
              code = MsgCode.EquipMergeRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.EquipMergeReponse,self)
    NetManager:SendPost(NetConfig.EQUIP_MERGE,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end


-- 装备融合（返回）
function EquipManagement:getEquipMerge(info)
    local json = require "cjson"
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    -- print("装备融合（返回） 成功"..#EquipInfoTab.bin_equips)
    local tab = json.decode(info.data)
    if tab.result == 1 then -- 融合成功
        for u =1,#tab.remove_list do 
        local id = tab.remove_list[u].id
            for k,v in pairs(EquipInfoTab.bin_equips) do
                if v.id == id then
                    table.remove(EquipInfoTab.bin_equips, k)
                    -- print("删除 #EquipInfoTab.bin_equips"..#EquipInfoTab.bin_equips)
                end 
            end
        end

    EquipInfoTab.bin_equips[#EquipInfoTab.bin_equips + 1] = tab.merge_info

    local tabData = {} -- 奖励tab添加
    tabData[1] = tab.merge_info -- 把奖励物品塞入
    self.equipScene:MergeEquipPanel_mergeBtnFormSer(tabData) -- 刷新列表
    end

end



-- 图鉴数据处理
function EquipManagement:handBookData()
    local hbt = {}
    local handBookTab = {}
    local gethandBookTab = {}

    local handbookInfo = {} -- 最终制成的tab
    -- 筛选配置表id
    for i =1, self.equipTable:GetLineNum() do

        local id = self.equipTable:GetData(i,'ID')
        -- print('id '..id)
        local tid = string.sub(tostring(id),1,-4)
        local hbtInfo = {id = nil , flag = false}
        local nub = #handBookTab
        if nub == 0 then
            handBookTab[nub +1] = tid
            -- hbt[nub +1] = id
            hbtInfo.id = id
            hbtInfo.flag = false
            handbookInfo[nub+1] = hbtInfo
        else
            if handBookTab[nub] ~= tid then
                handBookTab[nub +1] = tid
                -- hbt[nub +1] = id
                hbtInfo.id = id
                hbtInfo.flag = false
                handbookInfo[nub+1] = hbtInfo
            -- print("handbookInfo["..tostring(nub+1).."]"..handbookInfo[nub+1].id)
            end 
        end
    end

    -- for o =1, #handbookInfo do 
    --     print(o.."handbookInfo.id"..handbookInfo[o].id)
    -- end




    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)

    -- 筛选服务器信息id
    for u =1 , #EquipInfoTab.bin_equips do
        local tid = EquipInfoTab.bin_equips[u].tid
        local gtid = string.sub(tostring(tid),1,-4) -- 前三位id
        local nub = #gethandBookTab

        local flag = false
        for k,v in pairs(gethandBookTab) do
            if v == gtid then
                flag = true         
            end
        end

        if flag == false then
            gethandBookTab[nub +1] = gtid
            for gk,gv in pairs(handbookInfo) do
                local ggtid = string.sub(tostring(gv.id),1,-4)
                if gtid == ggtid then
                    gv.flag = true
                end
            end
        end

    end

    TxtFactory:setValue(TxtFactory.EquipInfo,TxtFactory.HANDBOOK_INFOTAB,handbookInfo)
    -- for gk,gv in pairs(handbookInfo) do
    --     print("gv.id:"..gv.id.." gv.flag:"..tostring(gv.flag))
    -- end


    -- 已经拥有的图鉴
end

function EquipManagement:tabDataDo()
  -- body
end

-- 获取已装备数量
function EquipManagement:getEquipedValue()
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local nub = 0
    for i , v in ipairs(EquipInfoTab.bin_equips) do
        if v.slot ~= 0 then
            nub = nub + 1
        end
    end
    return nub
end
-- 获取可用装备格子
function EquipManagement:GetCanUSeBagNum()
    -- body
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local unlocknum = EquipInfoTab["unlocknum"] --已解锁格子
    local Usenum = EquipInfoTab["bin_equips"] ~= nil and #EquipInfoTab["bin_equips"] or 0

    return unlocknum - Usenum
end
-- 装备抽取 （发送）
EquipManagement.isSendEquipEmail = nil
EquipManagement.money = {0,0}
function EquipManagement:sendEquipExtract(id,coin,diamond,num)
    local json = require "cjson"
   -- local msg = { prop_id = id ,use_coin = coin ,use_diamond = diamond }
   -- local strr = json.encode(msg)

    local levelNum  = self:GetCanUSeBagNum()
    if levelNum == 0 then
        self.equipScene:promptWordShow("当前装备格子已满，无法抽取")
        return false
    end
    self.money[1] = coin
    self.money[2] = diamond
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = { prop_id = id ,use_gold = coin ,use_diamond = diamond }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = item_pb.EquipLotteryRequest()
        message.prop_id = id
        message.use_gold = coin
        message.use_diamond = diamond
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = { 
              code = MsgCode.EquipLotteryRequest,
              data = strr, -- strr
             }
             self.ExtractNum = num
    self.isSendEquipEmail = false
    if levelNum < num then
        self.isSendEquipEmail = true
    end
    MsgFactory:createMsg(MsgCode.EquipLotteryResponse,self)
    NetManager:SendPost(NetConfig.EQUIP_SLOT,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    return true
end

-- 装备抽取 （返回）
function EquipManagement:getEquipExtract(info)
    local json = require "cjson"
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local tab = json.decode(info.data)

    if tab.result == 1 then -- 装备抽取结果
        if tab.reward_list ~= nil then
            for i =1 ,#tab.reward_list do
                local t = tab.reward_list[i]
                EquipInfoTab.bin_equips[#EquipInfoTab.bin_equips + 1] = t
            end
        end
        local priceType = nil
        if tab.gold ~= 0 then
            priceType = 3 -- 金币类型
        else
            priceType = 2 -- 钻石类型
        end
        GamePrintTable("装备抽取 （返回）")
        GamePrintTable(tab)
        local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
        local ggold = tab.gold ~= 0 and tab.gold or self.money[1]
        local ddiamond = tab.ddiamond ~= 0 and tab.ddiamond or self.money[2]

        memData:AddUserInfo(-ggold, -ddiamond)
        memData:AddUserInfo(tab.lottGoldT,tab.lottDiamond)

        self.equipScene:UpdatePlayerInfo()
        self.equipScene:creatGetItemsPanel(tab.reward_list,priceType)
        --self.equipScene.equipExtract:extractEquipInfoFromSer() --UpdatePlayerInfo()
        -- 更新金币
        --self.equipScene.equipExtract:UpdatePlayerInfo()
        -- print("2 #EquipInfoTab.bin_equips"..#EquipInfoTab.bin_equips)
        if self.isSendEquipEmail then
            self.equipScene:promptWordShow("背包已满，其余装备已发送邮件!")
            self.equipScene.sceneParent:GetMailList()
            --emailManagement:SendSystemEmail()
        end
    else
        self.equipScene.equipExtract:extractEquipInfoErr(tab.result)
    end
    self.isSendEquipEmail = false
end

-- 根据tid获取装备附加属性
function EquipManagement:getExtAttribute(tid)
    local valueCurData = ""
    local att_name = ""

    local nub = self.equipTable:GetData(tid, TxtFactory.S_EQUIP_MAX)
    att_name, valueCurData = self.equipTable:GetAttribute(tid)
    if tonumber(tid) >= tonumber(nub) then
        valueCurData = "max"
    end

    return att_name,valueCurData
end

-- 根据uid取tid
function EquipManagement:idFindForTid(id)
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local tid = nil
    for i , v in ipairs(EquipInfoTab.bin_equips) do
         -- print("判断是否装备了"..v.name.." "..btn.name)
        if v.id ==  id then
            tid = v.tid
        end  
    end

    return tid 
end

-- 融合装备位数量判断
function EquipManagement:mergeLeftleftVolumeNum(tab)
    local num = 0
    if tab == nil then
        return num
    end
    for i = 1 , #tab do
        -- print("已装备"..tab[i].."装备容量 "..#tab)
        if tonumber(tab[i]) then
            num = num + 1
        end
    end

    return num
end