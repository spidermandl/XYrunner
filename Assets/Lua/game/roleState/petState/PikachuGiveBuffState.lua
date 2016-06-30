--[[
皮卡丘给电力球状态 PikachuGiveBuffState
作者：Huqiuxiang
]]
PikachuGiveBuffState = class (BasePetState) 
PikachuGiveBuffState._name = "PikachuGiveBuffState"
PikachuGiveBuffState.distance = 0
PikachuGiveBuffState.player = nil  -- 主角
PikachuGiveBuffState.animator = nil 
PikachuGiveBuffState.IsGiveBuff = false 

function PikachuGiveBuffState:Enter(role)
    self.super.Enter(self,role)
    self.animator = role.character:GetComponent("Animator")
    self.animator:Play("attack")
    self.player = LuaShell.getRole(LuaShell.DesmondID)
    self.IsGiveBuff = false
end

PikachuGiveBuffState.duringTime = 0
PikachuGiveBuffState.keyframe = 40 
function PikachuGiveBuffState:Excute(role,dTime)

    if self.IsGiveBuff == true then
    	 return
    end

	self.duringTime = self.duringTime + 1
	if self.duringTime >= self.keyframe then
		 -- 加入电力球状态 
        local buff = ElectricBallState.new()
        buff.state = 3
        self.player.stateMachine:addSharedState(buff)
        self.IsGiveBuff = true
	end
   -- self.player.gameObject.transform.position 
end

function PikachuGiveBuffState:Exit(role)
	-- self.super.Exit(self,role)
end
