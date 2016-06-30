--[[
	author:gaofei
	主城中宠物行走基类
]]



BasePetWalk = class(BaseBehaviour)

BasePetWalk.type = "BasePetWalk"

BasePetWalk.petWalkSpeed = nil -- 宠物行走的速度

BasePetWalk.roadData = nil -- 路的数据结构

BasePetWalk.petWalkManagement = nil -- 路径管理器

BasePetWalk.curPointData = nil -- 当前点的数据
BasePetWalk.nextPointData = nil -- 下一个点的数据
BasePetWalk.moveDirection =nil --移动方向 (一个向量)

BasePetWalk.petMode = nil  -- 宠物模型
BasePetWalk.stopWalk = nil  -- 该宠物停止走

function BasePetWalk:Awake(petid,parent,petWalkManagement,bornPoint)
	--self.super.Awake(self)
	self.petWalkManagement = petWalkManagement
	-- 生成对象
	
	local mountTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
	local pName = "Pet/"
        --print("----------"..walkPetTab[i])
    pName = pName .. mountTable:GetData(petid, "MODEL").."_ui"
    self.petMode = newobject(Util.LoadPrefab(pName))
        
    self.petMode.transform.localScale = Vector3.one*5
    self.petMode.transform.parent = parent.transform
	
	self.roadData = self.petWalkManagement.roadData
	--math.randomseed(os.time())
    --local bornPoint = math.random(1,#self.roadData)
	self.curPointData = self.roadData[bornPoint]
	self.petMode.transform.localPosition = self.curPointData.postion	
	self.stopWalk = false
	self:initParam()
end

--设置宠物出生点已经数据
function BasePetWalk:initParam()
	--self.super.initParam(self)
	
	self.petWalkSpeed = 0.1
	self.moveDirection = Vector3(0,0,0)
	--[[
	--self.petWalkManagement = self.bundleParams
	self.roadData = self.petWalkManagement.roadData
	math.randomseed(os.time())
    local bornPoint = math.random(1,#self.roadData)
	self.curPointData = self.roadData[bornPoint]
	petMode.transform.localPosition = self.curPointData.postion	
	]]--
	-- 检测路
	self:CheckPetWalkDirection()
end

function BasePetWalk:Update()
	-- 如果该宠物走到了下一个点
	
	if self.nextPointData == nil or self.curPointData == nil then
		return
	end
	
	if self.stopWalk then
		return
	end
	
	if self:ChechReachNextPoint() then
		self.curPointData = self.nextPointData
		self.curPointData.state = false
		local petWalkDirection = self:CheckPetWalkDirection()
		if petWalkDirection == false then -- 无路可走
			--GamePrint("~~~~~~~~~~~~")
			-- 暂停一秒
			self.stopWalk = true
			coroutine.start(self.StartWalk, self)
			return
		end
	end
	self.petMode.transform.localPosition =self.petMode.transform.localPosition + self.moveDirection
	
end

--[[
	检测宠物可以行走的方向 -- 上北 下南 左西 右东 
	优先级为上，左，右，下
	如果四种情况都不可以走,该宠物停止走,等待下一帧的判断
]]--
function BasePetWalk:CheckPetWalkDirection()
	local roadIds = self.curPointData.roadIds
	local roadData = nil
	local canWalkPoint = {}
	local index = 1
	for i =1 ,#roadIds do
		roadData = self.petWalkManagement:GetRoadDataById(roadIds[i])
		--GamePrint(tostring(roadData.state))
		if roadData.state == false then
			-- 记录当前可以走的点
			canWalkPoint[index] = roadData
			index = index +1
		end
	end
	-- 根据优先级判断出那个路优先级最高
	local weight = 5 -- 权重
	roadData = nil
	for i = 1 ,#canWalkPoint do
		if self.curPointData.postion.x > canWalkPoint[i].postion.x then
			-- 往上移动
			roadData,weight = self:CheckWeight(weight,1,canWalkPoint[i],roadData)
		elseif self.curPointData.postion.x < canWalkPoint[i].postion.x then
			-- 往下移动
			roadData,weight = self:CheckWeight(weight,4,canWalkPoint[i],roadData)
		elseif self.curPointData.postion.z > canWalkPoint[i].postion.z then
			-- 往左移动
			roadData,weight = self:CheckWeight(weight,2,canWalkPoint[i],roadData)
		elseif self.curPointData.postion.z < canWalkPoint[i].postion.z then
			-- 往右移动
			roadData,weight = self:CheckWeight(weight,3,canWalkPoint[i],roadData)
		end
	end
	if #canWalkPoint > 0 then
		roadData.state = true
		self.nextPointData = roadData
		self:CheckDirection()
		return true
	end
	return false
end 

-- 判断当前方向和下一个可以行走方向的关系
function BasePetWalk:CheckDirectionForNextPoint(weight)
	-- 根据当前方向判断权重
	if weight == 1 then
		-- 向上跑
		if self.moveDirection == Vector3(self.petWalkSpeed,0,0) then
			-- 方向相反
			return 4
		else
			return 1
		end
	end
	
	if weight == 2 then
		-- 向上跑
		if self.moveDirection == Vector3(0,0,self.petWalkSpeed) then
			-- 方向相反
			return 4
		else
			return 1
		end
	end
	
	if weight == 3 then
		-- 向上跑
		if self.moveDirection == Vector3(0,0,-self.petWalkSpeed) then
			-- 方向相反
			return 4
		else
			return 1
		end
	end
	
	if weight == 4 then
		-- 向上跑
		if self.moveDirection == Vector3(-self.petWalkSpeed,0,0) then
			-- 方向相反
			return 4
		else
			return 1
		end
	end
end

-- 判断权重
function BasePetWalk:CheckWeight(minWeight,curWeight,curRoadData,roadData)
	curWeight = self:CheckDirectionForNextPoint(curWeight)
	
	if minWeight > curWeight then
		return curRoadData,curWeight
	end
	return roadData,minWeight
end

-- 检测是否到达下一个点(左右和上下误差0.01个点)
function BasePetWalk:ChechReachNextPoint()
	if math.abs(self.petMode.transform.localPosition.x - self.nextPointData.postion.x) < 0.001 and 
		math.abs(self.petMode.transform.localPosition.z - self.nextPointData.postion.z) < 0.001 then
		return true
	end
	return false
end

-- 检测当前需要走的方向
function BasePetWalk:CheckDirection()
	if self.curPointData.postion.x > self.nextPointData.postion.x then
		self.moveDirection = Vector3(-self.petWalkSpeed,0,0)
		self:PetRotation(1)
	elseif self.curPointData.postion.x < self.nextPointData.postion.x then
		self.moveDirection = Vector3(self.petWalkSpeed,0,0)
		self:PetRotation(4)
	elseif self.curPointData.postion.z > self.nextPointData.postion.z then
		self.moveDirection = Vector3(0,0,-self.petWalkSpeed)
		self:PetRotation(2)
	elseif self.curPointData.postion.z < self.nextPointData.postion.z then
		self.moveDirection = Vector3(0,0,self.petWalkSpeed)
		self:PetRotation(3)
	end
end

-- 设置宠物旋转
function BasePetWalk:PetRotation(direction)
	if direction == 1 then
		self.petMode.transform.localRotation = Quaternion.Euler(0,-90,0)
	elseif direction == 2 then
		self.petMode.transform.localRotation = Quaternion.Euler(0,180,0)
	elseif direction == 3 then
		self.petMode.transform.localRotation = Quaternion.Euler(0,0,0)
	elseif direction == 4 then
		self.petMode.transform.localRotation = Quaternion.Euler(0,90,0)
	end
end


function BasePetWalk:StartWalk()
	coroutine.wait(1)
	self.stopWalk = false
end