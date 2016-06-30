--[[
author:Desmond
关卡功能逻辑 数据部分
]]
ChapterManagement = class ()

ChapterManagement.scene = nil --对应场景
ChapterManagement.userTable = nil  --用户表
ChapterManagement.chapterTable = nil  -- 本地关卡配置表

--初始化
function ChapterManagement:Awake(targetscene)
    self.scene = targetscene
  	self.userTable = TxtFactory:getTable("UserTXT")
  	self.chapterTable = TxtFactory:getTable(TxtFactory.ChapterTXT)
end

--获取关卡进度信息 (发送)
function ChapterManagement:sendChapterInfo()
    local json = require "cjson"
   -- local msg = {}
   -- local strr = json.encode(msg)
    
     local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
        local msg = {}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = battle_pb.GetBattleListRequest()
        strr = ZZBase64.encode(message:SerializeToString())
    end
    local param = {
              code = MsgCode.GetBattleListRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.GetBattleListResponse,self)
    NetManager:SendPost(NetConfig.EQUIPINFO,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    -- print("获取玩家装备信息 发送")
end

--获取关卡进度信息 (回复)
function ChapterManagement:getChapterInfo(info)
    local json = require "cjson"
  	local tab = json.decode(info.data)
  	local memCache = TxtFactory:getTable("MemDataCache")
    if tab.bin_battles == nil then
        tab.bin_battles = {}
    end
    local c_info = {} 
    local star_info = {}
    
    
    tab.chapter_info = c_info --关卡大章解锁信息信息 
    tab.chapter_star = star_info -- 关卡星级
    tab.cupList = {}
  	memCache:setTable(TxtFactory.ChapterInfo,tab)

    
    --设置关卡大章信息
  	local line = self.chapterTable:GetLineNum()
  	for i = 1 , line do
      local id = self.chapterTable:GetData(i,'ID')
      table.insert(c_info ,id,false) -- 关卡小节
  		local chapterId = self.chapterTable:GetData(id,TxtFactory.S_CHAPTER_TYPE)
  		if c_info[chapterId] == nil then
  			 table.insert(c_info ,chapterId,false) -- 关卡大章
  		end
  	end
    --设置已被解锁的关卡大章
    for k, v in pairs(c_info) do
     local chapterID = self.chapterTable:GetData(tab.cur_battle_id,TxtFactory.S_CHAPTER_TYPE)

     if tab.cur_battle_id == tonumber(k) or k == chapterID then 
          c_info[k] = true
        end
    end
       
    for key,value in pairs(tab.bin_battles) do
        c_info[tonumber(value.id)] = true
        local chapterID = self.chapterTable:GetData(value.id,TxtFactory.S_CHAPTER_TYPE)
        c_info[chapterID] = true
        tab.chapter_star[value.id] = value.star
        --奖杯链表
        tab.cupList[value.id] = value.cups
    end
    --奖杯领取过得物品
    tab.CupRewardList = {}
    if tab.cups ~= nil then
        tab.CupRewardList = tab.cups
    end
    
    self.scene:CreatPanel()
end







