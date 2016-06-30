--TaskListMsg
--[[
author:Huqiuxiang
每日任务反馈
]]

TaskListMsg = class(BaseMsg)

function TaskListMsg:Excute(response)
    self.callback:GetSystemTask(response)
end