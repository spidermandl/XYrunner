--[[
author:Desmond
内存管理池，缓存场景中的动态object
]]
MemeryPool = class ()
--[[
{
   "name1":[...],
   "name2":[...],

   singleton:{
	  "name":...
   }
}
]]

MemeryPool.pool = nil --对象池 存放未激活物体
MemeryPool.newobjT = nil --记录新建的对象

--初始化
function MemeryPool:init()
	--print ("-----------------function MemeryPool:init() ")
	if self.pool == nil then
		self.pool = {}
		self.pool.singleton ={}
		self.newobjT = {}
	end
	PoolFunc.pool = self
end

--[[
获取单例
name:单例名字
create:是否强制创建
]]
function MemeryPool:pickSingleton(name,create)
	if create == true then
		self.pool.singleton[name] = nil
	end
    
    local single = self.pool.singleton[name]
	if single == nil then    
		single =_G[name].new()
		self.pool.singleton[name] = single
	end

	return single
end

--[[
 分配一个物体
 name: lua name
]]
function MemeryPool:pickObjByLuaName(name)
    --print ("--------------function MemeryPool:pickObjByLuaName(name) "..name)
	local create = function ()
	--print ("--------------function MemeryPool:pickObjByLuaName(name) 2 "..name)
    	local obj = GameObject.New()
    	obj.name = name
		self:record(name)
    	return obj
	end

	return self:pickObj(name,create)

end

--[[
分配一个物体
name:prefab name
]]
function MemeryPool:pickObjByPrefabName(name)
    --GamePrint ("--------------function MemeryPool:pickObjByPrefabName(name) "..name)
	local create = function ()
    	local obj = newobject(Util.LoadPrefab(name))
    	--GamePrint ("--------------function MemeryPool:pickObjByPrefabName(name) "..tostring(obj))
    	obj.name = name
    	self:record(name)
    	return obj
	end

	local obj = self:pickObj(name,create)
	obj:SetActive(true)
	return obj

end

--[[
分配一个物体
]]
function MemeryPool:pickObj(name,func)
	local inactive = self.pool[name]

	if inactive == nil then
        --print ("-------------------pickObj new table "..name)
		inactive = {}
		self.pool[name] = inactive
	end
    
    -- for k,v in pairs(self.pool[name]) do
    -- 	print (name..": "..tostring(k)..":"..tostring(v))
    -- end

    local obj = inactive[1]
    if obj ~= nil then --重用object
    	--print ("-------------------pickObj reuse "..obj.name)
    	table.remove(inactive,1)
    else
    	--print ("-------------------pickObj new "..name)
    	obj = func()
    end

    return obj
end
--激活物体
function MemeryPool:activeObj()
	-- body
end

--冷藏物体
function MemeryPool:inactiveObj(obj)
	if obj == nil then
		return
	end
	--print ("-----------------------function MemeryPool:inactiveObj(obj) "..tostring(obj:GetInstanceID()))
    local inactive = self.pool[obj.name]
    if inactive ~= nil then
    	for i=1,#inactive do --数组元素不能重复
    		if obj == inactive[i] then
    			return
    		end
    	end
		obj:SetActive(false)
		table.insert(self.pool[obj.name],obj)
	else
		if self.pool[obj.name] == nil then
			self.pool[obj.name] = {}
		end
		obj:SetActive(false)
		table.insert(self.pool[obj.name],obj)
    end
    
end

--记录新建的gameobject
function MemeryPool:record(name)
	if RoleProperty.isNewObjRecorded == true then
    	local num = self.newobjT[name]
    	if num == nil then
    		num = 0
    	end
    	num = num + 1
    	self.newobjT[name] = num
	end
end

--内存清理
function MemeryPool:gc()
	if self.pool ~=nil then
		for k,v in pairs(self.pool) do 
			self.pool[k] = nil
			k = nil
		end
		collectgarbage()
	end
end

--打印每种gameobject
function MemeryPool:printObject()
	if RoleProperty.isNewObjRecorded == true then
		local log = ""
		for key,value in pairs(self.newobjT) do
			log = log..key..":"..tostring(value).."    "
		end
		
		GamePrint(log)
	end
end



