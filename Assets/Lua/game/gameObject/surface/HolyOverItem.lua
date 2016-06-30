--[[
author:赵名飞
碰到该道具退出神圣模式
]]
HolyOverItem = class (BaseBehaviour)
HolyOverItem.roleName = "HolyOverItem"
HolyOverItem.collider = nil 

function HolyOverItem:Awake()
    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0,0)
    self.collider.size = Vector3(1,14,7)
    self.gameObject.transform.localScale = Vector3.one
    self.gameObject.transform.rotation = Quaternion.Euler(0,0,0)
    self:initParam()
end

--启动事件--
function HolyOverItem:Start()
end
--初始化参数配置
function HolyOverItem:initParam()
    self:CreateEffect()
end

function HolyOverItem:FixedUpdate()
end

function HolyOverItem:Update()
end
--创建特效
function HolyOverItem:CreateEffect()
    local effectManager = PoolFunc:pickSingleton("EffectGroup")
    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_chuansong_jin")
    effect.name = "ef_chuansong_jin"
    effect.transform.parent = self.gameObject.transform
    effect.transform.localPosition = Vector3(0,-3,0)
    effectManager:addObject(effect)

end


function HolyOverItem:OnTriggerEnter( gameObj )
	if gameObj.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --与主角碰撞
        return
    end
    local des = LuaShell.getRole(LuaShell.DesmondID) 
    local holyState = des.stateMachine:getSharedState("HolyState")
    if holyState ~= nil then
        des.stateMachine:removeSharedState(holyState) --退出神圣模式状态
    end
end