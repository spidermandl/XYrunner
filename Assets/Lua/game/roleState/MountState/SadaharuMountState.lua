--[[
定春坐骑状态
作者：秦仕超
]]
SadaharuMountState = class (BaseMountState) 

SadaharuMountState._name = "SadaharuMountState"


function SadaharuMountState:Enter(role)
	self.super.Enter(self,role)
end

function SadaharuMountState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
end

function SadaharuMountState:Exit(role)
	self.super.Exit(self,role)
end