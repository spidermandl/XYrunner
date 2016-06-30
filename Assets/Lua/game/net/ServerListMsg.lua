--[[
author:Desmond
服务器列表返回信息
]]
ServerListMsg = class(BaseMsg)
-- local this = ServerListMsg;

function ServerListMsg:Excute(response)

    self.callback:ServerListFromSer(response)
    local txt = TxtFactory:getTable("UserTXT")
	  --txt:setUser(response.Username,response.Password)

    local server_list = {}
    for i=1,#response.server_list do
        server_list = response.server_list[i]
    end


    --AppConst.SocketPort = 80
    -- print ("------------->>>>>>>>>> Enter ServerListMsg  url : "..server_list.url.."  "..response.recent_server_id)
    -- local ro = tonumber(txt:getValue('roleCount'))
    -- if ro == 0 then --没有创建角色
    --     -- self:test_pblua_func()
    --      local msg = charinfo_pb.RegisterRequest();
    --      msg.authkey = txt:getValue('authkey')
    --      local str = TabToString(msg)
    --      local param = {  --创建角色
    --           code = 51,
    --           data = str,
    --          }
    --          MsgFactory.MesId = 5
    --     NetManager:SendPost(NetConfig.ROLE_CREAT_API,json.encode(param)..'|'..txt:getValue('Username')..':'..txt:getValue('access_token'))
    -- elseif ro == 1 then
    --       -- NetManager:SendPost(NetConfig.SER_LISTGET_API,'a'..'|'..txt:getValue('Username')..':'..txt:getValue('access_token'))
    --      local msg = charinfo_pb.GetCharInfoRequest();
    --      msg.authkey = txt:getValue('authkey')

    --      local str = TabToString(msg)
    --      local param = {  --获取角色信息
    --           code = 16000,
    --           data = str,
    --          }
    --          MsgFactory.MesId = 6
    --          -- print("22222222"..charinfo_pb.GETCHARINFOREQUEST_MSGTYPE_ID_ENUM.number)
    --     NetManager:SendPost(NetConfig.ROLE_INFOGET_API,json.encode(param)..'|'..txt:getValue('Username')..':'..txt:getValue('access_token'))
    -- end

end

-- function TabToString(data)
--     local res = {}
--     local tab = data
--     local s = tostring(tab)
--     local array = lua_string_split(s,",")
--     for i = 1 , #array do 
--          local u = lua_string_split(array[i],":")
--          local key = string.gsub(u[1],"%s","")
--          local value = string.gsub(u[2],"%s","")
--          if tonumber(value) == nil then
--               res[key] = value
--               print("res[key]"..value)
--          else
--               res[key] = tonumber(value) 
--          print("msg.avator_tid "..tonumber(value)+10)
--          end
        
--     end


-- -- for k, v in pairs(res) do  
-- --     data[k] = v
-- --     print(k..v)
-- -- end

--    return  json.encode(res)
-- end