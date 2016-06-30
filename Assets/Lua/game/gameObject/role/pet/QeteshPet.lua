--[[
   author:Desmond
   奎特（冰河世纪）5%机率将金币变为松果，吃后可少量回复体力
]]
QeteshPet = class (BasePet)

QeteshPet.roleName = 'QeteshPet'

function QeteshPet:Awake()
	-- body
end

--启动事件--
function QeteshPet:Start()
	self.super.Start(self)
end


