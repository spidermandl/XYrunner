--[[
  author:Desmond
  动态敌人

]]
DynamicEnemy = class (BaseEnemy)
--DynamicEnemy.type ="DynamicEnemy"
DynamicEnemy.roleName = "blackcat"
DynamicEnemy.HP = 1
--攻击
function DynamicEnemy:attack(player)
    self.stateMachine:changeState(EnemyAtkState.new())
    player.stateMachine:changeState(DefendState.new())
        --show小黑特效
    local effectManager = PoolFunc:pickSingleton("EffectGroup")
    local effect = self.gameObject.transform:Find("ef_xiaohei_hit")
    if effect == nil then
        effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_xiaohei_hit")
        effectManager:addObject(effect)
    end
    effect.name = "ef_xiaohei_hit"
    effect.transform.parent = self.gameObject.transform
    effect.transform.localPosition = UnityEngine.Vector3(0,0.5,1)
    effect.transform.localRotation = Quaternion.Euler(0,0,0)
    -- show 掉钱特效 ef_player_goldcoins
    local goldEf = self.gameObject.transform:Find("ef_player_goldcoins")
    if goldEf == nil then
        goldEf = PoolFunc:pickObjByPrefabName("Effects/Common/ef_player_goldcoins")
        effectManager:addObject(goldEf)
    end
    goldEf.name = "ef_player_goldcoins"
    goldEf.transform.parent = self.gameObject.transform
    goldEf.transform.localPosition = UnityEngine.Vector3(0,0,1)
    goldEf.transform.localRotation = Quaternion.Euler(0,0,0)
end

--受到攻击
function DynamicEnemy:defend(player)
    self.stateMachine:changeState(EnemyDefState.new())
end


function DynamicEnemy:CreateDynamicEnemy()
    --print ("-----------------function DynamicEnemy:CreateDynamicEnemy() "..tostring(self.roleName))
    --[[设置角色]]
    if self.gameObject.transform:Find(self.roleName) == nil then
        --print ("-----------------function DynamicEnemy:CreateDynamicEnemy() 2 "..tostring(self.roleName))
        self.character = PoolFunc:pickObjByPrefabName("Monster/"..self.roleName)--newobject(Util.LoadPrefab("Monster/"..self.roleName))
        self.character.transform.parent=self.gameObject.transform
        self.character.transform.localPosition = UnityEngine.Vector3(0,0,0)
        --重置模型的大小和旋转
        self.character.transform.localRotation = Quaternion.identity
        self.character.transform.localScale = UnityEngine.Vector3.one

    else
        -- print("Enter 2")
        self.character = self.gameObject.transform:Find(self.roleName).gameObject
    end
    --加入动画
    self.animator = self.character:GetComponent("Animator")
    --print ("-------------------------function DynamicEnemy:CreateDynamicEnemy() "..tostring(self.animator))
    self.collider = self.gameObject:GetComponent(UnityEngine.CapsuleCollider.GetClassType())
    if self.collider == nil then
        --[[设置碰撞体]]
        self.collider = self.gameObject:AddComponent(UnityEngine.CapsuleCollider.GetClassType())
        self.collider.isTrigger = true
        self.collider.center=UnityEngine.Vector3(0,0.5,0)
        self.collider.radius=0.3
        self.collider.height=1
    end

end

function DynamicEnemy:goActiveState()
    self.stateMachine:changeState(EnemyIdleState.new())
end

