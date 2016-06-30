--[[
author:hanli_xiong
选择坐骑返回消息
]]
MountSelectMsg = class(BaseMsg)

function MountSelectMsg:Excute(response)
    self.callback:GetSelectMount(response) -- 通知升级信息回调
end