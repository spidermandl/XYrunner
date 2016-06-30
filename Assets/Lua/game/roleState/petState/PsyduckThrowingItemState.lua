--[[
可达鸭扔宝箱状态 PsyduckThrowingItemState
作者：Huqiuxiang
]]
PsyduckThrowingItemState = class (BasePetState) 
PsyduckThrowingItemState._name = "PsyduckThrowingItemState"
PsyduckThrowingItemState.distance = 0
PsyduckThrowingItemState.player = nil  -- 主角
PsyduckThrowingItemState.animator = nil 

function PsyduckThrowingItemState:Enter(role)
    self.super.Enter(self,role)
    self.animator = role.character:GetComponent("Animator")
    self.animator:Play("idle")
    self.player = LuaShell.getRole(LuaShell.DesmondID)
end

PsyduckThrowingItemState.animTime = 40
function PsyduckThrowingItemState:Excute(role,dTime)
    self.super.throwItem(self,role,dTime)
end

function PsyduckThrowingItemState:Exit(role)
	-- self.super.Exit(self,role)
end

function PsyduckThrowingItemState:bottleCreat(role)
    self.throwItemObj = newobject(Util.LoadPrefab("Items/UnsolvedTreasure_box_item"))
    self.throwItemObj.transform.position = role.gameObject.transform.position
    self.throwItemObj.transform:Translate(0,1.5,0)
    -- self.throwItemObj.transform.rotation = Quaternion.Euler(0,90,0)

    self.effect = newobject(Util.LoadPrefab("Effects/Common/ef_pet_guangquan"))
    self.effect.transform.position = role.gameObject.transform.position
end

function PsyduckThrowingItemState:bottleMove(role,dTime)
   self.super.bottleMove(self,role,dTime)
end

function PsyduckThrowingItemState:Upbase(role,dTime) --上升
   self.super.Upbase(self,role,dTime)
end

function PsyduckThrowingItemState:Dropbase(role,dTime) --下落过程
    local dHeight = (self.upSpeed  + dTime * self.springACC ) * dTime
    local pos =Vector3(self.throwItemObj.transform.position.x,self.throwItemObj.transform.position.y - self.throwItemObj.transform.localScale.y/2,self.throwItemObj.transform.position.z)

    local layer = UnityEngine.LayerMask.NameToLayer("Step")

    local flag,hitinfo = UnityEngine.Physics.Raycast (self.throwItemObj.transform.position, UnityEngine.Vector3.down, nil, dHeight,2^layer)
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