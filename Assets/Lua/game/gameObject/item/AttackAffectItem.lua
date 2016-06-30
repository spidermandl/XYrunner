--[[
攻击碰撞体
author:Desmond
]]
AttackAffectItem = class (BaseItem)
AttackAffectItem.type = "AttackAffectItem"


function AttackAffectItem:Awake()
	--print ("---------------function AttackAffectItem:Awake() ")
	self.super.Awake(self)
end

function AttackAffectItem:initParam()
	--print ("---------------function AttackAffectItem:initParam() ")
	self.super.initParam(self)
    if self.collider == nil then
        self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    end
    self.collider.isTrigger = true

    self.collider.center=UnityEngine.Vector3(0,0,0)
    self.collider.size=UnityEngine.Vector3(1,1,1)
end

function AttackAffectItem:OnTriggerEnter( gameObj ) 
end



