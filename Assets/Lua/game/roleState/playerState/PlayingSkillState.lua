--[[
释放技能中状态
author:赵名飞
]]
PlayingSkillState = class (BasePlayerState)
PlayingSkillState._name = "PlayingSkillState"
PlayingSkillState.skillId = nil --正在释放的技能ID
function PlayingSkillState:Enter(role)
	GamePrint("-------------  PlayingSkillState   skillId:"..self.skillId)
end

function PlayingSkillState:Excute(role,dTime)
end

function PlayingSkillState:Exit(role)
end