--[[
喵喵抛金币状态
作者：huqiuxiang
]]
MeowsThrowingCoinsState = class (BasePetState) 
MeowsThrowingCoinsState._name = "MeowsThrowingCoinsState"
MeowsThrowingCoinsState.player = nil  -- 主角
MeowsThrowingCoinsState.animator = nil 
MeowsThrowingCoinsState.distance = nil 

function MeowsThrowingCoinsState:Enter(role)
    self.super.Enter(self,role)
    self.animator = role.character:GetComponent("Animator")
    self.animator:Play("idle")
    self.player = LuaShell.getRole(LuaShell.DesmondID)
end

MeowsThrowingCoinsState.animTime = 30 -- 喵喵动画关键 延时帧
function MeowsThrowingCoinsState:Excute(role,dTime)
         self.super.throwItem(self,role,dTime)
end

function MeowsThrowingCoinsState:Exit(role)
end

MeowsThrowingCoinsState.coinGroupLua = nil 
function MeowsThrowingCoinsState:bottleCreat(role)
-- print("bottleMove    self.throwItemObj.name"..tostring(self.throwItemObj))
    self.throwItemObj = newobject(Util.LoadPrefab("Items/coinBigger")) -- coinBigger
    self.throwItemObj.transform.position = role.gameObject.transform.position
    self.throwItemObj.transform:Translate(0,1.5,0)
    self.throwItemObj.transform.rotation = Quaternion.Euler(0,90,0)
    self.throwItemObj.transform.localScale = UnityEngine.Vector3(2,2,2)


    local collider =  self.throwItemObj.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    collider.isTrigger = false
    collider.center=UnityEngine.Vector3(0,0,0)
    collider.size=Vector3(0.7,0.7,0.7)   --item.transform.localScale

     --[[设置刚体]]
    local rigidBody =  self.throwItemObj.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    rigidBody.useGravity = false
    rigidBody.isKinematic = false
    rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll

    -- 放入金币组
    local coinGroup = GameObject.New()
    coinGroup:SetActive(false)
    local coinGroupScr = coinGroup:AddComponent(BundleLua.GetClassType())
    coinGroupScr.luaName = "CoinGroupInObj"
    coinGroup.transform.position = role.gameObject.transform.position
    coinGroup:SetActive(true)
    self.coinGroupLua = LuaShell.getRole(coinGroup:GetInstanceID())
    self.coinGroupLua.coinGroupTable[1] = self.throwItemObj
    self.throwItemObj.gameObject.transform.parent = coinGroup.gameObject.transform

    self.effect = newobject(Util.LoadPrefab("Effects/Common/ef_pet_guangquan"))
    self.effect.transform.position = role.gameObject.transform.position
end

function MeowsThrowingCoinsState:bottleMove(role,dTime)
    local t = self.coinGroupLua.coinGroupTable 
        -- print("bottleMove    self.throwItemObj.name"..tostring(self.throwItemObj.gameObject.name))
    if  #t < 1 then --  抛的过程中被吃了
          self.state = 2
    end
    if self.state == 0  then
         self:Upbase(role,dTime)  --  上升
    elseif self.state == 1  then
         self:Dropbase(role,dTime)  --  下降
    elseif self.state == 2  then
         GameObject.Destroy(self.effect)
    end
end

function MeowsThrowingCoinsState:Upbase(role,dTime) --上升
   self.super.Upbase(self,role,dTime)
end

function MeowsThrowingCoinsState:Dropbase(role,dTime) --下落过程
   self.super.Dropbase(self,role,dTime)
end

