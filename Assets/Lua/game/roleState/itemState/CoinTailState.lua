--[[
author:Desmond
金币更随状态
]]
CoinTailState = class (IState)

CoinTailState._name = "CoinTailState"
CoinTailState.player = nil --角色
CoinTailState.animator = nil

function CoinTailState:Enter(role)
    --self.animator = role.item:GetComponent("Animator")
    --self.animator:Play("explode")

end

function CoinTailState:Excute(role,dTime)

	--LuaShell.OnDestroy(role.gameObject:GetInstanceID())
	--GameObject.Destroy(role.gameObject)
	if role ~= nil then
		local dy = self.player.gameObject.transform.position.y-role.gameObject.transform.position.y
		local dx = self.player.gameObject.transform.position.x-role.gameObject.transform.position.x

		local Vx = ConfigParam.CoinExplodeVelocity*dx/math.sqrt(dy*dy+dx*dx)
		local Vy = ConfigParam.CoinExplodeVelocity*dy/math.sqrt(dy*dy+dx*dx)

		role.gameObject.transform:Translate(Vx*dTime,Vy*dTime,0,Space.World)
	end

end