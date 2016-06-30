--[[
author:gaofei
宠物行走管理类
]]

PetWalkManagement = class ()

PetWalkManagement.roadData = nil -- 路的数据结构

function PetWalkManagement:Awake()
	self:InitRoadData()
end

-- 根据id获取到数据
function PetWalkManagement:GetRoadDataById(roadDataId)
	for i = 1 , #self.roadData do
		if self.roadData[i].id == roadDataId then
			return self.roadData[i]
		end
	end
	GamePrint("没有找到对应点的数据,数据错误")
	return nil
end

-- 初始化数据
function PetWalkManagement:InitRoadData()
	-- 第一条路
	self.roadData = {}
    local path = Util.DataPath..AppConst.luaRootPath.."game/export/petwalk_export.json"
    local json = require "cjson"
    local util = require "3rd/cjson.util"
    local objs = json.decode(util.file_load(path))

    --分割字符串成Vector3
    local getVector3 = function (str)
		local vectorArray = lua_string_split(str,",")
		return UnityEngine.Vector3(tonumber(vectorArray[1]),tonumber(vectorArray[2]),tonumber(vectorArray[3]))
    end

    for i=1,#objs do --遍历配置文件
    	local config = objs[i]
		local data = {}
	
		data.postion = getVector3(config['position'])
		data.id = config['id']
		data.state = config['state']
		data.roadIds = config['roadIds']
		table.insert(self.roadData,data)
	end
end

