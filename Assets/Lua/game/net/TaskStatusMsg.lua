
--[[
author:sunkai
汇报任务进度
]]

TaskStatusMsg = class(BaseMsg)

function TaskStatusMsg:Excute(response)
    self.callback:GetTaskStatusResponse(response)
end