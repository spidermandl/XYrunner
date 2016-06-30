--[[
抽奖配置
作者：huqiuxiang
]]
LotteryDataTXT = class(TableTXT)


LotteryDataTXT = class(TableTXT)

LotteryDataTXT.tag = "LotteryDataTXT"

LotteryDataTXT.TxtName = Util.DataPath..AppConst.luaRootPath.."game/export/".."lotteryData_config.txt"                  --记录文件地址和名字


function LotteryDataTXT:GetLineByID(id)
	return self.TxtArray[id]
end

-- 根据功能名字或者所需的表固定id
function LotteryDataTXT:GetFixedIdByFeatureName(featureName)
	if featureName == "coinOneByEquip" then  -- 金币单抽(装备)
		return 18001001
	elseif featureName == "coinTenByEquip" then  -- 金币十连抽(装备)
		return 18002001
	elseif featureName == "diamondOneByEquip" then  -- 钻石单抽(装备)
		return 18003001
	elseif featureName == "diamondTenByEquip" then  -- 钻石十连抽(装备)
		return 18004001
	elseif featureName == "coinoneRewardByEquip" then  --金币单抽奖励(装备)
		return 18001001
	elseif featureName == "cointenRewardByEquip" then  --金币十连奖励(装备)
		return 18002001
	elseif featureName == "diamondoneRewardByEquip" then  -- 钻石单抽奖励(装备)
		return 18003001
	elseif featureName == "diamondtenRewardByEquip" then  -- 钻石十连奖励(装备)
		return 18004001
	elseif featureName == "coinoneRewardByPet" then  --金币单抽奖励(宠物)
		return 18005001
	elseif featureName == "diamondoneRewardByPet" then  -- 钻石单抽奖励(宠物)
		return 18006001
	elseif featureName == "priceReward" then  -- 兑换碎片抽取奖励
		return 18008001
	end
end

