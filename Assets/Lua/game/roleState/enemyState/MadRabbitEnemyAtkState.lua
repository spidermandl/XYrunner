--[[
author:Huqiuxiang
疯兔攻击状态
]]
MadRabbitEnemyAtkState = class (BaseEnemyState)
MadRabbitEnemyAtkState._name = "MadRabbitEnemyAtkState"
MadRabbitEnemyAtkState.projectile = nil 
MadRabbitEnemyAtkState.animInfo = nil 
function MadRabbitEnemyAtkState:Enter(role)
	self.super.Enter(self,role)
	--self.animator:Play("attack")
	self.super.AtkStateEnter(self,role)
	
	 
end

function MadRabbitEnemyAtkState:Excute(role,dTime)
	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0) 
    if animInfo.normalizedTime >= 0.43  and animInfo.normalizedTime < 0.6 then --动画结束
		if self.projectile == nil then
			self.projectile = PoolFunc:pickObjByLuaName("ProjectileEnemy")

			self.projectile.transform.parent = role.gameObject.transform.parent
			self.projectile.transform.position = role.gameObject.transform.position
			--self.projectile.transform.localRotation = Quaternion.Euler(0,180,0)
			--self.projectile.transform.localScale = UnityEngine.Vector3(0.2,0.2,0.2)
			self.projectile.gameObject.name = "Carrot"

			self.projectile:SetActive(false)
			local sub = self.projectile:GetComponent(BundleLua.GetClassType())
		    if sub == nil then
		        sub = self.projectile:AddComponent(BundleLua.GetClassType())
		        sub.luaName = "ProjectileEnemy"
		    else
		    	self.projectile:initParam()
		    end
		    self.projectile:SetActive(true)
		end
    end
    if animInfo.normalizedTime >= 0.9 then
    	role.stateMachine:changeState(MadRabbitEnemyIdleState.new())
	end
end


--she konw exactly how to tell lie. before you play fires do think twice.