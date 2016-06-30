--[[功能建筑类]]
FunctionBuilding  = class(BaseBuilding)

FunctionBuilding.type = "FunctionBuilding"
FunctionBuilding.buildType = "bag"--测试用的
function FunctionBuilding:Awake()
	-- self.gameObject.layer = UnityEngine.LayerMask.NameToLayer("FunctionBuild")
	self.super.Awake(self)
end

--启动事件--
function FunctionBuilding:Start()
    -- print("-----------------FunctionBuilding Start--->>>-----------------")

end

function FunctionBuilding:Update()

end

function FunctionBuilding:FixedUpdate()
	-- body
end



