--[[
  author: huqiuxiang 赵名飞
  城管鸟
]]
ChasedBirdEnemy = class (BaseEnemy)
ChasedBirdEnemy.roleName = "ChasedBird"
ChasedBirdEnemy.HP = 1
ChasedBirdEnemy.dropSpeed = 20
ChasedBirdEnemy.isGo = false
ChasedBirdEnemy.BirdLeftSpeed = 5

function ChasedBirdEnemy:Awake()
    self.super.Awake(self)
end

--启动事件--
function ChasedBirdEnemy:Start()
end


function ChasedBirdEnemy:FixedUpdate()
    self.super.FixedUpdate(self)
end

function ChasedBirdEnemy:Update()
    self.super.Update(self)
end

function ChasedBirdEnemy:OnTriggerEnter( gameObj )
	if gameObj.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --与主角碰撞
        return
    end
    self.super.OnTriggerEnter(self,gameObj)
end
--攻击
function ChasedBirdEnemy:attack(player)
    iTween.Stop(self.gameObject)
    self.stateMachine:changeState(ChasedBirdEnemyAtkState.new())
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

--受到攻击
function ChasedBirdEnemy:defend(player)
    iTween.Stop(self.gameObject)
    self.stateMachine:changeState(ChasedBirdEnemyDefState.new())
end

function ChasedBirdEnemy:CreateDynamicEnemy()
	--[[设置角色]]
    if self.gameObject.transform:Find(self.roleName) == nil then
        self.character  = newobject(Util.LoadPrefab("Monster/"..self.roleName))
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
    self.collider.center=UnityEngine.Vector3(0,1,0)
    self.collider.radius=1
    self.collider.height=1.8
end
function ChasedBirdEnemy:playPathAnim()
    self.super.playPathAnim(self)
end

function ChasedBirdEnemy:goActiveState()
     self.stateMachine:changeState(ChasedBirdEnemyIdleState.new())
end

