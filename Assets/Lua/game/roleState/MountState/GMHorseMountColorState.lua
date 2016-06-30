--[[
草泥马坐骑状态
作者：秦仕超

]]
GMHorseMountColorState = class (GMHorseMountState) 

GMHorseMountColorState._name = "GMHorseMountColorState"
-- GMHorseMountColorState.PositionOffsetEnd1=nil
-- GMHorseMountColorState.PositionOffsetEnd2=nil
function GMHorseMountColorState:Enter(role)
	-- self.PositionOffsetStart=Vector3(3,0,0)
	-- self.PositionOffsetEnd=Vector3(7,0,0)
	-- self.PositionOffsetEnd1=Vector3(9,0,0)
	-- self.PositionOffsetEnd2=Vector3(11,0,0)

	self:CreateNotes(role,PetStaticTable.PositionOffsetEnd,PetStaticTable.PositionOffsetEnd1,PetStaticTable.PositionOffsetEnd2)
	-- self.super.Enter(self,role)
end

function GMHorseMountColorState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
end

function GMHorseMountColorState:Exit(role)
	self.super.Exit(self,role)
end