--[[
   author:Desmond
   萌宠基类
]]
BasePet = class (BaseBehaviour)
BasePet.roleName = nil
BasePet.type = "pet"
BasePet.character =nil  --prefab
BasePet.animator = nil
BasePet.stateMachine = nil
BasePet.collider = nil
BasePet.role = nil --主角
BasePet.distance=nil
BasePet.dropPoint = nil --萌宠释放角色点

function BasePet:Awake()
    --print("-----------------BasePet Awake--->>>-----------------")
    self.role = LuaShell.getRole(LuaShell.DesmondID) 
    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self
    if self.bundleParams ~= nil then
        local txt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
        self.petTypeID = self.bundleParams
        self.roleName = txt:GetData(self.petTypeID,TxtFactory.S_ROLE_MODEL)
    end
    
    self:createModel()
    self:initParam()
end

-- 启动事件--
function BasePet:Start()
end

function BasePet:Update()
    if self.role == nil then
        self.role = LuaShell.getRole(LuaShell.DesmondID) 
        return
    end

    self.distance = self.gameObject.transform.position.x - self.role.character.transform.position.x  -- 与主角距离
    if self.distance < ConfigParam.objectDestroyByCameraDis then
        --销毁特效
        local state = self.stateMachine:getState()
        if state ~= nil then
            state:Exit(self)
        end
        --LuaShell.OnDestroy(self.gameObject:GetInstanceID()) --销毁敌对象
        self.inactive() --冷藏对象
    end

end

function BasePet:FixedUpdate()
    self.stateMachine:runState(UnityEngine.Time.fixedDeltaTime)
end

--[[
初始化
]]
function BasePet:initParam()

    local petManager = PoolFunc:pickSingleton("PetGroup") --pet管理器
    local lua = self.gameObject:GetComponent(BundleLua.GetClassType()) --移除lua update
    lua.isUpdate = false
    petManager:addObject(self)
end

--[[
创建模型
]]
function BasePet:createModel()
    --[[设置角色]]
    if self.gameObject.transform:Find(self.roleName) == nil then
        self.character = PoolFunc:pickObjByPrefabName("Pet/"..self.roleName) --从内存池中读取
        self.character.transform.parent=self.gameObject.transform
        self.character.transform.localPosition = UnityEngine.Vector3(0,0,0)
        self.character.transform.localScale = UnityEngine.Vector3(1,1,1)
        self.character.transform.rotation=UnityEngine.Quaternion.Euler(0,180,0)
    else
        self.character = self.gameObject.transform:Find(self.roleName)
    end
    --[[设置碰撞体]]
end

--冷藏object
function BasePet:inactive()
    local petManager = PoolFunc:pickSingleton("PetGroup") --pet管理器
    petManager:removeObject(self)
end

--[[
消失特效
]]
function BasePet:playVanishExplode()
    self.stateMachine:changeState(PetIdleState.new())
    self:createEffect()
    self:inactive()
end
--创建特效
function BasePet:createEffect()
    local effectManager = PoolFunc:pickSingleton("EffectGroup") --effect管理器
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_pet_Mcxiaoshi")
    effectManager:addObject(effect)
    effect.transform.parent = self.gameObject.transform.parent
    local pos = self.gameObject.transform.localPosition
    pos.y = pos.y+0.7
    effect.transform.localScale = self.character.transform.localScale
    effect.transform.localPosition = pos --位置偏移
end

--进入萌宠主动技能发动状态
function BasePet:triggerCaptainSkill()

end

-- BasePet.isCanBeCreated = 0
--场景萌宠生成
-- function BasePet:BaseScenePetCreat(role)
--       self.gameObject:SetActive(false)
--       -- 人物套装判断 （人物无对应套装 则无法）
--       for i , v in ipairs(role.property.PetTabel) do -- 遍历人物宠物tabel
--            if v == self.roleName then
--                self.gameObject:SetActive(true)
--            end
--       end
      
-- end



