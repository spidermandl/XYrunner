--[[
author:gaofei
向其他玩家发起晋级挑战
]]
LadderChallengeMsg = class(BaseMsg)

function LadderChallengeMsg:Excute(response)
    self.callback:getLadderChallengeResponse(response)
end