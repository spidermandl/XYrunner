-- --[[草泥马
-- 作者：秦仕超
-- ]]

-- GMHorseMount=class(BaseMount)

-- GMHorseMount.roleName = "GMHorseMount"
-- GMHorseMount.player=nil 				---------主角实例
-- GMHorseMount.type=0 		---------0、草泥马；1、变色草泥马
-- function GMHorseMount:Awake()

-- end

-- --启动事件--
-- function GMHorseMount:Start()
-- 	self.super.Start(self)
-- 	self.player = LuaShell.getRole(LuaShell.DesmondID)
-- 	local magnet = GMHorseMountState.new()
-- 	magnet.player=self.player
-- 	if self.type==PetType.Discoloration then
--     	magnet.isColor = true
-- 	end
--     self.stateMachine:changeState(magnet)
-- end

-- function GMHorseMount:FixedUpdate()
-- 	self.super.FixedUpdate(self)
-- end
