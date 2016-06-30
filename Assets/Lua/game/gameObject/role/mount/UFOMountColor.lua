
--[[
UFO 变色版
作者：秦仕超
]]
UFOMountColor=class(BaseMount)
UFOMountColor.roleName = "UFOMountColor"                      ----主角实例

function UFOMountColor:Awake()
end

--启动事件--
function UFOMountColor:Start()
	self.super.Start(self)
	self.stateMachine:changeState(UFOMountColorState.new())
	-- self.stateMachine:changeState(RhubarbDuckMountState.new())
end

function UFOMountColor:FixedUpdate()
	self.super.FixedUpdate(self)
end
