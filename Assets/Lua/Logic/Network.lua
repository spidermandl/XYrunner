
require "Common/define"
require "Common/protocal"
require "Common/functions"
--require "PbLua/ladder_pb"
Event = require 'events'

-- 测试用

require "3rd/pblua/common_pb"
require "3rd/pblua/explorer_pb"
require "3rd/pblua/ladder_pb"
require "3rd/pblua/charinfo_pb"
require "3rd/pblua/item_pb"
require "3rd/pblua/build_pb"
require "3rd/pblua/task_pb"
require "3rd/pblua/rank_pb"
require "3rd/pblua/pet_pb"
require "3rd/pblua/mail_pb"
require "3rd/pblua/iap_pb"
require "3rd/pblua/friend_pb"
require "3rd/pblua/battle_pb"
require "3rd/pblua/avator_pb"


Network = {}
local this = Network

local islogging = false

function Network.Start() 
    warn("Network.Start!!")
    Event.AddListener(Connect, this.OnConnect)
    Event.AddListener(Login, this.OnLogin)
    Event.AddListener(Exception, this.OnException)
    Event.AddListener(Disconnect, this.OnDisconnect)
end

--http消息--
function Network.OnResponse(response)
    MsgFactory:Excute(response)
end
--Socket消息--
function Network.OnSocket(key, buffer)
    Event.Brocast(tostring(key), data)
end

--当连接建立时--
function Network.OnConnect() 
    warn("Game Server connected!!")
end

--异常断线--
function Network.OnException() 
    islogging = false; 
    NetManager:SendConnect();
   	error("OnException------->>>>")
end

--连接中断，或者被踢掉--
function Network.OnDisconnect() 
    islogging = false; 
    error("OnDisconnect------->>>>")
end

--当登录时--
function Network.OnLogin(buffer) 
    warn('OnLogin----------->>>')
    --createPanel("Message"); --Lua里创建面板
    local ctrl = CtrlManager.GetCtrl(CtrlName.Message)
    if ctrl ~= nil then
        ctrl:Awake();
    end
end

--卸载网络监听--
function Network.Unload()
    Event.RemoveListener(Connect)
    Event.RemoveListener(Login)
    Event.RemoveListener(Exception)
    Event.RemoveListener(Disconnect)
    warn('Unload Network...')
end