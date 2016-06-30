--[[
author:Desmond
关卡信息返回消息
]]

ChapterInfoMsg = class(BaseMsg)

function ChapterInfoMsg:Excute(response)
    self.callback:getChapterInfo(response)

end