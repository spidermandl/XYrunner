--[[
检测战斗道具状态
author:赵名飞
]]
CheckBattleItemState = class (BasePlayerState)
CheckBattleItemState._name = "CheckBattleItemState"
CheckBattleItemState.itemSkillTable = nil --已经购买的道具对应的技能IDtab
CheckBattleItemState.usedItems = nil --已经使用的道具
function CheckBattleItemState:Enter(role)
	self.usedItems = {}
	local memCache = TxtFactory:getTable("MemDataCache")
	self.itemSkillTable = TxtFactory:getMemDataCacheTable(TxtFactory.BattleUseItemInfo)
	if self.itemSkillTable == nil then
		role.stateMachine:removeSharedState(self)
		return
	end
	for k,v in pairs(self.itemSkillTable) do
		if v == nil or v == 0 then
			break
		end
		GamePrint("使用的ID为： "..k.."  的道具".."技能ID为： "..v)
		role:playSkill(v)
		table.remove(self.itemSkillTable,v)
		table.insert(self.usedItems,k)
	end
	role.stateMachine:removeSharedState(self)
end

function CheckBattleItemState:Excute(role,dTime)
end

function CheckBattleItemState:Exit(role)
	if #self.usedItems > 0 then
		GetCurrentSceneUI().manager:SendUseItemReq(self.usedItems)
	end
end