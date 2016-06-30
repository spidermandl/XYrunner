--FlightEnemyFlyState 飞行状态


FlightEnemyFlyState = class (BaseEnemyState)

FlightEnemyFlyState._name = "FlightEnemyFlyState"

function FlightEnemyFlyState:Enter(role)
    self.super.Enter(self,role)
    role.animator:Play("flight")
end

function FlightEnemyFlyState:Excute(role,dTime)
	role.gameObject.transform:Translate(Vector3.left*UnityEngine.Time.deltaTime*5) 
end