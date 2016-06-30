--[[
author:Desmond
宠物dive伴随
]]
PetEscortState  = class (IState) 

PetEscortState._name = "PetEscortState"
PetEscortState.animator = nil

PetEscortState.effect = nil
PetEscortState.effectSys = nil
PetEscortState.stage = 0 -- 0:正在escorting 1:role隐藏 2:播放结束动画

function PetEscortState:Enter(role)
	GamePrint ("-------------------------------->>>>  function PetEscortState:Enter(role) ")
    self.animator = role.character:GetComponent("Animator")
	self.animator:Play("rescue")

end

function PetEscortState:Excute(role,dTime)

end


function PetEscortState:Exit(role)
	GamePrint ("-------------------------------->>>>  function PetEscortState:Exit(role) ")
	self.animator:Play("idle")
end
