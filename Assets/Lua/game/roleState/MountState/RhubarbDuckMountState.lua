--[[
大黄鸭坐骑状态
作者：秦仕超
]]
RhubarbDuckMountState = class (BaseMountState) 

RhubarbDuckMountState._name = "RhubarbDuckMountState"
RhubarbDuckMountState.player=nil					-------主角
RhubarbDuckMountState.playerAnimator=nil 			-------主角动画
RhubarbDuckMountState.SpeedTime=PetStaticTable.RhubarbDuckMountSpeedTime	-------加速时间
RhubarbDuckMountState.oldState=nil 					-------之前状态
RhubarbDuckMountState.type=PetType.Ordinary			-------状态：0、坐骑；1、道具
RhubarbDuckMountState.myMount=nil 					--------坐骑
RhubarbDuckMountState.runPath=nil					--------运行路径
RhubarbDuckMountState.runIndex=0 					--------路径指针
RhubarbDuckMountState.runLength=1					--------数组长度
RhubarbDuckMountState.yTime=0 						--------y轴改变时间
RhubarbDuckMountState.position_Y=nil 				--------变化时y的位置
RhubarbDuckMountState.speed=Vector3(0,0,0) 			--------大黄鸭速度

function RhubarbDuckMountState:Enter(role)
	self.super.Enter(self,role)
	self.player=LuaShell.getRole(LuaShell.DesmondID)
	if self.runPath~=nil then
		self.runLength=table.getn(self.runPath)+1
	end
	if self.type~=PetType.Ordinary then
		if self.player.property.PetMountName~=nil then
			self.myMount=self.player.gameObject.transform:Find(self.player.property.PetMountName).gameObject
			self.myMount:SetActive(false)
		end
	end
	self:AddEffect(role,"ef_pleyer_male_chongci")
    --self.effect.transform.rotation = UnityEngine.Quaternion.Euler(0,90,0)
    local pArray = self.effect.gameObject.transform:GetComponentsInChildren(UnityEngine.ParticleSystem.GetClassType())
    local length = pArray.Length-1 
    for i=0,length do
    	System.Array.GetValue(pArray,i):Play()
	end
	self.oldState=self.player.SpecialState
	self.player.SpecialState=SpecialState.stealth
	self.player.myState=SpecialState.outControl
	role.gameObject.transform.parent=self.player.gameObject.transform.parent
	self.player.gameObject.transform.parent=role.gameObject.transform
end

function RhubarbDuckMountState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
	if self.runPath~=nil and self.runIndex<self.runLength then
		if math.abs(self.runPath[self.runIndex].y-role.gameObject.transform.position.y)>0.5 then
			self.speed.y= self.speed.x~=0 and(self.runPath[self.runIndex].y-role.gameObject.transform.position.y)/
			((self.runPath[self.runIndex].x-role.gameObject.transform.position.x)/
				self.speed.x) or 0
		else
			self.speed.y=0
		end
		if math.abs(self.runPath[self.runIndex].z-role.gameObject.transform.position.z)>0.5 then
			self.speed.z= self.speed.x~=0 and(self.runPath[self.runIndex].z-role.gameObject.transform.position.z)/
			((self.runPath[self.runIndex].x-role.gameObject.transform.position.x)/
				self.speed.x) or 0
		else
			self.speed.z=0
		end
		if role.gameObject.transform.position.x>self.runPath[self.runIndex].x then
		 	self.runIndex=self.runIndex+1
		end
	end
	role.gameObject.transform:Translate(self.speed*dTime,Space.World)
	if self.SpeedTime>0 and self.runIndex<self.runLength then
		self.SpeedTime=self.SpeedTime-UnityEngine.Time.deltaTime
		self.speed.x= self.player.moveSpeedVect * self.player.property.sprintSpeed
	else
		-- print("剩余时间："..tostring(self.SpeedTime))
		self.player.SpecialState=self.oldState
			self.player.myState=SpecialState.normal
			self.player.gameObject.transform.parent=role.gameObject.transform.parent
			role.gameObject.transform.parent=self.player.gameObject.transform
			self.speed=Vector3.zero
		if self.effect ~= nil then
			GameObject.Destroy(self.effect)
		end
		if self.type~=PetType.Ordinary then
			if self.myMount~=nil then
				self.myMount:SetActive(true)
			end
			LuaShell.OnDestroy(role.gameObject:GetInstanceID())
		end
	end
	
	-- role.gameObject.transform:Translate(self.speed)
	-- print(self.SpeedTime..":速度：："..tostring(self.player.property.moveDir.x))
end

function RhubarbDuckMountState:Exit(role)
	if self.effect ~= nil then
		GameObject.Destroy(self.effect)
	end
end