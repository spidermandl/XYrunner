--NinjaEnemy.lua
--[[
  author:  赵名飞
  忍者
]]
NinjaEnemy = class (BaseEnemy)
NinjaEnemy.roleName1 = "NinjaPig" --猪
NinjaEnemy.roleName2 = "NinjaBeauty" --美女
NinjaEnemy.roleName = nil
NinjaEnemy.hidedModel = nil --隐藏的模型
NinjaEnemy.modelType = -1 -- 模式切换 0 为忍者模式 1 为美女模式
NinjaEnemy.HP = 1
function NinjaEnemy:Awake()
    self.super.Awake(self)
end

--启动事件--
function NinjaEnemy:Start()
end

function NinjaEnemy:FixedUpdate()
    self.super.FixedUpdate(self)  
end

function NinjaEnemy:Update()
    self.super.Update(self)  
end

function NinjaEnemy:OnTriggerEnter( gameObj )
	self.super.OnTriggerEnter(self,gameObj)
end

--攻击
function NinjaEnemy:attack(player)
    if self.modelType == 0 then 
         self.stateMachine:changeState(NinjaPigEnemyAtkState.new())  --猪攻击
         player.stateMachine:changeState(DefendState.new())
    else  --美女模式
         self.stateMachine:changeState(NinjaBeautyEnemyAtkState.new())  --美女攻击
         player.stateMachine:changeState(DefendState.new())
    end 
        --show通用打击特效
    local effectManager = PoolFunc:pickSingleton("EffectGroup")
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_monster_hit")
    effectManager:addObject(effect)
    effect.name = "ef_monster_hit"
    effect.transform.parent = self.character.transform
    effect.transform.localPosition = UnityEngine.Vector3(0,0.5,1)
end

--受到攻击
function NinjaEnemy:defend(player)
    if self.modelType == 0 then --忍者模式
         self.stateMachine:changeState(NinjaPigEnemyDefState.new())  --忍者猪受击
    else  --美女模式
    	self.stateMachine:changeState(NinjaBeautyEnemyAtkState.new())  --美女攻击
        player.stateMachine:changeState(DefendState.new())  --自己受击
    end
end

function NinjaEnemy:CreateDynamicEnemy()
	--[[设置角色]]
    self:changeEnemy(0) --默认猪状态
    --[[设置碰撞体]]
    self.collider = self.gameObject:AddComponent(UnityEngine.CapsuleCollider.GetClassType())
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0.5,0)
    self.collider.radius=0.3
    self.collider.height=1
    self.isCreated = 1 --已创建敌人
end

function NinjaEnemy:goActiveState()
end

-- 创建模型 0 猪 1 美女
function NinjaEnemy:changeEnemy(modelType)

	if modelType == self.modelType then
		return
	end
	self.modelType = modelType
	if self.hidedModel ~= nil then	--如果存在 隐藏的模型，隐藏character，显示 存放的隐藏模型 
		self.character:SetActive(false)
		self.hidedModel:SetActive(true)
		self.hidedModel,self.character = self.character,self.hidedModel --交换两个值
		--重新获取动画
    	self.animator = self.character:GetComponent("Animator")
	else --不存在隐藏模型时说明只创建过一个模型，需创建另一个模型
		if self.character ~= nil then
			self.character:SetActive(false)
		end
		self.hidedModel = self.character
        self.roleName = (modelType == 0 and self.roleName1 or self.roleName2)
		self.character = PoolFunc:pickObjByPrefabName("Monster/"..self.roleName)
		self.character.transform.parent = self.gameObject.transform
		self.character.transform.localPosition = UnityEngine.Vector3(0,0,0)
         --重置模型的大小和旋转
        self.character.transform.localRotation = Quaternion.identity
        self.character.transform.localScale = UnityEngine.Vector3.one
		--重新获取动画
    	self.animator = self.character:GetComponent("Animator")
	end 
	self:changeState(modelType)

	--show特效
	local effectManager = PoolFunc:pickSingleton("EffectGroup")
	local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_single_jump")
	effectManager:addObject(effect)
	effect.transform.parent = self.character.transform
	effect.transform.localPosition = self.character.transform.localPosition
    effect.transform.localScale = self.character.transform.localScale
end
--改变状态
function NinjaEnemy:changeState(modelType)
	if modelType == 0 then --猪待机
		local state = NinjaPigEnemyIdleState.new()
		state.time = 0
		self.stateMachine:changeState(state)
    else --美女待机状态
    	local state = NinjaBeautyEnemyIdleState.new()
    	state.time = 0
    	self.stateMachine:changeState(state)
	end
end
