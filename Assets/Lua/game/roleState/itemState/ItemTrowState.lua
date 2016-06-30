ItemTrowState=class(IState)

ItemTrowState.isFinish=false 					--------是否已经完成操作
ItemTrowState.StartTime=nil 					--------开始时间
-- ItemTrowState.Endposition=nil 					--------停止的位置
ItemTrowState.previousState = nil				--------物体之前的状态
function ItemTrowState:Enter(role)
	self.player=LuaShell.getRole(LuaShell.DesmondID)
	self.StartTime=UnityEngine.Time.time
	self.StartPosition=role.gameObject.transform.position
	self.previousState = role.stateMachine:getPreState()
end

function ItemTrowState:Excute(role,dTime)
	if self.isFinish then
		return
	end
	local detime=(UnityEngine.Time.time-self.StartTime)*2
	if detime<1 then
		role.gameObject.transform.localPosition=Vector3.Lerp(Vector3.zero
		,role.Endposition,detime)--+Vector3(0,(UnityEngine.Mathf.Sin(180*detime))*4,0) 
		+Vector3.Lerp(Vector3(0,0,0),Vector3(0,9,0),detime<0.5 and detime or 1-detime)
	else
		role.stateMachine:changeState(self.previousState)
		self.isFinish=true
	end
end

function ItemTrowState:Exit(role)
	self.super.Exit(self,role)
end
