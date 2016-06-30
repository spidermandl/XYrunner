-- SpringEnemyDropState

SpringEnemyDropState = class (BaseEnemyState)

SpringEnemyDropState._name = "SpringEnemyDropState"
SpringEnemyDropState.springACC = 45

function SpringEnemyDropState:Enter(role)
    self.super.Enter(self,role)
    self.animator:Play("idle")
end

function SpringEnemyDropState:Excute(role,dTime)
local landPoint = self:Dropbase(role,dTime)
end


function SpringEnemyDropState:Dropbase(role,dTime) --下落过程

    local dHeight = (role.dropSpeed  + dTime * self.springACC ) * dTime
    local pos = role.gameObject.transform.position
    pos.y=pos.y - 0.1

	local flag,hitinfo = UnityEngine.Physics.Raycast (role.gameObject.transform.position, UnityEngine.Vector3.down, nil, dHeight)
    if flag ==true then --判断碰撞物是否为地面
    	flag = false
        local obj = LuaShell.getRole(hitinfo.collider.gameObject:GetInstanceID())
        if obj ~= nil then
        	if tostring(obj.type) == "RoadSurface" then
        		flag = true
        	end
        end
    end

	--下降过程:
	--一直下降直到撞击平面
	if flag == false then
        role.dropSpeed  = role.dropSpeed  + dTime * self.springACC
        role.gameObject.transform:Translate(0,-dHeight,0)
        role.gameObject.transform:Translate(0,0,UnityEngine.Time.deltaTime * role.movetoLeftSpeed)
        role.IsSpring = 3
	-- 下降至地面:
	else
        role.IsSpring = 1
        role.dropSpeed = self.dropSpeed
        role.stateMachine:changeState(SpringEnemySpringState.new())
	end

	return role.gameObject.transform.position.y
end