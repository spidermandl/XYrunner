--[[
彩虹猫
作者：秦仕超
]]
RainbowCatMount=class(BaseMount)

RainbowCatMount.roleName = "RainbowCatMount"

function RainbowCatMount:Awake()
    -- self.rotation=UnityEngine.Vector3(0,0,0)
    -- self.position=UnityEngine.Vector3(8,5,0)
    -- self.super.Awake(self)
    -- self.stateMachine:changeState(AliThrowingBottlesState.new())
end

--启动事件--
function RainbowCatMount:Start()
	-- if LuaShell.getRole(LuaShell.DesmondID).property.PetMountName~=self.roleName then
	-- 	LuaShell.OnDestroy(self.gameObject:GetInstanceID())
	-- else
		self.super.Start(self)
	    self.stateMachine:changeState(RainbowCatMountState.new())
	-- end
end

function RainbowCatMount:FixedUpdate()
	self.super.FixedUpdate(self)
end
