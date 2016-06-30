--[[
	问卷调查
]]
QuestAnswerMsg = class(BaseMsg)

function QuestAnswerMsg:Excute(response)
	self.callback:SurveyMessageListen(response)
end