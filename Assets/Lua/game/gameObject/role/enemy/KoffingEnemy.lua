--[[
  author: huqiuxiang
  瓦斯弹
]]
KoffingEnemy = class (BaseEnemy)
KoffingEnemy.roleName = "Koffing" --本地直接加载
KoffingEnemy.effectManager = nil --特效管理类
KoffingEnemy.effects = nil --特效
KoffingEnemy.HP = 1
KoffingEnemy.effectName = 
{
    "ef_monster_wasi",
    "ef_monster_wasix2",
    "ef_monster_wasix3",
    "ef_monster_wasix4",
}

function KoffingEnemy:Awake()
    self.super.Awake(self)
end


--攻击
function KoffingEnemy:attack(player)
    player.stateMachine:changeState(DefendState.new())
end

--受到攻击 (特例)
function KoffingEnemy:defend(player)

    if (player.stateMachine.sharedStates~=nil and player.stateMachine.sharedStates["ChangeBigState"] ~= nil )
    or (player.stateMachine.sharedStates~=nil and player.stateMachine.sharedStates["InvincibleState"] ~= nil )
    or player.stateMachine:getState()._name == "SprintState"
    or player.stateMachine.sharedStates["CleanMonsterState"] ~= nil 
    or player.type == "chinchillas" --龙猫
    then  -- 变大或无敌状态 才受击
        iTween.Stop(self.gameObject)
       self.stateMachine:changeState(KoffingEnemyDefState.new())
       return
    end
    player.stateMachine:changeState(DefendState.new())
end

function KoffingEnemy:CreateDynamicEnemy()
		--[[设置角色]]
    if self.gameObject.transform:Find(self.roleName) == nil then
        self.character = PoolFunc:pickObjByPrefabName("Monster/"..self.roleName)
        self.character.transform.parent=self.gameObject.transform
        self.character.transform.localPosition = UnityEngine.Vector3(0,0,0)
         --重置模型的大小和旋转
        self.character.transform.localRotation = Quaternion.Euler(0,-90,0) --写死旋转
        self.character.transform.localScale = UnityEngine.Vector3.one
    else
        self.character = self.gameObject.transform:Find(self.roleName)
    end
    --加入动画
    self.animator = self.character:GetComponent("Animator")
    --[[设置碰撞体]]
    self.collider = self.gameObject:GetComponent(UnityEngine.SphereCollider.GetClassType())
    if self.collider == nil then
        self.collider = self.gameObject:AddComponent(UnityEngine.SphereCollider.GetClassType())
        self.collider.isTrigger = true
        self.collider.center=UnityEngine.Vector3(0,0,0)
        self.collider.radius=0.5
    end

    --print ("---------------function KoffingEnemy:CreateDynamicEnemy() "..tostring(self.character.transform.localScale))
end
function KoffingEnemy:inactiveSelf()
    if self.effects ~= nil then
        self.effectManager:removeObject(self.effects)
    end
    self.super.inactiveSelf(self)
end
function KoffingEnemy:SetEffect()
        --show特效
    self.effectManager = PoolFunc:pickSingleton("EffectGroup")
    local index = 1
    index = math.floor(self.gameObject.transform.localScale.x) --瓦斯弹大小取整
    local name = self.effectName[index]
    if name == nil then 
        return
    end
    self.effects = PoolFunc:pickObjByPrefabName("Effects/Common/"..name)
    self.effectManager:addObject(self.effects,true)
    --self.effects.name = name
    self.effects.transform.parent = self.gameObject.transform
    self.effects.transform.localPosition = UnityEngine.Vector3(0,0,0)
    self.effects.transform.localRotation = Quaternion.Euler(0,0,0)
    self.effects.transform.localScale = UnityEngine.Vector3.one
end
function KoffingEnemy:goActiveState()
    --特殊类型 特效按照 0，0，0 做的
    iTween.Stop(self.gameObject)
    self.gameObject.transform.localRotation = Quaternion.identity
	self.stateMachine:changeState(KoffingEnemyIdleState.new())
    self:SetEffect()
end
