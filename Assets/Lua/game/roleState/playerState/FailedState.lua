--[[
author:Desmond
跑酷失败状态
]]
FailedState = class (BasePlayerState)

FailedState._name = "FailedState"
FailedState.follower = nil
FailedState.scene = nil --场景scene

function FailedState:Enter(role)
    GetCurrentSceneUI().gameIsOver = true
    self.super.Enter(self,role)
    --self.animator:Play("fail",0,0)
    self.super.playAnimation(self,role,"fail")
	role.property.moveDir=UnityEngine.Vector3(0,role.property.diveSpeed,0) --向量速度
end

function FailedState:Excute(role,dTime)
    -- 通知弹出失败界面 
    local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	if animInfo.normalizedTime >= 1.0 then --动画结束
		--print("弹出失败框")
		if self.scene ==nil then
        	self.scene = find(ConfigParam.SceneOjbName)
        	local battleScene = LuaShell.getRole(self.scene.gameObject:GetInstanceID())
    		battleScene:FailureUIPanelShow()
    	end
        
	end
end

function FailedState:Exit(role)
end