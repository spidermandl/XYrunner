--[[
author:Desmond
收集物组
]]

-- 收集物种类tabel 
CollectItemsTab = {
  "branch01","branch01a","branch01b","coin","diamond","iron01","iron01a","iron01b","jewel01","jewel01a","jewel01b","rock01","rock01a","rock01b",
  "teeth01","teeth01a","teeth01b"
}


EliminateItemGroup = class(BaseBehaviour)

EliminateItemGroup.role = nil
EliminateItemGroup.type = "EliminateItemGroup" --收集道具类型
EliminateItemGroup.coinGroupTable = nil
EliminateItemGroup.recycleTable = nil --存放消除的物体

EliminateItemGroup.FlowInSpeed = 14
EliminateItemGroup.itemLinks = nil --模型和主键联接
EliminateItemGroup.itemManager = nil

function EliminateItemGroup:Awake()
	 --print("-----------------EliminateItemGroup Awake--->>>---------------"..tostring(self.bundleParams))
    self.itemManager = PoolFunc:pickSingleton("ItemGroup") --获取怪物管理器
    local lua = self.gameObject:GetComponent(BundleLua.GetClassType()) --移除lua update
    lua.isUpdate = false

    self:initParam()
    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self

end

--[[
  初始化参数
]]
function EliminateItemGroup:initParam()
    if self.itemLinks == nil then
        self.itemLinks = {}
    end

    -- if self.recycleTable == nil then
    --     self.recycleTable = GameObject.New()
    --     self.recycleTable.name = "recycle"
    --     self.recycleTable:SetActive(false)
    --     self.recycleTabl.parent = self.gameObject.transform.parent
    -- end

    if type(self.bundleParams) == "table" then  --参数从json中读入,动态加载时生效
        -- print("cccccccccc")
        --[[ table参数
            luaname
            收集物位置
            收集物rotataion
            收集物scale
            材料表id
        ]]
        --self.itemGroup = {}
        self.coinGroupTable = {}
        
        --print ("----------function EliminateItemGroup:initParam() num "..tostring(#self.bundleParams))
        for i=1,#self.bundleParams["items"] do --初始化 itemGroup
            --local array = lua_string_split(self.bundleParams[i],"/") --参数间分割符
            --print ("----------function EliminateItemGroup:initParam() "..self.bundleParams[i])
            local config = self.bundleParams["items"][i]
            local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
            local modelName = txt:GetData(config['material_id'],TxtFactory.S_MATERIAL_MODEL)
            --print ("------------item id "..tostring(array[5]).." "..tostring(modelName))
            local prefabPath = "Items/"..modelName

            local item  = PoolFunc:pickObjByPrefabName(prefabPath)
            item.name = prefabPath
            item.transform.parent = self.gameObject.transform
            local subArr = lua_string_split(config['localPosition'],",")
            item.transform.localPosition = UnityEngine.Vector3(tonumber(subArr[1]),tonumber(subArr[2]),tonumber(subArr[3])) 
            subArr = lua_string_split(config['localRotation'],",")
            --print (config['localRotation'])
            item.transform.localRotation = Quaternion.Euler(tonumber(subArr[1]),tonumber(subArr[2]),tonumber(subArr[3]))
            --item.transform.rotation = UnityEngine.Vector3(tonumber(subArr[1]),tonumber(subArr[2]),tonumber(subArr[3])) 
            subArr = lua_string_split(config['localScale'],",")
            item.transform.localScale = UnityEngine.Vector3(tonumber(subArr[1]),tonumber(subArr[2]),tonumber(subArr[3])) 

            table.insert(self.coinGroupTable,item)
                  --item:AddComponent(MsgBehaviour.GetClassType())
            local collider = item.gameObject:GetComponent(UnityEngine.BoxCollider.GetClassType())
            if collider == nil then
                collider = item.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
            end
            collider.isTrigger = false
            collider.center=UnityEngine.Vector3(0,0,0)
            collider.size=Vector3(0.7,0.7,0.7)   --item.transform.localScale

            --[[设置刚体]]
            local rigidBody = item.gameObject:GetComponent(UnityEngine.Rigidbody.GetClassType())
            if rigidBody == nil then
                rigidBody = item.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
            end
            rigidBody.useGravity = false
            rigidBody.isKinematic = false
            rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll

            self.itemLinks[item] = config['material_id']
        end
      
    end

    self.itemManager:addObject(self) --加入怪物
end

--启动事件--
function EliminateItemGroup:Start()

end

function EliminateItemGroup:Update()
    --print( #self.coinGroupTable)
	  if self.role == nil then
	      self.role=LuaShell.getRole(LuaShell.DesmondID)
	      return
	  end

    self.distance = self.gameObject.transform.position.x - self.role.character.transform.position.x  -- 与主角距离
    if self.distance < ConfigParam.objectDestroyByCameraDis then
        --LuaShell.OnDestroy(self.gameObject:GetInstanceID()) --销毁对象
        self:inactive()--冷藏对象
    end

    self.stateMachine:runState(UnityEngine.Time.deltaTime)
    local buff = self.role.stateMachine:getSharedState("MagnetState") or self.role.stateMachine:getSharedState("ThroughoutMagentState")
    local debuff = self.role.stateMachine:getSharedState("AntiMagnetState")
    local pos = self.role.gameObject.transform.position
    pos.y = pos.y + 1
    -- 磁铁状态
    if buff ~= nil and debuff == nil and self.role.stateMachine:getState() ~= "DeadState" then
        buff.distance = (buff._name == "MagnetState" and ConfigParam.CoinDistance or self.role.property.ThroughoutMagentDistance)
        for i = 1, #self.coinGroupTable do
            if  UnityEngine.Vector3.Distance(self.coinGroupTable[i].gameObject.transform.position, self.role.character.transform.position)< buff.distance then
                self.coinGroupTable[i].gameObject.transform.position =  Vector3.MoveTowards(self.coinGroupTable[i].gameObject.transform.position, pos,Time.deltaTime * self.FlowInSpeed*2)
            end
        end
         --print("磁铁状态")
    end

    -- 金币变化状态（索尼克，独眼怪，奎特 效果）

end
--检测需要变身的item
function EliminateItemGroup:checkChange(distance,itemId)
    if self.role == nil then
        self.role=LuaShell.getRole(LuaShell.DesmondID)
        return
    end
    for i = 1, #self.coinGroupTable do
        if  UnityEngine.Vector3.Distance(self.coinGroupTable[i].gameObject.transform.position, self.role.character.transform.position)< tonumber(distance) then
            local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
            local modelName = txt:GetData(itemId,TxtFactory.S_MATERIAL_MODEL)
            local prefabPath = "Items/"..modelName
            if self.coinGroupTable[i].name ~= prefabPath then --如果原来的item和新的item不同
                self:inactiveItem(self.coinGroupTable[i]) --隐藏原来的item=
                local item = self:createItem(prefabPath,self.coinGroupTable[i].gameObject.transform.localPosition,self.coinGroupTable[i].gameObject.transform.localRotation,self.coinGroupTable[i].gameObject.transform.localScale)
                self.itemLinks[item] = itemId --记录id
                table.remove(self.coinGroupTable,i)
            end
        end
    end
end
--创建新的item
function EliminateItemGroup:createItem(prefabPath,p,r,s)
    local item  = PoolFunc:pickObjByPrefabName(prefabPath)
    item.name = prefabPath
    item.transform.parent = self.gameObject.transform
    item.transform.localPosition = p
    item.transform.localRotation = r
    item.transform.localScale = s
    table.insert(self.coinGroupTable,item)
    local collider = item.gameObject:GetComponent(UnityEngine.BoxCollider.GetClassType())
    if collider == nil then
        collider = item.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    end
    collider.isTrigger = false
    collider.center=UnityEngine.Vector3(0,0,0)
    collider.size=Vector3(0.7,0.7,0.7)   --item.transform.localScale
    --[[设置刚体]]
    local rigidBody = item.gameObject:GetComponent(UnityEngine.Rigidbody.GetClassType())
    if rigidBody == nil then
        rigidBody = item.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    end
    rigidBody.useGravity = false
    rigidBody.isKinematic = false
    rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll
    return item
end

--冷藏物体
function EliminateItemGroup:inactive()
    -- print ("---------------function EliminateItemGroup:inactive() "
    --   ..tostring(#self.coinGroupTable).." "
    --   ..tostring(self.gameObject.transform.childCount))

    for i=1,#self.coinGroupTable do
        self:inactiveItem(self.coinGroupTable[i])
    end
    --PoolFunc:inactiveObj(self.gameObject)
    self.itemManager:removeObject(self)
end

--冷藏物体
function EliminateItemGroup:inactiveItem(item)
    if item ~= nil then
        --item.transform.parent = self.recycleTable.transform
        PoolFunc:inactiveObj(item)
    end
end



--与主角碰撞逻辑，外部调用
function EliminateItemGroup:touchedWithPlayer( item )
    --print ("---------------  function EliminateItemGroup:touchedWithPlayer( item )")
    if self.itemLinks == nil then
        return
    end
    if self.role == nil then
        --self.role=LuaShell.getRole(LuaShell.DesmondID)
        return
    end
    if self.role ~= nil then
        local buff = self.role.stateMachine:getSharedState("AntiMagnetState")
        if buff ~= nil then --判断是否有 无法收集物品状态
            return
        end
    end
    local itemID = self.itemLinks[item]
    if itemID == nil then
        return
    end

    --[[
        TxtFactory.S_MATERIAL_COIN_ID = "15001000" --金币
        TxtFactory.S_MATERIAL_BIG_COIN_ID = "15002000" --大金币
        TxtFactory.S_MATERIAL_DIAMOND_FRAG_ID = "15003000" --钻石碎片
        TxtFactory.S_MATERIAL_DIAMOND_ID = "15004000" --钻石
        TxtFactory.S_MATERIAL_STONE_ID = "15005000" --小石子
        TxtFactory.S_MATERIAL_BLOCK_ID = "15006000" --大石块
        TxtFactory.S_MATERIAL_C_JEWEL_ID = "15007000" --金刚石
        TxtFactory.S_MATERIAL_TREE_BRANCH_ID = "15008000" --小树枝
        TxtFactory.S_MATERIAL_WOOD_ID = "15009000" --木片
        TxtFactory.S_MATERIAL_GOD_TREE_ID = "15010000" --神木树枝
        TxtFactory.S_MATERIAL_IRON_FRAG_ID = "15011000" --铁屑
        TxtFactory.S_MATERIAL_IRON_BOARD_ID = "15012000" --铁板
        TxtFactory.S_MATERIAL_IRON_STONE_ID = "15013000" --陨铁石
        TxtFactory.S_MATERIAL_HALF_SHAPED_DIAMOND_ID = "15014000" --半月宝石
        TxtFactory.S_MATERIAL_FULL_SHAPED_DIAMOND_ID = "15015000" --圆月宝石
        TxtFactory.S_MATERIAL_GOD_SHAPED_DIAMOND_ID = "15016000" --月神宝石
        TxtFactory.S_MATERIAL_POINT_TOOTH_ID = "15017000" --小尖牙
        TxtFactory.S_MATERIAL_SHARP_TOOTH_ID = "15018000" --锐利的牙
        TxtFactory.S_MATERIAL_BEAST_TOOTH_ID = "15019000" --神兽的牙
    ]]
    local task = TxtFactory:getTable(TxtFactory.TaskManagement)
    task:SetTaskData(TaskType.TASK_COLLECT,tonumber(itemID),1)
    
    local effect = nil
    local effectGroup = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
    local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
    local effectName = txt:GetData(itemID,TxtFactory.S_MATERIAL_EFFECT)
    --GamePrint("itemID   :"..itemID)
    if itemID == TxtFactory.S_MATERIAL_COIN_ID 
    or itemID == TxtFactory.S_MATERIAL_BIG_COIN_ID 
    or itemID == TxtFactory.S_MATERIAL_SMALL_COIN_ID
    then --金币特效
        -- print("Creat effect")
        --计算所加金币
        local money = TxtFactory:getTable(TxtFactory.MemDataCache):absorbCoinMoney(itemID)
        self.role:addMoney(money) 
    
    elseif itemID == "diamond" then  -- 钻石
    elseif itemID == "hollowcoin" then  -- 空心币
        self:getHollowcoin()
    elseif itemID == "pinecone" then  -- 松果 
        self:getPinecone()
    elseif itemID == "electricball" then  -- 电力求
        self:getElectricball()
    else

    end
    if self.last3Effect ~= nil then --隐藏多余的特效，保证显示的特效不超过三个
        effectGroup:removeObject(self.last3Effect)
    end
    --创建特效
    if effectName ~= nil and effectName ~= '' then
        effect = PoolFunc:pickObjByPrefabName("Effects/Common/"..effectName)
        -- 给特效设参数
        if effect ~= nil then
            effectGroup:addObject(effect)
            effect.gameObject.transform.position = item.gameObject.transform.position
            effect.gameObject.transform.parent = self.gameObject.transform
        end
        self.last3Effect = self.last2Effect--保存前三次的特效
        self.last2Effect = self.lastEffect
        self.lastEffect = effect 
    end

      --遍历table 删除相应的obj
    for i,v in ipairs(self.coinGroupTable) do
        if v == item then
            table.remove(self.coinGroupTable,i) --不会完全删除
            --print ("-------------------- test remove "..tostring(i)..":"..tostring(self.coinGroupTable[i]))
            self:inactiveItem(item)
            break
        end
    end
    local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
    local holyScore = txt:GetData(itemID,TxtFactory.S_MATERIAL_HOLYSCORE)

    local score = TxtFactory:getTable(TxtFactory.MemDataCache):absorbItemScore(itemID)--计算得分
    --print ("---------------  function EliminateItemGroup:touchedWithPlayer( item ) "..tostring(score))
    self.role:absortItem(score,tonumber(holyScore))
end



--------------------------------------------------------- 吃到收集物判断  -----

-- 空心币 
function EliminateItemGroup:getHollowcoin()
  -- 得分增加
  --print("getHollowcoin")
end

-- 松果 
function EliminateItemGroup:getPinecone()
    -- 增加体力
    --print("getPinecone")
    local buff = CureState.new()
    self.role.stateMachine:addSharedState(buff)
end

-- 电力球 
function EliminateItemGroup:getElectricball()
    -- 电力球Buff添加
    local buff = ElectricBallState.new()
    buff.state = 3
    self.role.stateMachine:addSharedState(buff)
end

