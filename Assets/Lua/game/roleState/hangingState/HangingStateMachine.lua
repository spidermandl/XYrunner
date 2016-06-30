--[[
author:Desmond
吸墙过程中
]]
HangingStateMachine = class (StateMachine)

HangingStateMachine.previousState = nil
HangingStateMachine.currentState = nil
HangingStateMachine.sharedStates = nil--公共状态

function HangingStateMachine:changeState( iState )
	if self.currentState ~= nil then
		self.currentState:Exit(self.role)
	end

    local flag = self:preCheck(iState) --状态切换前，检测切换条件
    if flag == false then 
        return
    end

	self.previousState  = self.currentState
	self.currentState = iState
	if iState ~= nil then
		self.currentState:Enter(self.role)
	end
end

function HangingStateMachine:preCheck( iState )
    if self.currentState == nil then 
        return true
    end
    
    if self.currentState._name == iState._name 
        then
        return false
    end
end

function HangingStateMachine:runState( dTime )
    if self.sharedStates ==nil then
        self.sharedStates = {}
    end

    if self.currentState ~= nil then
        self.currentState:Excute(self.role,dTime)

        for key,value in pairs(self.sharedStates) do  
            -- if key == "UnstopableState" then
            if value ~= nil then  
                if value._name ~= nil then
                    value:Excute(self.role,dTime)
                end
            end
            -- end
        end  

    end

end

function HangingStateMachine:addSharedState( iState )
    --GamePrint ("------------------------------------ function RoleStateMachine:addSharedState( iState ) "..tostring(iState._name))
    if self.sharedStates == nil then
        self.sharedStates = {}
    end
    
    self.sharedStates[iState._name] = iState
    iState:Enter(self.role)
end

function HangingStateMachine:removeSharedState( iState )
    --GamePrint ("------------------------------------ function RoleStateMachine:removeSharedState( iState ) "..tostring(iState.multiple).." "..tostring(iState._name))
    if iState._name ~=nil then
        self.sharedStates[iState._name] = nil
        iState:Exit(self.role)
    end
end

function HangingStateMachine:removeSharedStateByName( name )
    if self.sharedStates ==nil then
        return
    end
    local iState = nil
    for k, v in pairs(self.sharedStates) do 
        if v ~= nil and v._name == name then
            iState = v
            break
        end
    end
    if iState ~= nil then
        self:removeSharedState(iState)
    end
end

function HangingStateMachine:getSharedState(name)
    if name == nil then
        return
    end
    return self.sharedStates[name]
end
