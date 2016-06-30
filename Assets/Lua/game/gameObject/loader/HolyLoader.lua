--[[
	神圣模式载入场景object
	author：赵名飞
]]
HolyLoader = class(ObjectLoader)

HolyLoader.roadName = "part_Holy"
HolyLoader.index = 1 --动态生成 序号 对应data
HolyLoader.listener = nil --监听事件
HolyLoader.rotation = Quaternion.Euler(0,90,0)
HolyLoader.objTable = nil --存储本地图创建出的物体

function HolyLoader:Awake()
    self.objTable = {}
    --self.super.Awake(self)
    ConfigParam.isSceneObjLoadDynamic = true

    self.enemyManager = PoolFunc:pickSingleton("EnemyGroup")
    
    self.itemManager = PoolFunc:pickSingleton("ItemGroup")

    self.surfaceManager = PoolFunc:pickSingleton("SurfaceGroup")

    self.effectManager = PoolFunc:pickSingleton("EffectGroup")

    self.petManager = PoolFunc:pickSingleton("PetGroup")

    self:init()
end
function HolyLoader:init()
    local t = self:parseConfigJson()
    self.listener:setActiveLight(false)
    self:loadObj(t)
    self:loadRoad()
end
function HolyLoader:Update()
    self.super.Update(self)
end
--解析json配置
function HolyLoader:parseConfigJson()
    local path = Util.DataPath..AppConst.luaRootPath.."game/export/"..self.roadName..".json"
    local json = require "cjson"
    local util = require "3rd/cjson.util"
    local obj = json.decode(util.file_load(path))
    return obj
end
--生成物体
function HolyLoader:createObj(config)
    local obj = self.super.createObj(self,config)
    table.insert(self.objTable,obj) --加入创建出的物体
end

--载入地面
function HolyLoader:loadRoad()
	local road = self.memeryPool:pickObjByPrefabName("part/"..self.roadName)
	road.transform.rotation = self.rotation
	road.transform.position = ConfigParam.HolyMapPosition
    table.insert(self.objTable,road)
    if self.listener ~=nil then
        self.listener:notifySpeedChange(RoleProperty.holeStateSpeed)
    end
end
--载入配置
function HolyLoader:loadObj(obj)
    self.super.loadObj(self,obj)
end
--退出地图隐藏创建出的对象
function HolyLoader:inactiveObj()
    self.listener:setActiveLight(true)
    for i=1,#self.objTable do
        self.memeryPool:inactiveObj(self.objTable[i])
    end
end