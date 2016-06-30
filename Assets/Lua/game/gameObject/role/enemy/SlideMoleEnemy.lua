--[[
  author: huqiuxiang
  潜行鼠
]]
SlideMoleEnemy = class (BaseEnemy)
SlideMoleEnemy.roleName = "SlideMole"
SlideMoleEnemy.HP = 1

function SlideMoleEnemy:Awake()
    self.super.Awake(self)
    --self.gameObject.transform.rotation = Quaternion.Euler(0,60,0)
end

--启动事件--
function SlideMoleEnemy:Start()
end

function SlideMoleEnemy:FixedUpdate()
    self.super.FixedUpdate(self)
end

function SlideMoleEnemy:Update()
    self.super.Update(self)
end

function SlideMoleEnemy:OnTriggerEnter( gameObj )
	self.super.OnTriggerEnter(self,gameObj)
end

--攻击
function SlideMoleEnemy:attack(player)
    self.stateMachine:changeState(SlideMoleEnemyAtkState.new())
    player.stateMachine:changeState(DefendState.new())

    local buff = AntiMagnetState.new()
    if player.stateMachine:getSharedState(buff._name) == nil then
        player.stateMachine:addSharedState(buff)
    end

        --show通用打击特效
    local effectManager = PoolFunc:pickSingleton("EffectGroup")
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_monster_hit")
    effectManager:addObject(effect)
    effect.name = "ef_monster_hit"
    effect.transform.parent = self.character.transform
    effect.transform.localPosition = UnityEngine.Vector3(0,0.5,1)

end

--受到攻击
function SlideMoleEnemy:defend(player)
    self.stateMachine:changeState(SlideMoleEnemyDefState.new())
end

function SlideMoleEnemy:CreateDynamicEnemy()
	--[[设置角色]]
    if self.gameObject.transform:Find(self.roleName) == nil then
        self.character = PoolFunc:pickObjByPrefabName("Monster/"..self.roleName)
        self.character.transform.parent = self.gameObject.transform
        self.character.transform.localPosition = UnityEngine.Vector3(0,0,0)
         --重置模型的大小和旋转
        self.character.transform.localRotation = Quaternion.identity
        self.character.transform.localScale = UnityEngine.Vector3.one
    else
        self.character = self.gameObject.transform:Find(self.roleName)
    end
    --加入动画
    self.animator = self.character:GetComponent("Animator")
    --[[设置碰撞体]]
    self.collider = self.gameObject:AddComponent(UnityEngine.CapsuleCollider.GetClassType())
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0.5,0)
    self.collider.radius= 0.3
    self.collider.height= 1
end

function SlideMoleEnemy:goActiveState()
	self.stateMachine:changeState(SlideMoleEnemyIdleState.new())
end

