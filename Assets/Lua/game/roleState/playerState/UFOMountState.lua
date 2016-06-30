--[[
ufo座骑状态 共享状态
author:Desmond
]]
UFOMountState = class (BaseMountState)

UFOMountState._name = "UFOMountState"
UFOMountState.roleName = 'ufo_mount'
UFOMountState.configPos = nil --位置偏移表
UFOMountState.colorShift = false --是否变色


function UFOMountState:Enter(role)
    self.configPos = self:setPlayerRelativePos(role.roleName)
    role.stateMachine:addStateChangeListener(self)

	self.mount = newobject(Util.LoadPrefab("Mount/"..self.roleName))
    self.mount.transform.parent = role.gameObject.transform
    self.mount.transform.localRotation = Quaternion.Euler(0,90,0)
    self.mount.transform.localScale = UnityEngine.Vector3(1.5,1.5,1.5)
    self.mount.transform.localPosition = UnityEngine.Vector3(0,2,0)

    -- destroy(role.character.gameObject)--替换人物模型
    -- local skin = newobject(Util.LoadPrefab("Player/"..role.roleName))
    -- skin.transform.parent = role.gameObject.transform
    -- skin.transform.localPosition = UnityEngine.Vector3.zero
    -- role.character = skin.gameObject.transform

    --  --[[设置主角动画]]
    -- local modelCfg = role:GetModelConfig(role.roleName.."_mount")
    -- role:setEntity(modelCfg)
    self.animator = role.animator
    
    --[[设置碰撞体]]
    role.collider.center=UnityEngine.Vector3(0,2,0)
    role.collider.radius=2
    role.collider.height=4
    
	self.mountAnimator = self.mount:GetComponent("Animator")
	self.animator:Play("ride on ufo")

    --加入磁铁状态
    local buff = MagnetState.new()
    buff.stage = 0 
    buff.distance = ConfigParam.UFOMagnetDistance
    role.stateMachine:addSharedState(buff)
end

function UFOMountState:Excute(role,dTime)
	if self.effect ~= nil then
		local effectSys = self.effect.transform:GetChild(0):GetComponent(UnityEngine.ParticleSystem.GetClassType())
		if effectSys.time >= 0.2 then
			GameObject.Destroy(self.effect)
			self.effect = nil
			self:SetActive(true)
		end
	end
end

function UFOMountState:Exit(role)
	--还原角色配置
    role.collider.center=UnityEngine.Vector3(0.2,1,0)
    role.collider.radius=0.4
    role.collider.height=2

	role.character.transform:Translate(0,-1.3,0,UnityEngine.Space.World)
    role.character.transform.localPosition = UnityEngine.Vector3(0,0,0)
    role.stateMachine:removeStateChangeListener(self)
end

--获取坐骑动画
function UFOMountState:getMountAnimator()
	return self.mountAnimator
end

function UFOMountState:playMountAnimation( name )
	--print ("---------------------->>>>>>>>  function CNMMountState:playMountAnimation( name ) "..name)
    self.mountAnimator:Play(name)
end

function UFOMountState:playRoleAnimation( name )
	if name == nil then
		name = "ride on ufo"
	end
	self.animator:Play(name)
end

function UFOMountState:OnIKAnimation(role)

end

--设置人物相对坐标
function UFOMountState:setPlayerRelativePos()
	local  posTable = {}
	                                      
	posTable.RunState ={[1] =UnityEngine.Vector3(0,2.45,0),--role localpostion 中心偏移位置  
	                    [2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移

	                    [-1] =UnityEngine.Vector3(0,2.63,0),--role localpostion 中心偏移位置  
	                    [-2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    }
                         
    posTable.JumpState = {[1] =UnityEngine.Vector3(0,2.8,0),--role localpostion 中心偏移位置  
	                    [2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移

	                    [-1] =UnityEngine.Vector3(0,2.5,0),--role localpostion 中心偏移位置  
	                    [-2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    }

    posTable.JumpTopState = posTable.JumpState

 	posTable.DropState = posTable.RunState
						
    posTable.DoubleJumpState = {[1] = UnityEngine.Vector3(0,2.8,0),--role localpostion 中心偏移位置  
	                    		[2] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移

	                    		[-1] = UnityEngine.Vector3(0,2.5,0),--role localpostion 中心偏移位置  
	                    		[-2] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    		}

	posTable.DoubleDropState = {[1] = UnityEngine.Vector3(0,2.8,0),--role localpostion 中心偏移位置  
	                    		[2] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移

	                    		[-1] = UnityEngine.Vector3(0,2.5,0),--role localpostion 中心偏移位置  
	                    		[-2] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    		}

 	posTable.SprintState =posTable.RunState

    posTable.DiveState = {[1] =UnityEngine.Vector3(-0.3,3,0),--role localpostion 中心偏移位置  
	                    [2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移

	                    [-1] =UnityEngine.Vector3(0,2,0),--role localpostion 中心偏移位置  
	                    [-2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    }
	posTable.AttackState = posTable.RunState

	posTable.DefendState = posTable.RunState

	posTable.WallClimbState = {[1] =UnityEngine.Vector3(0,2.45,0),--role localpostion 中心偏移位置  
	                    [2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移

	                    [-1] =UnityEngine.Vector3(0,1.5,0),--role localpostion 中心偏移位置  
	                    [-2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    }
	posTable.FailedState = posTable.RunState
	posTable.DeadState = posTable.RunState
	posTable.BouncingState = posTable.RunState
    posTable.VictoryState = posTable.RunState

    girlPosTable = {}
    girlPosTable.RunState = {[1] =UnityEngine.Vector3(0,2.45,0),--role localpostion 中心偏移位置  
		                    [2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移

		                    [-1] =UnityEngine.Vector3(0,2.63,0),--role localpostion 中心偏移位置  
		                    [-2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
		                    }
	girlPosTable.JumpState = {[1] =UnityEngine.Vector3(0,2.45,0),--role localpostion 中心偏移位置  
		                    [2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移

		                    [-1] =UnityEngine.Vector3(0,2.63,0),--role localpostion 中心偏移位置  
		                    [-2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
		                    }
    girlPosTable.JumpTopState = {[1] =UnityEngine.Vector3(0,2.45,0),--role localpostion 中心偏移位置  
		                    [2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移

		                    [-1] =UnityEngine.Vector3(0,2.63,0),--role localpostion 中心偏移位置  
		                    [-2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
		                    }
    girlPosTable.DropState = {[1] =UnityEngine.Vector3(0,2.45,0),--role localpostion 中心偏移位置  
		                    [2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移

		                    [-1] =UnityEngine.Vector3(0,2.63,0),--role localpostion 中心偏移位置  
		                    [-2] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
		                    }
    girlPosTable.DoubleJumpState = girlPosTable.JumpState
    girlPosTable.DoubleDropState = girlPosTable.DropState
    girlPosTable.SprintState = girlPosTable.DropState
    girlPosTable.DiveState = girlPosTable.DropState
    girlPosTable.AttackState = girlPosTable.RunState
	girlPosTable.DefendState = girlPosTable.RunState
	girlPosTable.WallClimbState = girlPosTable.RunState
	girlPosTable.FailedState = girlPosTable.RunState
	girlPosTable.DeadState = girlPosTable.RunState
	girlPosTable.BouncingState = girlPosTable.RunState
	girlPosTable.VictoryState = girlPosTable.RunState

	if playerName == "dgirl" then
		return girlPosTable
	end

	return posTable
end

function UFOMountState:getPosByIndex( role,index,name)
	if name ==nil then
		name = role.stateMachine:getState()._name
	end
	local posT = self.configPos[name]
	if posT == nil then
		return UnityEngine.Vector3.zero
	end
	
	local sign = role.moveSpeedVect/math.abs(role.moveSpeedVect)
	return posT[index*sign]
end

--状态切换回调方法
function UFOMountState:stateChange(role,previousState,currentState)
	local sign = role.moveSpeedVect/math.abs(role.moveSpeedVect)
	local offset = self:getPosByIndex(role,1,currentState._name)
	local dir =  offset -  role.character.transform.localPosition --移动位置
	dir.x = dir.x * sign

	role.character.transform:Translate(dir,UnityEngine.Space.World)
	role.character.transform.localRotation = Quaternion.Euler(self:getPosByIndex(role,2,currentState._name))
end

function UFOMountState:SetActive(active)
	if self.mount == nil then
		return
	end

	self.mount:SetActive(active)
end

--播放烟雾特效
function UFOMountState:playExplode()
	if self.effect ~= nil then
		GameObject.Destroy(self.effect)
	end
	self.effect = --newobject(ioo.LoadPrefab("Effects/Common/ef_pet_xiaoshi"))
	newobject(Util.LoadPrefab("Effects/Common/ef_single_jump"))
	self.effect.transform.parent = self.mount.gameObject.transform.parent
	self.effect.transform.localScale = UnityEngine.Vector3(2,2,2)
	local pos = self.mount.gameObject.transform.position
	-- pos.y = pos.y+0.7
	self.effect.transform.position = pos --位置偏移
	
    local pArray = self.effect.gameObject.transform:GetComponentsInChildren(UnityEngine.ParticleSystem.GetClassType())
    local length = pArray.Length-1 
    for i=0,length do
    	System.Array.GetValue(pArray,i):Play()
	end

	self.effectSys = pArray
end
