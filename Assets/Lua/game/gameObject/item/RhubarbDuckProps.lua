--[[
生成大黄鸭道具
author：Desmond
]]

RhubarbDuckProps = class(BaseItem)

RhubarbDuckProps.player=nil 				--------RhubarbDuckMount
RhubarbDuckProps.myMount=nil 				--------坐骑
RhubarbDuckProps.runPath=nil					--------运行路径
RhubarbDuckProps.itemID = nil --道具Id
RhubarbDuckProps.effect = nil --特效
function RhubarbDuckProps:Awake()
	self.super.Awake(self)
end

function RhubarbDuckProps:initParam()
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
        self.item.transform.localScale = UnityEngine.Vector3.one
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


function RhubarbDuckProps:Update()
	if self.player == nil then
		self.player=LuaShell.getRole(LuaShell.DesmondID)
	end
end


function RhubarbDuckProps:OnTriggerEnter( gameObj )
	-- print("-----------------function PetFollower:OnTriggerEnter( gameObj )--->>>-----------------")
	if gameObj.gameObject:GetInstanceID() ~= LuaShell.DesmondID  or self.player.stateMachine:getState()._name == "DeadState" then --与主角碰撞
		return
	end
    PoolFunc:inactiveObj(self.gameObject)
    --移除特效
    if self.effect ~= nil then
        local effectManager = PoolFunc:pickSingleton("EffectGroup") --effect管理器
        effectManager:removeObject(self.effect)
    end
    local state = self.player.stateMachine:getState()
    if state._name == "BouncingState" then
        iTween.Stop(self.player.gameObject)
        state.forceDisrupt = true --打开可以切换
    end
    --根据道具ID找skillID
    local txt = TxtFactory:getTable(TxtFactory.MaterialTXT)
    local skillId = txt:GetData(self.itemId,TxtFactory.S_MATERIAL_SKILL_ID)
    self.player:playSkill(skillId)
end