--[[
丘比向前抛洒高分物质状态
作者：huqiuxiang
]]
ChobeThrowingThingsState = class (BasePetState) 
ChobeThrowingThingsState._name = "ChobeThrowingThingsState"

ChobeThrowingThingsState.distance = 0                
ChobeThrowingThingsState.player = nil                   
ChobeThrowingThingsState.animator = nil 

function ChobeThrowingThingsState:Enter(role)
    -- self.super.Enter(self,role)
    -- print("ChobeThrowingThingsState:Enter ")
    self.player = LuaShell.getRole(LuaShell.DesmondID)
end

-- ChobeThrowingThingsState.animTime = 40
function ChobeThrowingThingsState:Excute(role,dTime)
    if self.throwItemObj == nil then
    	    -- self.animStartTime = self.animStartTime + 1
         --    local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
         --    self.animator:Play("attack")
         --    if self.animStartTime >= self.animTime then --动画关键帧
         --          self:bottleCreat(role) -- 生成药品
         --    end
        self:bottleCreat(role) -- 生成药品
        self.previouY = self.throwItemObj.gameObject.transform.position.y
        -- print("self.previouY  :"..self.previouY)
    else
        self:bottleMove(role,dTime)   -- 药品移动
    end
end

function ChobeThrowingThingsState:Exit(role)

end

ChobeThrowingThingsState.previouY = nil -- 记录初始高度
-- ChobeThrowingThingsState.currentY = nil 
ChobeThrowingThingsState.itemTable = {"teeth01a","diamond","iron01","branch01"}  -- 随机生成收集物表
--------生成物品
function ChobeThrowingThingsState:bottleCreat(role)
    self.throwItemObj = --newobject(Util.LoadPrefab("Items/StaminaBottle_item"))
                        GameObject.New()
    self.throwItemObj:SetActive(false)
    local lua = self.throwItemObj:AddComponent(BundleLua.GetClassType())
        -- local petName=role.property.PetFlightName
    lua.luaName = "CoinGroupInObj" 

    local nub = math.random(#self.itemTable)
    local item = newobject(Util.LoadPrefab("Items/"..self.itemTable[nub]))
    self.throwItemObj:SetActive(true)
    item.gameObject.transform.parent = self.throwItemObj.gameObject.transform
    item.gameObject.transform.localPosition = Vector3.zero
    item.gameObject.transform.localScale = Vector3(1.5,1.5,1.5)

    local collider = item.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    collider.isTrigger = false
    collider.center=UnityEngine.Vector3(0,0,0)
    collider.size=Vector3(0.7,0.7,0.7)   --item.transform.localScale

    --[[设置刚体]]
    local rigidBody = item.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    rigidBody.useGravity = false
    rigidBody.isKinematic = false
    rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll

    local throwItemObjlua = LuaShell.getRole(self.throwItemObj:GetInstanceID())
    throwItemObjlua.coinGroupTable[#throwItemObjlua.coinGroupTable+1] = item



    self.throwItemObj.transform.position = role.gameObject.transform.position
    self.throwItemObj.transform:Translate(0,1.5,0)
    -- self.throwItemObj.transform.rotation = Quaternion.Euler(0,90,0)

    self.effect = newobject(Util.LoadPrefab("Effects/Common/ef_pet_guangquan"))
    self.effect.transform.position = role.gameObject.transform.position
end

--------物品运动轨迹
function ChobeThrowingThingsState:bottleMove(role,dTime)
    if self.state == 0  then
         self:Upbase(role,dTime)  --  上升
    elseif self.state == 1  then
         self:Dropbase(role,dTime)  --  下降
    elseif self.state == 2  then
         GameObject.Destroy(self.effect)

         local buff = self.player.stateMachine:getSharedState("ChobeThrowingThingsForRoleState")
         buff.isCreatedObj = false

         -- GameObject.Destroy(role.gameObject)
         -- destroy(role)
         LuaShell.OnDestroy(role.gameObject:GetInstanceID())


    end
end

function ChobeThrowingThingsState:Upbase(role,dTime) --上升
   self.super.Upbase(self,role,dTime)
end

function ChobeThrowingThingsState:Dropbase(role,dTime) --下落过程
    local dHeight = (self.upSpeed  + dTime * self.springACC ) * dTime

    local flag = false

    if self.previouY >= self.throwItemObj.gameObject.transform.position.y - dHeight then
    	flag = true
    	-- print("flag = true"..dHeight)
    end

    --下降过程:
    --一直下降直到撞击平面
    if flag == false then
        self.upSpeed  = self.upSpeed  + dTime * self.springACC
        self.throwItemObj.transform:Translate(UnityEngine.Time.deltaTime * self.movetoLeftSpeed,-dHeight,0,Space.World)
        -- print(" self.throwItemObj.gameObject.transform.position.y "..dHeight)
    -- 下降至地面:
    else
        -- self.animator:Play("idle")
        self.state = 2
    end
end
