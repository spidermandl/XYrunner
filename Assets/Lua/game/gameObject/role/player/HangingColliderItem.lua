--[[
author:Desmond
碰撞检测item
]]
HangingColliderItem = class(BaseBehaviour)

HangingColliderItem.type = 'HangingColliderItem'
HangingColliderItem.player = nil --角色
HangingColliderItem.stateMachine = nil

function HangingColliderItem:Awake()
	GamePrint("-----------------HangingColliderItem Awake--->>>-----------------")
    self:initParam()

    local lua = self.gameObject:GetComponent(BundleLua.GetClassType()) --移除lua update
    lua.isUpdate = false

    self.collider = self.gameObject:AddComponent(UnityEngine.CapsuleCollider.GetClassType())
    self.collider.isTrigger = false
    self.collider.center = self.player.collider.center
    self.collider.radius = self.gameObject.transform.localScale.x/2
    self.collider.height = self.player.collider.height*3/4

    self.rigidBody = self.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    self.rigidBody.useGravity = false
    self.rigidBody.isKinematic = false
    self.rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll


	self.stateMachine = HangingStateMachine.new()
	self.stateMachine.role = self
	self.stateMachine:addSharedState(HangingCheckState.new())
	self.stateMachine:changeState(HangingNormalState.new())

end

function HangingColliderItem:Update()
	self.stateMachine:runState(UnityEngine.Time.deltaTime)
end

function HangingColliderItem:initParam()
	self.player = self.bundleParams
end


function HangingColliderItem:OnCollisionEnter( collision )
	local obj = LuaShell.getRole(collision.gameObject:GetInstanceID())
    if obj ~= nil then
    	if tostring(obj.type) == "HangingSurface"then
    		
    	end
    end

end

function HangingColliderItem:OnCollisionStay( collision )

end


function HangingColliderItem:OnCollisionExit( collision )
	local obj = LuaShell.getRole(collision.gameObject:GetInstanceID())
    if obj ~= nil then
    	if tostring(obj.type) == "HangingSurface"then
    		
    	end
    end

end

-- function HangingColliderItem:OnTriggerExit( gameObj )
--     --GamePrint ("---------------------other-->>>"..tostring(gameObj.gameObject:GetInstanceID()))
--     local obj = LuaShell.getRole(gameObj:GetInstanceID())
--     if obj ~= nil then
--         if tostring(obj.type) == "HangingSurface"then
--             GamePrint("--------------------function HangingColliderItem:OnTriggerExit( gameObj ) ")
--         end
--     end
-- end


