--[[
定春
作者：秦仕超
]]
SadaharuMount=class(BaseMount)

SadaharuMount.roleName = "SadaharuMount"


function SadaharuMount:Awake()
    -- self.rotation=UnityEngine.Vector3(0,0,0)
    -- self.position=UnityEngine.Vector3(8,5,0)
    -- self.super.Awake(self)
    -- self.stateMachine:changeState(AliThrowingBottlesState.new())
end

--启动事件--
function SadaharuMount:Start()
	-- if LuaShell.getRole(LuaShell.DesmondID).property.PetMountName~=self.roleName then
	-- 	LuaShell.OnDestroy(self.gameObject:GetInstanceID())
	-- else
		self.super.Start(self)
	    self.stateMachine:changeState(SadaharuMountState.new())
	-- end
end

function SadaharuMount:FixedUpdate()
	self.super.FixedUpdate(self)
end
