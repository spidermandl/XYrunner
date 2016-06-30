--[[
author:赵名飞
好友系统 数据部分
]]
FriendManagement = class()

FriendManagement.userTable = nil --玩家数据表
FriendManagement.scene = nil --场景lua
--初始化
function FriendManagement:Awake(targetscene)

	self.scene = targetscene
	self.userTable = TxtFactory:getTable(TxtFactory.UserTXT)

    local memCache = TxtFactory:getTable("MemDataCache")
    if memCache:getTable(TxtFactory.FriendInfo) == nil then
    	local tabel = {}
    	memCache:setTable(TxtFactory.FriendInfo,tabel)
    end
end
--统一接口可以存放不同好友信息 page:代表存放好友列表的页签 column:列名 0 好友数据 1 好友申请列表 2 推荐好友列表
function FriendManagement:SetFriendInfo(column,value,page)

	if page ~= nil then --分页签存储好友列表
		local tab = self:GetFriendInfo(column,page) --获取当前页的table
        if tab == nil then
            tab = {}
        end
        local infos = {} --新table 根据 memberid做Key 存放数据
        value = value or {}
        for i =1 , #value do
            infos[value[i].memberid] = value[i]
            --table.insert(infos,value[i].memberid,value[i])
        end
		table.insert(tab,page,infos)--table[页][memberid]
		TxtFactory:setValue(TxtFactory.FriendInfo,column,tab)
	else
		TxtFactory:setValue(TxtFactory.FriendInfo,column,value or {})
	end
end
--根据列名获取好友信息 column:列名 page：代表获取好友列表的页签，获取其他数据不需要填
function FriendManagement:GetFriendInfo(column,page)
    
	local tab = TxtFactory:getValue(TxtFactory.FriendInfo,column)
	if page ~= nil and tab ~= nil then
		tab = tab[page]
	end
    return tab
end
--根据当前页签和好友ID删除该好友信息
function FriendManagement:RemoveFriendInfo(friendId)
    local tab = self:GetFriendInfo(0,self.scene.NowPage)
    if tab == nil then
        return nil
    end
    tab[friendId] = nil
end
--获取第一页好友数据（回复对方的申请后调用）
function FriendManagement:GetFirstPage()
    self:SendFriendListReq(0,0)
end
--好友列表 请求 type 0:好友数据,1:好友申请列表 needPage 页签
function FriendManagement:SendFriendListReq(needType,needPage)	

	local json = require "cjson"
   -- local msg = {page = tonumber(needPage),type = tonumber(needType)}
   -- local strr = json.encode(msg)
   
   local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = {page = tonumber(needPage),type = tonumber(needType)}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = friend_pb.FriendListRequest()
        message.page =  tonumber(needPage)
        message.type =  tonumber(needType)
        strr = ZZBase64.encode(message:SerializeToString())
    end
   
    local param = {
        code = MsgCode.FriendListRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.FriendListResponse,self)
    NetManager:SendPost(NetConfig.FRIENDLIST,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    --print("发送好友列表请求，页签是："..needPage.."  发送类型是:"..needType)
end
--好友信息List 回复
function FriendManagement:GetFriendListResp(resp)

    local json = require "cjson"
    local infos = json.decode(resp.data)
    --print("好友信息List 回复".."   信息类型是："..infos.type.."   当前信息页签是："..infos.page.."  总页签是:"..infos.page_num.."  总好友数是:"..infos.num)
    self:SetFriendInfo(infos.type,infos.bin_friend,infos.page) --存放list
    if infos.type == 0 then --获取好友列表时保存 页数数据
        self:SetFriendInfo(TxtFactory.FRIEND_NOWPAGE,infos.page) --存放当前页数
        self:SetFriendInfo(TxtFactory.FRIEND_ALLPAGE,infos.page_num) --存放总页数
        self:SetFriendInfo(TxtFactory.FRIEND_FRIENDNUM,infos.num) --存放现在的好友数
    end
    if infos.type == 1 then 
        self:SetFriendInfo(TxtFactory.FRIEND_REQNUM,infos.num) --存放申请数
    end
    self.scene:RefreshNum() --刷新好友数申请数
    if ((self.scene.SelectType == 1 or self.scene.SelectType == 4) and infos.type == 0)and infos.page == self.scene.NowPage then
        self.scene.FriendItem:checkData() --刷新好友item类, 会提前请求下一页数据 所以验证当前页数
    elseif self.scene.SelectType == 2 and infos.type == 1 then
        self.scene.FriendRequestItem:refresh() --刷新好友推荐item类
    end
    --self:printInfo(infos.bin_friend)
end
--查找好友信息 申请
function FriendManagement:SendFriendFindReq(friendId,findType)	

	local json = require "cjson"
   -- local msg = {find_type = tonumber(findType or 0),memberid = tonumber(friendId)}
   -- local strr = json.encode(msg)
    
      local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = {find_type = tonumber(findType or 0),memberid = tonumber(friendId)}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = friend_pb.FriendFindRequest()
        message.find_type =tonumber(findType or 0)
        message.memberid =  tonumber(friendId)
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    local param = {
        code = MsgCode.FriendFindRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.FriendFindResponse,self)
    NetManager:SendPost(NetConfig.FRIENDFIND,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    --print("发送好友查找请求，查找ID是："..friendId)
end
--好友查找信息 回复
function FriendManagement:GetFriendFindResp(resp)

    local json = require "cjson"
    local infos = json.decode(resp.data)
    if infos.result == 1 then
  		--error("查找到的好友ID是："..infos.friend_info.memberid.."名字是:"..infos.friend_info.nickname)
        self:RefreshFindView(infos.friend_info)
  	else
  		self.scene.scene:promptWordShow(self.scene.textsConfigTXT:GetText(1024))
  	end
end
--刷新好友查找列表
function FriendManagement:RefreshFindView(infos)
    local tab = {}
    tab[infos.memberid] = infos
    self.scene.FriendSeekView:HideView()
    self.scene.FriendRecommendItem:RefreshFindView(tab)
end
--好友添加 申请
function FriendManagement:SendFriendAddReq(friendId)	
    local reqNum = self:GetFriendInfo(TxtFactory.FRIEND_FRIENDNUM) --好友数量减
    if reqNum >= 50 then
        self.scene.scene:promptWordShow(self.scene.textsConfigTXT:GetText(1025))
        return
    end

	local json = require "cjson"
   -- local msg = {memberid = tonumber(friendId)}
  --  local strr = json.encode(msg)
    
     local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = {memberid = tonumber(friendId)}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = friend_pb.FriendAddRequest()
        message.memberid =  tonumber(friendId)
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    local param = {
        code = MsgCode.FriendAddRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.FriendAddResponse,self)
    NetManager:SendPost(NetConfig.FRIENDADD,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    --print("发送好友添加请求，添加的好友ID是："..friendId)
end
--好友添加 回复
function FriendManagement:GetFriendAddResp(resp)

    local json = require "cjson"
    local infos = json.decode(resp.data)
    if infos.result == 1 then
  		--print("申请添加好友成功，添加ID是："..infos.memberid)
        self.scene.scene:promptWordShow(self.scene.textsConfigTXT:GetText(1023))
        self.scene.FriendRecommendItem:ChangeStatus(infos.memberid)
    elseif infos.result == 2 then
        self.scene.scene:promptWordShow(self.scene.textsConfigTXT:GetText(1026))
  	else
  		self.scene.scene:promptWordShow("添加好友失败！")
  	end
end
--接受或拒绝 申请
function FriendManagement:SendFriendAcceptReq(friendId,reply)	

	local json = require "cjson"
    --local msg = {memberid = tonumber(friendId),accept = reply}
    --local strr = json.encode(msg)
    
    local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = {memberid = tonumber(friendId),accept = reply}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = friend_pb.FriendAcceptRequest()
        message.memberid =  tonumber(friendId)
        message.accept =  reply
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    local param = {
        code = MsgCode.FriendAcceptRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.FriendAcceptResponse,self)
    NetManager:SendPost(NetConfig.FRIENDACCEPT,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    --print("接受或拒绝，操作好友ID是："..friendId.."答复是："..tostring(reply))
end
--接受或拒绝 回复
function FriendManagement:GetFriendAcceptResp(resp)

    local json = require "cjson"
    local infos = json.decode(resp.data)
    if infos.result == 1 then
  		--print("接受或拒绝 回复成功，ID是："..infos.memberid)
        self.scene.FriendRequestItem:ChangeStatus(infos.memberid)
        local reqNum = self:GetFriendInfo(TxtFactory.FRIEND_REQNUM) --接受或拒绝后 申请数减一
        if reqNum >0 then
            self:SetFriendInfo(TxtFactory.FRIEND_REQNUM,reqNum-1)
        end
        self.scene:RefreshNum() --刷新好友数申请数
        --接受或拒绝后重新获取第一页好友数据
        self:GetFirstPage()
  	else
  		self.scene.scene:promptWordShow("添加或拒绝  失败！")
  	end
end
--推荐好友 申请
function FriendManagement:SendFriendRecommendReq(needType)	

	local json = require "cjson"
   -- local msg = {type = tonumber(needType or 1)}
  --  local strr = json.encode(msg)
    
     local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = {type = tonumber(needType or 1)}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = friend_pb.RecommendFriendRequest()
        message.type =  tonumber(needType or 1)
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    local param = {
        code = MsgCode.RecommendFriendRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.RecommendFriendResponse,self)
    NetManager:SendPost(NetConfig.RECOMMENDFRIEND,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    --print("发送推荐好友请求")
end
--推荐好友 回复
function FriendManagement:GetFriendRecommendResp(resp)

    local json = require "cjson"
    local infos = json.decode(resp.data)
    self:SetFriendInfo(2,infos.bin_friend)
    --self:printInfo(infos.bin_friend)
    self.scene.FriendRecommendItem:RefreshRecommendView()
    --print("获取推荐好友回复")
end
--删除好友 申请
function FriendManagement:SendFriendRemoveReq(friendId)  

    local ids = {}
    table.insert(ids,friendId)
    local json = require "cjson"
   -- local msg = {removed = ids}
   -- local strr = json.encode(msg)
    
     local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = {removed = ids}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = friend_pb.FriendRemoveRequest()
        for i =1 , #ids do
             message.removed:append(ids[i])
        end
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    local param = {
        code = MsgCode.FriendRemoveRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.FriendRemoveResponse,self)
    NetManager:SendPost(NetConfig.FRIENDREMOVE,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    print("发送删除好友请求：   ID:"..ids[1])
end
--删除好友 回复
function FriendManagement:GetFriendRemoveResp(resp)

    local json = require "cjson"
    local infos = json.decode(resp.data)
    if infos.result == 1 then
        self.scene.FriendInfoView:HideView()
        self.scene.FriendItem:RemoveFriendItem(infos.removed[1])
        self:RemoveFriendInfo(infos.removed[1])
        local reqNum = self:GetFriendInfo(TxtFactory.FRIEND_FRIENDNUM) --好友数量减1
        if reqNum >0 then
            self:SetFriendInfo(TxtFactory.FRIEND_FRIENDNUM,reqNum-1)
        end
        self.scene:RefreshNum() --刷新好友数
    else
        self.scene.scene:promptWordShow("删除好友失败！")
    end
end
--赠送体力 申请 friendId == nil 赠送所有人 else 赠送个人
function FriendManagement:SendGiveStrengthReq(friendId)  

    local json = require "cjson"
   -- local msg = {memberid = friendId and tonumber(friendId) or nil,to_all = friendId and 0 or 1} --to_all 如果friendId不为空 值为1 赠送所有人
   -- local strr = json.encode(msg)
    
    
     local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = {memberid = friendId and tonumber(friendId) or nil,to_all = friendId and 0 or 1}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = mail_pb.GiveStrengthRequest()
        message.memberid = friendId and tonumber(friendId) or nil
        message.to_all = friendId and 0 or 1
        strr = ZZBase64.encode(message:SerializeToString())
    end
    
    local param = {
        code = MsgCode.GiveStrengthRequest,
        data = strr,
    }
    MsgFactory:createMsg(MsgCode.GiveStrengthResponse,self)
    NetManager:SendPost(NetConfig.GIVESTRENGTH,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    local id,all = friendId and tonumber(friendId) or nil,(friendId and 0 or 1)
    print("发送赠送体力请求,iD:"..tostring(id).."   to_all:"..all)
end
--赠送体力 回复
function FriendManagement:GetGiveStrengthResp(resp)

    local json = require "cjson"
    local infos = json.decode(resp.data)
    if infos.result == 1 then
        self.scene.scene:promptWordShow(self.scene.textsConfigTXT:GetText(1027))
        local task = TxtFactory:getTable(TxtFactory.TaskManagement)
        task:SetTaskData(TaskType.LIGHT_COUNT,1)
        if infos.to_all == 1 then
            self.scene.FriendItem:HideBtnTili(nil,true)
        else
            self.scene.FriendItem:HideBtnTili(infos.memberid)
        end
        --[[
        local friendInfo = TxtFactory:getValue(TxtFactory.FriendInfo,0)[self.scene.NowPage][infos.memberid] --数据类型 ，页签，好友id
        if friendInfo ~= nil then
            print("friendInfo")
            friendInfo.give_str = 1
        end
        ]]
        --
    else
        print("赠送体力失败"..infos.result)
        self.scene.scene:promptWordShow(self.scene.textsConfigTXT:GetText(1028))
    end
end
--向其他好友发起挑战记录数据进入无尽界面
function FriendManagement:SendFriendChallengeReq(friendInfo)
    local tab = {}
    tab[TxtFactory.CHALLENGE_FRIENDID] = friendInfo.memberid
    tab[TxtFactory.CHALLENGE_FRIENDINFO] = friendInfo
    TxtFactory:setMemDataCacheTable(TxtFactory.ChallengeInfo,tab)
    --进入无尽界面
    self.scene:SkipEndlessScene()
end
--打印table （调试用）
function FriendManagement:printInfo(tab)
    if tab == nil then
        return
    end
	for i = 1, #tab do
    	print("名字："..tab[i].nickname.."    ID:"..tab[i].memberid.."   Lvl:"..tab[i].level.."  Icon:"..tab[i].icon.."last_time:"..tab[i].last_time.."give_str:"--[[..tab[i].give_str]])
	end
end
