--[[
author:Desmond
内存池 方法调用
]]
PoolFunc = {}

PoolFunc.pool = nil -- memerypool 实例

function PoolFunc:pickSingleton(name,create)
	if self.pool == nil then
		return
	end

	return self.pool:pickSingleton(name,create)
end
--冷藏对象
function PoolFunc:inactiveObj(obj)
	if self.pool == nil then
		return
	end

	self.pool:inactiveObj(obj)
end

--[[
分配一个物体
name:prefab name
]]
function PoolFunc:pickObjByPrefabName(name)
	--GamePrint("----------------function PoolFunc:pickObjByPrefabName(name) 1")
	if self.pool == nil then
		return
	end
    --GamePrint("----------------function PoolFunc:pickObjByPrefabName(name) 2")
	return self.pool:pickObjByPrefabName(name)

end

--[[
分配一个物体
name:lua name
]]
function PoolFunc:pickObjByLuaName( name )
	if self.pool == nil then
		return
	end

	return self.pool:pickObjByLuaName(name)
end

--[[
清理内存
]]
function PoolFunc:gc()
	if self.pool == nil then
		return
	end

	self.pool:gc()
end

--打印每种gameobject
function PoolFunc:printObject()
	self.pool:printObject()
end




