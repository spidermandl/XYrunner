-- CoinChangeFromPetState (宠物效果改变金币  奎特，独眼怪，索尼克等)
-- 作者：胡秋翔

CoinChangeFromPetState = class(BasePlayerState)
CoinChangeFromPetState._name = "CoinChangeFromPetState"
CoinChangeFromPetState.type = nil -- 金币变化的三种类型 不同怪 类型不一样
CoinChangeFromPetState.startTime = 0 
CoinChangeFromPetState.duringTime = 1 -- 间隔时间
CoinChangeFromPetState.r = 8 -- 触发半斤

function CoinChangeFromPetState:Enter(role)
	self.startTime = UnityEngine.Time.time
    self.probabilityOfSonic = ConfigParam.probabilityOfSonic 
    self.probabilityOfMike = ConfigParam.probabilityOfMike 
    self.probabilityOfKuite = ConfigParam.probabilityOfKuite 
end

function CoinChangeFromPetState:Excute(role,dTime)
    if UnityEngine.Time.time - self.startTime > self.duringTime then  -- 时间间隔触发判断
        -- 到达时间触发效果
        if self.type == 0 then
            self:SonicEvent(role)
        elseif self.type == 1 then
            self:MikeEvent(role)
        elseif self.type == 2 then
            self:KuiteEvent(role)
        end
        -- self:startChange(role) 
		self.startTime = UnityEngine.Time.time 
	end
end

function CoinChangeFromPetState:Exit(role)
    if self.effects ~= nil then
		GameObject.Destroy(self.effects)
	end
end

CoinChangeFromPetState.probabilityOfSonic = 100 -- 索尼克的概率
CoinChangeFromPetState.probabilityOfMike = 10 -- 索尼克的概率
CoinChangeFromPetState.probabilityOfKuite = 5 -- 索尼克的概率

CoinChangeFromPetState.groupItemType = nil
-- 索尼克金币变化
function CoinChangeFromPetState:SonicEvent(role)
    self.groupItemType = "hollowcoin"

    local nub = math.random(100)
    if nub <= self.probabilityOfSonic then
        self:startChange(role)
    end
end

-- 独眼怪金币变化
function CoinChangeFromPetState:MikeEvent(role)
    self.groupItemType = "pinecone"
    local nub = math.random(100)
    if nub <= self.probabilityOfMike then
        self:startChange(role)
    end
end

-- 奎特金币变化
function CoinChangeFromPetState:KuiteEvent(role)
    self.groupItemType = "electricball"
    local nub = math.random(100)
    if nub <= self.probabilityOfKuite then
        self:startChange(role)
    end
end


function CoinChangeFromPetState:startChange(role)
    local tab = UnityEngine.Physics.OverlapSphere(role.gameObject.transform.position,self.r)
    local length = tab.Length - 1 

    local parentLuaTab = {}
    for i=0,length do
        -- print(i)
         local c = System.Array.GetValue(tab,i)
         local cParent = c.gameObject.transform.parent
         local cParentLua = LuaShell.getRole(cParent.gameObject:GetInstanceID()) -- 获得收集物父级 Group lua
         if   cParentLua ~= nil and cParentLua.itemType == "coin" then -- 只有金币 才作出变化
              self:changeItem(c,cParentLua)
              -- 保存 父级group 到 parentLuaTab  最后统一改它的itemtype
              parentLuaTab[#parentLuaTab+1] = cParentLua
         end
    end

    -- 修改改变完的收集物 父级的itemtype
    for u=1,#parentLuaTab do
         parentLuaTab[u].itemType = self.groupItemType
    end
end

-- 统一 替换金币为其他收集物
function CoinChangeFromPetState:changeItem(item,group)
    -- print("11111111111111")
    local obj = newobject(Util.LoadPrefab("Items/"..self.groupItemType))
    obj.gameObject.transform.parent = group.gameObject.transform
    obj.gameObject.transform.position = item.gameObject.transform.position
    obj.gameObject.transform.localScale = Vector3(1.5,1.5,1.5)

    local collider = obj.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    collider.isTrigger = false
    collider.center=UnityEngine.Vector3(0,0,0)
    collider.size=Vector3(0.7,0.7,0.7)   --item.transform.localScale

     --[[设置刚体]]
    local rigidBody = obj.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    rigidBody.useGravity = false
    rigidBody.isKinematic = false
    rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll

        --遍历table 删除相应的金币
    for i , v in ipairs(group.coinGroupTable) do
      if v == item then
        table.remove(group.coinGroupTable,i)
      end
    end
    GameObject.Destroy(item.gameObject)

    -- 添加obj到table
    group.coinGroupTable[#group.coinGroupTable+1] = obj

end