--[[
  author:Huqiuxiang
  可破坏的墙
]]
CrackWall = class (BaseItem)
CrackWall.type = "CrackWall"
CrackWall.playerSpeed = 0 

function CrackWall:Awake()
    if self.gameObject.transform:Find("CrackWall") == nil then
        self.item  = PoolFunc:pickObjByPrefabName("Items/CrackWall")
        self.item.transform.parent = self.gameObject.transform
        self.item.transform.position = self.gameObject.transform.position
        -- self.item.transform.localScale = self.gameObject.transform.localScale
    else
        self.item = self.gameObject.transform:Find("CrackWall")
        self.item.localPosition = UnityEngine.Vector3(0,0,0)
    end

    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = false

    self.collider.center=UnityEngine.Vector3(0,0,0)
    local bound = self.item.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,bound.y,bound.z)

        --[[设置刚体]]
    self.rigidBody = self.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    self.rigidBody.useGravity = false
    self.rigidBody.isKinematic = false
    self.rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll

    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self
end

--启动事件--
function CrackWall:Start()
end

function CrackWall:Update()
    self.super.Update(self)
end

function CrackWall:FixedUpdate()
end

function CrackWall:OnCollisionEnter( collision )
	if collision.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --与主角碰撞
  --       local collider = collision.gameObject:GetComponent("BoxCollider")
  --       collider.isTrigger = true
  --       -- self.objIsIn = 1
		return
	end

	if self.role.stateMachine:getState()._name == "SprintState" or self.role.stateMachine.sharedStates["ChangeBigState"] ~= nil then
      self.stateMachine:changeState(CrackWallIsDestroyState.new())  -- 破坏状态
  else
      self.stateMachine:changeState(CrackWallIstDestroyState.new())  -- 未被破坏状态
  end

end


function CrackWall:OnCollisionStay( collision )
end

function CrackWall:OnCollisionExit( collision )
    if collision.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --与主角碰撞
		    return
	  end
end