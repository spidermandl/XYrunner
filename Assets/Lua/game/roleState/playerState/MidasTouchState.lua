--[[
跳跃产生金币
author:赵名飞
]]
MidasTouchState = class (BasePlayerState)
MidasTouchState._name = "MidasTouchState"
MidasTouchState.effectManager = nil --特效管理
MidasTouchState.effect = nil --特效
MidasTouchState.ongoing_times = nil --持续次数
MidasTouchState.CD_time = nil	--CD时间
MidasTouchState.ongoing_effect = nil --产生金币特效
MidasTouchState.end_effect = nil --头顶特效
MidasTouchState.prizeParent = nil --
MidasTouchState.jumpScore = nil --跳跃加分
function MidasTouchState:Enter(role)
	self.effectManager = PoolFunc:pickSingleton("EffectGroup")
    self.effect = PoolFunc:pickObjByPrefabName("Effects/Common/"..self.end_effect)
    self.effect.transform.parent = role.gameObject.transform
    self.effect.transform.position = role.gameObject.transform.position + Vector3(0,0,0)
    self.effectManager:addObject(self.effect,true)
    self.prizeParent = find("item")
end

function MidasTouchState:Excute(role,dTime)
end
--生成奖励
function MidasTouchState:CreatePrize(role)
	
	self.ongoing_times = self.ongoing_times - 1
	role:absortItem(self.jumpScore)
	local coinEffect = PoolFunc:pickObjByPrefabName("Effects/Common/"..self.ongoing_effect)
    coinEffect.transform.parent = role.gameObject.transform.parent
    coinEffect.transform.position = role.gameObject.transform.position
    self.effectManager:addObject(coinEffect)

    local path = Util.DataPath..AppConst.luaRootPath.."game/export/coinGroup.json"
    local json = require "cjson"
    local util = require "3rd/cjson.util"
    local param = json.decode(util.file_load(path))

	local goinGroup = PoolFunc:pickObjByLuaName("CoinGroupForMidasTouch")
	goinGroup:SetActive(false)
	goinGroup.transform.parent = self.prizeParent.transform
	goinGroup.transform.position = role.gameObject.transform.position + Vector3(10,0,0)
	local sub = goinGroup:GetComponent(BundleLua.GetClassType())
	if sub == nil then
		sub = goinGroup:AddComponent(BundleLua.GetClassType())
		sub.luaName = "CoinGroupForMidasTouch"
		LuaShell.setPreParams(goinGroup:GetInstanceID(),param)--预置构造参数
	else
		local lua = LuaShell.getRole(goinGroup:GetInstanceID())
        lua.bundleParams = param
        lua:initParam()
	end
	goinGroup:SetActive(true)

	if self.ongoing_times <= 0 then
		role.stateMachine:removeSharedState(self)
		return
	end
end

function MidasTouchState:Exit(role)
	self.effectManager:removeObject(self.effect)
	GetCurrentSceneUI().uiCtrl:SetSkillCDTime(self.CD_time) 	--记录CD时间
	role.stateMachine:removeSharedStateByName("PlayingSkillState")
end