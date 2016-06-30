--[[
    招财猫套装
    author:胡秋翔
]]

FortuneCatSuitState = class(BasePlayerState)
FortuneCatSuitState._name = "FortuneCatSuitState"
FortuneCatSuitState.startTime = nil
-- FortuneCatSuitState. = 1.5
FortuneCatSuitState.coinGroupObj = nil --金币组profeb
FortuneCatSuitState.coinGroupItem = nil 
FortuneCatSuitState.coinVspeed = 3 --金币向下
FortuneCatSuitState.coinHspeed = 2.5 -- 金币向左速度
FortuneCatSuitState.CoinRainStartTime = 0 
FortuneCatSuitState.CoinRainDelayTime = 0 --金币密度

function FortuneCatSuitState:Enter(role)
	  self.startTime = UnityEngine.Time.time
    self.CoinRainDelayTime = ConfigParam.CoinRainCount
end

function FortuneCatSuitState:Excute(role,dTime)
  	if UnityEngine.Time.time - self.startTime >ConfigParam.CoinRainTime then
    		role.stateMachine:removeSharedState(self)
    		return
  	end
    -- 批量延时段随机生成
    if self.CoinRainStartTime >= self.CoinRainDelayTime then 
        self:creatRain(role)
        self.CoinRainStartTime = 0
    end
    self.CoinRainStartTime = self.CoinRainStartTime + 1
end

function FortuneCatSuitState:Exit(role)
   destroy(self.coinGroupObj)
end

-- 金币雨item 创建
function FortuneCatSuitState:creatRain(role)
    local obj = PoolFunc:pickObjByLuaName("CoinRainGroup")
    obj.transform.position = role.gameObject.transform.position
    obj.transform:Translate(20,10,0, Space.World)
    obj:SetActive(false)
    local lua = obj:GetComponent(BundleLua.GetClassType())
    if lua == nil then
        lua = obj:AddComponent(BundleLua.GetClassType())
    else 
        -- local luaObj = LuaShell.getRole(obj.gameObject:GetInstanceID())
        -- luaObj:initParam()
    end
    local luaObj = LuaShell.getRole(obj.gameObject:GetInstanceID())
    print("luaObj"..tostring(luaObj))
    lua.luaName = "CoinRainGroup"
    obj:SetActive(true)
    local luaObjs = LuaShell.getRole(obj.gameObject:GetInstanceID())
    print("luaObjs"..tostring(luaObjs))
end
