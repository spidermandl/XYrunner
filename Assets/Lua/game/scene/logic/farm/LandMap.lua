--[[
author : Desmond
城镇地面管理
]]
LandMap = class(BaseBehaviour)
LandMap.name = 'LandMap'
LandMap.x_length =300 --x 长度
LandMap.z_length = 300 --z 长度

LandMap.xBlocks = 50  --x 方向总块数
LandMap.zBlocks = 50  --z 方向总块数
LandMap.minMoveDis = 8 --最小移动距离

LandMap.blockMatrix = nil --地块矩阵
LandMap.selectedBuilding = nil --选中的建筑
LandMap.StartBlockIndex = nil --起始地块号

LandMap.functionBuilds = nil --一般建筑父级
LandMap.generalBuilds = nil --功能建筑父级
LandMap.allBuilds = nil --城建建筑父类

function LandMap:Awake()
	--print("-----------------LandMap Awake--->>>-----------------")
	self:InitGameObject()
	self.gameObject.transform.localScale = UnityEngine.Vector3(self.x_length,1,self.z_length)
	self.gameObject.layer = UnityEngine.LayerMask.NameToLayer("Land")

	local collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
	collider.isTrigger = false
	collider.center=UnityEngine.Vector3(0,0,0)
	--collider.size=UnityEngine.Vector3(1,0,0)

    --[[设置刚体]]
    local rigidBody = self.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    rigidBody.useGravity = false
    rigidBody.isKinematic = false
    rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll

	self:initBlock()
	--self:initBuilding()
end

function LandMap:InitGameObject()
    self.functionBuilds = find("functionBuilds")
    self.generalBuilds = find("generalBuilds")
    self.allBuilds = find("allBuilds")
end

--初始化地块
function LandMap:initBlock()
	self.blockMatrix = {}
	local matrix = self.blockMatrix

	for i=1,self.xBlocks do
		matrix[i-1] = {}
		for j=1,self.zBlocks do
			matrix[i-1][j-1] = BaseBlock.new()
			matrix[i-1][j-1].index = (i-1) * self.zBlocks +(j-1)
		end
	end
end

--根据index获取地块
function LandMap:GetBlockBaseIndex(index)
	local matrix = self.blockMatrix
	local block = nil
	for i=1,self.xBlocks do
		for j=1,self.zBlocks do
			if matrix[i-1][j-1].index == index then
				block = matrix[i-1][j-1]
			end
		end
	end
	return block
end

--清除建筑所占地块信息
function LandMap:ClearBlock(block,build)
	local x = build.bound.size.x
	local z = build.bound.size.z
	local x_index = math.floor(block.index/self.xBlocks)
    local z_index = block.index - x_index*self.xBlocks
    local x_units = math.ceil(x/self.x_length*self.xBlocks)
    local z_units = math.ceil(z/self.z_length*self.zBlocks)
	for i=1,x_units do
		for j=1,z_units do
			local block = BaseBlock.new()
			block.index = self.blockMatrix[x_index + i-1][z_index+j-1].index
			self.blockMatrix[x_index + i-1][z_index+j-1] = block
		end	
	end
end

--初始化建筑
function LandMap:initBuilding()

	--print("创建建筑物")
    local path = Util.DataPath..AppConst.luaRootPath.."game/export/building_export.json"
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
	    local obj = GameObject.New()
	    obj:SetActive(false)
 		local lua = obj:AddComponent(BundleLua.GetClassType())
 		lua.isUpdate = false
        lua.luaName = config['luaName']
        obj.transform.parent = self.allBuilds.transform
	    obj.transform.position = getVector3(config['position'])
	    obj.transform.rotation = getVector3(config['rotation'])
	    obj.transform.localScale = getVector3(config['scale'])
        -- for v,k in pairs(config['param']) do
        -- 	print (tostring(v).." "..tostring(k))
        -- end
        --print ("-------------function LandMap:initBuilding() "..tostring(config['param'][0]))
        if config['param'] ~= '' then
            LuaShell.setPreParams(obj:GetInstanceID(),config['param'])--预置构造参数
        end
	    obj:SetActive(true)
    end
    

    
    -- self:SetBuilding(self.blockMatrix[0][0],self:CreateBuild())

    -- self:SetBuilding(self.blockMatrix[0][10],self:CreateBuild())

    -- self:SetBuilding(self.blockMatrix[0][20],self:CreateBuild())

    -- self:SetBuilding(self.blockMatrix[0][30],self:CreateBuild())

    -- self:SetBuilding(self.blockMatrix[0][40],self:CreateBuild())

    -- self:SetBuilding(self.blockMatrix[25][25],self:CreateFunctionBuild())
end

--[[
创建建筑物
]]
function LandMap:createBuild(config)
    local build = newobject(Util.LoadPrefab("Building/Alchemy01"))
    build.transform.parent = self.generalBuilds.gameObject.transform  
    build:SetActive(false)
    local item = build:AddComponent(BundleLua.GetClassType())
    item.luaName ="BaseBuilding"
    build.transform.localPosition = UnityEngine.Vector3.zero
    build.transform.localScale = UnityEngine.Vector3.one
    build:SetActive(true)

    return build
end

--[[
放置建筑物于地块
block:地块
build:建筑物
]]
function LandMap:SetBuilding(block,build)
	local luaBuild = LuaShell.getRole(build:GetInstanceID())
	local x = luaBuild.bound.size.x
	local z = luaBuild.bound.size.z

    local x_index = math.floor(block.index/self.xBlocks)
    local z_index = block.index - x_index*self.xBlocks
    local x_units = math.ceil(x/self.x_length*self.xBlocks)
    local z_units = math.ceil(z/self.z_length*self.zBlocks)
    luaBuild.blockIndex = block.index
    --luaBuild.blockIndex = (x_index + i-1)*self.zBlocks + (j-1)
	--luaBuild.allBlock = {}
	--local matrix = luaBuild.allBlock
	for i=1, x_units do  --设置地块和建筑相关信息
		--matrix[i-1] = {}
		for j=1,z_units do
			self.blockMatrix[x_index + i-1][z_index+j-1].building = luaBuild
			--matrix[i-1][j-1] = self.blockMatrix[x_index + i-1][z_index+j-1]
		end
	end
    --设置建筑位置
    build.gameObject.transform:Translate(
    	(x_index+x_units/2)*self.x_length/self.xBlocks-self.x_length/2,
    	0,
    	(z_index+z_units/2)*self.z_length/self.zBlocks-self.z_length/2)
end
--[[
放置建筑物
block:地块
build:建筑物
]]
function LandMap:SetBuild(block,build)
	local x = build.bound.size.x
	local z = build.bound.size.z

    local x_index = math.floor(block.index/self.xBlocks)
    local z_index = block.index - x_index*self.xBlocks
    local x_units = math.ceil(x/self.x_length*self.xBlocks)
    local z_units = math.ceil(z/self.z_length*self.zBlocks)
    build.blockIndex = block.index
	for i=1, x_units do  --设置地块和建筑相关信息
		for j=1,z_units do
			self.blockMatrix[x_index + i-1][z_index+j-1].building = build
		end
	end

    --设置建筑位置
    local pos = build.gameObject.transform.position
    build.gameObject.transform:Translate(
    	(x_index+x_units/2)*self.x_length/self.xBlocks-self.x_length/2-pos.x,
    	0,
    	(z_index+z_units/2)*self.z_length/self.zBlocks-self.z_length/2-pos.z)
    if self.StartBlockIndex ~= nil then
    	self.StartBlockIndex = nil
    end

    if self.selectedBuilding ~= nil then
    	self.selectedBuilding = nil
    end
end

--拖动建筑后的处理
function LandMap:DragEnd()
    if self.selectedBuilding == nil then
        return
    end

    local build = self.selectedBuilding
    local blockNew = self:GetBlockBaseIndex(build.blockIndex)
    local blockOld = self:GetBlockBaseIndex(self.StartBlockIndex)
    if blockNew == nil then
		return
	end

	if blockOld == nil then
		return
	end

    local x = build.bound.size.x
	local z = build.bound.size.z

    local x_indexNew = math.floor(blockNew.index/self.xBlocks)
    local z_indexNew = blockNew.index - x_indexNew*self.xBlocks

    local x_indexOld = math.floor(blockOld.index/self.xBlocks)
    local z_indexOld = blockOld.index - x_indexOld*self.xBlocks 

    local x_units = math.ceil(x/self.x_length*self.xBlocks)
    local z_units = math.ceil(z/self.z_length*self.zBlocks)

    local flag = self:IsHaveBuild(build,x_indexNew,z_indexNew,x_units,z_units)
	if flag == true then
		self:SetBuild(blockOld,build)
	else
		self:ClearBlock(blockOld,build)
		self:SetBuild(blockNew,build)
	end
   
end

--判断是否可以放置建筑
function LandMap:IsHaveBuild(build,x_index,z_index,x_units,z_units)
	local flag = false
	for i=1, x_units do  
		for j=1,z_units do
			if x_index + i-1 >= self.xBlocks then 
				flag = true
				break	
			end
			if z_index+j-1 >= self.zBlocks then
				flag = true
				break	
			end
			local buildT = self.blockMatrix[x_index+i-1][z_index+j-1].building
			if buildT ~= nil then
				if buildT ~= build then
					flag = true
					break
				end
			end
		end
	end
	return flag
end



--[[创建功能建筑物]]
function LandMap:CreateFunctionBuild()
    local build = newobject(Util.LoadPrefab("Building/Inn01"))
    build.transform.parent = self.functionBuilds.gameObject.transform
    build:SetActive(false)
    local item = build:AddComponent(BundleLua.GetClassType())
    item.luaName ="FunctionBuilding"
    build.transform.localPosition = UnityEngine.Vector3.zero
    build.transform.localScale = UnityEngine.Vector3.one
    build:SetActive(true)

    return build
end

--[[
移动建筑物
]]
function LandMap:moveBuild(direction)
	if self.selectedBuilding == nil then
		return
	end

	if self.StartBlockIndex == nil then
		self.StartBlockIndex = self.selectedBuilding.blockIndex
	end

    local dir = UnityEngine.Vector3.zero
    local x_unit = self.x_length/self.xBlocks
    local z_unit = self.z_length/self.zBlocks
    local dx = 0
    local dz = 0
    local x_block = 0
    local z_block = 0

	local x_index = math.floor(self.selectedBuilding.blockIndex/self.xBlocks)
    local z_index = self.selectedBuilding.blockIndex - x_index*self.xBlocks
    local x = x_index
    local z = z_index
	if math.abs(direction.x) >= x_unit then  --x方向移动
		if direction.x < 0 then
			dx = -x_unit
    		x_block = -1
	    end
	    if direction.x > 0 then
	    	dx = x_unit
	    	x_block = 1
	    end
	    if x_index+x_block >= 0 and x_index+x_block < self.xBlocks then
			self.selectedBuilding.gameObject.transform:Translate(dx,0,0)
			x = x_index+x_block
	    	dir.x = dx
		end 
	end

	if math.abs(direction.z) >= z_unit then  --z方向移动
		if direction.z < 0 then
			dz = -z_unit
    		z_block = -1
	    end
	    if direction.z > 0 then
	    	dz = z_unit
	    	z_block = 1
	    end
	    if z_index+z_block >= 0 and z_index+z_block < self.zBlocks then
			self.selectedBuilding.gameObject.transform:Translate(0,0,dz)
			z = z_index+z_block
	    	dir.z = dz
		end
	    
	end
	
	if x < 0 or x >= self.xBlocks then
		return
	end
	if z < 0 or z >= self.zBlocks then
		return
	end
	self.selectedBuilding.blockIndex = x*self.zBlocks+z
	return dir
end



