--[[
author:赵名飞
城建系统 数据部分
]]
BuildingManagement = class()

BuildingManagement.userTable = nil --玩家数据表
BuildingManagement.scene = nil --场景lua
BuildingManagement.buildingTable = nil --城建配置表
BuildingManagement.fetchId = nil --刚才收获的城建实例ID

function BuildingManagement:Awake(targetscene)
	self.scene = targetscene
	self.userTable = TxtFactory:getTable(TxtFactory.UserTXT)
    self.buildingTable = TxtFactory:getTable(TxtFactory.BuildingTXT)
    if TxtFactory:getMemDataCacheTable(TxtFactory.BuildingInfo) == nil then
        local buildingInfo = {}
        TxtFactory:setMemDataCacheTable(TxtFactory.BuildingInfo,buildingInfo)
    end
end
-- 请求城建数据
function BuildingManagement:SendSystemBuilding()
    --do return end
	local json = require "cjson"
   -- local msg = {}
   -- local strr = json.encode(msg)
    
    local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
      	local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = build_pb.BuildListRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    
    local param = {
        code = MsgCode.BuildListRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.BuildListResponse,self)
    NetManager:SendPost(NetConfig.BUILDINGINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end
-- 获取到城建数据
function BuildingManagement:GetBuildingInfo(resp)
    local json = require "cjson"
    local infos = json.decode(resp.data)
    if infos.bin_builds == nil then
        infos.bin_builds = {}
    end
    self:SetBuildingTabel(infos.bin_builds) --存放数据
    self.scene:CreateBuildings() --创建城建建筑，刷新建筑信息，刷新城建名字
    self.scene:RefreshBuildingNames()
end
--[[ 玩家城建表
    bin_buildings = 
    [
        id = 1      //实例Id
        tid = 2     //城建Id
        level = 3   //建筑等级
        pos_x = 4   //位置 x
        pos_y = 5   //位置 y
        status = 6  //状态    0未解锁1已经解锁
        buildType = 7   //建筑类型
        data = 8    //备用数据
    ]
]]
--设置城建动态数据tabel
function BuildingManagement:SetBuildingTabel(bin_builds) 
    if bin_builds == nil then
        bin_builds = {}
    end
    local IdTab = {}
    for i = 1,#bin_builds do
        IdTab[bin_builds[i].id] = bin_builds[i]
        if self.buildingTable:GetData(bin_builds[i].tid,TxtFactory.S_BUILDING_TYPENAME) == 2 and bin_builds[i].data > 0 then
            TxtFactory:setValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_FETCHID,bin_builds[i].id) --记录可以收获的建筑的ID
        end
    end
    TxtFactory:setValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_IDTABLE,IdTab)
    TxtFactory:setValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_HASDATA,"") --设置任意值，代表里面有服务器数据
end
--设置升级后的城建数据
function BuildingManagement:UpgradeBuildingInfo(build_info)
    local info = TxtFactory:getValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_IDTABLE)
    info[build_info.id] = build_info
end
--根据实例ID 获取城建的信息
function BuildingManagement:GetBuildingTabelById(id) 
    local info = TxtFactory:getValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_IDTABLE)
    return info[id]
end
--根据城建ID 获取该城建的basebuilding 对象
function BuildingManagement:GetBuildingObj(buildId)
    local id = math.floor(tonumber(buildId)/1000)
    local objTable = TxtFactory:getValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_OBJTABLE)
    local obj = objTable[tostring(id)]
    return obj
end
-- 城建升级请求
function BuildingManagement:BuildingUpLv_Req(buildId)
    local json = require "cjson"
    -- 向服务器发送升级请求
   -- local msg = { build_id = tonumber(buildId) }
   -- local strr = json.encode(msg)
    
     local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
      	local msg = { build_id = tonumber(buildId) }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = build_pb.BuildUpgradeRequest()
        message.build_id = tonumber(buildId)
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    local param = {
        code = MsgCode.BuildUpgradeRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.BuildUpgradeResponse,self)
    NetManager:SendPost(NetConfig.BUILDING_LVUP,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    print("发送城建升级请求 实例ID为："..buildId)
end
--升级功能消息回复
function BuildingManagement:BuildingUpLv_Resp(response)

    local json = require "cjson"
    local re = tonumber(response.result) -- 反馈结果
    if re == 0 then
        print("反馈服务器错误")
    elseif re == 1 then  -- 反馈成功结果 升级
        --print("升级成功")
        local coins,diamond = self.scene.Building:getUpLvlNeed()
        coins = coins or 0
        diamond = diamond or 0
        local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
        memData:AddUserInfo(-coins, -diamond) -- 扣除金币钻石
        self.scene:UpdatePlayerInfo()
        self:UpgradeBuildingInfo(response.build_info)
        self.scene.Building:upgrade(response.build_info)
    elseif re == 2 then
        print("等级到顶 。。。。。")
    elseif re == 3 then
        print("缺少金币")
    elseif re == 4 then
        print("缺少钻石")
    end
end
-- 领取城建产出请求
function BuildingManagement:BuildingFetch_Req(buildId)
    self.fetchId = buildId
    local json = require "cjson"
    -- 向服务器发送升级请求
   -- local msg = { build_id = tonumber(buildId) }
   -- local strr = json.encode(msg)
     local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
      	local msg = { build_id = tonumber(buildId) }
        strr = json.encode(msg)
    else
        --设置pb data
        local message = build_pb.BuildGainRequest()
        message.build_id = tonumber(buildId)
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
        code = MsgCode.BuildGainRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.BuildGainResponse,self)
    NetManager:SendPost(NetConfig.BUILDING_FETCH,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
end
-- 领取城建产出响应
function BuildingManagement:BuildingFetch_Resp(response)

    local json = require "cjson"
    local re = tonumber(response.result) -- 反馈结果
    if re == 0 then
        print("反馈服务器错误")
    elseif re == 1 then  -- 反馈成功结果 升级
        print("收获成功，获取的金币是："..response.gold)
        self:HideBuildingHarvest()
        self.scene:ShowFetchNumLabel(response.gold)
        local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
        memData:AddUserInfo(response.gold) -- 添加金币
        self.scene:UpdatePlayerInfo()
        TxtFactory:setValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_FETCHID,nil) --领取成功后删除记录的 可领取id
    else
        self.scene:promptWordShow("暂时无法收获，请稍后再来")
    end
end
--隐藏建筑产出
function BuildingManagement:HideBuildingHarvest()
    local info = self:GetBuildingTabelById(self.fetchId)
    if info == nil then
        return
    end
    local obj = self:GetBuildingObj(info.tid)
    obj:hideHarvest()
end
-- 获取服务器数据之后刷新城建的信息
function BuildingManagement:UpdateBuildingObjs()
    local tab = TxtFactory:getValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_IDTABLE)
    for k,v in pairs(tab) do
        local obj = self:GetBuildingObj(v.tid)
        if obj ~= nil then
            obj:updateBuilding(v.tid,k,true)
        else
            print(k.."该城建的对象是空")
        end
    end
end
