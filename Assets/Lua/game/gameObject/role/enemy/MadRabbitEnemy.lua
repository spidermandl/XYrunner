--[[
  author: huqiuxiang
  疯兔
]]
MadRabbitEnemy = class (BaseEnemy)
MadRabbitEnemy.roleName = "MadRabbit"
MadRabbitEnemy.HP = 1 

function MadRabbitEnemy:Awake()
    self.super.Awake(self)
end


--攻击
function MadRabbitEnemy:attack(player)
    self.stateMachine:changeState(MadRabbitEnemyAtkState.new())
    player.stateMachine:changeState(DefendState.new())
end

--受到攻击
function MadRabbitEnemy:defend(player)
    self.stateMachine:changeState(MadRabbitEnemyDefState.new())
end

function MadRabbitEnemy:CreateDynamicEnemy()
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

function MadRabbitEnemy:goActiveState()
    local idle = MadRabbitEnemyIdleState.new()
    idle.time = ConfigParam.MadRabbitAttackInterval
    self.stateMachine:changeState(idle)
end



