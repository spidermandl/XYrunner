--[[
   author:赵名飞
   主角全程磁铁状态
]]

ThroughoutMagentState = class(BasePlayerState)
ThroughoutMagentState._name = "ThroughoutMagentState"
ThroughoutMagentState.distance = 0 --范围
function ThroughoutMagentState:Enter(role)
	GamePrint("--------------------function ThroughoutMagentState:Enter ")
		local effectGroup = PoolFunc:pickSingleton("EffectGroup") --获取特效管理器
	    local effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_prop_xitieshi")--创建特效
	    effect.transform.parent = role.gameObject.transform.parent
	    effect.transform.localPosition = role.gameObject.transform.localPosition
	    effectGroup:addObject(effect,true)
end

function ThroughoutMagentState:Excute(role,dTime)
end

function ThroughoutMagentState:Exit(role)
end
