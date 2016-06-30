--[[
动态载入场景object
author:Desmond
]]
ObjectLoader = class (BaseBehaviour)
ObjectLoader.index = 1 --动态生成 序号 对应data
ObjectLoader.camera = nil --场景移动camera
ObjectLoader.data = nil --解析json配置信息
--[[
    path,没有使用
    parentName, 父gameobject名
    luaName, 绑定lua名
    left_x, 最左侧x坐标
    position, gameobject 中心位置
    rotation, gameobject 旋转位置
    scale, gameobject 大小
    param, 传给lua对象的初始参数
    ]]

ObjectLoader.rootObject = nil --场景动态物体根节点

ObjectLoader.memeryPool = nil --内存池

ObjectLoader.enemyManager = nil --怪物管理类
ObjectLoader.itemManager = nil --item管理类
ObjectLoader.surfaceManager = nil--surface管理类
ObjectLoader.effectManager = nil--surface管理类
ObjectLoader.petManager = nil --pet管理器

function ObjectLoader:Awake()
	--print ("---------------------------------------->>>>>>>>>> function ObjectLoader:Awake() 1")
    ConfigParam.isSceneObjLoadDynamic = true

    self.memeryPool = MemeryPool.new()
    self.memeryPool:init()
    
    self.enemyManager = PoolFunc:pickSingleton("EnemyGroup",true)
    self.enemyManager:Awake()
    
    self.itemManager = PoolFunc:pickSingleton("ItemGroup",true)
    self.itemManager:Awake()

    self.surfaceManager = PoolFunc:pickSingleton("SurfaceGroup",true)
    self.surfaceManager:Awake()

    self.effectManager = PoolFunc:pickSingleton("EffectGroup",true)
    self.effectManager:Awake()

    self.petManager = PoolFunc:pickSingleton("PetGroup",true)
    self.petManager:Awake()

    self:init()
end

function ObjectLoader:init()
    local t = self:parseConfigJson()
    self:loadObj(t)
    if TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_STORY) ~= UnityEngine.SceneManagement.SceneManager.GetActiveScene().name then --场景为非通用场景
        self:loadRoad()
    end

end

--启动事件--
function ObjectLoader:Start()
end

function ObjectLoader:Update()
	if self.camera == nil then
        print (" ------------------->>>>>>>> ObjectLoader camera not loaded")
    	return
    end
    
    self:managerUpdate()

    if self.data[self.index] ==nil or self.data[self.index]['left_x'] == nil then
        return
    end

    local dis = tonumber(self.data[self.index]['left_x']) - self.camera.gameObject.transform.position.x
    if  dis < ConfigParam.objectLoadByCameraDis then
    	self:createObj(self.data[self.index])
    	self.index = self.index +1
    end
end

function ObjectLoader:FixedUpdate()
    if self.enemyManager ~= nil then
        self.enemyManager:FixedUpdate()
    end

    if self.itemManager ~= nil then
        self.itemManager:FixedUpdate()
    end

    if self.surfaceManager ~= nil then
        self.surfaceManager:FixedUpdate()
    end

    if self.effectManager ~= nil then
        self.effectManager:FixedUpdate()
    end

    if self.petManager ~= nil then
        self.petManager:FixedUpdate()
    end
end

function ObjectLoader:LateUpdate()
    if self.enemyManager ~= nil then
        self.enemyManager:LateUpdate()
    end

    if self.itemManager ~= nil then
        self.itemManager:LateUpdate()
    end

    if self.surfaceManager ~= nil then
        self.surfaceManager:LateUpdate()
    end

    if self.effectManager ~= nil then
        self.effectManager:LateUpdate()
    end

    if self.petManager ~= nil then
        self.petManager:LateUpdate()
    end
end


function ObjectLoader:managerUpdate()
    if self.enemyManager ~= nil then
        self.enemyManager:Update()
    end

    if self.itemManager ~= nil then
        self.itemManager:Update()
    end

    if self.surfaceManager ~= nil then
        self.surfaceManager:Update()
    end

    if self.effectManager ~= nil then
        self.effectManager:Update()
    end

    if self.petManager ~= nil then
        self.petManager:Update()
    end
end
--解析json配置
function ObjectLoader:parseConfigJson()
    
    local path = Util.DataPath..AppConst.luaRootPath.."game/export/"..TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_STORY)..".json"
    --print(" path : "..path)
    --UnityEngine.Application.loadedLevelName..".json"
    local json = require "cjson"
    local util = require "3rd/cjson.util"
    --print(util.file_load(path))
    local obj = json.decode(util.file_load(path))
    -- local str = ""
    -- obj = json.decode(str)
    --print (tostring(obj))
    return obj

end

--载入地面
function ObjectLoader:loadRoad()
    local road = self.memeryPool:pickObjByPrefabName("part/"..TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_STORY))
    road.transform:Translate(0,0,0) 
end

--载入配置
--obj: 配置内容lua table
function ObjectLoader:loadObj(obj)
    --初始化数据
    for i=1,#obj do --重构数据
        --print (tostring(i)..": "..tostring(obj[i]['localPosition']))
        obj[i]['localPosition'] = self:getVector3(obj[i]['localPosition'])
        obj[i]['localRotation'] = self:getVector3(obj[i]['localRotation'])
        obj[i]['localScale'] = self:getVector3(obj[i]['localScale'])
    end
    self.data = obj
    self.rootObject = find("Objects")
end

--分割字符串成Vector3
function ObjectLoader:getVector3(str)
	local vectorArray = lua_string_split(str,",")
   -- print(" x : "..vectorArray[1] .." y : "..vectorArray[2] .."  z : "..vectorArray[3] )
	return UnityEngine.Vector3(tonumber(vectorArray[1]),tonumber(vectorArray[2]),tonumber(vectorArray[3]))
end

--生成物体
function ObjectLoader:createObj(config)
	if self[config['parentName']] == nil then --纪录根节点
		self[config['parentName']] = self.rootObject.transform:Find(config['parentName'])
	end
    
    local luaName = config['luaName'] --必须为绑定lua的object
    if luaName == '' then
        return
    end
    
    -- if config['parentName'] == 'monster' then
    --     return
    -- end

    local obj = self.memeryPool:pickObjByLuaName(luaName) --从内存池中读取
    obj:SetActive(false)
    local sub = obj:GetComponent(BundleLua.GetClassType())

    obj.transform.parent = self[config['parentName']]
    obj.transform.localPosition = config['localPosition']
    obj.transform.localRotation = Quaternion.Euler(config['localRotation'])
    --print ("---------------------function ObjectLoader:createObj(config) "..tostring(config['rotation']))
    obj.transform.localScale = config['localScale']
    
    --print ("---------------------function ObjectLoader:createObj(config) "..luaName)
    if sub == nil then --第一次创建物体
        sub = obj:AddComponent(BundleLua.GetClassType())
        sub.luaName = luaName
        -- if config['param'] ~=nil and config['param'] ~= '' then
        --     LuaShell.setPreParams(obj:GetInstanceID(),config['param'])--预置构造参数
        -- end
        LuaShell.setPreParams(obj:GetInstanceID(),config)--预置构造参数
        self:addDebugMesh(obj)
    else --重用加载
        local lua = LuaShell.getRole(obj:GetInstanceID())
        lua.bundleParams = config
        lua:initParam()
    end
    --print ("-------------------function ObjectLoader:createObj(config) "..tostring(obj.name))
    obj:SetActive(true)
    return obj
end

--加碰撞体mesh
function ObjectLoader:addDebugMesh(obj)
    --加mesh
    if ConfigParam.FilterColliderMash == false then--去碰撞物mesh
        if  obj.transform.parent.name == "collider" or obj.transform.parent.name == "wall" then
            local cube = self.memeryPool:pickObjByPrefabName("Items/mesh_test")
            local ms = obj.gameObject:AddComponent(UnityEngine.MeshFilter.GetClassType())
            ms.mesh = cube.gameObject:GetComponent(UnityEngine.MeshFilter.GetClassType()).mesh
            obj.gameObject:AddComponent(UnityEngine.MeshRenderer.GetClassType())
            --GameObject.Destroy(cube)
            self.memeryPool:inactiveObj(cube)
        end
    end
end


--设置摄像机
function ObjectLoader:setCamera( c )
    self.camera = c
    --print("------------------function ObjectLoader:setCamera( c ) "..tostring(self.camera))
end
