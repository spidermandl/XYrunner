--[[
变色UFO坐骑状态
作者：秦仕超
]]
UFOMountColorState = class (BaseMountState) 
UFOMountColorState._name = "UFOMountColorState"
UFOMountColorState.ufoCoinDistance = 10

function UFOMountColorState:Enter(role)
	self.super.Enter(self,role)
	--磁铁效果 距离 存在时间 
    ConfigParam.CoinDistance = self.ufoCoinDistance
end

function UFOMountColorState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)
    self.character.stateMachine:addSharedState(MagnetState.new())
end

function UFOMountColorState:Exit(role)
	self.super.Exit(self,role)
end