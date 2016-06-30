--[[
author:gaofei
用于处理天梯的数据逻辑以及一些通用的方法
]]

LadderManagement = class()

function LadderManagement:Awake(targetScene)
	self.scene = targetScene
    self.userTable = TxtFactory:getTable(TxtFactory.UserTXT)
end
-------------------------------------------------    天梯功能中与服务器交互  -----------------------------------

--获得玩家天梯信息  请求
function LadderManagement:SendLadderInfoRequest()

    local json = require "cjson"
    
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = ladder_pb.LadderInfoRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
   -- local msg = {}
   -- local strr = json.encode(msg)
    local param = {
        code = MsgCode.LadderInfoRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.LadderInfoResponse,self)
    NetManager:SendPost(NetConfig.LADDER_INFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    
end
--获得玩家天梯信息 回复
function LadderManagement:GetLadderInfoResponse(resp)

    local json = require "cjson"
    local infos = json.decode(resp.data)
    if infos.result == 1 then
        -- 请求信息成功
        -- 保存信息
        local ladderInfo =TxtFactory:getMemDataCacheTable(TxtFactory.LadderInfo)
		if ladderInfo == nil then
			ladderInfo = {}
			local memCache = TxtFactory:getTable("MemDataCache")
  			memCache:setTable(TxtFactory.LadderInfo,ladderInfo)
		end
        
        TxtFactory:setValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO,infos.ladder_info)
        -- 初始化界面
        self.scene:InitView()
    elseif infos.result == 2 then
        -- 天梯关闭
        self.scene.scene:promptWordShow("天梯功能已关闭")
    end
    
end


--确定段位  请求
function LadderManagement:SendLadderLevelConfirmRequest()

    local json = require "cjson"
    
    
     local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = ladder_pb.LadderLevelConfirmRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    --local msg = {}
    --local strr = json.encode(msg)
    local param = {
        code = MsgCode.LadderLevelConfirmRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.LadderLevelConfirmResponse,self)
    NetManager:SendPost(NetConfig.LADDER_INFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    
end
--确定段位 回复
function LadderManagement:GetLadderLevelConfirmResponse(resp)

    local json = require "cjson"
    local infos = json.decode(resp.data)
    if infos.result == 1 then
        -- 存储最新的信息
        TxtFactory:setValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO,infos.ladder_info)
        -- 关闭定级赛界面
        self.scene:LadderCloseBtnOnClick()
        -- 打开挑战界面
        self.scene:InitView()
    elseif infos.result == 2 then
        -- 天梯关闭
        self.scene.scene:promptWordShow("天梯功能已关闭")
    elseif infos.result == 3 then
        -- 定位失败原因是已经结算
        self.scene.scene:promptWordShow("奖励结算中不可以定位")
    end
    
end

--天梯排行列表  请求
function LadderManagement:SendLadderListRequest()
    printf("SendLadderListRequest")
    
    local json = require "cjson"
    
    local strr = nil
    if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = ladder_pb.LadderListRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
   -- local msg = {}
   -- local strr = json.encode(msg)
    local param = {
        code = MsgCode.LadderListRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.LadderListResponse,self)
    NetManager:SendPost(NetConfig.LADDER_INFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    
    --[[
    local  message = ladder_pb.LadderListRequest()
    
	--message.acc_id = Container.GameData.PlayerID()
   -- message.session = Container.GameData.PlayerSession()
	--message.code = MsgCode.LadderListRequest
    local msg = message:SerializeToString()
    MsgFactory:createMsg(MsgCode.LadderListResponse,self)
	Network.SendMessage(msg)
    ]]--
end
--天梯排行列表 回复 
function LadderManagement:GetLadderListResponse(resp)
    printf("GetLadderListResponse")
    local json = require "cjson"
    local infos = json.decode(resp.data)
    -- 返回的排行表  bin_ranks
    TxtFactory:setValue(TxtFactory.LadderInfo,TxtFactory.LADDER_RANKLIST,infos.bin_ranks)
    
    -- 刷新排行列表
    self.scene.ladderRankView:RefreshRankList()
end

--------------------------------------------------  天梯用到的一些公用的方法 ------------------------------------

-- 创建一个天梯等级的对象
function LadderManagement:CreateLadderLevelItem(parent,ladderId,scaleValue,ladderTabel)
	local ladderLevelItem = nil
	ladderLevelItem = newobject(Util.LoadPrefab("UI/Ladder/TemplateLadderLevelItem"))
	ladderLevelItem.transform.parent = parent
    ladderLevelItem.transform.localPosition = Vector3.zero
    ladderLevelItem.transform.localScale = Vector3.one * scaleValue
	--local starName = ladderTabel:GetData(ladderId,"ICON_STAR") 
	ladderLevelItem.transform:Find("Icon"):GetComponent("UISprite").spriteName = ladderTabel:GetData(ladderId,"ICON_BIG")
	--ladderLevelItem.transform:Find("Bg"):GetComponent("UISprite").spriteName = ladderTabel:GetData(ladderId,"ICON_BOX")
	--ladderLevelItem.transform:Find("Xing 1"):GetComponent("UISprite").spriteName =starName
	--ladderLevelItem.transform:Find("Xing 2"):GetComponent("UISprite").spriteName =starName
	--ladderLevelItem.transform:Find("Name"):GetComponent("UILabel").text = ladderTabel:GetData(ladderId,"NAME")
	return ladderLevelItem
end

-- 根据当前的天梯积分判断可以达到的段位
function LadderManagement:GetDanGradingLevelByLadderScore()
   local ladderInfo = TxtFactory:getValue(TxtFactory.LadderInfo,TxtFactory.LADDER_BASEINFO)
   if ladderInfo.max_score == 0 then
        return 0
   end
   local count = #ladderInfo.level_score
    for i = 0 , count - 1 do
        if ladderInfo.max_score >= ladderInfo.level_score[count-i] then
            return count - i
        end
    end
    return 1
end

-- 根据排名以及段位获取到周奖励和日奖励
