--[[
  author: huqiuxiang
  飞行敌人
]]
FlightEnemy = class (BaseEnemy)
FlightEnemy.roleName = "flightTortoise"
FlightEnemy.HP = 1

function FlightEnemy:Awake()
    self.super.Awake(self)
end

--攻击
function FlightEnemy:attack(player)
    -- self.stateMachine:changeState(FlightEnemyAtkState.new())
    player.stateMachine:changeState(DefendState.new())
        --show通用打击特效
    local effectManager = PoolFunc:pickSingleton("EffectGroup")
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_monster_hit")
    effectManager:addObject(effect)
    effect.name = "ef_monster_hit"
    effect.transform.parent = self.character.transform
    effect.transform.localPosition = UnityEngine.Vector3(0,0.5,1)
    effect.transform.localRotation = Quaternion.Euler(0,0,0)
end

--受到攻击 （特例）
function FlightEnemy:defend(player)
    if player.stateMachine.sharedStates["ChangeBigState"] ~= nil or 
       player.stateMachine.sharedStates["InvincibleState"] ~=nil or 
       player.stateMachine:getState()._name == "SprintState" or
       player.stateMachine.sharedStates["CleanMonsterState"] ~=nil 
       then  -- 变大或无敌状态 才受击
          iTween.Stop(self.gameObject)
           self.stateMachine:changeState(FlightEnemyDefState.new())
           return
    end
    player.stateMachine:changeState(DefendState.new())
end

function FlightEnemy:CreateDynamicEnemy()
   --print("创建飞行怪")
    --[[设置角色]]
    if self.gameObject.transform:Find(self.roleName) == nil then
        self.character = PoolFunc:pickObjByPrefabName("Monster/"..self.roleName)
        self.character.transform.parent=self.gameObject.transform
        self.character.transform.localPosition = UnityEngine.Vector3(0,0,0)
         --重置模型的大小和旋转
        self.character.transform.localRotation = Quaternion.identity
        self.character.transform.localScale = UnityEngine.Vector3.one
        self.character.name = self.roleName
    else
        self.character = self.gameObject.transform:Find(self.roleName)
    end
    --加入动画
    self.animator = self.character:GetComponent("Animator")
    
     --[[设置碰撞体]]
    self.collider = self.gameObject:GetComponent(UnityEngine.CapsuleCollider.GetClassType())
    if self.collider == nil then
       
        self.collider = self.gameObject:AddComponent(UnityEngine.CapsuleCollider.GetClassType())
        self.collider.isTrigger = true
        self.collider.center=UnityEngine.Vector3(0,0.5,0)
        self.collider.radius=0.5
        self.collider.height=1
    end
    self.isCreated = 1 --已创建敌人
end

function FlightEnemy:goActiveState()
    --self.stateMachine:changeState(FlightEnemyFlyState.new())
end
