--SuitSelectMsg  装备信息反馈
SuitSelectMsg = class(BaseMsg)

function SuitSelectMsg:Excute(response)
    self.callback:getSuitSelection(response)
end