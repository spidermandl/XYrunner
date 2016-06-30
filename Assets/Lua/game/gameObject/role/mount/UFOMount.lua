--[[
UFO
作者：秦仕超
]]

UFOMount=class(BaseMount)
UFOMount.roleName = "UFOMount"

function UFOMount:Awake()
    -- self.super.Awake(self)
end

--启动事件--
function UFOMount:Start()
		self.super.Start(self)
		self.stateMachine:changeState(UFOMountState.new())
end

function UFOMount:FixedUpdate()
		self.super.FixedUpdate(self)
end
