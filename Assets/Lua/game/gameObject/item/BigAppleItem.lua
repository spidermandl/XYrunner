--[[
  author:Huqiuxiang
  松鼠大作战道具大苹果
]]
BigAppleItem = class (BaseItem)
BigAppleItem.type = "BigApple"
BigAppleItem.playerSpeed = 0 

function BigAppleItem:Awake()
	-- print("-----------------StaminaBottle Awake--->>>-----------------")
    if self.gameObject.transform:Find("BigApple") == nil then
        self.item  = PoolFunc:pickObjByPrefabName("Items/BigApple")
        self.item.transform.parent = self.gameObject.transform
        self.item.transform.position = self.gameObject.transform.position
        -- self.item.transform.localScale = self.gameObject.transform.localScale
    else
        self.item = self.gameObject.transform:Find("BigApple")
        self.item.localPosition = UnityEngine.Vector3(0,0,0)
    end

    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = true

    -- self.collider.center=UnityEngine.Vector3(0,0,0)
    -- local bound = self.item.transform.localScale
    -- self.collider.size=UnityEngine.Vector3(bound.x,bound.y,bound.z)

        --[[设置刚体]]
    self.rigidBody = self.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    self.rigidBody.useGravity = false
    self.rigidBody.isKinematic = false
    self.rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll

    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self
end

--启动事件--
function BigAppleItem:Start()
end

function BigAppleItem:Update()
    self.super.Update(self)
end


function BigAppleItem:OnCollisionEnter( collision )
    if collision.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --与主角碰撞
    --       local collider = collision.gameObject:GetComponent("BoxCollider")
    --       collider.isTrigger = true
    --       -- self.objIsIn = 1
    	 return
    end

    if self.role.stateMachine:getState()._name == "SprintState" or self.role.stateMachine.sharedStates["ChangeBigState"] ~= nil then
        self.stateMachine:changeState(BigAppleItemIsDestroyState.new())  -- 大苹果被破坏状态
    else
        self.stateMachine:changeState(BigAppleItemIstDestroyState.new())   --  大苹果未被破坏状态
    end

end


function BigAppleItem:OnCollisionStay( collision )
    --print("-----------------FlatSurface OnCollisionStay--->>>-----------------")
end

function BigAppleItem:OnCollisionExit( collision )
	-- print ("-------------------------------------->>>>>> function FlatSurface:OnCollisionExit( collision ) "..collision.gameObject.name)
    if collision.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --与主角碰撞
		    return
	 end
end