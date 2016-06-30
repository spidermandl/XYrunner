--[[
彩虹猫坐骑状态
作者：秦仕超
]]
RainbowCatMountState = class (BaseMountState) 

RainbowCatMountState._name = "RainbowCatMountState"
RainbowCatMountState.IsSpeed=nil 						--是否加速

function RainbowCatMountState:Enter(role)
	self.super.Enter(self,role)
	self.player=LuaShell.getRole(LuaShell.DesmondID)
	self.player.property.moveDir.x= self.player.moveSpeedVect * PetStaticTable.RhubarbDuckMountState
	
	self.IsSpeed=true
end

function RainbowCatMountState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
	if self.IsSpeed then
		self.player.property.moveDir.x= self.player.moveSpeedVect * PetStaticTable.RhubarbDuckMountState
	end
end

function RainbowCatMountState:Exit(role)
	self.super.Exit(self,role)
end