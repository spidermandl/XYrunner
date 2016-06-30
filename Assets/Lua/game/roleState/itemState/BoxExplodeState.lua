--[[
author:Desmond
盒子爆破状态
]]
BoxExplodeState = class (IState)

BoxExplodeState._name = "BoxExplodeState"
BoxExplodeState.animator = nil
BoxExplodeState.effect = nil 

function BoxExplodeState:Enter(role)
    self.animator = role.item:GetComponent("Animator")
    self.animator:Play("explode")

    local player = LuaShell.getRole(LuaShell.DesmondID)
    --createFollowItems(player,self.randomItem) 
    role:explode() --创建箱子弹出金币

end

function BoxExplodeState:Excute(role,dTime)
	local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	if animInfo.normalizedTime >= 1.0 then --动画结束
        local child = role.gameObject.transform:GetChild(0)
        child.gameObject:SetActive(false)
	end
	
end

function BoxExplodeState:Exit(role,dTime)
    if self.effect ~= nil then
        GameObject.Destroy(self.effect)
    end
end