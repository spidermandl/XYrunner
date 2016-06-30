--[[
	author: 赵名飞
	普通城管鸟
]]
NormalBirdEnemy = class (BaseEnemy)
NormalBirdEnemy.roleName = "ChasedBird"
NormalBirdEnemy.HP = 1

function NormalBirdEnemy:Awake()
    self.super.Awake(self)
end

function NormalBirdEnemy:FixedUpdate()
    self.super.FixedUpdate(self)
end

function NormalBirdEnemy:Update()
    self.super.Update(self)
end

function NormalBirdEnemy:OnTriggerEnter( gameObj )
	self.super.OnTriggerEnter(self,gameObj)
end
--攻击
function NormalBirdEnemy:attack(player)
    iTween.Stop(self.gameObject)
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
function NormalBirdEnemy:defend(player)
    iTween.Stop(self.gameObject)
    self.stateMachine:changeState(NormalBirdEnemyDefState.new())
end


function NormalBirdEnemy:CreateDynamicEnemy()
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
    self.collider.radius=0.2
    self.collider.height=0.8
    self.isCreated = 1 --已创建敌人
end

function NormalBirdEnemy:goActiveState()
    self.stateMachine:changeState(NormalBirdEnemyIdleState.new())
end