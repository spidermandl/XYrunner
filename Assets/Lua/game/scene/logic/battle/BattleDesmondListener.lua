--[[
author:Desmond
主角跑酷内通知接口
]]
BattleDesmondListener = class()
BattleDesmondListener.callback = nil --回调对象

--结束接口
function BattleDesmondListener:notifyFinish()
	if self.callback ~= nil then
		self.callback:notifyFinish()
	end
end

--技能显示接口
function BattleDesmondListener:notifySkillInfo(num)
	if self.callback ~= nil then
		self.callback:notifySkillInfo(num)
	end
end
--UI界面展示技能信息
function BattleDesmondListener:showSkillInfo(skillID,petId)
	if self.callback ~= nil then
		self.callback:showSkillInfo(skillID,petId)
	end
end
--增加分数提示
function BattleDesmondListener:addScore( addVal )
	if self.callback ~= nil then
		self.callback:addScore(addVal)
	end
end
