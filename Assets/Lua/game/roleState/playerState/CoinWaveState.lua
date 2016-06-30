--[[
   author:Huqiuxiang
   role金币冲击波状态
]]
CoinWaveState = class(BasePlayerState)
CoinWaveState._name = "CoinWaveState"
CoinWaveState.startTime = nil
CoinWaveState.effects = nil 
CoinWaveState.effectsTime = 1.5
CoinWaveState.CoinGroup = nil 
CoinWaveState.CoinGroupLua = nil 
CoinWaveState.r = 8 -- 冲击波攻击半径

function CoinWaveState:Enter(role)
    GamePrint("---------------------------function CoinWaveState:Enter(role)")
	self.startTime = UnityEngine.Time.time
	self.effects = newobject(Util.LoadPrefab("Effects/Common/ef_prop_goldcoinswave")) --创建特效
    self.effects.gameObject.transform.position = role.gameObject.transform.position

    self.CoinGroup = newobject(Util.LoadPrefab("Items/CoinGroupForCoinWave")) --创建组
    self.CoinGroup.transform.position = role.gameObject.transform.position
    self.CoinGroupLua = LuaShell.getRole(self.CoinGroup.gameObject:GetInstanceID())
    self.CoinGroupLua.itemType = "coin"
        local tab = UnityEngine.Physics.OverlapSphere(role.gameObject.transform.position,self.r)
       -- local c = System.Array.GetValue(tab,0)

       local length = tab.Length - 1 
       for i=0,length do
         local c = System.Array.GetValue(tab,i)
         local clua = LuaShell.getRole(c.gameObject:GetInstanceID())
         -- print("Tab..  "..i.." :"..tostring(c.gameObject.name).." Type : "..clua.type)
         if clua ~= nil and clua.type == "enemy" then
         	 local coin = newobject(Util.LoadPrefab("Items/coin"))
         	 coin.gameObject.transform.position = clua.gameObject.transform.position
             self.CoinGroupLua.coinGroupTable[i+1] = coin 
             coin.transform.parent = self.CoinGroup.transform
    		  local collider = coin.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    	      collider.isTrigger = false
    	      collider.center=UnityEngine.Vector3(0,coin.transform.localScale.y/2,0)
    	      collider.size=coin.transform.localScale

        	    --[[设置刚体]]
    		  local rigidBody = coin.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    		  rigidBody.useGravity = false
    		  rigidBody.isKinematic = false
    		  rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll

         	 LuaShell.OnDestroy(clua.gameObject:GetInstanceID()) --销毁对象
         end
       end
end

function CoinWaveState:Excute(role,dTime)
	if UnityEngine.Time.time - self.startTime >self.effectsTime then
		role.stateMachine:removeSharedState(self)
		return
	end
    self.effects.gameObject.transform.position = role.gameObject.transform.position
end

function CoinWaveState:Exit(role)
    if self.effects ~= nil then
		GameObject.Destroy(self.effects)
	end
end