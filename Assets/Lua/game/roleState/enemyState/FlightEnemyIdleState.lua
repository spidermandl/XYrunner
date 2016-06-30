--飞行道具待机状态


FlightEnemyIdleState = class (BaseEnemyState)

FlightEnemyIdleState._name = "FlightEnemyIdleState"

function FlightEnemyIdleState:Enter(role)
	self.super.Enter(self,role)
	self.super.IdlStateEnter(self,role)
end

function FlightEnemyIdleState:Excute(role,dTime)


end