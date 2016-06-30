--[[
大黄鸭
作者：秦仕超
]]
RhubarbDuckMount=class(BaseMount)

RhubarbDuckMount.roleName = "RhubarbDuckMount"
RhubarbDuckMount.type=PetType.props 	---0、坐骑；1、道具
RhubarbDuckMount.runPath=nil 			---运行路径
function RhubarbDuckMount:Awake()
	if self.bundleParams ~= nil and self.bundleParams.Length ~= 0 then 
    	self.type=self.bundleParams[1]
    	self.runPath=self.bundleParams[2]
    end
end

--启动事件--
function RhubarbDuckMount:Start()
	self.super.Start(self)
	local magnet = RhubarbDuckMountState.new()
    magnet.type = self.type
    magnet.runPath=self.runPath
    self.stateMachine:changeState(magnet)
end

function RhubarbDuckMount:FixedUpdate()
	self.super.FixedUpdate(self,UnityEngine.Time.fixedDeltaTime)
end
