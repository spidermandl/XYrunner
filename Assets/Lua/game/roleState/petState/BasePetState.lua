--[[宠物状态基类
作者：秦仕超
]]

BasePetState=class(IState)
BasePetState._name = "BasePetState"
BasePetState.player = nil --主角
BasePetState.animator = nil

BasePetState.distance = 0
BasePetState.effect = nil
BasePetState.effectSys = nil
BasePetState.stage = 0 -- 0:正在escorting 1:role隐藏 2:播放结束动画

function BasePetState:Enter(role)
    self.animator = role.character:GetComponent("Animator")
    self.animator:Play("idle")
    self.player = LuaShell.getRole(LuaShell.DesmondID)
end

function BasePetState:Excute(role,dTime)
	-- self.super.Excute(self,role)
end

function BasePetState:Exit(role)
	-- self.super.Exit(self,role)
end


--[[ 地面判断 ]]
function BasePetState:isOnGround(role)
	local pos = role.gameObject.transform.position
	pos.y=pos.y + 0.1
	local flag,hitinfo = UnityEngine.Physics.Raycast (pos, UnityEngine.Vector3.down, nil, 1)

    if flag ==true then
    	flag = false
        local obj = LuaShell.getRole(hitinfo.collider.gameObject:GetInstanceID())
        if obj ~= nil then
        	if tostring(obj.type) == "RoadSurface" then
        		flag = true
        	end
        end
    end

	return flag
end

--------------------------------------------------- 抛物品 -----------------------------------------------------------------
BasePetState.animTime = 20  -- 动画延时关键帧
BasePetState.animStartTime = 0 -- 动画开始
BasePetState.throwItemObj = nil -- 抛物品profeb
-- 抛物品
function BasePetState:throwItem(role,dTime)
    self.distance = role.gameObject.transform.position.x - self.player.character.transform.position.x  -- 与主角距离
    if self.distance < 11 then   -- 到达距离投药品
        self.animStartTime = self.animStartTime + 1
        -- print("阿里投药瓶")
        if self.throwItemObj == nil then
            local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
    --print ("-------------------------------->>>>>>>>>> function AttackState:Excute(role,dTime) "..tostring(animInfo.normalizedTime))
            self.animator:Play("attack")
            if self.animStartTime >= self.animTime then --动画关键帧
                  self:bottleCreat(role) -- 生成药品
            end
        else
             self:bottleMove(role,dTime)   -- 药品移动
        end
    end
end


--------生成抛物品 及 特效
function BasePetState:bottleCreat(role)
    -- print("BasePetState:bottleCreat(role)")
    self.throwItemObj = newobject(Util.LoadPrefab("Items/StaminaBottle_item"))
    self.throwItemObj.transform.position = role.gameObject.transform.position
    self.throwItemObj.transform:Translate(0,1.5,0)
    self.throwItemObj.transform.rotation = Quaternion.Euler(0,90,0)

end

--------抛物品运动轨迹
BasePetState.state = 0 
function BasePetState:bottleMove(role,dTime)
    -- print("bottleMove    self.throwItemObj.name"..tostring(self.throwItemObj))
    if self.state == 0  then
         self:Upbase(role,dTime)  --  上升
    elseif self.state == 1  then
         self:Dropbase(role,dTime)  --  下降
    elseif self.state == 2  then
         GameObject.Destroy(self.effect)
    end
end

BasePetState.springACC = 45 
BasePetState.upSpeed = 15
BasePetState.movetoLeftSpeed = 12
function BasePetState:Upbase(role,dTime) --上升
        -- print("Upbase    self.throwItemObj.name"..tostring(self.throwItemObj))
    local dHeight = (self.upSpeed  - dTime * self.springACC) * dTime

    local flag = false
     if dHeight < 0 then
       flag = true
     else
       flag = false  
     end
    --上升过程:
    --一直上升
    if flag == false then
        self.upSpeed  = self.upSpeed  - dTime * self.springACC
        self.throwItemObj.transform:Translate(0,dHeight,0,Space.World)
        self.throwItemObj.transform:Translate(UnityEngine.Time.deltaTime * self.movetoLeftSpeed,0,0,Space.World)
    -- 到顶点:
    else
       self.state = 1
    end
end

function BasePetState:Dropbase(role,dTime) --下落过程
    local dHeight = (self.upSpeed  + dTime * self.springACC ) * dTime
    local pos =Vector3(self.throwItemObj.transform.position.x,self.throwItemObj.transform.position.y - self.throwItemObj.transform.localScale.y/2,self.throwItemObj.transform.position.z)

    local layer = UnityEngine.LayerMask.NameToLayer("Step")

    local flag,hitinfo = UnityEngine.Physics.Raycast (pos, UnityEngine.Vector3.down, nil, dHeight,2^layer)
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
        self.upSpeed  = self.upSpeed  + dTime * self.springACC
        self.throwItemObj.transform:Translate(UnityEngine.Time.deltaTime * self.movetoLeftSpeed,-dHeight,0,Space.World)
    -- 下降至地面:
    else
        self.animator:Play("idle")
        self.state = 2
    end
end