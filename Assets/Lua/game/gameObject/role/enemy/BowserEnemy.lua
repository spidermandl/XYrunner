--[[
  author: huqiuxiang 赵名飞
  胆小龟
]]
BowserEnemy = class (BaseEnemy)
BowserEnemy.roleName = "Bowser"
BowserEnemy.HP = 2

function BowserEnemy:Awake()
    self.super.Awake(self)
end

--启动事件--
function BowserEnemy:Start()
end


function BowserEnemy:FixedUpdate()
    self.super.FixedUpdate(self)
end

function BowserEnemy:Update()
    self.super.Update(self)
end

function BowserEnemy:OnTriggerEnter( gameObj )
    self.super.OnTriggerEnter(self,gameObj)
end

--攻击
function BowserEnemy:attack(player)
    self.stateMachine:changeState(BowserEnemyAtkState.new())
    player.stateMachine:changeState(DefendState.new())

    --show通用打击特效
    local effectManager = PoolFunc:pickSingleton("EffectGroup")
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_monster_hit")
    effectManager:addObject(effect)
    effect.name = "ef_monster_hit"
    effect.transform.parent = self.character.transform
    effect.transform.localPosition = UnityEngine.Vector3(0,0.5,1)
    effect.transform.localRotation = Quaternion.Euler(0,0,0)
    --effect.transform.localScale = UnityEngine.Vector3.one
end

--受到攻击
function BowserEnemy:defend(player)
    self.stateMachine:changeState(BowserEnemyDefState.new())
end

function BowserEnemy:CreateDynamicEnemy()
    --[[设置角色]]
    if self.gameObject.transform:Find(self.roleName) == nil then
        self.character = PoolFunc:pickObjByPrefabName("Monster/"..self.roleName)
        self.character.transform.parent=self.gameObject.transform
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
    self.collider.radius=0.3
    self.collider.height=1
end

function BowserEnemy:goActiveState()
    self.HP = 2
	self.stateMachine:changeState(BowserEnemyIdleState.new())
end
