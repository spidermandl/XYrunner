--[[
  author: huqiuxiang
  Projectile 投射物
]]

ProjectileEnemy = class (BaseEnemy)
ProjectileEnemy.roleName = "Projectile"
ProjectileEnemy.type = "Projectile"
ProjectileEnemy.speed = 0
function ProjectileEnemy:Awake()
    self.super.Awake(self)
   -- self.gameObject.transform.rotation = Quaternion.Euler(0,-90,0)
end

function ProjectileEnemy:initParam()
    
    self.super.initParam(self)
    self.role = LuaShell.getRole(LuaShell.DesmondID)
    if self.gameObject.name == "Fireball" then
        self.speed = ConfigParam.fireSpeed
    elseif self.gameObject.name == "Carrot" then
        self.speed = ConfigParam.carrotSpeed
    end
    
end
--启动事件--
function ProjectileEnemy:Start()
    
end
function ProjectileEnemy:Update()
    self.super.Update(self)
    --local rotate = UnityEngine.Time.deltaTime * self.speed
    self.gameObject.transform:Translate(Vector3.left * UnityEngine.Time.deltaTime * self.speed, Space.World)
end
function ProjectileEnemy:FixedUpdate()
    --self.super.FixedUpdate(self)
	--self.gameObject.transform:Translate(0,0,0.2 * self.speed)

end

function ProjectileEnemy:OnTriggerEnter( gameObj )
    self.super.OnTriggerEnter(self,gameObj)
end

--攻击
function ProjectileEnemy:attack(player)
    player.stateMachine:changeState(DefendState.new())
end

--受到攻击
function ProjectileEnemy:defend(player)
    player.stateMachine:changeState(DefendState.new())
end


function ProjectileEnemy:CreateDynamicEnemy()

        local PrefabName= ""
        if self.gameObject.name == "Fireball" then --醉酒鼠特效
            PrefabName = "Effects/Common/ef_monster_zuishu"
        elseif self.gameObject.name == "Carrot" then --疯狂兔子萝卜特效
            PrefabName = "Effects/Common/ef_monster_fengtu"
        end
        local effectManager = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
        local childObj = PoolFunc:pickObjByPrefabName(PrefabName)
        --enemyManager:addObject(childObj)
        childObj.gameObject.transform.parent=self.gameObject.transform
        childObj.gameObject.transform.localPosition = UnityEngine.Vector3(0,0,0)
        --childObj.gameObject.transform.localRotation = Quaternion.identity
        --childObj.gameObject.transform.localScale = UnityEngine.Vector3(1,1,1)
    self.collider = self.gameObject:GetComponent(UnityEngine.SphereCollider.GetClassType())
    if self.collider == nil then
        self.collider = self.gameObject:AddComponent(UnityEngine.SphereCollider.GetClassType())
        self.collider.isTrigger = true
        self.collider.center=UnityEngine.Vector3(0,0,0)
        self.collider.radius=0.5
    end
end

function ProjectileEnemy:goActiveState()
end
