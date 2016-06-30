--[[
author:Huqiuxiang 赵名飞
醉酒鼠攻击状态
]]
DrunkRatEnemyAtkState = class (BaseEnemyState)
DrunkRatEnemyAtkState._name = "DrunkRatEnemyAtkState"
DrunkRatEnemyAtkState.projectile = nil
MadRabbitEnemyAtkState.animInfo = nil
function DrunkRatEnemyAtkState:Enter(role)
	self.super.Enter(self,role)
	self.animator:Play("attack")
	self.animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
end

function DrunkRatEnemyAtkState:Excute(role,dTime)
	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	self.animator.speed = 2
    if animInfo.normalizedTime >= 0  and animInfo.normalizedTime < 1 then --动画结束
		if self.projectile == nil then
			self.projectile = PoolFunc:pickObjByLuaName("ProjectileEnemy")

			self.projectile.transform.parent = role.gameObject.transform.parent
			self.projectile.transform.position = role.gameObject.transform.position
			--self.projectile.transform.localRotation = Quaternion.identity
			--self.projectile.transform.localScale = UnityEngine.Vector3.one
			self.projectile.gameObject.name = "Fireball"

			self.projectile:SetActive(false)
			local sub = self.projectile:GetComponent(BundleLua.GetClassType())
		    if sub == nil then
		        sub = self.projectile:AddComponent(BundleLua.GetClassType())
		        sub.luaName = "ProjectileEnemy"
		    else
		    	local lua = LuaShell.getRole(self.projectile:GetInstanceID())
        		lua:initParam()
		    end
		    self.projectile:SetActive(true)
		    
		end
    end
    if animInfo.normalizedTime >= 0.9 then
    	role.stateMachine:changeState(DrunkRatEnemyIdleState.new())
	end
end
function DrunkRatEnemyAtkState:Exit()
	self.animator.speed = 1
end