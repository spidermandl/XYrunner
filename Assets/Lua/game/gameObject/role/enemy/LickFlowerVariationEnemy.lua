--[[
  author: huqiuxiang
  舔人花变异
]]
LickFlowerVariationEnemy = class (BaseEnemy)
LickFlowerVariationEnemy.roleName = "LickFlowerVariation"

function LickFlowerVariationEnemy:Awake()
    self.super.Awake(self)
    self.gameObject.transform.rotation = Quaternion.Euler(0,-90,0)
end

--启动事件--
function LickFlowerVariationEnemy:Start()
end


function LickFlowerVariationEnemy:FixedUpdate()
    self.super.FixedUpdate(self)
end

function LickFlowerVariationEnemy:Update()
    self.super.Update(self)
end

function LickFlowerVariationEnemy:OnTriggerEnter( gameObj )
	self.super.OnTriggerEnter(self,gameObj)
end

--攻击
function LickFlowerVariationEnemy:attack(player)
    self.stateMachine:changeState(LickFlowerVariationEnemyAtkState.new())
    player.stateMachine:changeState(DefendState.new())
end

--受到攻击
function LickFlowerVariationEnemy:defend(player)
    self.stateMachine:changeState(LickFlowerEnemyDefState.new())
end


function LickFlowerVariationEnemy:CreateDynamicEnemy()
	--[[设置角色]]
    if self.gameObject.transform:Find(self.roleName) == nil then
        self.character  = --newobject(ioo.LoadPrefab("Monster/"..self.roleName))
        newobject(Util.LoadPrefab("Monster/"..self.roleName))
        self.character.transform.parent=self.gameObject.transform
        self.character.transform.localPosition = UnityEngine.Vector3(0,0,0)
    else
        self.character = self.gameObject.transform:Find(self.roleName)
    end
    --[[设置碰撞体]]
    self.collider = self.gameObject:AddComponent(UnityEngine.CapsuleCollider.GetClassType())
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0.8,0)
    self.collider.radius=0.5
    self.collider.height=1.8

    self.isCreated = 1
end

function LickFlowerVariationEnemy:goActiveState()
	 self.stateMachine:changeState(LickFlowerEnemyIdleState.new())
end


