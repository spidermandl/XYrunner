--[[
  author: huqiuxiang 赵名飞
  相扑青蛙
]]
SumoFrogEnemy = class (BaseEnemy)
SumoFrogEnemy.roleName = "SumoFrog"
SumoFrogEnemy.HP = 2 
SumoFrogEnemy.isDead = 0

function SumoFrogEnemy:Awake()
    self.super.Awake(self)
     
end

--启动事件--
function SumoFrogEnemy:Start()
end

function SumoFrogEnemy:FixedUpdate()
    self.super.FixedUpdate(self)
end

function SumoFrogEnemy:Update()
    self.super.Update(self)
end

function SumoFrogEnemy:OnTriggerEnter( gameObj )

    self.super.OnTriggerEnter(self,gameObj)
end

--攻击
function SumoFrogEnemy:attack(player)
    self.stateMachine:changeState(SumoFrogEnemyAtkState.new())
    player.stateMachine:changeState(DefendState.new())

        --show通用打击特效
    local effectManager = PoolFunc:pickSingleton("EffectGroup")
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_monster_hit")
    effectManager:addObject(effect)
    effect.name = "ef_monster_hit"
    effect.transform.parent = self.character.transform
    effect.transform.localPosition = UnityEngine.Vector3(0,0.5,1)
end

--受到攻击
function SumoFrogEnemy:defend(player)
    self.stateMachine:changeState(SumoFrogEnemyDefState.new())
        -- + 短时间内无法攻击方法 ， 加一个小精灵跟随特效
end

function SumoFrogEnemy:CreateDynamicEnemy()
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
    self.collider.radius=0.72
    self.collider.height=1

    self.isCreated = 1
end

function SumoFrogEnemy:goActiveState()
    self.HP = 2
	self.stateMachine:changeState(SumoFrogEnemyIdleState.new())
end
