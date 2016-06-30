-- 攻击状态

FlightEnemyAtkState = class (IState)

FlightEnemyAtkState._name = "FlightEnemyAtkState"
FlightEnemyAtkState.animator = nil

function FlightEnemyAtkState:Enter(role)
	self.super.Enter(self,role)
    --self.animator:Play("attack")
    --print(" 飞行道具开始攻击！ ")
end

function FlightEnemyAtkState:Excute(role,dTime)

end