--[[
author:Desmond
所有怪物集合,怪物管理
]]

EnemyGroup = class (ObjectGroup)
EnemyGroup.name = "EnemyGroup"


function EnemyGroup:CleanEnemyByDistance(distance)
	if self.player == nil then
        self.player = LuaShell.getRole(LuaShell.DesmondID)
    end 
	for k , v in pairs(self.objGroup) do
		if v ~= nil and v.type == "enemy" 
			and (v.distance > 0 and v.distance < distance )
			and (v.stateMachine.currentState == nil or not(string.find(v.stateMachine.currentState._name,"DefState")))
			then
			v:defend(self.player)
			--血没扣完再defend 一次
			if v.HP > 1 then
				v:defend(self.player)
			end
		end
	end
end
function EnemyGroup:inactiveEnemyByDistance(distance)
	if self.player == nil then
        self.player = LuaShell.getRole(LuaShell.DesmondID)
    end 
	for k , v in pairs(self.objGroup) do
		if v ~= nil and v.type == "enemy" 
			and (v.distance > 0 and v.distance < distance )
			then
			v:inactiveSelf()
			return v
		end
	end
end
