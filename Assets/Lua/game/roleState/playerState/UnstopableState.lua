--[[
无敌状态
author:Desmond
]]
UnstopableState = class(BasePlayerState)

UnstopableState._name = "UnstopableState"
UnstopableState.frameTime = 1
UnstopableState.startTime = nil
UnstopableState.normalColor = nil

function UnstopableState:Enter(role)
	self.startTime = UnityEngine.Time.time
	--print ("----------------------------------------------- function UnstopableState:Enter(role) 1 "..tostring(role.roleName))
	self.normalColor = self:getNormalColor(role)
	self:changeColor(role,UnityEngine.Color.red)
end

function UnstopableState:Excute(role,dTime)
	if UnityEngine.Time.time - self.startTime >ConfigParam.UnstopableTime then
		role.stateMachine:removeSharedState(self)
		return
	end

	if (self.frameTime/ConfigParam.UnstopableSwitchFrame)%2 ==0 then
		--print ("----------------------------------------------- function UnstopableState:Enter(role) 2 "..tostring(role.roleName))
		if self.frameTime%ConfigParam.UnstopableSwitchFrame == 0 then
			self:changeColor(role,UnityEngine.Color.yellow)
		end
	else
		--print ("----------------------------------------------- function UnstopableState:Enter(role) 3 "..tostring(role.roleName))
		if self.frameTime%ConfigParam.UnstopableSwitchFrame == 0 then
			self:changeColor(role,self.normalColor)
		end
	end

	self.frameTime = self.frameTime + 1

end

function UnstopableState:Exit(role)
	self:changeColor(role,self.normalColor)
end

--[[更换皮肤]]
function  UnstopableState:changeColor( role,color )
    -- local rolePrefab = role.character
    -- local modelCfg = role:GetModelConfig()
    -- local skin = rolePrefab:Find (modelCfg.avatarName)
    -- local body = skin:Find (modelCfg.modelBody)
    -- local rend = body:GetComponent(UnityEngine.SkinnedMeshRenderer.GetClassType())
    -- rend.material.color = color

    -- local head = skin:Find (modelCfg.modelHead)
    -- rend = head:GetComponent(UnityEngine.SkinnedMeshRenderer.GetClassType())
    -- rend.material.color = color

    local renders = role.character:GetComponentsInChildren(UnityEngine.SkinnedMeshRenderer.GetClassType())
	for i = 1 , renders.Length do
		renders[i-1].material.color = color
	end
end

function UnstopableState:getNormalColor(role)
	-- local rolePrefab = role.character
	-- local modelCfg = role:GetModelConfig()
 --    local skin = rolePrefab:Find (modelCfg.avatarName)
 --    local body = skin:Find (modelCfg.modelBody)
 --    local rend = body:GetComponent(UnityEngine.SkinnedMeshRenderer.GetClassType())
 --    return rend.material.color

    local renders = role.character:GetComponentsInChildren(UnityEngine.SkinnedMeshRenderer.GetClassType())
	for i = 1 , renders.Length do
		return renders[i-1].material.color
	end
end