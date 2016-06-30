--[[
怪物变成金币
author:赵名飞
]]
MonsterIntoCoinState = class (BasePlayerState)
MonsterIntoCoinState._name = "MonsterIntoCoinState"
MonsterIntoCoinState.skillId = nil --技能ID
MonsterIntoCoinState.effectManager = nil --特效管理
MonsterIntoCoinState.ongoing_effect = nil --产生金币特效
MonsterIntoCoinState.prizeParent = nil --道具父级
MonsterIntoCoinState.CleanMonsterDistance = 0 --清怪距离
MonsterIntoCoinState.paramJson = nil --配置

function MonsterIntoCoinState:Enter(role)
	self.effectManager = PoolFunc:pickSingleton("EffectGroup")
    self.prizeParent = find("item")
    self.enemyManager = PoolFunc:pickSingleton("EnemyGroup")
    self.startTime = UnityEngine.Time.time
    local skillTxt = TxtFactory:getTable(TxtFactory.PetSkillMainTXT)
    local actionTxt = TxtFactory:getTable(TxtFactory.PetAnimTXT)
    self.CleanMonsterDistance = tonumber(skillTxt:GetData(self.skillId,TxtFactory.S_MAIN_SKILL_TARGET_SHAPE_PARA))
    self.paramJson =  skillTxt:GetData(self.skillId,TxtFactory.S_MAIN_SKILL_GAIN_VALUE)
    local action_id = skillTxt:GetData(self.skillId,TxtFactory.S_MAIN_SKILL_ACTION_ID)
    self.ongoing_effect = actionTxt:GetData(action_id,TxtFactory.S_PET_ANIM_ARISE_EFFECT)
    while(true) do
    	local monster = self.enemyManager:inactiveEnemyByDistance(self.CleanMonsterDistance)
    	if monster == nil then
			role.stateMachine:removeSharedState(self)
			return
		end
		self:CreatePrize(role,monster)
    end
end
--[[
function MonsterIntoCoinState:Excute(role,dTime)
	if UnityEngine.Time.time - self.startTime > self.duringTime then
		role.stateMachine:removeSharedState(self)
		return
	end
	local monster = self.enemyManager:inactiveEnemyByDistance(self.CleanMonsterDistance)
	self:CreatePrize(role,monster)
end
]]
--生成奖励
function MonsterIntoCoinState:CreatePrize(role,monster)
	if self.ongoing_effect ~= nil and self.ongoing_effect ~= "" then
		local coinEffect = PoolFunc:pickObjByPrefabName("Effects/Common/"..self.ongoing_effect)
	    coinEffect.transform.parent = monster.gameObject.transform.parent
	    coinEffect.transform.position = monster.gameObject.transform.position + Vector3(0,2,0)
	    self.effectManager:addObject(coinEffect)
	end

    local path = Util.DataPath..AppConst.luaRootPath.."game/export/"..self.paramJson
    local json = require "cjson"
    local util = require "3rd/cjson.util"
    local param = json.decode(util.file_load(path))

	local goinGroup = PoolFunc:pickObjByLuaName("CoinGroupForMidasTouch")
	goinGroup:SetActive(false)
	goinGroup.transform.parent = self.prizeParent.transform
	goinGroup.transform.position = monster.gameObject.transform.position
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

end

function MonsterIntoCoinState:Exit(role)
end