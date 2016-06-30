--[[
  author: huqiuxiang
  小帕
]]
SpiritPaEnemy = class (BaseEnemy)
SpiritPaEnemy.roleName = "SpiritPa"
SpiritPaEnemy.HP = 1 

function SpiritPaEnemy:Awake()
    self.super.Awake(self)
    self.gameObject.transform.rotation = Quaternion.Euler(0,-90,0)
end

--启动事件--
function SpiritPaEnemy:Start()
end

function SpiritPaEnemy:FixedUpdate()
    self.super.FixedUpdate(self)
end

function SpiritPaEnemy:Update()
    self.super.Update(self)
end

function SpiritPaEnemy:OnTriggerEnter( gameObj )
	self.super.OnTriggerEnter(self,gameObj)
end

--攻击
function SpiritPaEnemy:attack(player)
    self.stateMachine:changeState(SpiritPaEnemyAtkState.new())
    player.stateMachine:changeState(DefendState.new())

    
    local buff = CantAttackState.new()
    buff.hitForPa = 1
    buff.duringTime = ConfigParam.CantAttackTime
    player.stateMachine:addSharedState(buff)
    
end

--受到攻击
function SpiritPaEnemy:defend(player)
    self.stateMachine:changeState(SpiritPaEnemyDefState.new())
        -- + 短时间内无法攻击方法 ， 加一个小精灵跟随特效
end

function SpiritPaEnemy:CreateDynamicEnemy()
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
    
    self.collider = self.gameObject:GetComponent(UnityEngine.CapsuleCollider.GetClassType())
    if self.collider == nil then
        --[[设置碰撞体]]
        self.collider = self.gameObject:AddComponent(UnityEngine.CapsuleCollider.GetClassType())
        self.collider.isTrigger = true
        self.collider.center=UnityEngine.Vector3(0,0.5,0)
        self.collider.radius=0.3
        self.collider.height=1
    end
    local effectManager = PoolFunc:pickSingleton("EffectGroup")
    local effectG = PoolFunc:pickObjByPrefabName("Effects/Common/ef_monster_xiaopa")
    effectG.gameObject.transform.position = self.gameObject.transform.position
    effectG.gameObject.transform.parent = self.gameObject.transform
    effectManager:addObject(effectG,true)
    self.isCreated = 1
end

function SpiritPaEnemy:goActiveState()
	self.stateMachine:changeState(SpiritPaEnemyIdleState.new())
end
