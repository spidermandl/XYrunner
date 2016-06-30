--[[
author:Desmond
角色弹跳状态
]]
BouncingState = class (BasePlayerState)

BouncingState._name = "BouncingState"
BouncingState.effect = nil
BouncingState.camera = nil
BouncingState.forceDisrupt = nil --bouncing state 是否可以切换
BouncingState.targetX = nil --目标落点X轴
BouncingState.targetZ = nil --目标落点Z轴
BouncingState.direction = nil --角色朝向
BouncingState.actionSpeed = nil --角色动作速度
BouncingState.state = 0 --进度
BouncingState.isReplace = nil --是否取代默认动作
BouncingState.animName = nil 
function BouncingState:Enter(role)
	self.super.Enter(self,role)
	self.forceDisrupt = false
	--强制转变角色的朝向
	if self.direction < 0 then
		role.moveSpeedVect = -1
	elseif self.direction > 0 then
		role.moveSpeedVect = 1
	else
		if self.targetX ~= nil and self.targetX < role.gameObject.transform.position.x then
	    	role.moveSpeedVect = -1
	    else
	    	role.moveSpeedVect = 1
	    end
	end
    local vec = role.gameObject.transform.localScale
    vec.x = math.abs(vec.x)/role.moveSpeedVect
    role.gameObject.transform.localScale = vec
    role.isBlocked = false

	self.animName = self.isReplace == true and "bouncing span2" or "bouncing span"
	self.super.playAnimation(self,role,"single drop descend") --切换现在的动作
    self.state = 1
    if self.actionSpeed then
    	self.animator.speed = self.actionSpeed
    end
end

function BouncingState:Excute(role,dTime)
	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	if self.state == 1 then
		if animInfo:IsName(self.animName) == false then
			self.super.playAnimation(self,role,self.animName)
		else
			if animInfo.normalizedTime >= 1.0 then
				self.state = 2
			end
		end
	elseif self.state == 2 then
		if animInfo:IsName("bouncing span2") == false and  (self:GetTweenPathZ() ~= nil and math.abs(self:GetTweenPathZ()) >= 31) then --Z轴等于32时候播放第二个动作
			self.super.playAnimation(self,role,"bouncing span2")
		end
	end
	local flag = self.super.isOnGround(self,role)	--落地检测
    if 	flag == true then
        role:itweenCallback()
    end 
end

function BouncingState:Exit(role)
	self.animator.speed = 1
end
--获取路径点的Z轴
function BouncingState:GetTweenPathZ()
	return self.targetZ
end