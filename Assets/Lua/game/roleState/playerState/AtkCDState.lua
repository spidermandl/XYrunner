--[[
author:Desmond
攻击次数cd 共享状态
]]
AtkCDState = class(IState)

AtkCDState._name = "AtkCDState"
AtkCDState.ATK_CAP = nil --打击触发技能次数
AtkCDState.isActive = false --乔巴技能打开
AtkCDState.basicATK = 0 --攻击数计算开始值
AtkCDState.duringTimeParam = 3 --传入参数

function AtkCDState:Enter(role)
    self.super.Enter(self,role)
    --print ("------------function AtkCDState:Enter(role) "..tostring(self.TIME_CAP))
end

function AtkCDState:Excute(role,dTime)
	if self.isActive == false then
		local count = role:getATKCount()
		local integer,f = math.modf((count - self.basicATK)/self.ATK_CAP)
		if f==0 and count > self.basicATK then
			local buff = ChangeBigState.new()
			buff.duringTime = self.duringTimeParam --技能持续时间
    		role.stateMachine:addSharedState(buff)
    		self.isActive = true
    		self.basicATK = count
		end
		--print (tostring(count))
        role:updateSkillIcon(count%self.ATK_CAP)
	else
		local s = role.stateMachine:getSharedState("ChangeBigState")
		if s == nil then
			self.isActive = false
		else
			role:updateSkillIcon(nil)
		end

	end

end

function AtkCDState:Exit(role)

end

