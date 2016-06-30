--[[
物体跟随状态
作者：秦仕超
]]

ItemFlowState=class(IState)

ItemFlowState.StartTime=nil 						--------开始时间

ItemFlowState.player=nil 							--------主角
ItemFlowState.StartPosition=nil 					--------开始位置
function ItemFlowState:Enter(role)
	self.player=LuaShell.getRole(LuaShell.DesmondID)
	self.StartTime=UnityEngine.Time.time
	self.StartPosition=role.gameObject.transform.position
end

function ItemFlowState:Excute(role,dTime)
	role.gameObject.transform.position=Vector3.Lerp(self.StartPosition
		,self.player.gameObject.transform.position,(UnityEngine.Time.time-self.StartTime)*3)
end

function ItemFlowState:Exit(role)
	self.super.Exit(self,role)
end