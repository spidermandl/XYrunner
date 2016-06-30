--[[
	author:Desmond
	建筑基本类
]]
BaseBuilding = class(BaseBehaviour)

BaseBuilding.type = "BaseBuilding"
BaseBuilding.blockIndex = 0 --占地起始地块
BaseBuilding.allBlock = nil-- 建筑所占所有的地块
BaseBuilding.bound = nil --建筑size
BaseBuilding.building_id = nil --建筑ID
BaseBuilding.instance_id = nil --建筑的实例ID
BaseBuilding.model = nil --城建模型
BaseBuilding.collider = nil --碰撞物体
BaseBuilding.coinModel = nil --产出金币的模型
BaseBuilding.namePoint = nil --模型名字的位置点
BaseBuilding.goldEffect = nil --金币特效
BaseBuilding.shengjiEffect = nil --升级特效

function BaseBuilding:Awake()
	-- print("-----------------BaseBuilding Awake--->>>-----------------")

	self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
	self.collider.isTrigger = false

    --[[设置刚体]]
    local rigidBody = self.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    rigidBody.useGravity = false
    rigidBody.isKinematic = false
    rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll
    self:initParam()
end
--当隐藏时候,隐藏特效
function BaseBuilding:OnDisable()
	if self.goldEffect ~= nil then
		self.goldEffect:SetActive(false)
	end
	if self.shengjiEffect ~= nil then
		self.shengjiEffect:SetActive(false)
	end
end
--设置空城建对象 存储对象
function BaseBuilding:initParam()
    if type(self.bundleParams) == "table" then  --参数从json中读入,动态加载时生效
	    --[[ table参数
	    	 城建id 
	    ]]
	    --存储建筑对象
		self:SetBuildingObj(self.bundleParams[1],self)
	end
end
--将生成之后的城建对象存在表里
--实参 不带等级信息 类似于 11013
function BaseBuilding:SetBuildingObj(buildId,obj) 
	local objTable = TxtFactory:getValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_OBJTABLE)
	if objTable == nil then
		local tab = {}
		TxtFactory:setValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_OBJTABLE,tab)
		objTable = TxtFactory:getValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_OBJTABLE)
	end
	objTable[buildId] = obj
end
--获取本类名字点的世界坐标
function BaseBuilding:GetNamePointWorldPos()
	if self.namePoint ~= nil then
		return self.namePoint.transform:TransformPoint(self.namePoint.transform.localPosition)
	else
		return UnityEngine.Vector3.zero
	end
end
--获得城建信息之后刷新该城建对象的城建id 和 模型 , 是否需要刷新产出
function BaseBuilding:updateBuilding(buildingId,instanceId,chectFecth)
	self.instance_id = instanceId
	self.building_id = buildingId
	local txt = TxtFactory:getTable(TxtFactory.BuildingTXT)
	local modelName = txt:GetData(self.building_id,TxtFactory.S_BUILD_MODEL)
	self.gameObject.name = self.building_id
	GameObject.Destroy(self.model)
    self.model = newobject(Util.LoadPrefab("Building/"..modelName))
    self.model.transform.parent = self.gameObject.transform
    self.model.transform.localPosition = UnityEngine.Vector3(0,0,0)
    self:RecalculateBounds(self.model)
 	self.collider.center=UnityEngine.Vector3(0,self.bound.size.y/2,0)
	self.collider.size=self.bound.size*0.7

	if chectFecth then --升级后不需要检查产出
		--如果本对象的实例ID和可收获的ID相同就show收获模型
		local fetchId = TxtFactory:getValue(TxtFactory.BuildingInfo,TxtFactory.BUILDING_FETCHID) 
		if fetchId ~=nil and self.instance_id~=nil then
			if self.instance_id == fetchId then
				self:showHarvest(self.instance_id)
			end
		end
	end
	--生成城建名字点
	self.namePoint = GameObject.New("namePoint")
	self.namePoint.transform.parent = self.gameObject.transform
	local pos = txt:GetData(self.building_id,"BUILDING_NAME_POSITION")
	local p_v3 = Vector3.zero
	local v3_array = lua_string_split(pos, ";")
	if #v3_array == 3 then
		p_v3:Set(tonumber(v3_array[1]),tonumber(v3_array[2]),tonumber(v3_array[3]))
	end
	self.namePoint.transform.localPosition = p_v3
	self.namePoint.transform.localRotation = UnityEngine.Vector3.zero
	self.namePoint.transform.localScale = UnityEngine.Vector3.one
end
--初始化建筑size
function BaseBuilding:RecalculateBounds(obj)
	local this_mf = obj.transform:GetComponent(UnityEngine.MeshFilter.GetClassType())
	if this_mf==nil then
		self.bound = UnityEngine.Bounds(UnityEngine.Vector3.zero,UnityEngine.Vector3.zero)
	else
		self.bound = this_mf.sharedMesh.bounds
	end

	local mfs = obj.transform:GetComponentsInChildren(UnityEngine.MeshFilter.GetClassType())
	for i=1,mfs.Length do
		
		local pos = mfs[i-1].transform.localPosition
		if mfs[i-1].sharedMesh == nil then
			break
		end
        local child_bounds = mfs[i-1].sharedMesh.bounds
        child_bounds.center = child_bounds.center + pos

        self.bound:Encapsulate(child_bounds)
	end
end

--获取建筑操作类型
function BaseBuilding:getBuildingOperationType()
	local txt = TxtFactory:getTable(TxtFactory.BuildingTXT)
	local mType = txt:GetData(self.building_id,TxtFactory.S_BUILDING_TYPE)
	local isOpen = txt:GetData(self.building_id,TxtFactory.S_BUILDING_OPEN_TYPE)

	if isOpen == '1' then
		return mType
	else
		return nil
	end
    
end

--检测建筑升级
--返回 0 可升级 1 材料不足 2 最大等级
function BaseBuilding:checkUpgrade()
	local status = 0
	local build_txt = TxtFactory:getTable(TxtFactory.BuildingTXT) --获取建筑表
	local isMax = build_txt:GetData(self.building_id,TxtFactory.S_BUILDING_MAX_LVL)
	if  isMax == nil then
		local material_txt = TxtFactory:getTable(TxtFactory.MaterialTXT) --获取材料表
		local bagInfo = TxtFactory:getMemDataCacheTable(TxtFactory.BagItemsInfo) --玩家材料表
		local userInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo) --玩家信息表
		local material_ids = nil
		local materialStr = build_txt:GetData(self.building_id,TxtFactory.S_BUILDING_METERIAL)
		if materialStr ~= "" then
			material_ids = lua_string_split(materialStr, ';')
		end
		local flag = true --检测结果
		if material_ids ~= nil then --判断有没有升级材料
			for i=1,#material_ids do --设置升级材料
				local strs = lua_string_split(material_ids[i],'=')
				local m_id = strs[1]
				local num = strs[2]
			    local c_num = 0
				for i =1 , #bagInfo.bin_items do  --计算材料个数
					local id = bagInfo.bin_items[i].tid
					if tostring(id) == m_id then
						c_num = bagInfo.bin_items[i].num
						break
					end
				end
					
				if tonumber(num) > tonumber(c_num) then
					status = 1
				end
			end
		end
		local require_gold = build_txt:GetData(self.building_id,TxtFactory.S_BUILDING_UPGOLD)
		if require_gold == nil or require_gold =='' then
		    require_gold = 0
		end
		local require_diamonds = build_txt:GetData(self.building_id,TxtFactory.S_BUILDING_UPDIAMONDS)
		if require_diamonds == nil or require_diamonds =='' then
			require_diamonds = 0
		end

		local diamond = userInfo[TxtFactory.USER_DIAMOND]

		if tonumber(require_diamonds) > tonumber(diamond) then
			status = 1
		end
		local gold = userInfo[TxtFactory.USER_GOLD]
		if tonumber(require_gold) > tonumber(gold) then
			status = 1
		end
	else
		status = 2
	end
	return status
end
--建筑升级
function BaseBuilding:upgrade(build_info)
	print("现在的tid是："..self.building_id.."   升级后的tid是："..build_info.tid.."  升级后的实例id是："..build_info.id)
	--播放建筑升级特效
	if self.shengjiEffect == nil then
		self.shengjiEffect = newobject(Util.LoadPrefab("Effects/Building/ef_CJ_shengji"))
	end
    self.shengjiEffect.transform.parent = self.gameObject.transform
    self.shengjiEffect.transform.localPosition = UnityEngine.Vector3(0,10,0)
    self.shengjiEffect.transform.rotation = Quaternion.Euler(-33,90,24)
    self.shengjiEffect.transform.localScale = UnityEngine.Vector3.one
    self.shengjiEffect:SetActive(true)
	self:updateBuilding(build_info.tid,build_info.id)
end
--选中效果
--ScaleFrom：立即改变游戏物体的比例大小，然后随时间返回游戏物体原本的大小
function BaseBuilding:ShakeObject()
	if self.gameObject.transform.localScale == Vector3.one then --大小恢复到原大小后才可以再次变大
		iTween.ScaleFrom(self.gameObject, Vector3(1.2, 1.2, 1.2), 0.6);
	end
end
--展示产出模型
function BaseBuilding:showHarvest(id)
    self.coinModel = newobject(Util.LoadPrefab("Items/".."Spincoin"))
	self.coinModel.transform.parent = self.gameObject.transform
	self.coinModel.transform.localPosition = UnityEngine.Vector3(-3,28,0)
	self.coinModel.transform.localScale = UnityEngine.Vector3(2,8,8)
	local box = self.coinModel:AddComponent(UnityEngine.BoxCollider.GetClassType())
	box.center=UnityEngine.Vector3.zero
	box.size=UnityEngine.Vector3.one
	self.coinModel.name = id
end
--隐藏查出模型
function BaseBuilding:hideHarvest()
	--播放收获金币特效
	if self.goldEffect == nil then
		self.goldEffect = newobject(Util.LoadPrefab("Effects/Building/ef_CJ_goldcoins"))
	end
    self.goldEffect.transform.parent = self.gameObject.transform
    self.goldEffect.transform.localPosition = UnityEngine.Vector3(0,0,0)
    self.goldEffect.transform.rotation = Quaternion.Euler(0,0,0)
    self.goldEffect.transform.localScale = UnityEngine.Vector3.one
    self.goldEffect:SetActive(true)

	if self.coinModel ~= nil then
		GameObject.Destroy(self.coinModel)
	end
end
--获取建筑id
function BaseBuilding:getBuildingId()
	return self.building_id
end
--获取建筑的实例ID
function BaseBuilding:getBuildingInstanceId()
	return self.instance_id or 0
end
--返回建筑父类的位置
function BaseBuilding:getBuildingObjPosition()
	return self.gameObject.transform.localPosition
end
--获取该建筑升级消耗的金币和钻石
function BaseBuilding:getUpLvlNeed()
	local build_txt = TxtFactory:getTable(TxtFactory.BuildingTXT) --获取建筑表
	local require_gold = build_txt:GetData(self.building_id,TxtFactory.S_BUILDING_UPGOLD)
	local require_diamonds = build_txt:GetData(self.building_id,TxtFactory.S_BUILDING_UPDIAMONDS)
	return tonumber(require_gold),tonumber(require_diamonds)
end







