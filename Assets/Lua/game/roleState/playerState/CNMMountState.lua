--[[
author:Desmond
草泥马座骑状态 
共享状态
]]
CNMMountState = class (BaseMountState)

CNMMountState._name = "CNMMountState"
CNMMountState.roleName = 'cnm_hourse'
CNMMountState.neck = nil --脖子位置
CNMMountState.body = nil --躯干位置
CNMMountState.configPos = nil --位置偏移表


function CNMMountState:Enter(role)
	--print("CNMMountState:Enter")
    self.configPos = self:setPlayerRelativePos(role.roleName)
    role.stateMachine:addStateChangeListener(self)

	self.mount = newobject(Util.LoadPrefab("Mount/"..self.roleName))
    self.mount.transform.parent = role.gameObject.transform
    --self.mount.transform.rotation = UnityEngine.Vector3(0,0,0)
    self.mount.transform.localRotation = Quaternion.Euler(0,90,0)
    self.mount.transform.localScale = UnityEngine.Vector3(1.5,1.5,1.5)
    self.mount.transform.localPosition = UnityEngine.Vector3(0,0,0)
    --self.mount.transform:Translate(0,0,0,UnityEngine.Space.World)

    -- destroy(role.character.gameObject)--替换人物模型
    -- local skin = newobject(Util.LoadPrefab("Player/"..role.roleName))
    -- skin.transform.parent = role.gameObject.transform
    -- skin.transform.localPosition = UnityEngine.Vector3.zero
    -- role.character = skin.gameObject.transform

    -- --[[设置动画]]
    -- local modelCfg = role:GetModelConfig(role.roleName.."_mount")
    -- role:setEntity(modelCfg)
    self.animator = role.animator

    role.collider.center=UnityEngine.Vector3(0,1.5,0)
    role.collider.radius=1
    role.collider.height=3

    
	self.mountAnimator = self.mount:GetComponent("Animator")
	self.animator:Play("ride")
	--role.character.transform:Translate(self.configPos.RunState[1],UnityEngine.Space.World)

    local sub = role.character.gameObject:AddComponent(IKBehaviour.GetClassType()) --IK绑定role id
	sub.attachID = role.gameObject:GetInstanceID()

	local trans = self.mount.gameObject.transform:GetComponentsInChildren(UnityEngine.Transform.GetClassType())
    local length = trans.Length-1 
    for i=0,length do
    	if System.Array.GetValue(trans,i).name == 'Bip001 Neck' then
    		self.neck = System.Array.GetValue(trans,i)
    	end
    	if System.Array.GetValue(trans,i).name == 'Bip001 Spine1' then
    		self.body = System.Array.GetValue(trans,i)
    	end
	end
end

function CNMMountState:Excute(role,dTime)
	--self.animator:Play("ride")
	if self.effect ~= nil then
		local effectSys = self.effect.transform:GetChild(0):GetComponent(UnityEngine.ParticleSystem.GetClassType())
		if effectSys.time >= 0.2 then
			GameObject.Destroy(self.effect)
			self.effect = nil
			self:SetActive(true)
		end
	end
end

function CNMMountState:Exit(role)
	--还原角色配置
    role.collider.center=UnityEngine.Vector3(0.2,1,0)
    role.collider.radius=0.4
    role.collider.height=2

	role.character.transform:Translate(0,-1.3,0,UnityEngine.Space.World)
    role.character.transform.localPosition = UnityEngine.Vector3(0,0,0)
    role.stateMachine:removeStateChangeListener(self)
end

--获取坐骑动画
function CNMMountState:getMountAnimator()
    return self.mountAnimator
end

function CNMMountState:playMountAnimation( name )
    --print ("---------------------->>>>>>>>  function CNMMountState:playMountAnimation( name ) "..name)
    self.mountAnimator:Play(name)
end

function CNMMountState:playRoleAnimation( name )
	if name == nil then
		name = "ride"
	end
	self.animator:Play(name)
end

function CNMMountState:OnIKAnimation(role)
	--print ("-------------->>>>>>>>>>  function CNMMountState:OnIKAnimation(role) ")

	if role.roleName == "dgirl" then
		self.animator:SetIKPositionWeight(UnityEngine.AvatarIKGoal.LeftHand,1.0)
		local lefthandTarget = self.neck.position + self:getPosByIndex(role,2)
		self.animator:SetIKPosition(UnityEngine.AvatarIKGoal.LeftHand,lefthandTarget)
		return
	end

	if role.roleName == "desmond" then
		self.animator:SetIKPositionWeight(UnityEngine.AvatarIKGoal.LeftHand,1.0)
		self.animator:SetIKPositionWeight(UnityEngine.AvatarIKGoal.RightHand,1.0)
		self.animator:SetIKPositionWeight(UnityEngine.AvatarIKGoal.LeftFoot,1.0)
		self.animator:SetIKPositionWeight(UnityEngine.AvatarIKGoal.RightFoot,1.0)

	    local lefthandTarget = self.neck.position + self:getPosByIndex(role,2)
	    local righthandTarget = self.neck.position + self:getPosByIndex(role,3)
	    local leftfootTarget = self.body.position + self:getPosByIndex(role,4)
	    local rightfootTarget = self.body.position + self:getPosByIndex(role,5)

		self.animator:SetIKPosition(UnityEngine.AvatarIKGoal.LeftHand,lefthandTarget)
	    self.animator:SetIKPosition(UnityEngine.AvatarIKGoal.RightHand,righthandTarget)
	    self.animator:SetIKPosition(UnityEngine.AvatarIKGoal.LeftFoot,leftfootTarget)
	    self.animator:SetIKPosition(UnityEngine.AvatarIKGoal.RightFoot,rightfootTarget)
	end
end

--设置人物相对坐标
function CNMMountState:setPlayerRelativePos(playerName)
	local  posTable = {}
	                                      
	posTable.RunState ={[1] =UnityEngine.Vector3(-0.21,1.46,0),--role localpostion 中心偏移位置  
	                    [2] =UnityEngine.Vector3(-0.3,0.3,0.2),--左手ik偏移位置
	                    [3] =UnityEngine.Vector3(-0.3,0.3,-0.2),--右手ik偏移位置 
	                    [4] =UnityEngine.Vector3(0,0,0.6),--左脚ik偏移位置 
	                    [5] =UnityEngine.Vector3(0,0,-0.6),--右脚ik偏移位置 
	                    [6] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    --[7] =UnityEngine.Vector3(0,1.5,0), --碰撞体位置

	                    [-1] =UnityEngine.Vector3(-0.21,1.46,0),--role localpostion 中心偏移位置  
	                    [-2] =UnityEngine.Vector3(-0.3,0.3,0.2),--左手ik偏移位置
	                    [-3] =UnityEngine.Vector3(-0.3,0.3,-0.2),--右手ik偏移位置 
	                    [-4] =UnityEngine.Vector3(0,0,0.6),--左脚ik偏移位置 
	                    [-5] =UnityEngine.Vector3(0,0,-0.6),--右脚ik偏移位置 
	                    [-6] =UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    --[-7] =UnityEngine.Vector3(0,1.5,0), --碰撞体位置
	                    }
                         
    posTable.JumpState = {[1] = UnityEngine.Vector3(-0.95,1.31,0),--role localpostion 中心偏移位置  
	                      [2] = UnityEngine.Vector3(-0.3,0.3,0.2),--左手ik偏移位置
	                      [3] = UnityEngine.Vector3(-0.3,0.3,-0.2),--右手ik偏移位置 
	                      [4] = UnityEngine.Vector3(0,0,0.6),--左脚ik偏移位置 
	                      [5] = UnityEngine.Vector3(0,0,-0.6),--右脚ik偏移位置 
	                      [6] = UnityEngine.Vector3(0,90,0),--role rotation 旋转偏移
	                      [7] = UnityEngine.Vector3(-0.8,1.5,0), --碰撞体位置

	                      [-1] = UnityEngine.Vector3(-1,0.5,0),--role localpostion 中心偏移位置  
	                      [-2] = UnityEngine.Vector3(2,-1.5,0.2),--左手ik偏移位置
	                      [-3] = UnityEngine.Vector3(2,-1.5,-0.2),--右手ik偏移位置 
	                      [-4] = UnityEngine.Vector3(1,-1,0.6),--左脚ik偏移位置 
	                      [-5] = UnityEngine.Vector3(1,-1,-0.6),--右脚ik偏移位置 
	                      [-6] = UnityEngine.Vector3(0,90,0),--role rotation 旋转偏移
	                      --[-7] = UnityEngine.Vector3(-0.8,1.5,0), --碰撞体位置
	                     }

    posTable.JumpTopState = {[1] = UnityEngine.Vector3(-0.94,1.31,0),--role localpostion 中心偏移位置  
	                     	[2] = UnityEngine.Vector3(-0.3,0.3,0.2),--左手ik偏移位置
	                     	[3] = UnityEngine.Vector3(-0.3,0.3,-0.2),--右手ik偏移位置 
	                     	[4] = UnityEngine.Vector3(0,0,0.6),--左脚ik偏移位置 
	                     	[5] = UnityEngine.Vector3(0,0,-0.6),--右脚ik偏移位置 
	                     	[6] = UnityEngine.Vector3(0,90,0),--role rotation 旋转偏移
	                     	--[7] = UnityEngine.Vector3(0-0.8,1.5,0), --碰撞体位置

                            [-1] = UnityEngine.Vector3(-0.75,0.3,0),--role localpostion 中心偏移位置  
	                     	[-2] = UnityEngine.Vector3(2,0,0.2),--左手ik偏移位置
	                     	[-3] = UnityEngine.Vector3(2,0,-0.2),--右手ik偏移位置 
	                     	[-4] = UnityEngine.Vector3(1,-1,0.6),--左脚ik偏移位置 
	                     	[-5] = UnityEngine.Vector3(1,-1,-0.6),--右脚ik偏移位置 
	                     	[-6] = UnityEngine.Vector3(0,90,0),--role rotation 旋转偏移
	                     	--[-7] = UnityEngine.Vector3(0-0.8,1.5,0), --碰撞体位置

	                     }

 	posTable.DropState = {[1] = UnityEngine.Vector3(-0.36,1.18,0),--role localpostion 中心偏移位置  
	                     [2] = UnityEngine.Vector3(-0.3,0.3,0.2),--左手ik偏移位置
	                     [3] = UnityEngine.Vector3(-0.3,0.3,-0.2),--右手ik偏移位置 
	                     [4] = UnityEngine.Vector3(0,0,0.6),--左脚ik偏移位置 
	                     [5] = UnityEngine.Vector3(0,0,-0.6),--右脚ik偏移位置 
	                     [6] = UnityEngine.Vector3(0,90,0),--role rotation 旋转偏移
						 --[7] = UnityEngine.Vector3(0,1.5,0), --碰撞体位置

 						 [-1] = UnityEngine.Vector3(-0.36,0.2,0),--role localpostion 中心偏移位置  
	                     [-2] = UnityEngine.Vector3(1.5,-0.3,0.2),--左手ik偏移位置
	                     [-3] = UnityEngine.Vector3(1.5,-0.3,-0.2),--右手ik偏移位置 
	                     [-4] = UnityEngine.Vector3(1,-1,0.6),--左脚ik偏移位置 
	                     [-5] = UnityEngine.Vector3(1,-1,-0.6),--右脚ik偏移位置 
	                     [-6] = UnityEngine.Vector3(0,90,0),--role rotation 旋转偏移
						 --[-7] = UnityEngine.Vector3(0,1.5,0), --碰撞体位置
	                     }
						
    posTable.DoubleJumpState = posTable.JumpTopState
    		-- 			{
						-- UnityEngine.Vector3(-1.37,1.34,0),--role localpostion 中心偏移位置  
	     --                 UnityEngine.Vector3(-0.3,0.3,0.2),--左手ik偏移位置
	     --                 UnityEngine.Vector3(-0.3,0.3,-0.2),--右手ik偏移位置 
	     --                 UnityEngine.Vector3(0,0,0.6),--左脚ik偏移位置 
	     --                 UnityEngine.Vector3(0,0,-0.6),--右脚ik偏移位置 
	     --                 UnityEngine.Vector3(-60,90,0),--role rotation 旋转偏移
	     --                 UnityEngine.Vector3(0,1.5,0), --碰撞体位置
      --            		}

	posTable.DoubleDropState = posTable.DropState
						-- {
						-- UnityEngine.Vector3(-1.37,1.34,0),--role localpostion 中心偏移位置  
	     --                 UnityEngine.Vector3(-0.3,0.3,0.2),--左手ik偏移位置
	     --                 UnityEngine.Vector3(-0.3,0.3,-0.2),--右手ik偏移位置 
	     --                 UnityEngine.Vector3(0,0,0.6),--左脚ik偏移位置 
	     --                 UnityEngine.Vector3(0,0,-0.6),--右脚ik偏移位置 
      --                    UnityEngine.Vector3(-60,90,0),--role rotation 旋转偏移
        --                  UnityEngine.Vector3(0,1.5,0), --碰撞体位置
	     --                 }

 	posTable.SprintState ={
						[1] = UnityEngine.Vector3(-0.21,1.46,0),--role localpostion 中心偏移位置  
	                    [2] = UnityEngine.Vector3(-0.3,0.3,0.2),--左手ik偏移位置
	                    [3] = UnityEngine.Vector3(-0.3,0.3,-0.2),--右手ik偏移位置 
	                    [4] = UnityEngine.Vector3(0,0,0.6),--左脚ik偏移位置 
	                    [5] = UnityEngine.Vector3(0,0,-0.6),--右脚ik偏移位置 
	                    [6] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    --[7] = UnityEngine.Vector3(0,1.5,0), --碰撞体位置

						[-1] = UnityEngine.Vector3(-0.21,1.46,0),--role localpostion 中心偏移位置  
	                    [-2] = UnityEngine.Vector3(-0.3,0.3,0.2),--左手ik偏移位置
	                    [-3] = UnityEngine.Vector3(-0.3,0.3,-0.2),--右手ik偏移位置 
	                    [-4] = UnityEngine.Vector3(0,0,0.6),--左脚ik偏移位置 
	                    [-5] = UnityEngine.Vector3(0,0,-0.6),--右脚ik偏移位置 
	                    [-6] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    --[-7] = UnityEngine.Vector3(0,1.5,0), --碰撞体位置
	                     }

    posTable.DiveState = {
    					[1] = UnityEngine.Vector3(-0.21,1.21,0),--role localpostion 中心偏移位置  
	                    [2] = UnityEngine.Vector3(-0.3,0.3,0.2),--左手ik偏移位置
	                    [3] = UnityEngine.Vector3(-0.3,0.3,-0.2),--右手ik偏移位置 
	                    [4] = UnityEngine.Vector3(0,0,0.6),--左脚ik偏移位置 
	                    [5] = UnityEngine.Vector3(0,0,-0.6),--右脚ik偏移位置 
	                    [6] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    --[7] = UnityEngine.Vector3(0,1.5,0), --碰撞体位置

    					[-1] = UnityEngine.Vector3(-0.21,0.2,0),--role localpostion 中心偏移位置  
	                    [-2] = UnityEngine.Vector3(1.5,-0.3,0.2),--左手ik偏移位置
	                    [-3] = UnityEngine.Vector3(1.5,-0.3,-0.2),--右手ik偏移位置 
	                    [-4] = UnityEngine.Vector3(1,-1,0.6),--左脚ik偏移位置 
	                    [-5] = UnityEngine.Vector3(1,-1,-0.6),--右脚ik偏移位置 
	                    [-6] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    --[-7] = UnityEngine.Vector3(0,1.5,0), --碰撞体位置
						}
	posTable.AttackState = posTable.RunState
	posTable.DefendState = posTable.RunState
	posTable.WallClimbState = {
    					[1] = UnityEngine.Vector3(-0.7,1.46,0),--role localpostion 中心偏移位置  
	                    [2] = UnityEngine.Vector3(-0.3,0.3,0.2),--左手ik偏移位置
	                    [3] = UnityEngine.Vector3(-0.3,0.3,-0.2),--右手ik偏移位置 
	                    [4] = UnityEngine.Vector3(0,0,0.6),--左脚ik偏移位置 
	                    [5] = UnityEngine.Vector3(0,0,-0.6),--右脚ik偏移位置 
	                    [6] = UnityEngine.Vector3(-30,90,0), --role rotation 旋转偏移
	                    --[7] = UnityEngine.Vector3(-0.8,1.5,0), --碰撞体位置

    					[-1] = UnityEngine.Vector3(-0.25,0.8,0),--role localpostion 中心偏移位置  
	                    [-2] = UnityEngine.Vector3(1.5,-0.3,0.2),--左手ik偏移位置
	                    [-3] = UnityEngine.Vector3(1.5,-0.3,-0.2),--右手ik偏移位置 
	                    [-4] = UnityEngine.Vector3(1.5,-0.5,0.6),--左脚ik偏移位置 
	                    [-5] = UnityEngine.Vector3(1.5,-0.5,-0.6),--右脚ik偏移位置 
	                    [-6] = UnityEngine.Vector3(-40,90,0), --role rotation 旋转偏移
	                    --[-7] = UnityEngine.Vector3(-0.8,1.5,0), --碰撞体位置
						}
	posTable.FailedState = posTable.RunState
	posTable.DeadState = posTable.RunState
	posTable.BouncingState = posTable.RunState
	posTable.VictoryState = posTable.RunState

	local girlPosTable = {}
	girlPosTable.RunState = {
						[1] = UnityEngine.Vector3(-0.1,1.12,-0.25),--role localpostion 中心偏移位置  
	                    [2] = UnityEngine.Vector3(-0.3,0.3,-0.2),--左手ik偏移位置
	                    [3] = UnityEngine.Vector3(0,0,0),--右手ik偏移位置 
	                    [4] = UnityEngine.Vector3(0,0,0),--左脚ik偏移位置 
	                    [5] = UnityEngine.Vector3(0,0,0),--右脚ik偏移位置 
	                    [6] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    --[7] = UnityEngine.Vector3(0,1.5,0), --碰撞体位置

	                    [-1] = UnityEngine.Vector3(-0.1,1.12,-0.25),--role localpostion 中心偏移位置  
	                    [-2] = UnityEngine.Vector3(-0.3,0.3,-0.2),--左手ik偏移位置
	                    [-3] = UnityEngine.Vector3(0,0,0),--右手ik偏移位置 
	                    [-4] = UnityEngine.Vector3(0,0,0),--左脚ik偏移位置 
	                    [-5] = UnityEngine.Vector3(0,0,0),--右脚ik偏移位置 
	                    [-6] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    --[-7] = UnityEngine.Vector3(0,1.5,0), --碰撞体位置
	                    }
	girlPosTable.JumpState = {
						[1] = UnityEngine.Vector3(-0.78,1.28,-0.25),--role localpostion 中心偏移位置  
	                    [2] = UnityEngine.Vector3(-0.3,0.3,-0.2),--左手ik偏移位置
	                    [3] = UnityEngine.Vector3(0,0,0),--右手ik偏移位置 
	                    [4] = UnityEngine.Vector3(0,0,0),--左脚ik偏移位置 
	                    [5] = UnityEngine.Vector3(0,0,0),--右脚ik偏移位置 
	                    [6] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    --[7] = UnityEngine.Vector3(0,1.5,0), --碰撞体位置

	                    [-1] = UnityEngine.Vector3(-0.78,1.28,-0.25),--role localpostion 中心偏移位置  
	                    [-2] = UnityEngine.Vector3(-0.3,0.3,-0.2),--左手ik偏移位置
	                    [-3] = UnityEngine.Vector3(0,0,0),--右手ik偏移位置 
	                    [-4] = UnityEngine.Vector3(0,0,0),--左脚ik偏移位置 
	                    [-5] = UnityEngine.Vector3(0,0,0),--右脚ik偏移位置 
	                    [-6] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    --[-7] = UnityEngine.Vector3(0,1.5,0), --碰撞体位置
	                    }
	girlPosTable.JumpTopState = {
						[1] = UnityEngine.Vector3(-0.76,1.12,-0.25),--role localpostion 中心偏移位置  
	                    [2] = UnityEngine.Vector3(-0.3,0.3,-0.2),--左手ik偏移位置
	                    [3] = UnityEngine.Vector3(0,0,0),--右手ik偏移位置 
	                    [4] = UnityEngine.Vector3(0,0,0),--左脚ik偏移位置 
	                    [5] = UnityEngine.Vector3(0,0,0),--右脚ik偏移位置 
	                    [6] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    --[7] = UnityEngine.Vector3(0,1.5,0), --碰撞体位置

	                    [-1] = UnityEngine.Vector3(-0.76,1.12,-0.25),--role localpostion 中心偏移位置  
	                    [-2] = UnityEngine.Vector3(-0.3,0.3,-0.2),--左手ik偏移位置
	                    [-3] = UnityEngine.Vector3(0,0,0),--右手ik偏移位置 
	                    [-4] = UnityEngine.Vector3(0,0,0),--左脚ik偏移位置 
	                    [-5] = UnityEngine.Vector3(0,0,0),--右脚ik偏移位置 
	                    [-6] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    --[-7] = UnityEngine.Vector3(0,1.5,0), --碰撞体位置
	                    }
	girlPosTable.DropState = {
						[1] = UnityEngine.Vector3(-0.3,0.7,-0.25),--role localpostion 中心偏移位置  
	                    [2] = UnityEngine.Vector3(-0.3,0.3,-0.2),--左手ik偏移位置
	                    [3] = UnityEngine.Vector3(0,0,0),--右手ik偏移位置 
	                    [4] = UnityEngine.Vector3(0,0,0),--左脚ik偏移位置 
	                    [5] = UnityEngine.Vector3(0,0,0),--右脚ik偏移位置 
	                    [6] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    --[7] = UnityEngine.Vector3(0,1.5,0), --碰撞体位置

	                    [-1] = UnityEngine.Vector3(-0.3,0.7,-0.25),--role localpostion 中心偏移位置  
	                    [-2] = UnityEngine.Vector3(-0.3,0.3,-0.2),--左手ik偏移位置
	                    [-3] = UnityEngine.Vector3(0,0,0),--右手ik偏移位置 
	                    [-4] = UnityEngine.Vector3(0,0,0),--左脚ik偏移位置 
	                    [-5] = UnityEngine.Vector3(0,0,0),--右脚ik偏移位置 
	                    [-6] = UnityEngine.Vector3(0,90,0), --role rotation 旋转偏移
	                    --[-7] = UnityEngine.Vector3(0,1.5,0), --碰撞体位置
	                    }
    girlPosTable.DoubleJumpState = girlPosTable.JumpTopState
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

function CNMMountState:getPosByIndex( role,index,name)
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
function CNMMountState:stateChange(role,previousState,currentState)
	local sign = role.moveSpeedVect/math.abs(role.moveSpeedVect)
	local offset = self:getPosByIndex(role,1,currentState._name)
	local dir =  offset - role.character.transform.localPosition --移动位置
	dir.x = dir.x * sign

	role.character.transform:Translate(dir,UnityEngine.Space.World)
	role.character.transform.localRotation = Quaternion.Euler(self:getPosByIndex(role,6,currentState._name))
	--role.collider.center=self:getPosByIndex(role,7,currentState._name)
end

---------生成音符
function CNMMountState:CreateNotes( ... )--参数1、role；2、endPosOff1；3、endPosOff2；4、endPosOff3
	local args = {...}
	local startPos = args[1].gameObject.transform.position+PetStaticTable.PositionOffsetStart
	local endPos ={} 
	endPos[0]=args[1].gameObject.transform.position+args[2]
	local Length = table.getn(args)
	if Length>2 then
		endPos[1]= args[1].gameObject.transform.position+args[3]
		endPos[2]= args[1].gameObject.transform.position+args[4]
	end
	for i=1,Length-1 do
        CreateThings(args[1],PetStaticTable.GMHorseMountNotes,PetStaticTable.NotesLua,startPos,args[1].gameObject.transform.parent.parent,{startPos,endPos[i-1]})
    end
end

function CNMMountState:SetActive(active)
	if self.mount == nil then
		return
	end

	self.mount:SetActive(active)
end

--播放烟雾特效
function CNMMountState:playExplode()
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
