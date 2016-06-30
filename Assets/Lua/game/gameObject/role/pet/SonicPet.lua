--[[
   author:Desmond
   索尼克萌宠，没有表现
]]
SonicPet = class(BasePet)
SonicPet.roleName = 'SonicPet'

function SonicPet:Awake()
	-- body
end

--启动事件--
function SonicPet:Start()
	self.super.Start(self)
	self.role.stateMachine:addSharedState(CoinChangeFromPetState.new())
end


