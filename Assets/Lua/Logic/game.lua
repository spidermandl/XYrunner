require "3rd/pblua/login_pb"
require "3rd/pbc/protobuf"

local lpeg = require "lpeg"

local json = require "cjson"
local util = require "3rd/cjson.util"

require "Logic/luaclass"
--require "Logic/CtrlManager"
require "Common/functions"
--require "Controller/PromptCtrl"
require "System/Global"
require "game/config"  --Desmond

--管理器--
GameManager = {}
local this = GameManager

function GameManager.LuaScriptPanel()
	return 'Prompt', 'Message'
end

function GameManager.Awake()
    --warn('Awake--->>>');
end

--启动事件--
function GameManager.Start()
	--warn('Start--->>>');
end

--初始化完成，发送链接服务器信息--
function GameManager.OnInitOK()
    AppConst.SocketPort = 80 --端口
    AppConst.SocketAddress = NetDomain
    --NetManager:SendConnect();
    TxtFactory:RegisterAll()
    if TxtFactory:getTable("UserTXT"):isActive() == true then

        -- local MountTxt = TxtFactory:getTable("MountTXT")
        -- -- local a = MountTxt:GetData(id+1,key)
        -- local a = MountTxt:GetData(tostring(101001),"TYPE")
        -- print(tostring(a))
        
        -- print("go getTable if")  --登陆game
        -- local txt = TxtFactory:getTable("UserTXT")
        --     local param = {
        --     -- -- device = "111116",e25081f3
        --     username = txt:getValue('Username'),
        --     password = txt:getValue('Password'),
        -- }
        -- MsgFactory.MesId = 3
        -- NetManager:SendPost(NetConfig.USER_LOGIN_API,json.encode(param))

        -- local param = {  --注册
        --     --  username":"xy0000006","password":"3d472b",
        --         device = "1111195"
        -- }
        -- local txt = TxtFactory:getTable("UserTXT")
        -- txt:addRole("0") -- 没有创建过角色
        -- MsgFactory.MesId = 1
        -- NetManager:SendPost(NetConfig.GUEST_REG_API,json.encode(param))


       -- local msg = charinfo_pb.GetCharInfoRequest()
    -- msg.authkey = self.txt:getValue('authkey')
       -- local strr = json.encode(msg)

       -- local protobuf = require "protobuf"
       -- local aaa = charinfo_pb.REGISTERREQUEST
       -- aaa = protobuf.Descriptor() 
       -- aaa.name = "a"
      -- if next(aaa) ~= nil then
      --    print("aaa table 有元素 :"..aaa.name .. "end")
      -- end

      -- print("msg"..tostring(msg.gggg))
      -- for i, v in pairs(msg) do  
      --      print("i:"..tostring(i).."      v:"..tostring(v))
      -- end
      --   print("aa")
      -- --   print(tostring(msg._is_present_in_parent))

      --  if next(msg.field) ~= nil then
      --     print("msg._fields 有元素 :"..msg._fields .. "end")
      -- end

      -- for i, v in pairs(msg.field) do  
      --      print("i:"..tostring(i).."      v:"..tostring(v))
      -- end
      -- print(4%8)

    else
        print("go getTable else")
        local param = {
            device = "111116",
        }
        NetManager:SendPost(NetConfig.GUEST_REG_API,json.encode(param))
    end
    -- this.test_class_func();
    -- this.test_pblua_func();
    -- this.test_cjson_func();
    -- this.test_pbc_func();
    -- this.test_lpeg_func();

    --createPanel("Prompt");
    -- CtrlManager.Init();
    -- local ctrl = CtrlManager.GetCtrl(CtrlName.Prompt);
    -- if ctrl ~= nil then
    --     ctrl:Awake();
    -- end
    -- warn('OnInitOK--->>>');
end

function GameManager.test_lpeg_func()
	warn("test_lpeg_func-------->>");
	-- matches a word followed by end-of-string
	local p = lpeg.R"az"^1 * -1

	print(p:match("hello"))        --> 6
	print(lpeg.match(p, "hello"))  --> 6
	print(p:match("1 hello"))      --> nil
end

--测试lua类--
function GameManager.test_class_func()
    luaclass:New(10, 20):test();
end

--测试pblua--
function GameManager.test_pblua_func()
    local login = login_pb.LoginRequest();
    login.id = 2000;
    login.name = 'game';
    login.email = 'jarjin@163.com';
    print(tostring(login))

     local a =   TabToString(login)
    
    local msg = login:SerializeToString();
    LuaHelper.OnCallLuaFunc(msg, this.OnPbluaCall);
end

--pblua callback--
function GameManager.OnPbluaCall(data)
    local msg = login_pb.LoginRequest();


    msg:ParseFromString(data);

    --     local data = {}
    -- print(tostring(msg))
    -- for k, v in pairs(msg) do  
    -- data[k] = v
    -- print("k :"..tostring(k).." v :"..tostring(v))
    -- end
    -- -- NetManager:SendPost(NetConfig.USER_LOGIN_API,json.encode(msg))
    -- -- print("msg"..msg);
    -- print(msg.id..' '..msg.name);
end

--测试pbc--
function GameManager.test_pbc_func()
    local path = Util.DataPath.."lua/3rd/pbc/addressbook.pb";
    log('io.open--->>>'..path);

    local addr = io.open(path, "rb")
    local buffer = addr:read "*a"
    addr:close()
    protobuf.register(buffer)

    local addressbook = {
        name = "Alice",
        id = 12345,
        phone = {
            { number = "1301234567" },
            { number = "87654321", type = "WORK" },
        }
    }
    local code = protobuf.encode("tutorial.Person", addressbook)
    LuaHelper.OnCallLuaFunc(code, this.OnPbcCall)
end

--pbc callback--
function GameManager.OnPbcCall(data)
    local path = Util.DataPath.."lua/3rd/pbc/addressbook.pb";

    local addr = io.open(path, "rb")
    local buffer = addr:read "*a"
    addr:close()
    protobuf.register(buffer)
    local decode = protobuf.decode("tutorial.Person" , data)

    print(decode.name)
    print(decode.id)
    for _,v in ipairs(decode.phone) do
        print("\t"..v.number, v.type)
    end
end

--测试cjson--
function GameManager.test_cjson_func()
    local path = Util.DataPath.."lua/3rd/cjson/example2.json";
    local text = util.file_load(path);
    LuaHelper.OnJsonCallFunc(text, this.OnJsonCall);
end

--cjson callback--
function GameManager.OnJsonCall(data)
    local obj = json.decode(data);
    print(obj['menu']['id']);
end

--销毁--
function GameManager.OnDestroy()
	--warn('OnDestroy--->>>');
end
