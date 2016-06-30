--[[
无尽模式载入场景object
author:Desmond
]]

EndlessLoader = class(ObjectLoader)

--[[
无尽关卡配置格式
  //id规则   base＋stage＋offset 1000 ＋ 1
  id:[{"path":"","rotation":"0,0,0","position":"-747.3,-3.66,134.4","left_x":-794.50805664063,
       "scale":"94.41614,7.304693,6.824931","parentName":"collider","luaName":"FlatSurface","param":""},
       ...]
]]
EndlessLoader.sceneElementConfig = nil
EndlessLoader.offset_X = 0 --放入物件x方向偏移量

EndlessLoader.currentSpeed = 1 --当前速度难度
EndlessLoader.currentBase = 0 --当前场景号
EndlessLoader.currentType = 0 --随机组序号
EndlessLoader.randomIDs = nil --随机id 数组
EndlessLoader.rollNum = 0 --每种关卡类型随机数量
EndlessLoader.sceneNum = 0 --每种场景随机数量
EndlessLoader.totalIndex = 0 --关卡随机索引
EndlessLoader.bkOffset = 0 --中远景偏差
EndlessLoader.activatedRoads = nil --激活的路面
EndlessLoader.activeNum = 2 --激活数量

EndlessLoader.listener = nil --监听事件
EndlessLoader.isCreateNexting = false --是否正在生产下一段路面

function EndlessLoader:Awake()
	--print ("---------------------------------------->>>>>>>>>> function ObjectLoader:Awake() 1")
    self.super.Awake(self)
end

--初始化数据
function EndlessLoader:init()
	--print ("-------------------function EndlessLoader:init() 1")
    local time = os.time()--设置随机种子
    math.randomseed(time)

	-- if self.listener ~=nil then
	-- 	self.listener:notifySpeedChange(self.speedStage[1])
	-- end

    self.activatedRoads = {}

    self.sceneElementConfig = {}

    if self.listener ~=nil then -- 初始中景和远景
        --print ('=====================================================EndlessLoader:init() '..tostring(self.offset_X))
    	--self.listener:changeFarLandscape(self.currentBase,self.offset_X)
    	--self.listener:changeMiddleLandscape(self.currentBase,self.offset_X)
        --self.bkOffset = self.offset_X
	end
    
    self.randomIDs = {}
    self:randomElement()
end


function EndlessLoader:Update()
	if self.camera == nil then
        print (" ------------------->>>>>>>> EndlessLoader camera not loaded")
    	return
    end
    if self.isCreateNexting == true then --正在生成下一段路面
        return 
    end
    self:managerUpdate()

    local right = 2 * self.data[self.index]['localPosition'].x - self.data[self.index]['left_x']
    
    --print("index:"..tostring(self.index).." self.data: "..tostring(#self.data).." right:"..tostring(right).." offset_X:"..tostring(self.offset_X))
    local distance = self.offset_X - self.camera.gameObject.transform.position.x
    --GamePrint("self.camera.x:"..self.camera.gameObject.transform.position.x.."  self.offset_X:"..self.offset_X.." distance:"..distance)
    if (self.index == #self.data or right >= self.offset_X) and distance < ConfigParam.NextEndlessRoadDistance then --开始载入新关卡条件
    	self:randomElement()
        return
    end
    local dis = tonumber(self.data[self.index]['left_x']) - self.camera.gameObject.transform.position.x
    if  dis < ConfigParam.objectLoadByCameraDis then
    	local config = self.data[self.index]
    	-- if config['parentName'] == 'EliminateItemGroup' then
    	-- 	self:createEliminateItem(config)
    	-- else
    		self:createObj(config)
    	--end
    	self.index = self.index +1
    end
    local distance = self.camera.gameObject.transform.position.x - self.bkOffset
    if distance > 0 and self.listener ~=nil then
        self:changeLandscape(1)
    end
end


--解析json配置
function EndlessLoader:parseConfigJson(roadName)
	if self.sceneElementConfig[roadName] == nil then
	    local path = Util.DataPath..AppConst.luaRootPath.."game/export/"..roadName..".json"
	    local json = require "cjson"
	    local util = require "3rd/cjson.util"
	    local obj = json.decode(util.file_load(path))
	    self.sceneElementConfig[roadName] = obj
	end
    return self.sceneElementConfig[roadName]
end

--随机关卡
function EndlessLoader:randomElement()
    self.totalIndex = self.totalIndex + 1
    --设置随即数值
    local endlessTxt = TxtFactory:getTable(TxtFactory.EndlessTXT)
    local param = {}
    local changeScene = 0 --1、只改变中景，2、中远景一起变    
    --print ("-----------function EndlessLoader:randomElement() "..tostring(self.rollNum).." : "..tostring(self.sceneNum).." : "..tostring(#self.randomIDs))
    if self.rollNum == 0 or self.sceneNum == 0 or ( self.rollNum == -1 and #self.randomIDs == 0 ) then    --设置参数
        --随机关随完          场景随完                 无限循环随机关卡随完
        local add = 1
        if self.rollNum < 0 then --如果roll == -1 表示无限随机关
            add = 0
        end
        if self.sceneNum == 0 then --如果当前场景随完,后面有比当前base大的关,base+1
            local par = {}
            par[TxtFactory.S_ENDLESS_BASE] = tostring(self.currentBase + 1)
            local ids = endlessTxt:getIDbyCondition(par)
            if #ids >0 then
                self.currentBase = self.currentBase + 1
                self.sceneNum = tonumber(endlessTxt:GetData(ids[1],TxtFactory.S_ENDLESS_SEASON))
            end
            changeScene = 2
        end
        param[TxtFactory.S_ENDLESS_TYPE] = tostring(self.currentType + add)
        param[TxtFactory.S_ENDLESS_BASE] = tostring(self.currentBase)
        self.randomIDs = endlessTxt:getIDbyCondition(param) --根据base和type取数据
        if #self.randomIDs == 0 then
            print (' type:'..tostring(param[TxtFactory.S_ENDLESS_TYPE])..tostring(param[TxtFactory.S_ENDLESS_BASE]))
            print ("random failed ")
            return
        end
        
        self.currentSpeed = tonumber(endlessTxt:GetData(self.randomIDs[1],TxtFactory.S_ENDLESS_SPEED))
        self.currentType = tonumber(endlessTxt:GetData(self.randomIDs[1],TxtFactory.S_ENDLESS_TYPE))
        self.rollNum = tonumber(endlessTxt:GetData(self.randomIDs[1],TxtFactory.S_ENDLESS_ROLL))
        
    end
    --GamePrint("150 self.currentBase   :"..self.currentBase)
    local index = math.random(1,#self.randomIDs)
    local id = tostring(self.randomIDs[index])
    --print ('-----------------  function EndlessLoader:randomElement() id '..id)
    --GamePrint("Id:"..id.."  self.currentBase:"..self.currentBase.."  self.currentSpeed:"..self.currentSpeed.."  self.currentType:"..self.currentType)
    TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_HP_RATE,tonumber(endlessTxt:GetData(id,TxtFactory.S_ENDLESS_HP_USE)))
    local roadName = endlessTxt:GetData(id,TxtFactory.S_ENDLESS_NAME)
    local jsonName = endlessTxt:GetData(id,TxtFactory.S_ENDLESS_PREFABNAME)
    if roadName == nil or jsonName == nil then
        print (" no road prefab found")
        return
    end
    
    if self.listener ~=nil then
        self.listener:notifySpeedChange(tonumber(self.currentSpeed))
    end



    self:loadRoad(roadName)
    self:loadObj(self:parseConfigJson(jsonName))

    -- 删除过度动画  跑到第二个小关卡删除
    if self.lastChangeScene and self.listener ~= nil then
        self.lastChangeScene = false
        self.listener:removeCurtain()
    end
    self:changeLandscape(changeScene)
    if changeScene then --记录场景变化
        self.lastChangeScene = true 
    end

    if self.rollNum < 0 then --最高速度
    else --roll次数减一
        self.rollNum = self.rollNum - 1
    end
    
    self.sceneNum = self.sceneNum - 1 

    table.remove(self.randomIDs,index)

end
function EndlessLoader:changeLandscape(changeScene)
    if changeScene > 0 and self.listener ~=nil then --载入新场景
        -- 添加过度动画
        --self.listener:addCurtain(self.offset_X)
        if changeScene > 1 then
            self.listener:changeFarLandscape(self.currentBase,self.bkOffset)
        end
        self.listener:changeMiddleLandscape(self.currentBase,self.bkOffset)
        self.bkOffset = self.bkOffset + 600 --临时做法 中景长度
    end
end
-- EndlessLoader.testIndex = 0
-- --随机关卡
-- function EndlessLoader:randomElement()
--     local endlessTxt = TxtFactory:getTable(TxtFactory.EndlessTXT)
--     local id = self.testIndex - math.floor(self.testIndex/6)*6 +1
--     self.testIndex = self.testIndex + 1
--     if math.floor(self.testIndex/6)*6 == self.testIndex then
--         self.testIndex = self.testIndex + 1
--     end
--     local roadName = endlessTxt:GetData(tostring(id),TxtFactory.S_ENDLESS_NAME)
--     self.currentSpeed = tonumber(endlessTxt:GetData(tostring(id),TxtFactory.S_ENDLESS_SPEED))
--     if self.listener ~=nil then
--         --print ("------------------------function EndlessLoader:randomElement() "..tostring(self.speedStage))
--         self.listener:notifySpeedChange(self.speedStage[self.currentSpeed])
--     end

--     self:loadRoad(roadName)
--     self:loadObj(self:parseConfigJson(roadName))
-- end

--载入地面
function EndlessLoader:loadRoad(name)
	if #self.activatedRoads > self.activeNum then --冷藏即将加载的路面的第前activeNum个路面
		self.memeryPool:inactiveObj(self.activatedRoads[1])
		table.remove(self.activatedRoads,1)
	end

	local road = self.memeryPool:pickObjByPrefabName("part/"..name)
	--GamePrint('-----------------loadRoad '..tostring(self.offset_X))
    self.memeryPool:printObject()
	local old_x = road.transform.position.x
	road.transform:Translate(self.offset_X-old_x,0,0)

	table.insert(self.activatedRoads,road)
	
end

--载入配置
--obj: 配置内容lua table
function EndlessLoader:loadObj(obj)
    --初始化数据
    local data = {}
    if self.data ~= nil then --老配置迁移
        while self.data[self.index] ~= nil do
        	table.insert(data, self.data[self.index])
            self.index = self.index + 1
        end
    end

    local max_x = 0
    for i=1,#obj do --重构数据
    	if obj[i]['hasParsed'] ~= true then --第一次 配置json字串解析
	        obj[i]['localPosition'] = self:getVector3(obj[i]['localPosition'])
	        obj[i]['localRotation'] = self:getVector3(obj[i]['localRotation'])
	        obj[i]['localScale'] = self:getVector3(obj[i]['localScale'])
	        obj[i]['hasParsed'] = true
	    end
        
        local copy = clone (obj[i])--复制一份配置，加入偏移信息
		copy['localPosition'].x = copy['localPosition'].x + self.offset_X
		copy['left_x'] = copy['left_x']+self.offset_X
		--print("center:"..tostring(copy['localPosition'].x).." left_x:"..tostring(copy['left_x']))

        local right = copy['localPosition'].x + copy['localScale'].x/2
        if right > max_x and copy["luaName"] == "FlatSurface" then --只计算地面长度
        	max_x = right 
        end

        table.insert(data,copy)
    end

    self.offset_X = max_x
    self.index = 1
    self.data = data
    self.rootObject = find("Objects")

end
--载入下一段路面
function EndlessLoader:loadNextRoad()
    local point = self.itemManager:getNearestHolyLandingPointMarkByType(self.camera.gameObject.transform.position.x)
    if point ~= nil then
        GamePrint("-----------------进入神圣模式前找到的下落点    :"..tostring(point))
        return point
    end
    if self.isCreateNexting == false then
        self.data = nil
        self:randomElement()
        self.isCreateNexting = true
    end
    local config = self.data[self.index]
    if config == nil then
        return nil
    end
    self:createObj(config)
    self.index = self.index +1
end

-- --[[
-- 创建eliminateGroup
-- ]]
-- function EndlessLoader:createEliminateItem(config)
--     -- if sub.luaName == "EliminateItemGroup" then
-- 	if self[config['parentName']] == nil then --纪录根节点
-- 		self[config['parentName']] = self.rootObject.transform:Find(config['parentName'])
-- 	end
    
--     local luaName = config['luaName'] --必须为绑定lua的object
--     if luaName == '' then
--         return
--     end

--     local luaName = 'EliminateItemGroup'
--     local group = self.memeryPool:pickObjByLuaName(luaName)
--     local sub = group:GetComponent(BundleLua.GetClassType())
--     if sub == nil then
--         sub = group:AddComponent(BundleLua.GetClassType())
--         group.luaName = luaName
--         group.transform.position = UnityEngine.Vector3(0,0,0)
--         group.transform.rotation = UnityEngine.Vector3(0,0,0)
--         group.transform.localScale = UnityEngine.Vector3(1,1,1)
--         group.transform.parent = self[config['parentName']]
--     end
--     --[[ table参数
--         luaname
--         收集物位置
--         收集物rotataion
--         收集物scale
--         材料表id
--     ]]
--     local posStr = lua_string_s it(config['position'],",")
--     local groupPos = UnityEngine.Vector3(tonumber(posStr[1]),tonumber(posStr[2]),tonumber(posStr[3]))
--     local array = lua_string_split(config['param'],"/") --参数间分割符
--     local subArr = lua_string_split(array[2],",")
--     array[2] = UnityEngine.Vector3(tonumber(subArr[1]),tonumber(subArr[2]),tonumber(subArr[3])) 
--     array[2] = array[2]+ groupPos
--     array[2].x = array[2].x + self.offset_X
--     subArr = lua_string_split(array[3],",")
--     array[3] = UnityEngine.Vector3(tonumber(subArr[1]),tonumber(subArr[2]),tonumber(subArr[3])) 
--     subArr = lua_string_split(array[4],",")
--     array[4] = UnityEngine.Vector3(tonumber(subArr[1]),tonumber(subArr[2]),tonumber(subArr[3])) 

--     config['param'] = array
--     local lua = LuaShell.getRole(group:GetInstanceID())
--     lua.bundleParams = array
--     lua:initParam()

-- end


