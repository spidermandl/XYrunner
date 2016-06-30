--[[
  author: huqiuxiang 赵名飞
  小水滴
]]
LittleDropEnemy = class (BaseEnemy)
LittleDropEnemy.roleName = "LittleDrop"
LittleDropEnemy.HP = 1

function LittleDropEnemy:Awake()
    self.super.Awake(self)
end

--启动事件--
function LittleDropEnemy:Start()
	self:setSkin() --根据场景换肤
end


function LittleDropEnemy:FixedUpdate()
    self.super.FixedUpdate(self)
end

function LittleDropEnemy:Update()
    self.super.Update(self)
end

function LittleDropEnemy:OnTriggerEnter( gameObj )
	self.super.OnTriggerEnter(self,gameObj)
end

--攻击
function LittleDropEnemy:attack(player)
    self.stateMachine:changeState(LittleDropEnemyAtkState.new())
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
function LittleDropEnemy:defend(player)
    self.stateMachine:changeState(LittleDropEnemyDefState.new())
end


function LittleDropEnemy:CreateDynamicEnemy()
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
    self.collider.center=UnityEngine.Vector3(0,0.8,0)
    self.collider.radius=0.9
    self.collider.height=1.8
    self.isCreated = 1 --已创建敌人
end

function LittleDropEnemy:goActiveState()
    self.stateMachine:changeState(LittleDropEnemyIdleState.new())
end

-- 小水滴根据场景改变贴图方法
function LittleDropEnemy:setSkin()
end