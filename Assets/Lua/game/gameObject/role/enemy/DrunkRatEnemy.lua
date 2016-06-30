--[[
  author: huqiuxiang 赵名飞
  醉酒鼠
]]
DrunkRatEnemy = class (BaseEnemy)
DrunkRatEnemy.roleName = "DrunkRat"
DrunkRatEnemy.HP = 1

function DrunkRatEnemy:Awake()
    --print("醉酒鼠 ------------ Awake")
    self.super.Awake(self)
end

--启动事件--
function DrunkRatEnemy:Start()
end

function DrunkRatEnemy:FixedUpdate()
    self.super.FixedUpdate(self)
    --self.super.fireRange(self,"Projectile_Fireball",1,ConfigParam.DrunkRatAttackDistance) --投射功能(最后一个参数穿的是投射物profeb名字)
end

function DrunkRatEnemy:Update()
    self.super.Update(self)
end

function DrunkRatEnemy:OnTriggerEnter( gameObj )
	self.super.OnTriggerEnter(self,gameObj)
end

--攻击
function DrunkRatEnemy:attack(player)
    --error("醉酒老鼠，攻击攻击")
    self.stateMachine:changeState(DrunkRatEnemyAtkState.new())
    player.stateMachine:changeState(DefendState.new())
end

--受到攻击
function DrunkRatEnemy:defend(player)
    self.stateMachine:changeState(DrunkRatEnemyDefState.new())
end

function DrunkRatEnemy:CreateDynamicEnemy()
	--[[设置角色]]
    if self.gameObject.transform:Find(self.roleName) == nil then
        self.character = PoolFunc:pickObjByPrefabName("Monster/"..self.roleName)
        self.character.transform.parent=self.gameObject.transform
        self.character.transform.localPosition = UnityEngine.Vector3(0,0,0)
         --重置模型的大小和旋转
        self.character.transform.localRotation = Quaternion.identity
        self.character.transform.localScale = UnityEngine.Vector3.one
    else
        self.character = self.gameObject.transform:Find(self.roleName).gameObject
    end
    --加入动画
    self.animator = self.character:GetComponent("Animator")
    --[[设置碰撞体]]
    self.collider = self.gameObject:GetComponent(UnityEngine.CapsuleCollider.GetClassType())
    if self.collider == nil then
        self.collider = self.gameObject:AddComponent(UnityEngine.CapsuleCollider.GetClassType())
        self.collider.isTrigger = true
        self.collider.center=UnityEngine.Vector3(0,0.5,0)
        self.collider.radius=0.3
        self.collider.height=1
    end
end

function DrunkRatEnemy:goActiveState()
    --error("DrunkRatEnemy:goActiveState")
    local idle = DrunkRatEnemyIdleState.new()
    idle.time = ConfigParam.DrunkRatAttackInterval
	self.stateMachine:changeState(idle)
end
