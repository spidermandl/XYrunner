--[[
author Desmond
攻击动画配置txt
]]
ATKAnimTXT = class(TableTXT)

ATKAnimTXT.tag = "ATKAnimTXT"

ATKAnimTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."suit_atk_config.txt"

function ATKAnimTXT:Init()
	self.super.Init(self)
end

--[[
获取攻击动画组
]]
function ATKAnimTXT:getATKarrayBySuitAndSex(suit_id,sex)
	--print (tostring("--------function ATKAnimTXT:getATKarrayBySuitAndSex(suit_id,sex) "..tostring(suit_id).." : "..tostring(sex)))
	local ids = {}
	for i=1,self.super.GetLineNum(self) do --遍历表
		local line = self.super.GetLine(self,i)
		--print (tostring("--------function ATKAnimTXT:getATKarrayBySuitAndSex(suit_id,sex) "..tostring(line[self.TxtTitle[TxtFactory.S_ATK_ANIM_SUIT]-1])))
		--print (tostring("--------function ATKAnimTXT:getATKarrayBySuitAndSex(suit_id,sex) "..tostring(line[self.TxtTitle[TxtFactory.S_ATK_ANIM_SEX]-1])))
		if line[self.TxtTitle[TxtFactory.S_ATK_ANIM_SUIT]-1] == tostring(suit_id)
		   and line[self.TxtTitle[TxtFactory.S_ATK_ANIM_SEX]-1] == tostring(sex)  
		   and line[self.TxtTitle[TxtFactory.S_ATK_ANIM_JUMP_ATK]-1] == "0" then --key不存在
		   --print ("--------function ATKAnimTXT:getATKarrayBySuitAndSex(suit_id,sex) ")
			local id = line[self.TxtTitle['ID']-1]
			ids[tonumber(self:GetData(id,TxtFactory.S_ATK_ANIM_ORDER))] = id

		end
	end
    -- for i=1,#ids do
    -- 	print ('id: '..tostring(ids[i]))
    -- end
	return ids
end

--[[
获取空中攻击动画
]]
function ATKAnimTXT:getAirATKBySuitAndSex(suit_id,sex)
	for i=1,self.super.GetLineNum(self) do --遍历表
		local line = self.super.GetLine(self,i)
		--print (tostring("--------function ATKAnimTXT:getATKarrayBySuitAndSex(suit_id,sex) "..tostring(line[self.TxtTitle[TxtFactory.S_ATK_ANIM_SUIT]-1])))
		--print (tostring("--------function ATKAnimTXT:getATKarrayBySuitAndSex(suit_id,sex) "..tostring(line[self.TxtTitle[TxtFactory.S_ATK_ANIM_SEX]-1])))
		if line[self.TxtTitle[TxtFactory.S_ATK_ANIM_SUIT]-1] == tostring(suit_id)
		   and line[self.TxtTitle[TxtFactory.S_ATK_ANIM_SEX]-1] == tostring(sex)  
		   and line[self.TxtTitle[TxtFactory.S_ATK_ANIM_JUMP_ATK]-1] == "1" then --key不存在
		   --print ("--------function ATKAnimTXT:getATKarrayBySuitAndSex(suit_id,sex) ")
			local id = line[self.TxtTitle['ID']-1]
			return id
		end
	end
end

-- --[[
-- 获取table一行,一列数据
-- id:主键或者行号
-- column:列名
-- ]]
function ATKAnimTXT:GetData(id,column)
    if column == TxtFactory.S_ENDLESS_BASE_NUM then
    	return self.baseNum
    elseif column == TxtFactory.S_ENDLESS_MAX_SPEED then
    	return self.maxSpeed
    end

	return self.super.GetData(self,id,column)

end