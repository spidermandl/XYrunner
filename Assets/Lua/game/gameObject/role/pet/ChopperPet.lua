--[[
  author:Desmond
  乔巴 解锁乔巴套装，同行可强化套装能力
]]
ChopperPet = class (BasePet)

ChopperPet.type = 'ChopperPet'

function ChopperPet:Awake()
	-- body
end

--启动事件--
function ChopperPet:Start()
	self.super.Start(self)
	
end

