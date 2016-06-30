--[[
author:Desmond
独眼怪 没有表现
1%机率将金币变为电力(新收集物)，吃后可补充1个电球（参考皮卡丘效果）
]]
MonoEyedPet = class (BasePet)

MonoEyedPet.type = 'MonoEyedPet'

function MonoEyedPet:Awake()
	-- body
end

--启动事件--
function MonoEyedPet:Start()
	self.super.Start(self)
	self.role.stateMachine:addSharedState(CoinChangeFromPetState.new())
	self.role.stateMachine:addSharedState(ElectricBallState.new())
	
end

function MonoEyedPet:Update()

end

function MonoEyedPet:FixedUpdate()

end