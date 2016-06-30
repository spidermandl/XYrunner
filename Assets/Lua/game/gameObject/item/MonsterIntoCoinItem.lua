--[[
怪物变金币道具
author：赵名飞
]]

MonsterIntoCoinItem = class(BaseItem)
MonsterIntoCoinItem.player=nil
MonsterIntoCoinItem.effect = nil --特效
function MonsterIntoCoinItem:Awake()
	self.super.Awake(self)
end

function MonsterIntoCoinItem:initParam()
    if type(self.bundleParams) == "table" then
        local config = self.bundleParams
        local param = lua_string_split(config['param'],";")
        self.itemId = param[1]
        local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
        local modelName = txt:GetData(self.itemId,TxtFactory.S_MATERIAL_MODEL)
        local effectName = txt:GetData(self.itemId,TxtFactory.S_MATERIAL_EFFECT)
        self.effect = self.super.CreateEffect(self,effectName)
        self.item  = PoolFunc:pickObjByPrefabName("Items/"..modelName)
        self.item.transform.parent = self.gameObject.transform
        self.item.transform.localPosition = Vector3.zero
        --self.item.transform.localScale = UnityEngine.Vector3.one
        self.item.transform.localRotation = Quaternion.Euler(0,0,0)
    end
    if self.collider == nil then
        self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    end
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,bound.y,bound.z)
    self.super.initParam(self)
end


function MonsterIntoCoinItem:Update()
	if self.player == nil then
		self.player=LuaShell.getRole(LuaShell.DesmondID)
	end
end


function MonsterIntoCoinItem:OnTriggerEnter( gameObj )
	if gameObj.gameObject:GetInstanceID() ~= LuaShell.DesmondID  or self.player.stateMachine:getState()._name == "DeadState" then --与主角碰撞
		return
	end
    local effectManager = PoolFunc:pickSingleton("EffectGroup") --effect管理器
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_prop_goldcoinswave")
    effectManager:addObject(effect)
    effect.transform.parent = self.gameObject.transform.parent
    effect.transform.localPosition = self.gameObject.transform.localPosition
    PoolFunc:inactiveObj(self.gameObject)
        --移除特效
    if self.effect ~= nil then
        local effectManager = PoolFunc:pickSingleton("EffectGroup") --effect管理器
        effectManager:removeObject(self.effect)
    end
    --根据道具ID找skillID
    local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
    local skillId = txt:GetData(self.itemId,TxtFactory.S_MATERIAL_SKILL_ID)
    self.player:playSkill(skillId)
end