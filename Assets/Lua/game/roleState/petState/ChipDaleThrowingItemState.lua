--[[
大松鼠扔苹果状态 ChipDaleThrowingItemState
作者：Huqiuxiang
]]
ChipDaleThrowingItemState = class (BasePetState) 
ChipDaleThrowingItemState._name = "ChipDaleThrowingItemState"
ChipDaleThrowingItemState.distance = 0
ChipDaleThrowingItemState.player = nil  -- 主角
ChipDaleThrowingItemState.animator = nil 

function ChipDaleThrowingItemState:Enter(role)
    self.super.Enter(self,role)
    self.animator = role.character:GetComponent("Animator")
    self.animator:Play("idle")
    self.player = LuaShell.getRole(LuaShell.DesmondID)
end

ChipDaleThrowingItemState.animTime = 40
function ChipDaleThrowingItemState:Excute(role,dTime)
    self.super.throwItem(self,role,dTime)
end

function ChipDaleThrowingItemState:Exit(role)
	-- self.super.Exit(self,role)
end

-------- 大苹果 -------
function ChipDaleThrowingItemState:bottleCreat(role)

    self.throwItemObj = newobject(Util.LoadPrefab("Items/BigApple_item"))
    self.throwItemObj.transform.position = role.gameObject.transform.position
    self.throwItemObj.transform:Translate(0,1.5,0)
    self.throwItemObj.transform.rotation = Quaternion.Euler(0,90,0)
    self.throwItemObj.transform.localScale = UnityEngine.Vector3(3,3,3)
    self.throwItemObj.transform.parent = role.gameObject.transform

    self.effect = newobject(Util.LoadPrefab("Effects/Common/ef_pet_guangquan"))
    self.effect.transform.position = role.gameObject.transform.position
end

function ChipDaleThrowingItemState:bottleMove(role,dTime)
   self.super.bottleMove(self,role,dTime)
end

function ChipDaleThrowingItemState:Upbase(role,dTime) --上升
   self.super.Upbase(self,role,dTime)
end

function ChipDaleThrowingItemState:Dropbase(role,dTime) --下落过程 (大苹果有人物碰壁停留效果)
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
        local objlLua =  LuaShell.getRole(self.throwItemObj.gameObject:GetInstanceID())
        objlLua.collider.isTrigger = false
    end
end