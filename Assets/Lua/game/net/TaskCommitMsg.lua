--TaskCommitMsg
--[[
author:Huqiuxiang
提交任务反馈
]]

TaskCommitMsg = class(BaseMsg)

function TaskCommitMsg:Excute(response)
    self.callback:GetCommitTask(response)
end