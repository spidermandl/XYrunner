-- SpringEnemy 弹跳龟壳

SpringEnemy = class (BaseEnemy)
SpringEnemy.roleName = "SpringTortoise"
SpringEnemy.IsSpring = 0             --下降上升判断条件    
SpringEnemy.dropSpeed = 0           --弹射波动高度
SpringEnemy.movetoLeftSpeed = 0      --向左移动速度
SpringEnemy.HP = 1 
function SpringEnemy:Awake()
    self.super.Awake(self)
    self.gameObject.transform.rotation = Quaternion.Euler(0,-90,0)
    self.dropSpeed = ConfigParam.dropSpeed
    self.movetoLeftSpeed = ConfigParam.springtoLeftSpeed

end


--攻击
function SpringEnemy:attack(player)
    player.stateMachine:changeState(DefendState.new())
end

--受到攻击 （特例）
function SpringEnemy:defend(player)

    if player.type == "chinchillas" then --龙猫
        return
    end
    if player.stateMachine.sharedStates["ChangeBigState"] ~= nil or player.stateMachine.sharedStates["InvincibleState"] or player.stateMachine:getState()._name == "SprintState" then  -- 变大或无敌状态 才受击
           self.stateMachine:changeState(SpringEnemyDefState.new())
           return
    end
    player.stateMachine:changeState(DefendState.new())
        -- + 短时间内无法攻击方法 ， 加一个小精灵跟随特效
end


function SpringEnemy:CreateDynamicEnemy()
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
    self.collider = self.gameObject:GetComponent(UnityEngine.CapsuleCollider.GetClassType())
    if self.collider == nil then
        self.collider = self.gameObject:AddComponent(UnityEngine.CapsuleCollider.GetClassType())
        self.collider.isTrigger = true
        self.collider.center=UnityEngine.Vector3(0,0.5,0)
        self.collider.radius=0.5
        self.collider.height=1
    end
end


function SpringEnemy:goActiveState()
    self.stateMachine:changeState(SpringEnemyDropState.new())
end
