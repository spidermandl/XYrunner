--[[
author:Desmond
宠物救起主角状态
]]
PetRescueState = class (IState)

PetRescueState._name = "PetRescueState"
PetRescueState.dead = nil --主角
PetRescueState.animator = nil

PetRescueState.movePath = nil --移动路径
PetRescueState.pathIndex = 1 --移动点索引

PetRescueState.FlowInSpeed = 10
PetRescueState.itemManager = nil --itemGroup
PetRescueState.targetPoint = nil --目标点
-- 宠物相对主角偏移坐标
PetLocalTrans = { ["NORMAL"] =  UnityEngine.Vector3(-0.2,0.2,0),
                  ["CNMMountState"] = UnityEngine.Vector3(-0.5,1.4,0),
                  ["UFOMountState"] = UnityEngine.Vector3(-0.2,2.6,0),}

function PetRescueState:Enter(role)
    self.animator = role.character:GetComponent("Animator")
    self.animator:Play("rescue")
    self.dead = LuaShell.getRole(LuaShell.DesmondID)
    -- 调整宠物位置
    if self.dead ~= nil and self.dead.mount ~= nil then
        local mountstate = self.dead:getMountState()--获取座骑状态
        if mountstate ~= nil then
            role.gameObject.transform:Translate(PetLocalTrans[mountstate._name])
        end
    else
        role.gameObject.transform:Translate(PetLocalTrans["NORMAL"])
    end
    self.itemManager = PoolFunc:pickSingleton("ItemGroup")
    self.targetPoint = --self.itemManager:getNearestPointMarkByType("RevivePointMark")
                        self.itemManager:getNearestRevivePointMarkByType(self.dead.gameObject.transform.position.x)
    self.movePath = {}
    self.movePath[1] = self.dead.gameObject.transform.position
    if self.targetPoint == nil then --如果没找到最近的复活点，给一个设定的位置，在向这位置移动中持续找复活点
        self.movePath[3] = Vector3(self.movePath[1].x,self.movePath[1].y,self.movePath[1].z)+ConfigParam.FindRevivePointDistance
    else
        self.movePath[3] = self.targetPoint--.gameObject.transform.position
    end
    self.movePath[2] = UnityEngine.Vector3(self.movePath[1].x,self.movePath[3].y,self.movePath[1].z)

    self.pathIndex = 2

    --强制转变角色的朝向
    --[[
    if self.movePath[3].x > self.movePath[1].x then
        self.dead.moveSpeedVect = 1
    else
        self.dead.moveSpeedVect = -1
    end
    ]]
    self.dead.moveSpeedVect = 1
    local vec = self.dead.gameObject.transform.localScale
    vec.x = math.abs(vec.x)/self.dead.moveSpeedVect
    self.dead.gameObject.transform.localScale = vec

end


function PetRescueState:Excute(role,dTime)
    if self.pathIndex > #self.movePath then
        --print ("-----------function PetRescueState:Excute(role,dTime) "..tostring(self.pathIndex))
        self.dead:reborn()
        self.dead:isOnCollision(false) --移除碰撞 死亡状态防止和其他物体发生逻辑
        role:playVanishExplode()
        return
    end
    local last_position = self.dead.gameObject.transform.position
    local new_position = 
            Vector3.MoveTowards(last_position,
                self.movePath[self.pathIndex],dTime * self.FlowInSpeed)
    self.dead.gameObject.transform.position = new_position
    local new_distance = UnityEngine.Vector3.Distance(new_position,self.movePath[self.pathIndex])

    --print (tostring(new_position))
    --print (tostring(self.movePath[self.pathIndex]).." "..tostring(new_position).." "..tostring(new_distance).." "..tostring(dTime * self.FlowInSpeed))
    if new_distance < 0.2  then -- 到达一个路径点
        --print ("-----------function PetRescueState:Excute(role,dTime) 2 ")
        self.pathIndex = self.pathIndex +1 
    end
    if self.targetPoint == nil then
        --GamePrint("持续找点中。。。。。。")
        self.targetPoint = --self.itemManager:getNearestPointMarkByType("RevivePointMark")
                           self.itemManager:getNearestRevivePointMarkByType(self.dead.gameObject.transform.position.x)
    else
        self.movePath[3] = self.targetPoint--.gameObject.transform.position
    end
end










