--[[
author:Desmond
普通运动物件状态机
]]
StateMachine = class ()

StateMachine.previousState = nil
StateMachine.currentState = nil
StateMachine.role = nil  --不可为nil
StateMachine._name = nil

function StateMachine:changeState( iState )
	if self.currentState ~= nil then
		self.currentState:Exit(self.role)
	end

	self.previousState  = self.currentState
	self.currentState = iState
	if iState ~= nil then
		self.currentState:Enter(self.role)
	end
end

function StateMachine:runState( dTime )
	if self.currentState ~= nil then
		self.currentState:Excute(self.role,dTime)
	end

end

function StateMachine:getState()
	return self.currentState
end

function StateMachine:getPreState()
	return self.previousState
end
--------------------------------------------------------------------------------------------------------------------
--[[逻辑代码]]   
--------------------------------------------------------------------------------------------------------------------


